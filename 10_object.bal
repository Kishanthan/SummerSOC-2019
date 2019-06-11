type Person object {
   string name;
   int age;

   // constructor method
   function __init(string name, int age) {
       self.name = name;
       self.age = age;
   }

   // member function
   function getName() returns string {
       return self.name;
   }
};

public function main() {
    Person p1 = new ("John", 50);
    Person p2 = new Person("Doe", 40);

    // invoke member functions
    string name = p1.getName();
}
