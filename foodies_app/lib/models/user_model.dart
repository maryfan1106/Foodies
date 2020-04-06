class User {
  final String name;
  final String email;

  User({
    this.name,
    this.email
  });

  factory User.fromJson(Map<String, dynamic> parsedJson){
    return User(
        name: parsedJson['name'],
        email: parsedJson['email'],
    );
  }
}