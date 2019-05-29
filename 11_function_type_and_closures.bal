function main(string... args) {
    int a = 2;

    var outerFunc = (int x) => int {
        int b = 18;
        
        function (int) innerFunc = (int y) => () {
            a++;
            b--;
        };

        return b;
    };

    // invoking the function using the variable
    int result = outerFunc(2);
}
