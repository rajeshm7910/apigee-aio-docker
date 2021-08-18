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
