import ballerina/config;
import ballerina/http;
import ballerina/io;
import ballerina/log;
import wso2/gsheets4;

gsheets4:Client spreadsheetClientEP = new({
    clientConfig: {
        auth: {
            scheme: http:OAUTH2,
            config: {
                grantType: http:DIRECT_TOKEN,
                config: {
                    accessToken: config:getAsString("GOOGLE_ACCESS_TOKEN"),
                    refreshConfig: {
                        refreshToken: config:getAsString("GOOGLE_REFRESH_TOKEN"),
                        clientId: config:getAsString("GOOGLE_CLIENT_ID"),
                        clientSecret: config:getAsString("GOOGLE_CLIENT_SECRET"),
                        refreshUrl: gsheets4:REFRESH_URL
                    }
                }
            }
        }
    }
});

public function main() {
    gsheets4:Spreadsheet testSheet = new;
    int testSheetId = 0;

    var createResponse = spreadsheetClientEP->createSpreadsheet("Sample-Spreadsheet");
    if (createResponse is gsheets4:Spreadsheet) {
        testSheet = createResponse;
        io:println(createResponse);
    } else {
        log:printError(<string>createResponse.detail().message);
    }

    var addResponse = spreadsheetClientEP->addNewSheet(untaint testSheet.spreadsheetId, "Sample-Sheet");
    if (addResponse is gsheets4:Sheet) {
        testSheetId = addResponse.properties.sheetId;
        io:println(addResponse);
    } else {
        log:printError(<string>addResponse.detail().message);
    }

    var deleteResponse = spreadsheetClientEP->deleteSheet(untaint testSheet.spreadsheetId, untaint testSheetId);
    if (deleteResponse is boolean) {
        io:println(deleteResponse);
    } else {
        log:printError(<string>deleteResponse.detail().message);
    }
}