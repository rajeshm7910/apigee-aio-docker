FROM centos:7
LABEL authors="Rajesh Mishra, Nandan Sridhar"
ARG FTPUSER=someuser
ARG FTPPASSWORD=somepassword
ARG EDGEVERSION=someversion


RUN groupadd -r apigee
RUN useradd -r -g apigee -d /opt/apigee -s /bin/bash -c "Apigee platform user" apigee
RUN yum clean all
RUN yum install policycoreutils selinux-policy-targeted -y
RUN yum install which -y
RUN yum install sudo -y
RUN yum install wget -y
RUN yum install epel-release -y
RUN yum install yum-utils -y
RUN yum install yum-plugin-priorities -y

COPY entrypoint.sh /tmp

RUN curl https://$FTPUSER:$FTPPASSWORD@software.apigee.com/bootstrap_$EDGEVERSION.sh -o /tmp/bootstrap_$EDGEVERSION.sh
RUN chmod 700 /tmp/bootstrap_$EDGEVERSION.sh
RUN chmod 700 /tmp/entrypoint.sh

RUN /bin/bash -c "/tmp/bootstrap_$EDGEVERSION.sh apigeeuser=$FTPUSER apigeepassword='$FTPPASSWORD' JAVA_FIX=I"
RUN /opt/apigee/apigee-service/bin/apigee-service apigee-setup install
RUN /opt/apigee/apigee-service/bin/apigee-service apigee-mirror install
RUN /opt/apigee/apigee-service/bin/apigee-service apigee-mirror sync --only-new-rpms
RUN /opt/apigee/apigee-service/bin/apigee-service apigee-mirror nginxconfig

EXPOSE 3939
ENTRYPOINT ["/tmp/entrypoint.sh"]
CMD [""]