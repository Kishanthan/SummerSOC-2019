import ballerina/io;
import ballerina/socket;

public function main() {
    socket:Client socketClient = new({ host: "localhost", port: 61598,
            callbackService: ClientService });
    string content = "Hello Ballerina";
    byte[] payloadByte = content.toByteArray("UTF-8");

    var writeResult = socketClient->write(payloadByte);
    if (writeResult is error) {
        io:println("Unable to written the content ", writeResult);
    }
}

service ClientService = service {

    resource function onConnect(socket:Caller caller) {
        io:println("Connect to: ", caller.remotePort);
    }

    resource function onReadReady(socket:Caller caller) {
        var result = caller->read();
        if (result is (byte[], int)) {
            var (content, length) = result;
            if (length > 0) {
                io:ReadableByteChannel byteChannel =
                    io:createReadableChannel(content);
                io:ReadableCharacterChannel characterChannel =
                    new io:ReadableCharacterChannel(byteChannel, "UTF-8");
                var str = characterChannel.read(25);
                if (str is string) {
                    io:println(untaint str);
                } else {
                    io:println("Error while reading characters ", str);
                }
            } else {
                io:println("Client close: ", caller.remotePort);
            }
        } else {
            io:println(result);
        }

        var closeResult = caller->close();
        if (closeResult is error) {
            io:println(closeResult);
        } else {
            io:println("Client connection closed successfully.");
        }
    }

    resource function onError(socket:Caller caller, error err) {
        io:println(err);
    }
};