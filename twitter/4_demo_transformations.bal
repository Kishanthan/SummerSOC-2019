import ballerina/config;
import ballerina/http;
import wso2/twitter;

twitter:Client tw = new({
        clientId: config:getAsString("clientId"),
        clientSecret: config:getAsString("clientSecret"),
        accessToken: config:getAsString("accessToken"),
        accessTokenSecret: config:getAsString("accessTokenSecret"),
        clientConfig: {}
});

@http:ServiceConfig { basePath: "/" }
service hello on new http:Listener(9090) {

    @http:ResourceConfig {
        path: "/",
        methods: ["POST"]
    }
    resource function hi (http:Caller caller, http:Request request) {
        string payload = checkpanic request.getTextPayload();
        payload = payload + " #ballerina";

        twitter:Status st = checkpanic tw->tweet(payload);
        json respJson = {
            text: payload,
            id: st.id,
            agent: "ballerina"
        };

        checkpanic caller->respond(untaint respJson);
    }
}
