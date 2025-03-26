class User {
  final String userName;
  final String email;
  final String profileImageUrl;
  final String? token;
  final String? password; // Added password field

  User({
    required this.userName,
    required this.email,
    required this.profileImageUrl,
    this.token,
    this.password, // Initialize password
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      token: json['token'],
      password: json['password'], // Parse password
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': userName,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'token': token,
      'password': password, // Include password in JSON
    };
  }
}
