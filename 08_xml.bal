function main(string... args) {
    
    // a simple XML
    xml x1 = xml`<name>John</name>`;

    // an XML with namespaces
    xmlns "http://wso2.com" as ns0;
    xml x2 = xml `<name id="123" status="single">
                      <ns0:fname>John</ns0:fname>
                      <ns0:lname>John</ns0:lname>
                  </name>`;

    // an XML literal with interpolation
    string lastName = "Doe";
    xml x3 = xml`<lname>{{lastName}}</lname>`;

    // concatenating XML
    xml x4 = x1 + x2 + x3;

    // get children by name
    xml fiirstNames1 = x2[ns0:fname];
    xml fiirstNames2 = x2["{http://wso2.com}fname"];

    // get all the children
    xml allChildren = x2.*;

    // get an attribute
    string id = x2@["id"];

    // get all the attributes as a map
    map attributes = <map> x2@;

    // set children
    x1.setChildren(x3);
}
