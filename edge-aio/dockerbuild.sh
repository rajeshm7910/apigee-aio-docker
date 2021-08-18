#!/bin/bash


red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
reset=`tput sgr0`

usage() {

  echo "${blue}Usage: $0 [option...]" >&2
  echo
  echo "   -u, --ftp_user           * FTP User. "
  echo "   -p, --ftp_password       * Ftp Password. "
  echo "   -v, --version            * Apigee Edge Version "

  echo "${reset}"

  exit 1
}


while [[ $# -gt 0 ]]; do
param="$1"
case $param in
        -u|--ftp_user )           ftp_user=$2
                       shift # past argument
                       shift # past value
                       ;;
        -p|--ftp_password )           ftp_password=$2
                       shift # past argument
                       shift # past value
                       ;;
        -v|--version)           version=$2
                       shift # past argument
                       shift # past value
                       ;;
        -h|*         ) shift
                       shift
                       usage
                       exit
    esac
done

#Validation

while [ "$ftp_user" = "" ]
do
    read  -p "${blue}Ftp User to build docker image [apigeese]:${reset}" ftp_user
    if [[ "$ftp_user" = "" ]]; then
     ftp_user="apigeese"
    fi
done


while [ "$ftp_password" = "" ]
do
  read -s -p  "${blue}Ftp Password to build docker image [required]:${reset}" ftp_password
  echo
done

while [ "$version" = "" ]
do
    read -p "${blue}Apigee OPDK Version [required]:${reset}" version
    echo
done


#Create an edge-mirror and start the edge-mirror local container
apigee_mirror_container_id=$(docker ps -aqf name=apigee-edge-mirror)
docker stop $apigee_mirror_container_id
docker rm $apigee_mirror_container_id
cd ../edge-mirror
#docker build  --build-arg FTPUSER="$ftp_user" --build-arg FTPPASSWORD="$ftp_password"  --build-arg EDGEVERSION="$version" -t apigee-edge-mirror .
./dockerbuild.sh $ftp_user $ftp_password $version
./dockerrun.sh $version
apigee_mirror_container_id=$(docker ps -aqf name=apigee-edge-mirror)

if [[ -n $apigee_mirror_container_id ]]; then
	cd -
	IPAddress=$(docker inspect apigee-edge-mirror | jq .[].NetworkSettings.IPAddress | sed -e s/\"//g)
	echo "IP Address of mirror image : "$IPAddress
	docker build --memory 8196m --memory-swap 81966m --build-arg EDGEMIRRORURL=$IPAddress --build-arg EDGEVERSION="$version"  -t apigee-edge-aio:$version .
else 
	echo "Looks like the mirror image didn't got created or started."
fi
apigee_mirror_container_id=$(docker ps -aqf name=apigee-edge-mirror)
docker stop $apigee_mirror_container_id
docker rm $apigee_mirror_container_id


