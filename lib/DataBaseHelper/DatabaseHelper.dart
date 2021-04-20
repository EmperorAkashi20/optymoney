class UserInfoDb {
  String? userId;
  String? password;
  String? pan;
  String? name;
  String? email;
  String? pin;

  UserInfoDb(
      this.userId, this.password, this.name, this.pan, this.email, this.pin);

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'password': password,
      'pan': pan,
      'name': name,
      'email': email,
      'pin': pin,
    };
  }

  UserInfoDb.fromMap(Map<String, dynamic> map) {
    userId = map['userId'];
    password = map['password'];
    pan = map['pan'];
    name = map['name'];
    email = map['email'];
    pin = map['pin'];
  }
}
