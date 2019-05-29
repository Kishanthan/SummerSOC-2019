import ballerina/io;

function main (string... args) {
    // while loop
    int i = 0;
    while(i < 10) {
        if (i == 5) {
            continue;
        }
        if (i == 7) {
            break;
        }
        i++;
    }

    // foreach loop
    string[] colors= ["red", "blue", "white"];
    foreach item in colors {
        io:println(item);
    }

}