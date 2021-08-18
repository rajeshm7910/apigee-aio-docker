Apigee Edge Docker Image Creation
This project describes how you can create a docker image for Apigee Edge Installation.

### Prerequisites
- Docker
Please refer to this page to install docker in your machine
https://www.docker.com/products/docker-toolbox

### How to Build

  - Clone the Project
  - Switch to the edge aio directory
  ```cd edge-docker/edge-aio```
  - Change Docker preferences to alloacte atleast 6 GB RAM and 2 core CPUs
  - Put license file as license.txt under edge-aio/license directory.
  - Run dockcer build to create the docker image ```./dockerbuild.sh```
  - This will create a docker image ```apigee-edge-aio```. You can do ```docker images -a``` to list all the docker images.

### How to Run
More details [here](./docs/README.md).


### License
Apache 2.0
