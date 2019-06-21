import ballerina/log;
import ballerina/rabbitmq;

// Creates a ballerina RabbitMQ connection that allows reusability if necessary.
rabbitmq:Connection connection = new({ host: "localhost", port: 5672 });

// The consumer service listens to the "MyQueue" queue.
listener rabbitmq:ChannelListener channelListener = new(connection);
@rabbitmq:ServiceConfig {
    queueConfig: {
        queueName: "testQueue"
    }
}
// Attaches the service to the listener.
service simpleConsumer on channelListener {

    // Gets triggered when a message is received by the queue.
    resource function onMessage(string message) {
        log:printInfo("The message received: " + message);
    }
}
