type Person object {
   string name;
   int age;

   // constructor method
   new(name, age) {}

   // member function
   function getName() returns string {
       return name;
   }
};

function main(string... args) {
    Person p1 = new ("John", 50);
    Person p2 = new Person("Doe", 40);

    // invoke member functions
    string name = p1.getName();
}
