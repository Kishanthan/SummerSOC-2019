import ballerina/io;

type Employee record {
    int id;
    string name;
    float salary;
};

public function main(string... args) {
    // This creates an in-memory `table` constrained by the `Employee` type with `id` marked as the
    // primary key in the column descriptor. Three data records are inserted to the `table`. Order of
    // the data values should match the order of the column descriptor.
    table<Employee> tbEmployee = table {
        { key id, name, salary },
        [ { 1, "Mary",  300.5 },
          { 2, "John",  200.5 },
          { 3, "Jim", 330.5 }
        ]
    };
    
    // This prints the `table` data.
    io:print("Table Information: ");
    io:println(tbEmployee);

    // Create `Employee` records.
    Employee e1 = { id: 1, name: "Jane", salary: 300.50 };
    Employee e2 = { id: 2, name: "Anne", salary: 100.50 };
    Employee e3 = { id: 3, name: "John", salary: 400.50 };
    Employee e4 = { id: 4, name: "Peter", salary: 150.0 };

    // This creates an in-memory `table` constrained by the `Employee` type with `id` as the primary key.
    // Two records are inserted to the `table`.
    table<Employee> tb = table {
        { key id, name, salary },
        [e1, e2]
    };
}
