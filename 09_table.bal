function main(string... args) {
    // table constrained with Student record
    table<Student> tbStudent = table {
        {primarykey id, name, age },
        [
            { 1, "John",  34 },
            { 2, "Anne",  24 }
        ]
    };
}

type Student record {
    int id;
    string name;
    int age;
};
