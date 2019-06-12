import ballerina/config;
import ballerina/http;
import ballerina/log;
import ballerinax/kubernetes;

@kubernetes:Service {
    serviceType: "NodePort"
}

@kubernetes:Ingress {
    hostname: "abc.com"
}
listener http:Listener helloWorldEP = new(9090, config = {
    secureSocket: {
        keyStore: {
            path: "${ballerina.home}/bre/security/ballerinaKeystore.p12",
            password: "ballerina"
        },
        trustStore: {
            path: "${ballerina.home}/bre/security/ballerinaTruststore.p12",
            password: "ballerina"
        }
    }
});

@kubernetes:ConfigMap {
    conf: "./ballerina.conf"
}

@kubernetes:Deployment {
    livenessProbe: true,
    image: "kubernetes:v.1.0"
}
@http:ServiceConfig {
    basePath: "/helloWorld"
}
service helloWorld on helloWorldEP {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/config/{user}"
    }
    resource function getConfig(http:Caller outboundEP, http:Request request, string user) {
        string userId = getConfigValue(user, "userid");
        string groups = getConfigValue(user, "groups");
        json payload = {
            userId: userId,
            groups: groups
        };
        var responseResult = outboundEP->respond(payload);
        if (responseResult is error) {
            error err = responseResult;
            log:printError("Error sending response", err = err);
        }
    }
}

function getConfigValue(string instanceId, string property) returns (string) {
    string key = untaint instanceId + "." + untaint property;
    return config:getAsString(key, defaultValue = "Invalid User");
}