import wso2/kafka;

kafka:ProducerConfig producerConfig = {
    // Here we create a producer configs with optional parameters client.id - used for broker side logging.
    // acks - number of acknowledgments for request complete,
    // noRetries - number of retries if record send fails.
    bootstrapServers: "localhost:9092",
    clientID:"basic-producer",
    acks:"all",
    noRetries:3
};

kafka:SimpleProducer kafkaProducer = new(producerConfig);

public function main() returns error? {
    string msg = "Hello World Advance";
    byte[] serializedMsg = msg.toByteArray("UTF-8");
    check kafkaProducer->send(serializedMsg, "test-kafka-topic");
}