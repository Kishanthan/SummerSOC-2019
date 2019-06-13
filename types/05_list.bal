import ballerina/io;

public function main () {

    // Arrays.
    int[] a = [1, 2, 3, 4, 5, 6, 7, 8];
    int val = a[2];
    a[999] = 100;

    string[2] b = ["apple", "orange"];
    string[*] c = ["apple", "orange"];

    // Tuple
    (int, string, int) tuple1 = (1, "its a string value", 5);
    string value = tuple1[1];

    io:println(value);

    (string, int, boolean) tuple2 = getTupleData();
}

function getTupleData() returns (string, int, boolean) {
    return ("aString", 10, false);
}