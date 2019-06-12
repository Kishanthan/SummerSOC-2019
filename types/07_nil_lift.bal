import ballerina/io;

public function main (string... args) {
    map<string>? m = ();
    string? s1 = m.name;

    // eliminate nil using elvis operator
    string s3 = m.name ?: "N/A";

    io:println(s3);
}