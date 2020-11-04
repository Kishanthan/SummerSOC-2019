import ballerina/http;
import ballerina/log;
import ballerina/io;
http:Client clientEP1 = new("https://api.bitbucket.org/2.0", config = {
        auth: {
            scheme: http:OAUTH2,
            config: {
                grantType: http:CLIENT_CREDENTIALS_GRANT,
                config: {
                    tokenUrl: "https://bitbucket.org/site/oauth2/access_token",
                    clientId: "Client_ID_Value",
                    clientSecret: "Client_Secret_Value"
            }
        }
    }
});

http:Client clientEP2 = new("https://api.bitbucket.org/2.0", config = {
        auth: {
            scheme: http:OAUTH2,
            config: {
                grantType: http:PASSWORD_GRANT,
                config: {
                    tokenUrl: "https://bitbucket.org/site/oauth2/access_token",
                    username: "b7a.demo@gmail.com",
                    password: "ballerina",
                    clientId: "Client_ID_Value",
                    clientSecret: "Client_Secret_Value"
                    refreshConfig: {
                        refreshUrl: "https://bitbucket.org/site/oauth2/access_token"
                }
            }
        }
    }
});


public function main() {
    var response1 = clientEP1->get("/repositories/b7ademo");
    if (response1 is http:Response) {
        var result = response1.getJsonPayload();
        log:printInfo(result is error ? "Failed to retrieve payload for clientEP1." : <string> result.values[0].uuid);
    } else {
        log:printError("Failed to call the endpoint.", err = response1);
    }
    var response2 = clientEP2->get("/repositories/b7ademo");
    if (response2 is http:Response) {
        var result = response2.getJsonPayload();
        log:printInfo((result is error) ? "Failed to retrieve payload for clientEP2." : <string> result.values[0].uuid);
    } else {
        log:printError("Failed to call the endpoint.", err = response2);
    }
}
