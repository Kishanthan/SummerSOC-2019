import ballerina/io;
import ballerina/runtime;

type Person record {
    string name;
    int age;
    string status;
    string address;
    string phoneNo;
};

type Child record {
    string name;
    int age;
    string city;
};

int index = 0;
stream<Person> personStream = new;
stream<Child> childrenStream = new;

Child[] globalChildrenArray = [];
function initFilterQuery() {
    forever {
        from personStream where personStream.age <= 16
        select personStream.name, personStream.age,
                personStream.address as city
        => (Child[] children) {
            foreach var c in children {
                childrenStream.publish(c);
            }
        }
    }
}

public function main() {
    Person[] personArray = [];
    Person t1 = { name: "Raja", age: 12, status: "single",
                    address: "Mountain View", phoneNo: "+19877386134" };
    Person t2 = { name: "Mohan", age: 30, status: "single",
                    address: "Memphis", phoneNo: "+198353536134"};
    Person t3 = { name: "Shareek", age: 16, status: "single",
                    address: "Houston", phoneNo: "+1343434454" };

    personArray[0] = t1;
    personArray[1] = t2;
    personArray[2] = t3;
    initFilterQuery();

    childrenStream.subscribe(printChildren);

    foreach var t in personArray {
        personStream.publish(t);
    }

    int count = 0;
    while(true) {
        runtime:sleep(500);
        count += 1;
        if((globalChildrenArray.length()) == 2 || count == 10) {
            break;
        }
    }
}
function printChildren(Child child) {
    io:println("Child detected. Child name : " +
            child.name + ", age : " + child.age + " and from : " + child.city);
    addToGlobalChildrenArray(child);
}
function addToGlobalChildrenArray(Child e) {
    globalChildrenArray[index] = e;
    index = index + 1;
}