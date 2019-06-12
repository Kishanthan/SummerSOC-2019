import ballerina/io;
import ballerina/rabbitmq;

rabbitmq:Connection connection = new({ host: "localhost", port: 5672 });

public function main() {
    rabbitmq:Channel newChannel = new(connection);

    var queueResult = newChannel->queueDeclare(queueConfig = { queueName: "testQueue" });
    if (queueResult is error) {
        io:println("An error occurred while creating the queue");
    } else {
        io:println("The queue was created successfully");
    }

    var sendResult = newChannel->basicPublish("Hello from Ballerina", "testQueue");
    if (sendResult is error) {
        io:println("An error occurred while sending the message");
    } else {
        io:println("The message was sent successfully");
    }
}