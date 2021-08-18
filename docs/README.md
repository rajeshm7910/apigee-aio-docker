# Purpose and Intent
Apigee does not officially support docker images. However these community based docker images are built to quickly run apigee services as docker container.

## Prerequisite
 
- Credentials : You would need credentials to access docker.apigee.net. These credentials are same as the one you use for software.apigee.com

- License Key : Some of the docker images would need a license key. Contact your Apigee account representative for a license key. If you dont know who your sales representative is, please send an email to edgesalesteam@google.com



## Getting Started

```md

docker login docker.apigee.net
<<Your software creds >>
docker pull docker.apigee.net/<service>

```

## Services and Documentation
The list of Docker Services 
+ [apigee-edge-aio](./apigee-edge-aio)
+ [apigee-edge-portal](./apigee-edge-portal)

