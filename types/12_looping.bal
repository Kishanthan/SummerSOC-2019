import ballerina/io;

public function main () {
    int i = 0;
    // This is a basic `while` loop.
    while (i < 3) {
        io:println(i);
        i = i + 1;
    }

    int j = 0;
    while (j < 5) {
        // If you want to move to the next loop iteration immediately, use the `continue` statement as shown here.
        if (j < 3) {
            j = j + 1;
            continue;
        }
        io:println(j);

        // If you want to break the loop, use the `break` statement as shown here.
        if (j == 3) {
            break;
        }
    }

    string[] fruits = ["apple", "banana", "cherry"];

    // The `foreach` statement can be used to iterate an array. Each iteration returns an element in the array. Note
    // that the index of the corresponding element is not returned.
    foreach var v in fruits {
        io:println("fruit: " + v);
    }

    io:println("\nIterating a map :");
    map<string> words = { a: "apple", b: "banana", c: "cherry" };

    // Iterating a `map` will return the key (`string`) and the value as a `tuple` variable.
    // We can use tuple destructuring to split the tuple variable in to two variables.
    foreach var (k, v) in words {
        io:println("letter: " + k + ", word: " + v);
    }

}