import ballerina/grpc;
import ballerina/log;

service HelloWorld on new grpc:Listener(9090) {
    resource function hello (grpc:Caller caller, string name, grpc:Headers headers) {
        log:printInfo("Server received hello from " + name);
        string message = "Hello " + name;
        string reqHeader = headers.get("client_header_key") ?: "none";
        log:printInfo("Server received header value: " + reqHeader);

        grpc:Headers resHeader = new;
        resHeader.setEntry("server_header_key", "Response Header value");

        error? err = caller->send(message, headers = resHeader);
        if (err is error) {
            log:printError("Error from Connector: " + err.reason() + " - "
                                             + <string>err.detail().message);
        }

        error? result = caller->complete();
        if (result is error) {
            log:printError("Error in sending completed notification to caller",
                err = result);
        }
    }
}