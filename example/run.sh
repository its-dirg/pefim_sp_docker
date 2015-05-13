#!/bin/bash
#
# To debug your container:
#
#   DOCKERARGS="--entrypoint /bin/bash" bash -x ./run.sh
#

c_path=$(pwd)
cddir=$(dirname `which $0`)
#Go to correct directory
cd $cddir

# Name of config file
conf=service_conf.py

# Image name
image=itsdirg/pefim_sp

# Name of container
name=pefim_sp

# relative path to volume
volume=etc

port=$(cat ${volume}/${conf} | grep PORT | grep -v "#" | head -1 | sed 's/[^0-9]//g')

dir=$(pwd)

centos_or_redhat=$(cat /etc/centos-release 2>/dev/null | wc -l)

if [ ${centos_or_redhat} = 1 ]; then
    $(chcon -Rt svirt_sandbox_file_t ${dir}/${volume})
fi

# Check if running on mac
if [ $(uname) = "Darwin" ]; then

    port_check=$(netstat -an | grep ${port} | wc -l)
    port_b2d=$(VBoxManage showvminfo "boot2docker-vm" --details | grep ${port} | wc -l)

    if [ ${port_b2d} = 0 ]; then
        if [ ${port_check} = 0 ]; then
            port_b2d=1
            VBoxManage controlvm "boot2docker-vm" natpf1 "${name},tcp,127.0.0.1,${port},,${port}"
        else
            echo "Port: " ${port} " is already used! Change port in the files " ${conf}
            exit 1
        fi
    fi

    # Check so the boot2docker vm is running
    if [ $(boot2docker status) != "running" ]; then
        boot2docker start
    fi
    $(boot2docker shellinit)
else
    # if running on linux
    if [ $(id -u) -ne 0 ]; then
        sudo="sudo"
    fi
fi

if ${sudo} docker ps | awk '{print $NF}' | grep -qx ${name}; then
    echo "$0: Docker container with name $name already running. Press enter to restart it, or ctrl+c to abort."
    read foo
    ${sudo} docker kill ${name}
fi
$sudo docker rm ${name} > /dev/null 2> /dev/null

#mkdir ./etc/logs > /dev/null 2> /dev/null

${sudo} docker run --rm=true \
    --name ${name} \
    --hostname localhost \
    -v ${dir}/${volume}:/opt/pefim/etc \
    -p ${port}:${port} \
    $DOCKERARGS \
    -i -t \
    ${image}

# delete port forwarding
if [ $(uname) = "Darwin" ] && [ ${port_b2d} = 1 ]; then
    VBoxManage controlvm "boot2docker-vm" natpf1 delete "${name}"
fi

#Return to starting path
cd $c_path