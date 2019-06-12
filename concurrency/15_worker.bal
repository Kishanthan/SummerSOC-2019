import ballerina/io;
import ballerina/runtime;

public function main() {
    worker w1 {
        int i = 100;
        float k = 2.34;

        (i, k) -> w2;
        io:println("[w1 -> w2] i: ", i, " k: ", k);

        json j = {};
        j = <- w2;
        string jStr = j.toString();
        io:println("[w1 <- w2] j: ", jStr);
        io:println("[w1 ->> w2] i: ", i);
    }

    worker w2 {
        int iw;
        float kw;
        (int, float) vW1 = (0, 1.0);
        vW1 = <- w1;
        (iw, kw) = vW1;
        io:println("[w2 <- w1] iw: " + iw + " kw: " + kw);

        json jw = {
            "name": "Ballerina"
        };
        io:println("[w2 -> w1] jw: ", jw);
        jw -> w1;
    }

    wait w1;
}
