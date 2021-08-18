ip=$1
#sed -i "s/MANAGEMENT_UI_PUBLIC_IP=localhost/MANAGEMENT_UI_PUBLIC_IP=$ip/g" /tmp/idp-config.txt
#sed -i "s/IDP_PUBLIC_URL_HOSTNAME=localhost/IDP_PUBLIC_URL_HOSTNAME=$ip/g" /tmp/idp-config.txt
#sed -i "s/IP2=*/IP2=$ip/g" /tmp/apigee-sso-config.txt
#sed -i "s/IP2=*/IP2=$ip/g" /tmp/apigee-sso-config.txt
#sed -i "s/IP2=*/IP2=$ip/g" /tmp/edge-ue-sso-config.txt

sed -i.bak s/IP2=.*/IP2=${ip}/g /tmp/apigee-sso-config.txt
sed -i.bak s/IP2=.*/IP2=${ip}/g /tmp/edge-ue-sso-config.txt


#/opt/apigee/apigee-service/bin/apigee-service apigee-internal-idp setup -f /tmp/idp-config.txt
#curl -k https://localhost:9090/idp/shibboleth -o /opt/apigee/customer/application/apigee-sso/saml/metadata.xml
#chown apigee:apigee /opt/apigee/customer/application/apigee-sso/saml/metadata.xml
/opt/apigee/apigee-setup/bin/setup.sh -p sso -f /tmp/apigee-sso-config.txt
/opt/apigee/apigee-setup/bin/setup.sh -p ue -f /tmp/edge-ue-sso-config.txt
