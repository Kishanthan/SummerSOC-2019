#### Access the service (basic_01)
```
$ curl -v localhost:9090/hello/sayHello

Hello, World!
```

#### Access the service (basic_02)
```
$ curl -v http://localhost:9090/foo/bar -d "{\"hello\": \"world\"}" -H "Content-Type: application/json"

{"hello": "world"}
```

#### Access the service (data_binding)
```
$ curl -v http://localhost:9090/hello/bindJson -d '{ "Details": { "ID": "77999", "Name": "XYZ"} , "Location": { "No": "01", "City": "Colombo"}}' -H "Content-Type:application/json"

{"ID":"77999","Name":"XYZ"}

$ curl -v http://localhost:9090/hello/bindStruct -d '{ "Name": "John", "Grade": 12, "Marks": {"English" : "85", "IT" : "100"}}' -H "Content-Type:application/json"

{"Name":"John","Grade":12}
```

#### Access the service (passthrough)
```
$ curl http://localhost:9090/passthrough -X POST
Hello World!
$ curl http://localhost:9090/passthrough -X GET
Hello World!
$ curl http://localhost:9090/passthrough -X PUT
Hello World!
```