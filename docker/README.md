#### Build the Ballerina program to generate the Docker image and Dockerfile.
```
$ ballerina build docker_deployment.bal
Compiling source
    docker_deployment.bal

Generating executable
    docker_deployment.balx
        @docker                  - complete 3/3

        Run the following command to start a Docker container:
        docker run -d -p 9090:9090 helloworld:v1.0
```

#### Verify if the Docker image is generated
```
$ docker images
REPOSITORY  TAG      IMAGE ID            CREATED             SIZE
helloworld  v1.0    8d5b2f26145b        2 seconds ago        127MB
```

#### Run the generated Docker image
```
$ docker run -d -p 9090:9090 helloworld:v1.0
```

#### Access the service
```
$ curl http://localhost:9090/helloWorld/sayHello
Hello World from Docker!
```
