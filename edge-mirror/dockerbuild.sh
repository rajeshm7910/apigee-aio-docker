#!/bin/bash

docker build  --build-arg FTPUSER="$1" --build-arg FTPPASSWORD="$2"  --build-arg EDGEVERSION="$3" -t apigee-edge-mirror:$3 .
