import ballerina/io;
import wso2/kafka;
import ballerina/encoding;
import ballerina/internal;

// Kafka consumer listener configurations
kafka:ConsumerConfig consumerConfig = {
    bootstrapServers: "localhost:9092",
    // Consumer group ID
    groupId: "group-id",
    // Listen from topic 'product-price'
    topics: ["test-kafka-topic"],
    // Poll every 1 second
    pollingInterval: 1000,
    autoCommit:false
};

// Create kafka listener
listener kafka:SimpleConsumer consumer = new(consumerConfig);

// Kafka service that listens from the topic 'product-price'
// 'inventoryControlService' subscribed to new product price updates from
// the product admin and updates the Database.
service kafkaService on consumer {
    // Triggered whenever a message added to the subscribed topic
    resource function onMessage(kafka:SimpleConsumer simpleConsumer, kafka:ConsumerRecord[] records) {
        // Dispatched set of Kafka records to service, We process each one by one.
        foreach var kafkaRecord in records {
            processKafkaRecord(kafkaRecord);
        }
        // Commit offsets returned for returned records, marking them as consumed.
        var result = consumer->commit();
    }
}

function processKafkaRecord(kafka:ConsumerRecord kafkaRecord) {
    byte[] serializedMsg = kafkaRecord.value;
    string msg = encoding:byteArrayToString(serializedMsg);
    // Print the retrieved Kafka record.
    io:println("Topic: " + kafkaRecord.topic + " Received Message: " + msg);
}