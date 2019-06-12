import ballerina/io;
import ballerina/transactions;

public function main() {
    transaction {
        var res = trap localTransactionParticipant();
        if (res is error) {
            io:println("Local participant panicked.");
        }
    } onretry {
        io:println("Retrying transaction");
    } committed {
        io:println("Transaction committed");
    } aborted {
        io:println("Transaction aborted");
    }
}

@transactions:Participant {
    oncommit: participantOnCommit
}
function localTransactionParticipant() {
    io:println("Invoke local participant function.");
    error er = error("Simulated Failure");
    panic er;
}

function participantOnCommit(string transactionId) {
    io:println("Local participant committed function handler...");
}