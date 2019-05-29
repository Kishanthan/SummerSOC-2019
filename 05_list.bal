function main (string... args) {

    // Arrays.
    int[] a = [1, 2, 3, 4, 5, 6, 7, 8];
    int val = a[2];
    a[999] = 100;

    string[2] b = ["apple", "orange"];
    string[!...] c = ["apple", "orange"];

    // Tuple
    (int, string, int) tuple = (1, "value", 5);
    string value = tuple[1];

}

function getMultipleData () returns (string, int, boolean) {
    return ("aString", 10, false);
}