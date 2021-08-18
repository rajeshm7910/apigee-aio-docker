mkdir -p /opt/apigee/customer/application/apigee-internal-idp/tomcat-ssl
cd /opt/apigee/customer/application/apigee-internal-idp/tomcat-ssl
openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out cert.pem -x509 -sha256  -subj "/C=US/ST=Foo/L=Bar/O=Foobar/OU=Sales/CN=Foobar.com/emailAddress=foo@bar.com"
openssl pkcs12 -export -in cert.pem -inkey key.pem -out cert.p12 -passout pass:Secret123
keytool -importkeystore -srckeystore cert.p12 -srcstoretype PKCS12 -destkeystore cert.jks -deststoretype JKS -deststorepass Secret123 -srcstorepass Secret123
keytool -changealias -alias "1" -destalias "idp" -keystore cert.jks -storepass Secret123
chown -R apigee:apigee /opt/apigee/customer/application/apigee-internal-idp/tomcat-ssl
/opt/apigee/apigee-service/bin/apigee-service  apigee-internal-idp install
/opt/apigee/apigee-service/bin/apigee-service apigee-internal-idp setup -f /tmp/idp-config.txt