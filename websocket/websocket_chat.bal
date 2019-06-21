import ballerina/http;
import ballerina/log;

final string NAME = "NAME";
final string AGE = "AGE";

@http:ServiceConfig {
    basePath: "/chat"
}
service chatAppUpgrader on new http:Listener(9090) {

    // Upgrade from HTTP to WebSocket and define the service the WebSocket client needs to connect to.
    @http:ResourceConfig {
        webSocketUpgrade: {
                upgradePath: "/{name}",
                upgradeService: chatApp
        }
    }
    resource function upgrader(http:Caller caller, http:Request req,
                                string name) {
        http:WebSocketCaller wsEp;
        // Retrieves query parameters from the `http:Request`.
        map<string> queryParams = req.getQueryParams();
        // Cancel handshake by sending a 400 status code if the age parameter is missing in the request.
        if (!queryParams.hasKey("age")) {
            var err = caller->cancelWebSocketUpgrade(400, "Age is required");
            if (err is error) {
                log:printError("Error cancelling handshake", err = err);
            }
            return;
        }
        map<string> headers = {};
        wsEp = caller->acceptWebSocketUpgrade(headers);
        // The attributes map of the caller is useful for storing connection specific data.
        // In this case `NAME`and `AGE` are unique to each connection.
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

// Stores the connection IDs of users who join the chat.
map<http:WebSocketCaller> connectionsMap = {};

service chatApp = @http:WebSocketServiceConfig {} service {

    // Once a user connects to the chat, store the attributes of the user, such as username and age, and
    // broadcast that the user has joined the chat.
    resource function onOpen(http:WebSocketCaller caller) {
        string msg;
        msg = getAttributeStr(caller, NAME) + " with age "
                    + getAttributeStr(caller, AGE) + " connected to chat";
        broadcast(msg);
        connectionsMap[caller.id] = caller;
    }

    // Broadcast the messages sent by a user.
    resource function onText(http:WebSocketCaller caller, string text) {
        string msg = getAttributeStr(caller, NAME) + ": " + text;
        log:printInfo(msg);
        broadcast(msg);
    }

    // Broadcast that a user has left the chat once a user leaves the chat.
    resource function onClose(http:WebSocketCaller caller, int statusCode, string reason) {
        _ = connectionsMap.remove(caller.id);
        string msg = getAttributeStr(caller, NAME) + " left the chat";
        broadcast(msg);
    }
};

// Function to perform the broadcasting of text messages.
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

function getAttributeStr(http:WebSocketCaller ep, string key)
             returns (string) {
    var name = <string>ep.attributes[key];
    return name;
}
