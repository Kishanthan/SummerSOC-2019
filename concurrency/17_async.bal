import ballerina/io;

public function main() {

    // Asynchronously invoke mergeSort.  
    future<int[]> result = start mergeSort([6, 2, 8]);

    // do something

    // Wait on result
    int[] sortedArray = wait result;

}

function mergeSort (int[] array) returns int[] {
    // sort the array
    return array;
}
