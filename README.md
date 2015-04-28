# pefim_sp_docker

This project contains docker build scripts to generate a docker image for a PEFIM sp based on https://github.com/its-dirg/pefim_sp.

You can also find an example how to configure and run the docker image.

This is an early alpha version and contains some temporary quick fixes to create a working proof of concept.
The intention is to refactor the code and configuration.

Install Docker
==============

To install docker on your specific OS, follow the instruction on the docker page: http://docs.docker.com/installation/

Install PEFIM idp using docker
==============================

Download the PEFIM docker project from: https://github.com/its-dirg/pefim_sp_docker

The scripts has been verified in OS X Yosemite, CentOS 7 and Ubuntu 14.04.

All files necessary to build the PEFIM sp image are located in the dockerfiles directory. To build the image run the script::

    dockerfiles/build.sh

If you want to test the PEFIM sp, you can use the example sp setup in the example directory.
Replace the metadata in example/etc/metadata with your metadata or change the metadata configuration in example/etc/sp_conf.py.

To start the idp run the script::

    example/run.sh

If you are running windows there exists powershell scripts. The scripts are not signed so you have to give yourself
permission to run them. One example can be:

To build the image:
cd [..]/dockerfiles/
PowerShell.exe -ExecutionPolicy Bypass -File build.ps1

To start:
cd [..]/example/
PowerShell.exe -ExecutionPolicy Bypass -File run.ps1