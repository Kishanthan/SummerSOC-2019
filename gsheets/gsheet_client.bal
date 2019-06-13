import ballerina/http;
import ballerina/io;
import wso2/gsheets4;

gsheets4:SpreadsheetConfiguration spreadsheetConfig = {
    clientConfig: {
        auth: {
            scheme: http:OAUTH2,
            config: {
                grantType: http:DIRECT_TOKEN,
                config: {
                    accessToken: "<accessToken>",
                    refreshConfig: {
                        clientId: "<clientId>",
                        clientSecret: "<clientSecret>",
                        refreshToken: "<refreshToken>",
                        refreshUrl: gsheets4:REFRESH_URL
                    }
                }
            }
        }
    }   
};
gsheets4:Client spreadsheetClient = new(spreadsheetConfig);

public function main(string... args) {
    var response = spreadsheetClient->openSpreadsheetById("1Ti2W5mGK4mq0_xh9Gl_zG_dK9qqwdduirsFgl6zZu7M");
    if (response is gsheets4:Spreadsheet) {
        io:println("Spreadsheet Details: ", response);
    } else {
        io:println("Error: ", response);
    }
}