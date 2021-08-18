docker create --name apigee-edge-aio  -p 9000:9000 -p 8080:8080 -p 9001:9001 -p 3000:3000 -p 8079:8079 -P -it apigee-edge-aio
docker cp license/license.txt $(docker ps -aqf name=apigee-edge-aio):/opt/apigee/customer/conf/license.txt
docker start $(docker ps -aqf name=apigee-edge-aio)
# copy the license file after starting. otherwise the file is not copied
#docker cp license.txt $(docker ps -aqf name=apigee-edge-aio):/opt/apigee/customer/conf/license.txt
docker ps
