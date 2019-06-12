import ballerina/http;
import ballerina/io;
http:Client clientEndpoint = new("https://postman-echo.com");

public function main() {
    io:println("GET request:");
    var response = clientEndpoint->get("/get?test=123");
    handleResponse(response);    io:println("\nPOST request:");
    http:Request req = new;
    req.setPayload("POST: Hello World");
    response = clientEndpoint->post("/post", req);
    handleResponse(response);    io:println("\nDELETE request:");
    req.setPayload("DELETE: Hello World");
    response = clientEndpoint->delete("/delete", req);
    handleResponse(response);    io:println("\nUse custom HTTP verbs:");
    req.setPayload("CUSTOM: Hello World");
    response = clientEndpoint->execute("COPY", "/get", req);
    req = new;
    req.addHeader("Sample-Name", "http-client-connector");
    response = clientEndpoint->get("/get", message = req);
    if (response is http:Response) {
        string contentType = response.getHeader("Content-Type");
        io:println("Content-Type: " + contentType);        int statusCode = response.statusCode;
        io:println("Status code: " + statusCode);    } else {
        io:println("Error when calling the backend: " , response.reason());
    }
}

function handleResponse(http:Response|error response) {
    if (response is http:Response) {
        var msg = response.getJsonPayload();
        if (msg is json) {
            io:println(msg);
        } else {
            io:println("Invalid payload received:" , msg.reason());
        }
    } else {
        io:println("Error when calling the backend: ", response.reason());
    }
}
