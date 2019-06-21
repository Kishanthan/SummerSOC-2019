To check the sample, use a Chrome or Firefox JavaScript console and run the following commands.
Change `xml` to another sub protocol to observe the behavior of the WebSocket server.
```
$ var ws = new WebSocket("ws://localhost:9090/basic/ws", "xml", "my-protocol");
$ ws.onmessage = function(frame) {console.log(frame.data)};
$ ws.onclose = function(frame) {console.log(frame)};
```
Send a message.
```
$ ws.send("hello world");
```
Use an advanced client to check the ping and pong since the browser client does not have the capability to send pings.
Use the following command to observe the behavior when the server sends a ping message to the browser client.
```
$ ws.send("ping");
```
Close the connection.
```
$ ws.close(1000, "I want to go");
```
Close the connection from the server side.
```
$ ws.send("closeMe");
```
Wait for 120 seconds to check the connection closure due to the connection timeout or change the timeout in the configuration annotation.
