import ballerina/io;
type Person record {
    int id;
    int age = -1;
    float salary;
    string name;
    boolean married;
};

type Order record {
    int personId;
    int orderId;
    string items;
    float amount;
};

type SummedOrder record {
    int personId;
    float amount;
};

type OrderDetails record {
    int orderId;
    string personName;
    string items;
    float amount;
};

type PersonPublicProfile record {
    string knownName;
    int age = -1;
};

public function main() {
    string queryStmt = "";

    Person p1 = { id: 1, age: 25, salary: 1000.50, name: "jane", married: true };
    Person p2 = { id: 2, age: 26, salary: 1050.50, name: "kane", married: false };
    Person p3 = { id: 3, age: 27, salary: 1200.50, name: "jack", married: true };
    Person p4 = { id: 4, age: 28, salary: 1100.50, name: "alex", married: false };

    table<Person> personTable = table {
        { id, age, salary, name, married },
        [p1, p2, p3, p4]
    };

    printTable(queryStmt, "The personTable:  ", personTable);

    Order o1 =
    { personId: 1, orderId: 1234, items: "pen, book, eraser", amount: 34.75 };
    Order o2 =
    { personId: 1, orderId: 2314, items: "dhal, rice, carrot", amount: 14.75 };
    Order o3 =
    { personId: 2, orderId: 5643, items: "Macbook Pro", amount: 2334.75 };
    Order o4 = { personId: 3, orderId: 8765, items: "Tshirt", amount: 20.75 };

    table<Order> orderTable = table {
        { personId, orderId, items, amount },
        [o1, o2, o3, o4]
    };

    printTable(queryStmt, "The orderTable: ", orderTable);


    table<Person> personTableCopy = from personTable select *;
    queryStmt = "\ntable<Person> personTableCopy = from personTable select *;";
    printTable(queryStmt,"personTableCopy: ", personTableCopy);

    table<Person> orderedPersonTable = from personTable select * order by salary;
    queryStmt = "\ntable<Person> orderedPersonTable = " +
            "from personTable select * order by salary;";
    printTable(queryStmt, "orderedPersonTable: ", orderedPersonTable);

    table<Person> personTableCopyWithFilter =
                 from personTable where name == "jane" select *;
    queryStmt = "\ntable<Person> personTableCopyWithFilter = " +
            "from personTable where name == 'jane' select *;";
    printTable(queryStmt, "personTableCopyWithFilter: ", personTableCopyWithFilter);

    table<PersonPublicProfile> childTable = from personTable
                  select name as knownName, age;
    queryStmt = "\ntable<PersonPublicProfile > childTable = " +
                    "from personTable select name as knownName, age;";
    printTable(queryStmt, "childTable: ", childTable);

    table<SummedOrder> summedOrderTable = from orderTable
                  select personId, sum(amount) group by personId;
    queryStmt = "\ntable<SummedOrder> summedOrderTable = " +
            "from orderTable select personId, sum(amount) group by personId;";
    printTable(queryStmt, "summedOrderTable: ", summedOrderTable);

    table<OrderDetails> orderDetailsTable =
                    from personTable as tempPersonTable
                    join orderTable as tempOrderTable
                        on tempPersonTable.id == tempOrderTable.personId
                    select tempOrderTable.orderId as orderId,
                            tempPersonTable.name as personName,
                            tempOrderTable.items as items,
                            tempOrderTable.amount as amount;
    queryStmt = "\ntable<OrderDetails> orderDetailsTable = " +
            "from personTable as tempPersonTable
            join orderTable as tempOrderTable " +
                    "on tempPersonTable.id == tempOrderTable.personId
            select tempOrderTable.orderId as orderId, " +
                    "tempPersonTable.name as personName, " +
                    "tempOrderTable.items as items, " +
                    "tempOrderTable.amount as amount;";
    printTable(queryStmt, "orderDetailsTable: ", orderDetailsTable);

    table<OrderDetails> orderDetailsWithFilter =
                    from personTable
                    where name != "jane" as tempPersonTable
                    join orderTable where personId != 3 as tempOrderTable
                            on tempPersonTable.id == tempOrderTable.personId
                    select tempOrderTable.orderId as orderId,
                            tempPersonTable.name as personName,
                            tempOrderTable.items as items,
                            tempOrderTable.amount as amount;
    queryStmt = "\ntable<OrderDetails> orderDetailsWithFilter = " +
            "from personTable where name != 'jane' as tempPersonTable
             join orderTable where personId != 3 as tempOrderTable " +
                    "on tempPersonTable.id == tempOrderTable.personId
             select tempOrderTable.orderId as orderId, " +
                    "tempPersonTable.name as personName," +
                    "tempOrderTable.items as items,
                    tempOrderTable.amount as amount;";
    printTable(queryStmt, "orderDetailsWithFilter: ", orderDetailsWithFilter);
}

function printTable(string stmt, string tableName, table<anydata> returnedTable) {
    var retData = json.convert(returnedTable);
    io:println(stmt);
    io:print(tableName);
    if (retData is json) {
        io:println(io:sprintf("%s", retData));
    } else {
        io:println("Error in table to json conversion");
    }
}