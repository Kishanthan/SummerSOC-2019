import ballerina/io;
// a simple function
function simpleFunc(int a) returns int {
    return a + 1;
}

// required and defaultable parameters
function defaultableParams(int a, string op = "inc") {
    io:println(op);
}

// rest parameter
function restParams(int a, string... names) {
    io:println(names[2]);
}

public function main() {
    var result = simpleFunc(4);

    defaultableParams(5, op = "dec");
    defaultableParams(5);

    restParams(3, "a", "b", "c");

    // pass an array as the rest parameter
    string[] letters = ["a", "b", "c", "d"]; 
    restParams(3, ...letters);
}
