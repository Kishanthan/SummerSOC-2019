import ballerina/io;

function getAccount(int accountID) returns json|error {
    if (accountID < 100) {
        // Buiness error.
        error err = error("Account with ID: " + accountID + " is not found");
        return err;
    } else if (accountID < -1) {
        // This is a Hypothetical Promgram error.
        error err = error("Unkown account ID");
        panic err;
    } else {
        json account = {
            id: accountID,
            balance: 600
        };
        return account;
    }
}

public function main() returns error? {
    json|error account = getAccount(25);

    // Option 1: check whether an error occurred.
    if (account is json) {
        io:println("Account Balance : ", account.balance);
    } else {
        io:println("Error occurred: " + account.reason());
    }

    // Option 2: Differ error handling, later check for error.
    json|error balance = account!balance;
    io:println("Account balance : ", balance is json ? balance : 0);

    // Option 3: Eliminate the error using check expression.
    json acc3 = check getAccount(25);
    io:println("Account balance : ", acc3.balance);

    // Handling Program/Runtime errors.
    json|error value = trap getAccount(-1000);
    if (value is error) {
        // Handle error.
        io:println("Error occured : ", value.reason());
    }
}
