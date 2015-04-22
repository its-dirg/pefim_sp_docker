#!/bin/bash

make_metadata.py sp_conf.py > sp.xml
pefim_sp sp_conf service_conf