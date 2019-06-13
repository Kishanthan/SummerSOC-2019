import ballerina/io;
public function main () {
    // Optional types of string, int and nil
    // The value can take any of the type
    string|int|() value = 5;
    value = "foo";
    value = ();

    // Optional types.
    // string? is same as string|()
    string? s = "some value";

    io:println(s);
}