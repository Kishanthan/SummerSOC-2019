import ballerina/mysql;

function userDefinedSecureOperation(@sensitive string secureParameter) {

}

type Student record {
    string firstname;
};

public function main(string... args) {

    userDefinedSecureOperation(args[0]);

    if (isInteger(args[0])) {
        userDefinedSecureOperation(untaint args[0]);
    } else {
        error err = error("Validation error: ID should be an integer");
        panic err;
    }

    mysql:Client customerDBEP = new ({
        host: "localhost",
        port: 3306,
        name: "testdb",
        username: "root",
        password: "root",
        poolOptions: { maximumPoolSize: 5 }
    });
    var result = customerDBEP->select("SELECT firstname FROM student WHERE registration_id = " + args[0], ());
    
    table<record {}> dataTable;
    if (result is error) {
        panic result;
    } else {
        dataTable = result;
    }

    while (dataTable.hasNext()) {
        var jsonResult = Student.convert(dataTable.getNext());
        Student jsonData;
        if (jsonResult is error) {
            panic jsonResult;
        } else {
            jsonData = jsonResult;
        }
        userDefinedSecureOperation(jsonData.firstname);


        string sanitizedData1 = sanitizeAndReturnTainted(jsonData.firstname);
        userDefinedSecureOperation(sanitizedData1);

        string sanitizedData2 = sanitizeAndReturnUntainted(jsonData.firstname);
        userDefinedSecureOperation(sanitizedData2);
    }
    checkpanic customerDBEP.stop();
    return;
}

function isInteger(string input) returns boolean {
    string regEx = "\\d+";
    boolean|error isInt = input.matches(regEx);
    if (isInt is error) {
        panic isInt;
    } else {
        return isInt;
    }
}

function sanitizeAndReturnTainted(string input) returns string {
    string regEx = "[^a-zA-Z]";
    return input.replace(regEx, "");
}
function sanitizeAndReturnUntainted(string input) returns @untainted string {
    string regEx = "[^a-zA-Z]";
    return input.replace(regEx, "");
}

