
APIGEE_ROOT=/opt/apigee
#EDGE_UI_CLONE="http://localhost:88/customrepo/edge-classic-ui-clone.tar.gz"
PORT=${1:-9098}
VERSION=${2:-4.19.06}

echo "Cloning from existing edge-ui"
source $APIGEE_ROOT/etc/defaults.sh
if [[ ! -d "/opt/apigee/edge-ui" ]] ; then
        echo "Edge  UI not installed in this server"
        exit 1;
fi

su -m -c "mkdir -p $APIGEE_ROOT/edge-classic-ui-${VERSION}-0.0.0" apigee
su -m -c "cp -fr $APIGEE_ROOT/edge-ui/* $APIGEE_ROOT/edge-classic-ui-${VERSION}-0.0.0/" apigee
su -m -c "ln -s $APIGEE_ROOT/edge-classic-ui-${VERSION}-0.0.0 $APIGEE_ROOT/edge-classic-ui" apigee


echo "Changing the current classic ui on port : " $PORT
su -m -c "cp /tmp/settings /opt/apigee/edge-ui/lib/settings" apigee
su -m -c "cp /tmp/apigee-env.sh /opt/apigee/edge-classic-ui/lib/apigee-env.sh" apigee
su -m -c "mv /opt/apigee/edge-classic-ui/token/installType/opdk/application/ui.properties /opt/apigee/edge-classic-ui/token/installType/opdk/application/classic-ui.properties" apigee


/opt/apigee/apigee-service/bin/apigee-service edge-classic-ui setup -f /tmp/config
#/opt/apigee/apigee-service/bin/apigee-service edge-classic-ui configure-sso -f /tmp/edge-ue-sso-config.txt
#/opt/apigee/apigee-service/bin/apigee-service edge-management-ui install
#/opt/apigee/apigee-service/bin/apigee-service edge-management-ui setup -f /tmp/edge-ue-sso-config.txt
#/opt/apigee/apigee-service/bin/apigee-service edge-management-ui configure-sso -f /tmp/edge-ue-sso-config.txt

apigee-service edge-ui start
/opt/apigee/apigee-setup/bin/setup.sh -p ue -f /tmp/edge-ue-sso-config.txt
