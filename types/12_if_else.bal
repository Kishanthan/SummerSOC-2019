import ballerina/io;

public function main() {
    int value = 10;
    
    if (value > 0) {
        io:println("positive number");
    } else if (value < 0) {
        io:println("negative number");
    } else {
        io:println("zero");
    }

    // ternary expression
    string status = (value >= 0) ? "positive" : "negative";
}
