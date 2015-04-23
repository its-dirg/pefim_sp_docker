.. _configuration:

***************
PEFIM sp setup
***************

Setting up PEFIM sp docker container

Docker volume structure
=======================

To run a PEFIM sp using the docker image, you need to bind a volume to **/opt/pefim/etc** in the container.
This volume will act as the working directory of the PEFIM sp and contain all necessary files to the sp.

An example of how to build a valid volume to the container can be found in the **example/etc** directory.
And how to bind the volume can be found in the **example/run.sh** script.

The start.sh script
-------------------

In the volume root, a file named **start.sh** must exist. This file is the starting point of the application and is
responsible of starting the PEFIM sp.

An example of a start script::

    #!/bin/bash

    make_metadata.py sp_conf.py > sp.xml
    pefim_sp sp_conf

This creates a metadata file of the config file sp_conf.py and starts the PEFIM sp.

Change configuration
====================

The main configuration is based on pysaml2 and can be found in **example/etc/sp_conf.py**. Be aware that you may
need to change the **example/etc/start.sh** and **exmple/run.sh** depending on the changes.

