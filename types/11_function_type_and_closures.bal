public function main() {
    int a = 2;

    var outerFunc = function (int x) returns int {
        int b = 18;
        
        function (int) innerFunc = function (int y) returns () {
            a += 1;
            b -= 1;
        };

        return b;
    };

    // invoking the function using the variable
    int result = outerFunc.call(2);
}
