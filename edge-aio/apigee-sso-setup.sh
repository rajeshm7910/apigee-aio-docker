sudo mkdir -p /opt/apigee/customer/application/apigee-sso/jwt-keys
cd /opt/apigee/customer/application/apigee-sso/jwt-keys/
sudo openssl genrsa -out privkey.pem 2048
sudo openssl rsa -pubout -in privkey.pem -out pubkey.pem
sudo chown apigee:apigee *.pem
sudo mkdir -p /opt/apigee/customer/application/apigee-sso/saml/
cd /opt/apigee/customer/application/apigee-sso/saml/

#sudo openssl genrsa -aes256 -passout pass:Secret123 -out server.key 2048
#sudo openssl rsa -in server.key -passin pass:Secret123  -out server.key
#sudo openssl req -x509 -sha256 -new -key server.key -out server.csr  -subj "/C=US/ST=California/L=Fremont/O=Foobar/OU=Sales/CN=Foobar.com/emailAddress=foo@bar.com"
#sudo openssl x509 -sha256 -days 365 -in server.csr -signkey server.key -out selfsigned.crt
#sudo chown apigee:apigee server.key
#sudo chown apigee:apigee selfsigned.crt

cd -

sleep 30
#curl -k https://localhost:9090/idp/shibboleth -o /opt/apigee/customer/application/apigee-sso/saml/metadata.xml
#chown apigee:apigee /opt/apigee/customer/application/apigee-sso/saml/metadata.xml
/opt/apigee/apigee-setup/bin/setup.sh -p sso -f /tmp/apigee-sso-config.txt
