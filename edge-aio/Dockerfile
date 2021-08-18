FROM centos:7
LABEL authors="Rajesh Mishra, Nandan Sridhar"
ARG EDGEVERSION=someversion
ARG EDGEMIRRORURL=someurl
RUN echo 127.0.0.1 $(hostname) > /etc/hosts;
COPY license/license.txt /tmp
COPY config /tmp
COPY dpconfig /tmp
COPY monitoringconfig /tmp
RUN chmod 666 /tmp/license.txt
RUN chmod 666 /tmp/config
RUN chmod 666 /tmp/dpconfig
RUN chmod 666 /tmp/monitoringconfig

RUN groupadd -r apigee
RUN useradd -r -g apigee -d /opt/apigee -s /bin/bash -c "Apigee platform user" apigee
RUN chown apigee:apigee /tmp/config
RUN yum clean all
RUN yum install policycoreutils selinux-policy-targeted -y
RUN yum install which -y
RUN yum install sudo -y
RUN yum install wget -y
RUN yum install epel-release -y
RUN yum install yum-utils -y
RUN yum install yum-plugin-priorities -y

RUN curl http://admin:admin@$EDGEMIRRORURL:3939/bootstrap_$EDGEVERSION.sh -o /tmp/bootstrap_$EDGEVERSION.sh
RUN chmod 700 /tmp/bootstrap_$EDGEVERSION.sh
RUN /bin/bash -c "/tmp/bootstrap_$EDGEVERSION.sh apigeerepohost=$EDGEMIRRORURL:3939 apigeeuser=admin apigeepassword=admin apigeeprotocol=http:// JAVA_FIX=I"
RUN /opt/apigee/apigee-service/bin/apigee-service apigee-setup install
ENV TERM xterm-256color
RUN /opt/apigee/apigee-service/bin/apigee-service apigee-provision install

#Added a workaround to set Drupal password. This needs to be investigated later

#COPY idp-config.txt /tmp
#COPY idp-setup.sh /tmp
#RUN chmod +x /tmp/idp-setup.sh
#COPY idp.repo /etc/yum.repos.d/
COPY apigee-sso-config.txt /tmp
COPY apigee-sso-setup.sh /tmp
RUN chmod +x /tmp/apigee-sso-setup.sh
COPY edge-ue-sso-config.txt /tmp
COPY settings /tmp
COPY apigee-env.sh /tmp

COPY edge-ue-setup.sh /tmp
RUN chmod +x /tmp/edge-ue-setup.sh

RUN echo 127.0.0.1 $(hostname) > /etc/hosts && /opt/apigee/apigee-setup/bin/setup.sh -p aio -f /tmp/config && /opt/apigee/apigee-service/bin/apigee-service apigee-provision setup-org -f /tmp/config && /opt/apigee/apigee-service/bin/apigee-service edge-router stop &&  /opt/apigee/apigee-service/bin/apigee-service edge-ui stop  && /opt/apigee/apigee-setup/bin/setup.sh -p dp -f /tmp/dpconfig && cd /opt/apigee/apigee-drupal/wwwroot && drush upwd trial --password=Secret123 && /tmp/apigee-sso-setup.sh && /tmp/edge-ue-setup.sh 9098 $EDGEVERSION 


RUN rm -fr /tmp/license.txt
RUN echo "Replace license file" > /opt/apigee/customer/conf/license.txt
COPY message-processor.properties /opt/apigee/customer/application
RUN chown apigee:apigee /opt/apigee/customer/application/message-processor.properties
RUN chmod 600 /opt/apigee/customer/application/message-processor.properties
COPY ui.properties /opt/apigee/customer/application
RUN chown apigee:apigee /opt/apigee/customer/application/ui.properties
RUN chmod 600 /opt/apigee/customer/application/ui.properties
COPY classic-ui.properties /opt/apigee/customer/application
RUN chown apigee:apigee /opt/apigee/customer/application/classic-ui.properties
RUN chmod 600 /opt/apigee/customer/application/classic-ui.properties

#Install Dev Portal
#RUN echo 127.0.0.1 $(hostname) > /etc/hosts && /opt/apigee/apigee-setup/bin/setup.sh -p pdb -f /tmp/dpconfig && /opt/apigee/apigee-setup/bin/setup.sh -p dp -f /tmp/dpconfig


#This section makes apigee-lb service redundant and allows dev portal from the same nginx as edge router

COPY nginx.conf /opt/nginx/conf
RUN chown apigee:apigee /opt/nginx/conf/nginx.conf
RUN chmod 666 /opt/nginx/conf/nginx.conf

COPY apigee-drupal-devportal-nginx.conf /opt/apigee/data/apigee-lb/conf.d/
RUN chown apigee:apigee /opt/apigee/data/apigee-lb/conf.d/apigee-drupal-devportal-nginx.conf
RUN chmod 666 /opt/apigee/data/apigee-lb/conf.d/apigee-drupal-devportal-nginx.conf
RUN rm -fr /opt/apigee/data/apigee-lb/conf.d/0-*
RUN rm -fr /opt/apigee/apigee-lb/source/conf.d/*
RUN rm -fr /opt/apigee/apigee-lb/conf.d/*
COPY start /opt/apigee/apigee-lb/bin/start
RUN chown apigee:apigee /opt/apigee/apigee-lb/bin/start
RUN chmod 777 /opt/apigee/apigee-lb/bin/start

#Clean up Yum vars
RUN rm -fr /etc/yum/vars/apigee*
RUN mv /opt/apigee/customer /opt/apigee/customer-source
RUN mv /opt/apigee/data /opt/apigee/data-source
RUN mkdir /opt/apigee/license && chown apigee:apigee /opt/apigee/license

VOLUME ["/opt/apigee/customer"]
VOLUME ["/opt/apigee/license"]
VOLUME ["/opt/apigee/data"]
VOLUME ["/opt/apigee/var/log"]


COPY entrypoint.sh /tmp
RUN chmod 700 /tmp/entrypoint.sh

COPY reset-sso-idp-ue-ip.sh /tmp
RUN chmod +x /tmp/reset-sso-idp-ue-ip.sh

EXPOSE 8080
EXPOSE 9000
EXPOSE 9001
EXPOSE 3000
EXPOSE 8079
EXPOSE 9090 
EXPOSE 3001
EXPOSE 9099
ENTRYPOINT ["/tmp/entrypoint.sh"]
CMD [""]

