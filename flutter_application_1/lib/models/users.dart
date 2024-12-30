class User {
  final String uid;
  final String email;
  final String role;

  User({
    required this.uid,
    required this.email,
    required this.role,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
    };
  }
}
