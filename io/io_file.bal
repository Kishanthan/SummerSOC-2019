import ballerina/io;
import ballerina/log;

function getReadableRecordChannel(string filePath, string encoding, string rs, string fs) returns (io:ReadableTextRecordChannel) {
    io:ReadableByteChannel byteChannel = io:openReadableFile(filePath);
    io:ReadableCharacterChannel characterChannel = new(byteChannel, encoding);
    io:ReadableTextRecordChannel delimitedRecordChannel = new(characterChannel,
                                                              rs = rs,
                                                              fs = fs);
    return delimitedRecordChannel;
}
function getWritableRecordChannel(string filePath, string encoding, string rs, string fs) returns (io:WritableTextRecordChannel) {
    io:WritableByteChannel byteChannel = io:openWritableFile(filePath);
    io:WritableCharacterChannel characterChannel = new(byteChannel, encoding);
    io:WritableTextRecordChannel delimitedRecordChannel = new(characterChannel,
                                                              rs = rs,
                                                              fs = fs);
    return delimitedRecordChannel;
}
function process(io:ReadableTextRecordChannel srcRecordChannel, io:WritableTextRecordChannel dstRecordChannel) returns error? {
    while (srcRecordChannel.hasNext()) {
        string[] records = check srcRecordChannel.getNext();
        var result = check dstRecordChannel.write(records);
    }
    return;
}

function closeRc(io:ReadableTextRecordChannel rc) {
    var closeResult = rc.close();
    if (closeResult is error) {
        log:printError("Error occured while closing the channel: ",
                       err = closeResult);
    }
}

function closeWc(io:WritableTextRecordChannel wc) {
    var closeResult = wc.close();
    if (closeResult is error) {
        log:printError("Error occured while closing the channel: ",
                       err = closeResult);
    }
}

public function main() {
    string srcFileName = "./files/sample.txt";
    string dstFileName = "./files/sampleResponse.txt";
    io:ReadableTextRecordChannel srcRecordChannel =
    getReadableRecordChannel(srcFileName, "UTF-8", "\\r?\\n", ",");
    io:WritableTextRecordChannel dstRecordChannel =
    getWritableRecordChannel(dstFileName, "UTF-8", "\r\n", "|");
    io:println("Start processing the text file from " + srcFileName + " to the text file in " + dstFileName);
    var result = process(srcRecordChannel, dstRecordChannel);
    if (result is error) {
        log:printError("An error occurred while processing the records: ", err = result);
    } else {
        io:println("Processing completed. The processed file is located in ", dstFileName);
    }
    closeRc(srcRecordChannel);
    closeWc(dstRecordChannel);
}
