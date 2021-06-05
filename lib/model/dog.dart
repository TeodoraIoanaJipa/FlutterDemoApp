class Dog {
  int id;
  String name;
  int age;

  Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  int get getId {
    return id;
  }

  String get dogName {
    return name;
  }

  set setId(int givenId) {
    id = givenId;
  }

  set setName(String givenName) {
    name = givenName;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  static Dog fromMapObject(Map<String, dynamic> map) {
    return Dog(id: map['id'], name: map['name'], age: map['age']);
  }

  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
