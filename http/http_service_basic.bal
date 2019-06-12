import ballerina/http;
import ballerina/log;

@http:ServiceConfig {
    basePath: "/foo"
}
service echo on new http:Listener(9090) {
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/bar"
    }
    resource function echo(http:Caller caller, http:Request req) {
        var payload = req.getJsonPayload();
        http:Response res = new;
        if (payload is json) {
            if (validateJson(payload.hello)) {
                res.setJsonPayload(untaint payload);
            } else {
                res.statusCode = 400;
                res.setPayload("JSON containted invalid data");
            }
        } else {
            res.statusCode = 500;
            res.setPayload(untaint <string>payload.detail().message);
        }
        var result = caller->respond(res);
        if (result is error) {
           log:printError("Error in responding", err = result);
        }
    }
}

function validateJson(json payload) returns boolean {
    var result = payload.toString().matches("[a-zA-Z]+");
    if (result is error) {
        return false;
    } else {
        return result;
    }
}
