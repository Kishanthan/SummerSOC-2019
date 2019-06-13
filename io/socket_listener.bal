import ballerina/io;
import ballerina/log;
import ballerina/socket;

service echoServer on new  socket:Listener(61598) {

    resource function onConnect(socket:Caller caller) {
        log:printInfo("Client connected: " + caller.id);
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
                var str = characterChannel.read(20);
                if (str is string) {
                    string reply = untaint str + " back";
                    byte[] payloadByte = reply.toByteArray("UTF-8");

                    var writeResult = caller->write(payloadByte);
                    if (writeResult is int) {
                        log:printInfo("Number of bytes written: " + writeResult);
                    } else {
                        log:printError("Unable to write the content",
                            err = writeResult);
                    }
                } else {
                    log:printError("Error while writing content to the caller",
                        err = str);
                }
            } else {
                log:printInfo("Client left: " + caller.remotePort);
            }
        } else {
            io:println(result);
        }
    }

    resource function onError(socket:Caller caller, error er) {
        log:printError("An error occured", err = er);
    }
}
