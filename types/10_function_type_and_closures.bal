import ballerina/io;

public function main() {
    int a = 2;

    var outerFunc = function (int x) returns int {
        int b = 18;
        
        function (int) innerFunc = function (int y) returns () {
            a += 1;
            b -= 1;
        };

        return b;
    };

    // invoking the function using the variable
    int result = outerFunc.call(2);
    io:println("Answer: " + result);


    // Value `test` will serve as a function pointer to the `foo` function.
    io:println("Answer: " + foo(10, test));
    io:println("Answer: " + foo(10, getFunctionPointer()));
    
    // Function pointer as a variable.
    function (int) returns float f = getFunctionPointer();
    io:println("Answer: " + foo(10, f));
}


// The `test` function acts as a variable function pointer in the `main` function
function test(int x) returns float {
    return x * 1.0 * 10;
}

// Function pointer as a parameter. Use the `.call()` method to invoke the function using the function pointer.
function foo(int x, function (int) returns float bar) returns float {
    return x * bar.call(10);
}

// Function pointer as a return type.
function getFunctionPointer() returns (function (int) returns float) {
    return test;
}
