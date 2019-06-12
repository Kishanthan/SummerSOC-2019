import ballerina/http;
import ballerina/log;

final string NAME = "NAME";
final string AGE = "AGE";

@http:ServiceConfig {
    basePath: "/chat"
}
service chatAppUpgrader on new http:Listener(9090) {
    @http:ResourceConfig {
        webSocketUpgrade: {
                upgradePath: "/{name}",
                upgradeService: chatApp
        }
    }
    resource function upgrader(http:Caller caller, http:Request req,
                                string name) {
        http:WebSocketCaller wsEp;
        map<string> queryParams = req.getQueryParams();
        if (!queryParams.hasKey("age")) {
            var err = caller->cancelWebSocketUpgrade(400, "Age is required");
            if (err is error) {
                log:printError("Error cancelling handshake", err = err);
            }
            return;
        }
        map<string> headers = {};
        wsEp = caller->acceptWebSocketUpgrade(headers);
        wsEp.attributes[NAME] = name;
        wsEp.attributes[AGE] = queryParams["age"];
        string msg =
            "Hi " + name + "! You have successfully connected to the chat";
        var err = wsEp->pushText(msg);
        if (err is error) {
            log:printError("Error sending message", err = err);
        }
    }
}
map<http:WebSocketCaller> connectionsMap = {};service chatApp = @http:WebSocketServiceConfig {} service {
    resource function onOpen(http:WebSocketCaller caller) {
        string msg;
        msg = getAttributeStr(caller, NAME) + " with age "
                    + getAttributeStr(caller, AGE) + " connected to chat";
        broadcast(msg);
        connectionsMap[caller.id] = caller;
    }
    resource function onText(http:WebSocketCaller caller, string text) {
        string msg = getAttributeStr(caller, NAME) + ": " + text;
        log:printInfo(msg);
        broadcast(msg);
    }
    resource function onClose(http:WebSocketCaller caller, int statusCode,
                                string reason) {
        _ = connectionsMap.remove(caller.id);
        string msg = getAttributeStr(caller, NAME) + " left the chat";
        broadcast(msg);
    }
};

function broadcast(string text) {
    http:WebSocketCaller ep;
    foreach var (id, con) in connectionsMap {
        ep = con;
        var err = ep->pushText(text);
        if (err is error) {
            log:printError("Error sending message", err = err);
        }
    }
}

function getAttributeStr(http:WebSocketCaller ep, string key) returns (string) {
    var name = <string>ep.attributes[key];
    return name;
}
