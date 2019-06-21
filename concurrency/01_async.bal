import ballerina/http;
import ballerina/io;
import ballerina/runtime;

int count = 0;

http:Client clientEndpoint = new("https://postman-echo.com", config = {});

public function main() {

    // Example - 01 
    // Asynchronously call the function named `sum()`.
    future<int> f1 = start sum(40, 50);
    // You can pass the value of the `future` variable around
    // and call its results later.
    int result = squarePlusCube(f1);
    // Wait for future `f1` to finish.
    _ = wait f1;
    io:println("SQ + CB = ", result);


    // Example - 02 
    // Call the `countInfinity()` function, that runs forever in asynchronous
    // mode.
    future<()> f2 = start countInfinity();
    // Check if the function call is done.
    io:println(f2.isDone());
    // Check if someone cancelled the asynchronous execution.
    io:println(f2.isCancelled());
    // Cancel the asynchronous execution.
    boolean cancelled = f2.cancel();
    io:println(cancelled);
    io:println("Counting done in one second: ", count);


    // Example - 03 
    // Asynchronously invoke the action call `get()`.
    future<http:Response|error> f3 = start clientEndpoint->get("/get?test=123");
    // Check if the action call is done.
    io:println(f3.isDone());
    // Wait for action call `f3` to finish.
    http:Response|error response = wait f3;
    // Print the response payload of the action call if successful, or print the
    // reason for failure.
    if (response is http:Response) {
        io:println(untaint response.getJsonPayload());
    } else {
        io:println(response.reason());
    }
    // Check if the action call is done after waiting for it to complete.
    io:println(f3.isDone());


    // Example - 04 
    // Asynchronously invoke the functions named `square()` and `greet()`.
    future<int> f4 = start square(20);
    future<string> f5 = start greet("Bert");

    // You can wait for any one of the given futures to complete.
    // Here `f4` will finish before `f5` since `runtime:sleep()` is called
    // in the `greet()` function to delay its execution. The value returned
    // by the future that finishes first will be taken as the result.
    int|string anyResult = wait f4 | f5;
    io:println(anyResult);
}

function sum(int a, int b) returns int {
    return a + b;
}

function square(int n) returns int {
    return n * n;
}

function cube(int n) returns int {
    return n * n * n;
}

function greet(string name) returns string {
    // A `runtime:sleep` is added to delay the execution.
    runtime:sleep(2000);
    return "Hello " + name + "!!";
}

function squarePlusCube(future<int> f) returns int {
    worker w1 {
        int n = wait f;
        int sq = square(n);
        sq -> w2;
    }
    worker w2 returns int {
        int n = wait f;
        int cb = cube(n);
        int sq;
        sq = <- w1;
        return sq + cb;
    }
    // Wait for worker `W2` to complete.
    return wait w2;
}

function countInfinity() {
    while (true) {
        count += 1;
    }
}
