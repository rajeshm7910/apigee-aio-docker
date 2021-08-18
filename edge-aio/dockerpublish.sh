#!/bin/bash
version=$1
docker tag apigee-edge-aio:$version gcr.io/edge-apigee/apigee-edge-aio:$version
docker push gcr.io/edge-apigee/apigee-edge-aio:$version
gsutil -h Content-Type:text/markdown cp ../docs/README.md gs://apigee-docker/README.md
gsutil acl ch -u AllUsers:R gs://apigee-docker/README.md
gsutil -h Content-Type:text/markdown cp ../docs/apigee-edge-aio/README.md gs://apigee-docker/apigee-edge-aio/README.md
gsutil acl ch -u AllUsers:R gs://apigee-docker/apigee-edge-aio/README.md
 
