import ballerina/io;

public function main () {

    // Variable length arrays.
    int[] a = [1, 2, 3, 4, 5, 6, 7, 8];
    int val = a[2];
    a[999] = 100;

    // Fixed length arrays.
    string[2] b = ["apple", "orange"];
    string[*] c = ["apple", "orange"];

    // Tuple : a list of two or more values of fixed length.
    (int, string, int) tuple1 = (1, "its a string value", 5);
    string value = tuple1[1];

    io:println(value);

    (string, int, boolean) tuple2 = getTupleData();
}

function getTupleData() returns (string, int, boolean) {
    return ("aString", 10, false);
}