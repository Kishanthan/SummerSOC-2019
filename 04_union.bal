function main (string... args) {
    string|int|() value = 5;
    value = "foo";
    value = ();

    // Optional types.
    // string? is same as string|()
    string? s = "some value";

}