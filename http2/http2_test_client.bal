import ballerina/http;
import ballerina/log;
http:Client clientEP = new("http://localhost:7090",
    config = { httpVersion: "2.0" });

public function main() {
    http:Request serviceReq = new;
    http:HttpFuture httpFuture = new;
    var submissionResult = clientEP->submit("GET", "/http2Service", serviceReq);

    if (submissionResult is http:HttpFuture) {
        httpFuture = submissionResult;
    } else {
        log:printError("Error occurred while submitting a request",
            err = submissionResult);
        return;
    }
    http:PushPromise?[] promises = [];
    int promiseCount = 0;
    boolean hasPromise = clientEP->hasPromise(httpFuture);

    while (hasPromise) {
        http:PushPromise pushPromise = new;
        var nextPromiseResult = clientEP->getNextPromise(httpFuture);

        if (nextPromiseResult is http:PushPromise) {
            pushPromise = nextPromiseResult;
        } else {
            log:printError("Error occurred while fetching a push promise",
                err = nextPromiseResult);
            return;
        }
        log:printInfo("Received a promise for " + pushPromise.path);
        if (pushPromise.path == "/resource2") {
            clientEP->rejectPromise(pushPromise);

            log:printInfo("Push promise for resource2 rejected");
        } else {
            promises[promiseCount] = pushPromise;

            promiseCount = promiseCount + 1;
        }
        hasPromise = clientEP->hasPromise(httpFuture);
    }
    http:Response response = new;
    var result = clientEP->getResponse(httpFuture);

    if (result is http:Response) {
        response = result;
    } else {
        log:printError("Error occurred while fetching response",
            err = result);
        return;
    }
    var responsePayload = response.getJsonPayload();
    if (responsePayload is json) {
        log:printInfo("Response : " + responsePayload.toString());
    } else {
        log:printError("Expected response payload not received",
          err = responsePayload);
    }
    foreach var p in promises {
        http:PushPromise promise = <http:PushPromise> p;
        http:Response promisedResponse = new;
        var promisedResponseResult = clientEP->getPromisedResponse(promise);
        if (promisedResponseResult is http:Response) {
            promisedResponse = promisedResponseResult;
        } else {
            log:printError("Error occurred while fetching promised response",
                err = promisedResponseResult);
            return;
        }
        var promisedPayload = promisedResponse.getJsonPayload();
        if (promisedPayload is json) {
            log:printInfo("Promised resource : " + promisedPayload.toString());
        } else {
            log:printError("Expected promised response payload not received",
                err = promisedPayload);
        }
    }
}