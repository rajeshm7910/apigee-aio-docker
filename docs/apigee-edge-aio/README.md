## Purpose and Intent
Apigee does not officially support running Apigee Edge in docker containers for on-premises customers. However, a self-contained docker image is being provided for evaluation purposes primarily targeted to prospective customers who intend to use the software on-premises



## Quick Start
This docker image contains latest Apigee Edge all-in-one. The components - API Services (runtime) & Analytics, developer portal and operation monitoring dashboard are all on the same image.

### Pre-requisites
- **Docker** : Download & install the Docker from here: https://docs.docker.com/engine/installation/ 
- **License Key** : The docker image does not contain a license key. Contact your Apigee account representative for a license key. If you don't know who your sales representative is, please send an email to edgesalesteam@google.com
- **Docker Settings** : Ensure your docker preferences have at least **CPUs: 2 and Memory: 6 GB**

### Running Docker Container
#### Step 0: Login to docker registery
Login with **software.apigee.com** (NOT docker!) credentials.

```md
docker login docker.apigee.net
```

#### Step 1: Pull the image. Specify version if you want to pull a specific version. 
```md 
docker pull docker.apigee.net/apigee-edge-aio
docker pull docker.apigee.net/apigee-edge-aio:4.19.06

```
To pull older version of  edge 
```md 
docker pull docker.apigee.net/apigee-edge-aio:4.19.01
docker pull docker.apigee.net/apigee-edge-aio:4.18.01
docker pull docker.apigee.net/apigee-edge-aio:4.17.09
```

#### Step 2: Create  container
```md
docker container create --name apigee-edge-aio -p 3001:3001 -p 9090:9090 -p 9099:9099 -p 9000:9000 -p 8080:8080 -p 9001:9001 -p 3000:3000 -p 8079:8079 -it docker.apigee.net/apigee-edge-aio
```

To create container from previous version of edge 
```md
docker container create --name apigee-edge-aio -p 9000:9000 -p 8080:8080 -p 9001:9001 -p 3000:3000 -p 8079:8079 -P -it docker.apigee.net/apigee-edge-aio:4.18.01
```

#### Step 3: Copy the license file to the container
```md
docker cp license.txt apigee-edge-aio:/opt/apigee/customer/conf/
```
#### Step 4: Start the container
```md
docker container start apigee-edge-aio
```

NOTE: See below for another option to run docker image in single command. 

## Start  container with  docker run
Here is a second option to start the docker container. 
Get the license text without any line breaks. You can  use following command to get the license text.
```md
echo $(cat license.txt | tr -d '\n') 
```
Start the docker container by pasting the license text at the end. It accepts the license text as parameter.

```md
docker run --name apigee-edge-aio -d  -p 3001:3001 -p 9090:9090 -p 9099:9099 -p 9000:9000 -p 8080:8080 -p 9001:9001 -p 3000:3000 -p 8079:8079 -P -it docker.apigee.net/apigee-edge-aio "PASTE YOUR LICENSE AS STRING WIHOUT ANY RETURNS CARRIAGE"
```

## How to access the product?
**Note : it takes the UI a few mins (up to 5 mins) to load after docker start

The port and access details are as below:

```md

| Component                                  | Port         | 
| -------------------------------------------|--------------| 
| ClassicUI                                  | 9000         |
| New Edge Experience                        | 3001         | 
| Runtime API                                | 9001         |
| Managenet Server                           | 8080         |
| Developer Portal                           | 8079         | 
| Apigee SSO                                 | 9099         |
| Local SAML IDP                             | 9090         |
| Monitoring Dashboard (Only 4.18.01)        | 3001         |


Monitoring Dashboard Credentials: admin/admin ( Only for 4.18.01 )
Edge UI Admin user: trial@apigee.com
Edge UI Admin password: Secret123
[Applies to Classic Edge UI , New Edge Experience and Developer Portal]
```
New Edge experience comes with a embedded SAML IDP which runs on 
NOTE: Only the virtual host `localhost` has been mapped. `127.0.0.1` will not work.


## Custom Virtual Hosts
If you are running docker on different host(like Cloud), you may not be able to use "localhost" to access the Apigee Components. In that case, you can setup a custom virtual host like this:
```
curl -X POST -H 'Content-Type: application/json' -u trial@apigee.com:Secret123 http://localhost:8080/v1/organizations/trial/environments/test/virtualhosts/default -d "{\"name\": \"default\" , \"hostAliases\": [\"custom.host.com\"], \"port\": \"9001\",\"interfaces\" : []}"
```
NOTE: You've now updated virtual host. Deploy proxies on that VH.

# Volumes 
The steps mentioned above allows you to start docker container easily but what happens when you start/ stop destroy container. The docker image comes with following volume mounting :

```md
| Volumes       | Mount point in image | Purpose                             |
| ------------- |--------------------- | ------------------------------------|
| data          | /opt/apigee/data     | Runtime configuration and data      |
| customer      | /opt/apigee/customer | All customer configuration.         |
| license       | /opt/apigee/license  | Place your license file here        |
| log           | /opt/apigee/var/log  | All log files     |

```

When the container starts for the first time, the mounted data and customer directory is initialized from the image. On subsequent boot, it will boot from the volume.

How do you start Apigee edge with volume mounting :
In your Workspace directory create 3 local directories. 

```md
mkdir -p license
```
Put your license file inside license directory you created above:

```md
docker run --name apigee-edge-aio -d -p 3001:3001 -p 9090:9090 -p 9099:9099 -p 9000:9000 -p 8080:8080 -p 9001:9001 -p 3000:3000 -p 8079:8079 -P -v $PWD/data:/opt/apigee/data -v $PWD/customer:/opt/apigee/customer -v $PWD/license:/opt/apigee/license -v $PWD/log:/opt/apigee/var/log -it docker.apigee.net/apigee-edge-aio

```

- You will see data and customer directories populated with all initial data. 
- Create few api proxies in apigee edge.
- Stop and destroy container.
- Start the container as stated above. You can see all your api proxies intact.
- Delete the contents of your data and customer directory and restart container. This should boot with initial configurations.

## Setup SMTP
SMTP is not set during initial setup. This can be done by making change in the config file and rerunning ui setup
```md
docker exec -it $(docker ps -aqf name=apigee-edge-aio) /bin/bash
```
Edit /tmp/config and change SMTP settings. 

```md
SKIP_SMTP=n
#Change this to n to set smtp
SMTPHOST=smtp.example.com
#Put your hosts
SMTPUSER=smtp@example.com
#Comment out this field if no user auth required to access smtp
SMTPPASSWORD=smtppwd
#Comment out this field if no password set to access smtp
SMTPMAILFROM=apiadmin@apigee.com
SMTPSSL=n
SMTPPORT=25

/opt/apigee/apigee-setup/bin/setup.sh -p classic-ui -f /tmp/config
```


## Reset  UE IP Address

In case you are running docker container on other server, you may need to access services on some other IP address and not on localhost. UE, IDP and SAML SSO components are configured by default on localhost. It can be changed to other IP address by running following command:

```md
docker exec -it $(docker ps -aqf name=apigee-edge-aio) sh -c "/tmp/reset-sso-idp-ue-ip.sh <IP address>"
```
For ex:
```md
docker exec -it $(docker ps -aqf name=apigee-edge-aio) sh -c "/tmp/reset-sso-idp-ue-ip.sh 127.0.0.1"
```


## Troubleshooting

### Step1 Check CPU and RAM Settings 

Check the prerequisite section and allocate sufficient RAM and CPU to container. If sufficient resources are not provided, all apigee services won't start.

### Step2 Check all apigee Service is running
```md
docker exec -it $(docker ps -aqf name=apigee-edge-aio) /bin/bash
opt/apigee/apigee-service/bin/apigee-all status
```

#### Step 3: Check License
```md
docker exec -it $(docker ps -aqf name=apigee-edge-aio) /bin/bash
/opt/apigee/apigee-service/bin/apigee-service edge-management-server status
cat /opt/apigee/customer/conf/license.txt 
(replace it if not valid)
/opt/apigee/apigee-service/bin/apigee-service edge-management-server restart
```
#### Step 4: Check Log Files
```md
docker exec -it $(docker ps -aqf name=apigee-edge-aio) /bin/bash
cd /opt/apigee/var/log
```

### Important Docker command

- Stop the docker image
```md
docker stop <container id>
```

- Remove the docker image
```md
docker rmi -f docker.apigee.net/apigee-edge-aio
```

- Start image (this will cause docker to fetch the latest image)
```md 
docker start docker.apigee.net/apigee-edge-aio
```
- Commit Changes

If you have not volume mounted, please use docker commit to save your changes of docker image. However volume mounting is most preferred way.
```md
docker commit
```

## Deploy With Docker-Compose
Please save the contents in docker-compose.yml file

```md
version: "3"
services:
  edge-aio:
    # specify an image version or 'latest'
    image: docker.apigee.net/apigee-edge-aio:latest
    ports:
      - "9000:9000"
      - "9001:9001"
      - "8080:8080"
      - "8079:8079"
      - "3000:3000"
      - "3001:3001"
      - "9090:9090"
      - "9099:9099"
    volumes:
      - ./license:/opt/apigee/license
      # uncomment if you need persistent data
      - ./customer:/opt/apigee/customer
      - ./data:/opt/apigee/data
      - ./log:/opt/apigee/var/log
    networks:
      - edge
networks:
  edge:
```

Start your docker container as follows
```md
docker-compose up
```


## Deploy on a Kubernetes Cluster
You can deploy the apigee edge aio docker image on a kubernetes cluster. 

- Create Kubernetes cluster with worker node size of 6 GB or more
- Create a docker registry secret

```md
kubectl create secret docker-registry apigeesecret  --docker-server=docker.apigee.net --docker-username=uName --docker-password=pWord --docker-email=email
```
-  Copy the contents to a file - kube-generic.yaml

```md
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: apigee-license
data:
  apigee-license.txt: 
---

kind: Service
apiVersion: v1
metadata:
  name: apigee
  labels:
    app: apigee
spec:
  ports:
  - name: admin-http
    protocol: TCP
    port: 9000
    targetPort: 9000
  - name: api-http
    protocol: TCP
    port: 9001
    targetPort: 9001
  - name: management-http
    protocol: TCP
    port: 8080
    targetPort: 8080
  - name: developer-http
    protocol: TCP
    port: 8079
    targetPort: 8079
 - name: ue-port
    protocol: TCP
    port: 3001
    targetPort: 3001
  - name: saml-sso-port
    protocol: TCP
    port: 9099
    targetPort: 9099
  - name: idp-port
    protocol: TCP
    port: 9090
    targetPort: 9090
  - name: developer-http
    protocol: TCP
    port: 8079
    targetPort: 8079
  - name: monitoring-http
    protocol: TCP
    port: 3000
    targetPort: 3000
  selector:
    app: apigee
  type: LoadBalancer
  sessionAffinity: None
---

kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: apigee
  labels:
    app: apigee
  annotations:
    deployment.kubernetes.io/revision: 1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apigee
  template:
    metadata:
      creationTimestamp: 
      labels:
        app: apigee
    spec:
      volumes:
      - name: empty-dir
        emptyDir: {}
      - name: apigee-data
        emptyDir: {}
      - name: apigee-customer
        emptyDir: {}
      - name: apigee-log
        emptyDir: {}
      - name: apigee-license
        configMap:
          name: apigee-license
          items:
          - key: apigee-license.txt
            path: license.txt
          defaultMode: 420
      containers:
      - name: apigee
        image: docker.apigee.net/apigee-edge-aio:latest
        ports:
        - containerPort: 9000
          name: admin-http
        - containerPort: 8080
          name: management-http
        - containerPort: 9001
          name: api-http
        - containerPort: 3000
          name: monitoring-http
        - containerPort: 8079
          name: developer-http
        - containerPort: 3001
          name: ue-port
        - containerPort: 9099
          name:  saml-sso-port
        - containerPort: 9090
          name:  idp-port
        resources: 
          limits:
            memory: "6144Mi"
            cpu: "2"
          requests:
            memory: "6144Mi"
            cpu: "1"
        volumeMounts:
        - name: apigee-data
          mountPath: "/opt/apigee/data"
        - name: apigee-customer
          mountPath: "/opt/apigee/customer"
        - name: apigee-log
          mountPath: "/opt/apigee/var/log"
        - name: apigee-license
          mountPath: "/opt/apigee/license"
        terminationMessagePath: "/dev/termination-log"
        terminationMessagePolicy: File
        imagePullPolicy: Always
        securityContext:
          privileged: true
      restartPolicy: Always
      terminationGracePeriodSeconds: 30
      dnsPolicy: ClusterFirst
      securityContext:
        fsGroup: 998
      schedulerName: default-scheduler
      imagePullSecrets:
      - name: apigeesecret
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 25%
      maxSurge: 25%
  revisionHistoryLimit: 10
  progressDeadlineSeconds: 600
---
```

-  If you want the data to be persisted, use persistent volume.  If you want the data to be persisted, use persistent volume. In case of GKE, copy and paste the contents below to a file - gke-deployment.yaml

```md
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: apigee-license
data:
  apigee-license.txt: My license text without any line breaks

---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: apigee-customer
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
  storageClassName: standard

---

kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: apigee-data
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
  storageClassName: standard

---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: apigee-log
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
  storageClassName: standard
---

kind: Service
apiVersion: v1
metadata:
  name: apigee
  labels:
    app: apigee
spec:
  ports:
  - name: admin-http
    protocol: TCP
    port: 9000
    targetPort: 9000
  - name: api-http
    protocol: TCP
    port: 9001
    targetPort: 9001
  - name: management-http
    protocol: TCP
    port: 8080
    targetPort: 8080
  - name: developer-http
    protocol: TCP
    port: 8079
    targetPort: 8079
  - name: monitoring-http
    protocol: TCP
    port: 3000
    targetPort: 3000
  - name: ue-port
    protocol: TCP
    port: 3001
    targetPort: 3001
  - name: saml-sso-port
    protocol: TCP
    port: 9099
    targetPort: 9099
  - name: idp-port
    protocol: TCP
    port: 9090
    targetPort: 9090
  selector:
    app: apigee
  type: LoadBalancer
  sessionAffinity: None

---

kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: apigee
  labels:
    app: apigee
  annotations:
    deployment.kubernetes.io/revision: 1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apigee
  template:
    metadata:
      creationTimestamp: 
      labels:
        app: apigee
    spec:
      volumes:
      - name: empty-dir
        emptyDir: {}
      - name: apigee-data
        persistentVolumeClaim:
          claimName: apigee-data
      - name: apigee-customer
        persistentVolumeClaim:
          claimName: apigee-customer
     - name: apigee-log
        persistentVolumeClaim:
          claimName: apigee-log
      - name: apigee-license
        configMap:
          name: apigee-license
          items:
          - key: apigee-license.txt
            path: license.txt
          defaultMode: 420
      containers:
      - name: apigee
        image: docker.apigee.net/apigee-edge-aio:latest
        ports:
        - containerPort: 9000
          name: admin-http
        - containerPort: 8080
          name: management-http
        - containerPort: 9001
          name: api-http
        - containerPort: 3000
          name: monitoring-http
        - containerPort: 8079
          name: developer-http
        - containerPort: 3001
          name: ue-port
        - containerPort: 9099
          name:  saml-sso-port
        - containerPort: 9090
          name:  idp-port
        resources: 
          limits:
            memory: "6144Mi"
            cpu: "2"
          requests:
            memory: "6144Mi"
            cpu: "1"
        volumeMounts:
        - name: apigee-data
          mountPath: "/opt/apigee/data"
        - name: apigee-customer
          mountPath: "/opt/apigee/customer"
        - name: apigee-license
          mountPath: "/opt/apigee/license"
        - name: apigee-log
          mountPath: "/opt/apigee/var/log"
        terminationMessagePath: "/dev/termination-log"
        terminationMessagePolicy: File
        imagePullPolicy: Always
        securityContext:
          privileged: true
      restartPolicy: Always
      terminationGracePeriodSeconds: 30
      dnsPolicy: ClusterFirst
      securityContext:
        fsGroup: 998
      schedulerName: default-scheduler
      imagePullSecrets:
      - name: apigeesecret
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 25%
      maxSurge: 25%
  revisionHistoryLimit: 10
  progressDeadlineSeconds: 600
---
```

- Paste license text in apigee-license.txt in the file. You can get the license without any  breaks as follows :
```md
cat license.txt | tr -d '\n'
```
- Create apigee edge service and deployment in Kubernetes cluster. If you are using GKE, use the gke-deployment.yaml else use kube-generic.yaml as described above.
```md
kubectl apply -f gke-deployment.yaml
kubectl get services

apigee       LoadBalancer   10.3.243.156   35.193.6.6    9000:32274/TCP,9001:30488/TCP,8080:31148/TCP,8079:32055/TCP,3000:30482/TCP   2m
```
- Access Edge as given in Access the product section mentioned above. 
- Update Virtualhost with Loadbalancer IP.


