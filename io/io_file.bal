import ballerina/io;
import ballerina/log;

// Copies content from the source channel to a destination channel.
function copy(io:ReadableByteChannel src, io:WritableByteChannel dst) returns error? {
    int readCount = 1;
    byte[] readContent;
    // Here is how to read all the content from
    // the source and copy it to the destination.
    while (readCount > 0) {
        // The operation attempts to read a maximum of 1000 bytes and returns
        // with the available content, which could be < 1000.
        (byte[], int) result = check src.read(1000);
        (readContent, readCount) = result;
        // The operation writes the given content into the channel.
        var writeResult = check dst.write(readContent, 0);
    }
    return;
}

// Closes a given readable or writable byte channel.
function close(io:ReadableByteChannel|io:WritableByteChannel ch) {
    abstract object {
        public function close() returns error?;
    } channelResult = ch;
    var cr = channelResult.close();
    if (cr is error) {
        log:printError("Error occurred while closing the channel: ", err = cr);
    }
}

public function main() {
    string srcPath = "./files/ballerina.txt";
    string dstPath = "./files/ballerinaCopy.txt";
    // Initializes the readable byte channel.
    io:ReadableByteChannel srcCh = io:openReadableFile(srcPath);
    // Initializes the writable byte channel.
    io:WritableByteChannel dstCh = io:openWritableFile(dstPath);
    io:println("Start to copy files from " + srcPath + " to " + dstPath);
    // Copy the source byte channel to the target byte channel.
    var result = copy(srcCh, dstCh);
    if (result is error) {
        log:printError("error occurred while performing copy ", err = result);
    } else {
        io:println("File copy completed. The copied file is located at " + dstPath);
    }
    // Close the connections.
    close(srcCh);
    close(dstCh);
}
