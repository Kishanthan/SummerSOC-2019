import ballerina/io;
import ballerina/runtime;
type Employee record {
    int id;
    string name;
};
public function main() {
    stream<Employee> employeeStream = new;

    employeeStream.subscribe(printEmployeeName);

    Employee e1 = { id: 1, name: "Jane" };
    Employee e2 = { id: 2, name: "Anne" };
    Employee e3 = { id: 3, name: "John" };

    employeeStream.publish(e1);
    employeeStream.publish(e2);
    employeeStream.publish(e3);
    runtime:sleep(1000);

    stream<float> temperatureStream = new;

    temperatureStream.subscribe(printTemperature);

    temperatureStream.publish(28.0);
    temperatureStream.publish(30.1);
    temperatureStream.publish(29.5);

    runtime:sleep(1000);

    stream<anydata> updateStream = new;

    updateStream.subscribe(printEvent);

    updateStream.publish("Hello Ballerina!");
    updateStream.publish(1.0);
    updateStream.publish(e1);

    runtime:sleep(1000);
}

function printEmployeeName(Employee employee) {
    io:println("Employee event received for Employee Name: "
                    + employee.name);
}

function printTemperature(float temperature) {
    io:println("Temperature event received: " + temperature);
}

function printEvent(anydata event) {
    io:println("Event received: ", event);
}