import ballerina/io;

// This function returns a value of the `anydata` type.
function getValue() returns anydata {
    string name = "cat";
    return name;
}

public function main() {
    // anydata example
    // In this example, the variable named `a` of the `anydata` type holds an `int` value.
    anydata a = 5;
    io:println(a);

    // Before using the value of `a` in arithmetic operations, we need to
    // ascertain that it is indeed an `int`. To this end, a type cast or
    // a type guard can be used.
    int intVal = <int>a;
    io:println(intVal + 10);

    if (a is int) {
        io:println(a + 20);
    }

    // A variable of type `anydata` can hold any value of an `anydata` compatible type.
    int[] ia = [1, 3, 5, 6];
    anydata ar = ia;
    io:println(ar);

    io:println(getValue());

    // any example
    // In this example, the variable named `a` of the `any` type holds
    // a `Person` object.
    any b = new Person("John", "Doe");

    // Before anything useful can be done with `a`, we need to ascertain
    // its type. To this end, a type cast or a type guard can be used.
    Person john = <Person>b;
    io:println("Full name: ", john.getFullName());

    if (b is Person) {
        io:println("First name: ", john.fname);
    }

    // Variables of type `any` can hold values of any type except for `error`.
    int[] ib = [1, 3, 5, 6];
    any br = ib;
    io:println(ar);
}


type Person object {
    string fname;
    string lname;

    function __init(string fname, string lname) {
        self.fname = fname;
        self.lname = lname;
    }

    function getFullName() returns string {
        return self.fname + " " + self.lname;
    }
};