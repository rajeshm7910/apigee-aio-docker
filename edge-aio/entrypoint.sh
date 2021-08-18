#!/bin/bash

echo "Started entry point" >> /tmp/entrypoint.log
echo 127.0.0.1 $(hostname) > /etc/hosts

### Initialize for Persistent Volumes
if [ ! -f /opt/apigee/data/mounted ]; then
	if [  -d /opt/apigee/data-source ]; then
		# Move the contents of data-source to data
		rm -fr /opt/apigee/data
		mkdir -p /opt/apigee/data
		cp -fr /opt/apigee/data-source/*  /opt/apigee/data/
		touch /opt/apigee/data/mounted
		chown -R apigee:apigee /opt/apigee/data
	fi
else 
	if [ ! -d /opt/apigee/data/apigee-internal-idp ]; then
		cp -fr /opt/apigee/data-source/apigee-internal-idp  /opt/apigee/data/apigee-internal-idp
		chown -R apigee:apigee /opt/apigee/data/apigee-internal-idp
	fi
	if  [ ! -d /opt/apigee/data/apigee-sso ]; then
		cp -fr /opt/apigee/data-source/apigee-sso  /opt/apigee/data/apigee-sso
		chown -R apigee:apigee /opt/apigee/data/apigee-sso
	fi
	if [ ! -d /opt/apigee/data/edge-management-ui ]; then
		cp -fr /opt/apigee/data-source/edge-management-ui  /opt/apigee/data/edge-management-ui
		chown -R apigee:apigee /opt/apigee/data/edge-management-ui
	fi
	if [ ! -d /opt/apigee/data/edge-classic-ui ]; then
		cp -fr /opt/apigee/data-source/edge-classic-ui  /opt/apigee/data/edge-classic-ui
		chown -R apigee:apigee /opt/apigee/data/edge-classic-ui
	fi
fi
chmod -R 700 /opt/apigee/data/apigee-postgresql/pgdata

if [ ! -f /opt/apigee/customer/mounted ]; then
	if [  -d /opt/apigee/customer-source ]; then
		# Move the contents of data-source to data
		rm -fr /opt/apigee/customer
		mkdir -p /opt/apigee/customer
		cp -fr  /opt/apigee/customer-source/* /opt/apigee/customer/
		touch /opt/apigee/customer/mounted
		chown -R apigee:apigee /opt/apigee/customer
	fi
else
	#These are done to introduce apigee-sso
	if [ ! -d /opt/apigee/customer/application/apigee-sso ]; then
		upgrade=true
		cp -fr  /opt/apigee/customer-source/application/apigee-sso /opt/apigee/customer/application/apigee-sso
		chown -R apigee:apigee /opt/apigee/customer/application/apigee-sso
	fi
	if [ ! -d /opt/apigee/customer/application/apigee-internal-idp ]; then
		cp -fr  /opt/apigee/customer-source/application/apigee-internal-idp /opt/apigee/customer/application/apigee-internal-idp
		chown -R apigee:apigee /opt/apigee/customer/application/apigee-internal-idp
	fi
fi

if [ -f /opt/apigee/license/* ]; then
        cat /opt/apigee/license/* > /opt/apigee/customer/conf/license.txt
        chown apigee:apigee /opt/apigee/customer/conf/license.txt
fi

if [ -d /opt/apigee/var/log ]; then
     	chown -R apigee:apigee /opt/apigee/var/log/
     	chown -R apigee:apigee /opt/apigee/var/lib/
fi

###Drupl dev portal handler
if [ -d /opt/apigee/apigee-drupal-devportal ]; then
	rm -fr /opt/apigee/var/run/apigee-drupal-devportal/apigee-drupal-devportal.pid
	mkdir -p /opt/apigee/var/log/apigee-drupal-devportal
	chown -R apigee:apigee /opt/apigee/var/log/apigee-drupal-devportal
fi

if [ "$1" ==  "" ]
then
  echo "License already present" >> /tmp/entrypoint.log
else
    echo "License is given as parameter" >> /tmp/entrypoint.log
    echo $1 > /opt/apigee/customer/conf/license.txt
fi

chown apigee:apigee /opt/apigee/customer/conf/license.txt
/opt/apigee/apigee-service/bin/apigee-all restart

if [ -d /opt/apigee/var/log ]; then
     	chown -R apigee:apigee /opt/apigee/var/log/
     	chown -R apigee:apigee /opt/apigee/var/lib/
fi


# SIGUSR1-handler
my_handler() {
  echo "my_handler" >> /tmp/entrypoint.log
  /opt/apigee/apigee-service/bin/apigee-all stop
}

# SIGTERM-handler
term_handler() {
  echo "term_handler" >> /tmp/entrypoint.log
  /opt/apigee/apigee-service/bin/apigee-all stop
  exit 143; # 128 + 15 -- SIGTERM
}

# setup handlers
# on callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
trap 'kill ${!}; my_handler' SIGUSR1
trap 'kill ${!}; term_handler' SIGTERM

while true
do
        tail -f /dev/null & wait ${!}
done
