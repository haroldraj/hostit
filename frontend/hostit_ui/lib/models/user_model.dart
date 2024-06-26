class User {
  int? id;
  String? name;
  String? email;
  String? password;
  bool? emailVerified;
  bool? twoFactorEnabled;

  User({
    this.email,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    User user = User();
    user.id = json['user']['id'];
    user.name = json['user']['name'];
    user.email = json['user']['email'];
    return user;
  }

  Map<String, String> toJsonLogin() {
    return {
      'username': email!,
      'password': password!,
    };
  }

  Map<String, String> toJsonSignup() {
    return {
      'username': name!,
      'email': email!,
      'password': password!,
    };
  }
}
