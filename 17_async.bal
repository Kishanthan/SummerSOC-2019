import ballerina/io;

function main(string... args) {

    // Asynchronously invoke mergeSort.  
    future<int[]> result = start mergeSort([6, 2, 8]);

    // do something

    // Wait on result
    int[] sortedArray = await result;

}

function mergeSort (int[] array) returns int[] {
    // sort the array
    return array;
}
