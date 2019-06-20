import ballerina/io;

type Address record {
    string line01;
    string line02;
    string city;
    string state;
    string zipcode;
};

// According to the `Person` record type descriptor, the `addr` field could either hold an `Address` record or the value nil (`()`).
type Person record {
    string name;
    int age;
    Address? addr;
};

// This function optionally returns a `Person` value.
function getPerson(string name, int age) returns Person? {
    if (name == "" || age == 0) {
        return;
    } else {
        Person p = {
            name: name,
            age: age,
            addr: {
                line01: "No. 61",
                line02: "Brandon street",
                city: "Santa Clara",
                state: "CA",
                zipcode: "95134"
            }
        };
        return p;
    }
}

public function main() {
    // The field access operator is a lifted operator in Ballerina.
    // The types of both `p1` and `p1.addr` are optional types.
    // If the type of either `p1` or `p1.addr` is `()` at run time, `()` would
    // be assigned to the `city1` variable, else the `string` value of `p1.addr.city`
    // would be assigned.
    Person? p1 = getPerson("John", 30);
    io:println(p1);

    string? city1 = p1.addr.city;
    // The value "Santa Clara" is displayed in the console.
    io:println(city1);

    // Invoking `getPerson()` as follows will result in `()` being assigned to `p2`.
    Person? p2 = getPerson("", 0);
    // The `city2` variable will thus contain `nil` as the value.
    string? city2 = p2.addr.city;
    io:println(city2);

    // Here, the Elvis operator is used to eliminate `nil`.
    // If the value of the first expression is not `nil`, the Elvis operator returns that value.
    // If the value of the first expression is `nil`, the operator returns the value of the second expression.
    string defaultCity = "San Jose";
    string city = city2 ?: defaultCity;
    io:println(city);
}