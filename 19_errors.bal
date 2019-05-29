import ballerina/io;

function getAccount(int accountID) returns (json|error) {
   if (accountID < 100) {
       // Buiness error.
       error err = { message: "Account with ID: " + accountID + " is not found" };
       return err;
   } else if (accountID < -1) {
       // This is a Hypothetical Promgram error.
       error err = { message: "Unkown account ID" };
       throw err;
   } else {
       json account = { id : accountID, balance : 600};
       return account;
   }
}

function main(string... args) {
   
    json|error account = getAccount(25);

    // Option 1: check whether an error occurred.
    match account {
        json j =>  io:println("Account Balance : ", j.balance); 
        error err => {
            io:println("Error occurred: " + err.message);
        }
    }

    // Option 2: Differ error handling, later check for error.
    json|error balance = account!balance;
    io:println("Account balance : ", balance but { error => 0});

    // Option 3: Eliminate the error using check expression.
    json acc3 = check account;
    io:println("Account balance : ", acc3.balance); 

    // Handling Program/Runtime errors.
    try {
        json|error value = getAccount(-1000);
    } catch (error er) {
        // Handle error.
        io:println("Error occured : ", er.message);
    }
}
