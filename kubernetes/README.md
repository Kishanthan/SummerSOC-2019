#### Create a `ballerina.conf` file with following content in the same directory as kubernetes_deployment.bal file.
```
[john]
userid="john@ballerina.com"
groups="apim,esb"
[jane]
userid="jane3@ballerina.com"
groups="esb"
```


#### Build the ballerina program
```
$ ballerina build kubernetes_deployment.bal
Compiling source
    kubernetes_deployment.bal

Generating executable
    kubernetes_deployment.balx
        @kubernetes:Service                      - complete 1/1
        @kubernetes:Ingress                      - complete 1/1
        @kubernetes:Secret                       - complete 1/1
        @kubernetes:ConfigMap                    - complete 1/1
        @kubernetes:Deployment                   - complete 1/1
        @kubernetes:Docker                       - complete 3/3

        Run the following command to deploy the Kubernetes artifacts:
        kubectl apply -f ./kubernetes
```

#### Verify the docker image is generated
```
$ docker images
REPOSITORY  TAG      IMAGE ID            CREATED             SIZE
kubernetes  v1.0   6c0a26a62545        2 seconds ago       127MB
```

#### Run generated docker image
```
$ kubectl apply -f ./kubernetes/
service/helloworldep-svc created
ingress.extensions/helloworldep-ingress created
secret/helloworldep-secure-socket created
configmap/helloworld-ballerina-conf-config-map created
deployment.extensions/kubernetes-deployment-deployment created
```

#### Verify the service, pods & config-maps are deployed
```
$ kubectl get pods
NAME                                     READY     STATUS   RESTARTS   AGE
kubernetes-deployment-5858fd78d4-lnz8n   1/1       Running   0         20s

$ kubectl get svc
NAME                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
helloworldep-svc    NodePort    10.109.125.193   <none>        9090:32417/TCP   1m

$ kubectl get cm
NAME                                   DATA      AGE
helloworld-ballerina-conf-config-map   1         5m

$ kubectl get ingress
NAME                        HOSTS                 ADDRESS   PORTS     AGE
helloworldep-ingress        abc.com                         80, 443   183d
```

#### Using ingress
Add /etc/hosts entry to match hostname. (127.0.0.1 is only applicable to docker for mac users. Other users should map the hostname with correct ip address from kubectl get ingress command.)
```
127.0.0.1 abc.com
```

#### Access the service
```
$ curl http://abc.com/helloWorld/config/jane -k
{userId: jane3@ballerina.com, groups: esb}

$ curl http://abc.com/helloWorld/config/john -k
{userId: john@ballerina.com, groups: apim,esb}
```

#### For information and more examples
[https://github.com/ballerinax/kubernetes](https://github.com/ballerinax/kubernetes) 
