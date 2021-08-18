curl -X POST -u trial@apigee.com:Secret123 -H "Content-Type: text/xml" \
http://localhost:8080/v1/o/trial/e/test/keystores \
-d '<KeyStore name="demoKeystore"/>'

mkdir -p certs
mkdir -p certs/META-INF
cd certs

sudo openssl genrsa -aes256 -passout pass:Secret123 -out server.key 2048
sudo openssl rsa -in server.key -passin pass:Secret123  -out server.key
sudo openssl req -x509 -sha256 -new -key server.key -out server.csr  -subj "/C=US/ST=California/L=Demo/O=Foobar/OU=Sales/CN=Foobar.com/emailAddress=foo@bar.com"
sudo openssl x509 -sha256 -days 365 -in server.csr -signkey server.key -out selfsigned.crt

echo "certFile=selfsigned.crt" > META-INF/descriptor.properties
echo "keyFile=server.key" >> META-INF/descriptor.properties

jar -cf demoKeystore.jar selfsigned.crt server.key
jar -uf demoKeystore.jar META-INF/descriptor.properties

curl -u trial@apigee.com:Secret123 -X POST -H "Content-Type: multipart/form-data" -F file="@demoKeystore.jar" -F password={key_pword} \
"http://localhost:8080/v1/o/trial/e/test/keystores/demoKeystore/aliases?alias=demo&format=keycertjar"

curl -X POST  -H "Content-Type:application/xml" http://localhost:8080/v1/o/trial/e/test/references \
-d '<ResourceReference name="demokeystoreref">
    <Refers>demoKeystore</Refers>
    <ResourceType>KeyStore</ResourceType>
</ResourceReference>' -u trial@apigee.com:Secret123

curl -X POST -H "Content-Type:application/xml" \
  http://localhost:8080/v1/o/trial/environments/test/virtualhosts \
  -d '<VirtualHost  name="secure">
    <HostAliases>
      <HostAlias>localhost</HostAlias>
    </HostAliases>
    <Interfaces/>
    <Port>9443</Port>
    <OCSPStapling>off</OCSPStapling>
    <SSLInfo>
      <Enabled>true</Enabled>
      <ClientAuthEnabled>false</ClientAuthEnabled>
      <KeyStore>ref://demokeystoreref</KeyStore>
      <KeyAlias>demo</KeyAlias>
    </SSLInfo>
  </VirtualHost>' \
  -u trial@apigee.com:Secret123

