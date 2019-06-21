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

    // value based match
    string[] animals = ["Cat", "Canine", "Mouse", "Horse"];
    foreach string animal in animals {
        // The value match can also be used with binary OR expression.
        match animal {
            "Mouse" => io:println("Mouse");
            "Dog"|"Canine" => io:println("Dog");
            "Cat"|"Feline" => io:println("Cat");
            // The pattern `_` can be used as the final static value match pattern which will be matched to all values.
            _ => io:println("Match All");
        }
    }
}
