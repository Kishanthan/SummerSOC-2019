import ballerina/io;

public function main () {
    // while loop
    int i = 0;
    while(i < 10) {
        if (i == 5) {
            continue;
        }
        if (i == 7) {
            break;
        }
        i += 1;
    }

    // foreach loop
    string[] colors= ["red", "blue", "white"];
    foreach var item in colors {
        io:println(item);
    }

}