import ballerina/io;

function main(string... args) {

    int status = 0;

    transaction with retries = 2 {
        // do something
        if (status == -1) {
            abort;
        }

        if (status == 1) {
            retry;
        }

    } onretry {
        // do something before retrying
        io:println("im going to try again");
    }
}
