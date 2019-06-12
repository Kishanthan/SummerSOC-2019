import ballerina/log;
import ballerina/rabbitmq;
rabbitmq:Connection connection = new({ host: "localhost", port: 5672 });

listener rabbitmq:ChannelListener channelListener = new(connection);
@rabbitmq:ServiceConfig {
    queueConfig: {
        queueName: "testQueue"
    }
}

service testSimpleConsumer on channelListener {

    resource function onMessage(string message) {
        log:printInfo("The message received: " + message);
    }
}
