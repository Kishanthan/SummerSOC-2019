import ballerina/io;
import ballerina/mysql;

function main (string... args) {
    if (lengthof args == 0) {
        io:println("Not enough arguments!");
        return;
    }

    // Read the JSON
    json bookStoreJSON = readJSON(args[0]);

    // Check the current store name
    string storeName =  bookStoreJSON.store.name.toString();
    io:println("Store Name: ", storeName);

    // Convert the array of books to XML. Enclose each book with a tag called 'book'
    xml booksXML = check bookStoreJSON.store.books.toXML( { arrayEntryTag: "book" } );

    // Create a new XML using the books
    xml booksStoreXML = xml `<bookStore> 
                                <storeName>{{storeName + " - Colombo"}}</storeName>
                                <books>{{booksXML}}</books>
                            </bookStore>`;
    io:println("\nStore XML: \n", booksStoreXML);

    // Write the XML to DB and a file paralelly 
    write(booksStoreXML);

    io:println("\nDone!");
}


function readJSON(string path) returns json {
    io:ByteChannel byteChannel = io:openFile(untaint path, io:READ);
    io:CharacterChannel ch = new io:CharacterChannel(byteChannel, "UTF8");

    // Read the content of the file as a JSON
    json|error result = ch.readJson();
    // var result = ch.readJson();    // we can also use 'var' instead of union type

    match result {
        json j => {
            return j;
        }
        error e => {
            error err = {message: "Failed to parse JSON: " + e.message};
            throw e;
        }
    }
}

// An endpoint to the MySQL database
endpoint mysql:Client bookStoreDB {
    host: "localhost",
    port: 3306,
    name: "booksDB",
    username: "root",
    password: "root",
    useSSL: false
};


function write(xml booksXML) {
    worker w1 {
        writeToFile(booksXML);
    }
    worker w2 {
        writeToDB(booksXML);
    }
}

function writeToFile(xml booksXML) {
    string path = "booksXML.xml";
    io:ByteChannel byteChannel = io:openFile(path, io:WRITE);
    io:CharacterChannel ch = new io:CharacterChannel(byteChannel, "UTF8");

    error? result = ch.writeXml(booksXML);
    io:println("XML written to file");
}

function writeToDB(xml booksXML) {
    // Create a Table, of not exists
    var result = bookStoreDB -> update("CREATE TABLE bookStore(
                                        title VARCHAR(50), 
                                        author VARCHAR(50), 
                                        year INT, 
                                        PRIMARY KEY (title))");

    // Start a DB transaction. If inserting any of the books failed,
    // then rollback and exit without inserting any book. 
    transaction with retries = 3 {

        // Iterate through books in the XML
        foreach book in booksXML.books.* {
            // Ignore text XML items
            if (book.getItemType() != "element") {
                continue;
            }

            string title = book.title.getTextValue();
            string author = book.author.getTextValue();
            int year = check <int> book.year.getTextValue();

            // Insert book info to the table
            result = bookStoreDB -> update("INSERT INTO bookStore(title, author, year)
                                            values (?, ?, ?)", title, author, year);

            match result {
                error e => { retry; }   // If an error occurred when inserting a book, then retry
                int c => {
                    if (c == 0) {   // If the query failed to insert anything, abort the transaction
                        abort;
                    }

                    // Otherwise continue inserting the rest of the books
                }
            }
        }
    }
}
