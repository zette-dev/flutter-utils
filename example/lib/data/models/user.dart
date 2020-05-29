
class User {
  final String id;
  final String email;
  final String firstName, lastName;

  String get fullName => '$firstName $lastName';

  User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  dynamic toJson() => {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
      };

  User copyWith({
    String id,
    String email,
    String firstName,
    String lastName,
  }) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
      );
}