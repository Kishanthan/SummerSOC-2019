import ballerina/io;

function main(string... args) {
    string|int status = 10;

    match status {
        string s => { io:println("Im a string"); }
        int i => { io:println("Im an integer"); }
    }

    string s = status but { int i => "integer"}; 
}
