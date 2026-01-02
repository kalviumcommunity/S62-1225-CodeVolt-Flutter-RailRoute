class Student {
  String name;
  int age;

  Student(this.name, this.age);

  void introduce() {
    print("Hi, I'm $name and I'm $age years old.");
  }
}

void runDartDemo() {
  var s1 = Student("Aanya", 20);
  s1.introduce();
}
