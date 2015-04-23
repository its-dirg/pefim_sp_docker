#!/bin/bash
#
# To debug your container:
#
#   DOCKERARGS="--entrypoint /bin/bash" bash -x ./run.sh
#

port=8087
image=itsdirg/pefim_sp
name=pefim_sp

# Check if running on mac
if [ $(uname) = "Darwin" ]; then

    port_check=$(netstat -an | grep ${port} | wc -l)
    port_b2d=$(VBoxManage showvminfo "boot2docker-vm" --details | grep ${port} | wc -l)

    if [ ${port_b2d} = 0 ]; then
        if [ ${port_check} = 0 ]; then
            VBoxManage controlvm "boot2docker-vm" natpf1 "${name},tcp,127.0.0.1,${port},,${port}"
        else
            echo "Port: " ${port} " is already used! Change port in the files (run.sh, sp_conf.py, service_conf.py). This will be better in the future..."
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
    -v $PWD/etc:/opt/pefim/etc \
    -p ${port}:${port} \
    $DOCKERARGS \
    -i -t \
    ${image}
