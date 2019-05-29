function main (string... args) {
    map<string>? m;
    string? s1 = m.name;

    // eliminate nil using but-expression
    string s2 = m.name but { () => "N/A" };

    // eliminate nil using elvis operator
    string s3 = m.name ?: "N/A";
}
