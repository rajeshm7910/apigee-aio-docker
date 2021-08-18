#!/bin/bash

/opt/nginx/scripts/apigee-nginx start
while true
do
        tail -f /dev/null & wait ${!}
done
