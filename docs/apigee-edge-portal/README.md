## Purpose and Intent
Apigee does not officially support running Apigee Edge Portal in docker containers for on-premises customers. However, a self-contained docker image is being provided for evaluation purposes primarily targeted to prospective customers who intend to use the software on-premises



## Quick Start
This docker image contains latest Apigee Edge Portal . 

### Pre-requisites
- **Docker** : Download & install the Docker from here: https://docs.docker.com/engine/installation/ 
- **License Key** : The docker image does not contain a license key. Contact your Apigee account representative for a license key. If you don't know who your sales representative is, please send an email to edgesalesteam@google.com
- **Docker Settings** : Ensure your docker preferences have at least **CPUs: 2 and Memory: 2 GB**

### Running Docker Container
#### Step 0: Login to docker registery
Login with **software.apigee.com** (NOT docker!) credentials.

```md
docker login docker.apigee.net
```

#### Step 1: Pull the image. Specify version if you want to pull a specific version. 
```md 
docker pull docker.apigee.net/apigee-edge-portal

```
```md
docker run --name apigee-edge-portal -d -p 80:8079 -P -it docker.apigee.net/apigee-edge-portal
```

## How to access the product?
```md
**Note : it takes the UI a few mins to load after docker start

The Developer Port: 80
Portal UI Admin user: trial@apigee.com
Portal UI Admin password: Secret123
```

## Connecting to  Edge Instance
You can start the container by passing the edge details as environment variables during docker run
For ex:
```md
docker run --name apigee-edge-portal -d -p 80:8079 -P -v $PWD/data:/opt/apigee/data -v $PWD/customer:/opt/apigee/customer -e MGMT=http://localhost:8080/v1 -e USER=trial1@apigee.com -e PASSWORD=Secret1234 -it apigee-edge-portal:latest
```


# Volumes 
The steps mentioned above allows you to start docker container easily but what happens whhen you start/ stop destroy container. The docker image comes with following volume mounting :

```md
| Volumes       | Mount point in image | Purpose                                         |
| ------------- |--------------------- | ------------------------------------------------|
| data          | /opt/apigee/data     | Runtime configuration and data                  |
| customer      | /opt/apigee/customer | All customer configuration.                     |
```


When the container starts for the first time, the mounted data and customer directory is intialized from the image. On subsequent boot, it will boot from the volume.

How do you start Apigee edge with volume mounting :
In your Workspace directory create 3 local directories. 

```md
mkdir -p data
mkdir -p customer
```

```md
docker run --name apigee-edge-aio -d  -p 80:8079 -P -v $PWD/data:/opt/apigee/data -v $PWD/customer:/opt/apigee/customer -it apigee-edge-portal

```

- You will see data and customer directries poulated with all initial data. 
- Create few api proxies in apigee edge.
- Stop and deestroy container.
- Start the container as stated above. You can see all your api proxies intact.
- Delete the contents of your data and customer directory and restart container. This should boot you apigee with initial configurations.


