import ballerina/io;
import wso2/kafka;
import ballerina/encoding;

// Kafka consumer listener configurations
kafka:ConsumerConfig consumerConfig = {
    bootstrapServers: "localhost:9092, localhost:9093",
    // Consumer group ID
    groupId: "inventorySystem",
    // Listen from topic 'product-price'
    topics: ["product-price"],
    // Poll every 1 second
    pollingInterval: 1000
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
        foreach var entry in records {
            byte[] serializedMsg = entry.value;
            // Convert the serialized message to string message
            string msg = encoding:byteArrayToString(serializedMsg);
            io:println("New message received from the product admin");
            // log the retrieved Kafka record
            io:println("Topic: " + entry.topic + "; Received Message: " + msg);
            // Mock logic
            // Update the database with the new price for the specified product
            io:println("Database updated with the new price of the product");
        }
    }
}