import ballerina/io;

function main(string... args) {
    fork {
        worker w1 {
            int a;
            a -> fork;
        }
        worker w2 {
            string b;
            b -> fork;
        }
    } join (all) (map results) {
        io:println(results.w1);
        io:println(results.w2);
    }
}
