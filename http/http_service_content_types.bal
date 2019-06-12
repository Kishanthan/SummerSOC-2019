import ballerina/http;
import ballerina/log;


service infoService on new http:Listener(9092) {
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/",
        consumes: ["text/json", "application/json"],
        produces: ["application/xml"]
    }
    resource function student(http:Caller caller, http:Request req) {
        http:Response res = new;
        var msg = req.getJsonPayload();
        if (msg is json) {
            string nameString = <string>msg["name"];
            if (validateString(nameString)) {
                xml name = xml `<name>${untaint nameString}</name>`;
                res.setXmlPayload(name);
            } else {
                res.statusCode = 400;
                res.setPayload("Name contains invalid data");
            }
        } else {
            res.statusCode = 500;
            res.setPayload(untaint <string>msg.detail().message);
        }        
        
        var result = caller->respond(res);
        if (result is error) {
           log:printError("Error in responding", err = result);
        }
    }
}

function validateString(string nameString) returns boolean {
    var result = nameString.matches("[a-zA-Z]+");
    if (result is error) {
        return false;
    } else {
        return result;
    }
}
