import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String username;
  String password;
  String role;
  int balance;

  UserModel({
    required this.name,
    required this.username,
    required this.password,
    required this.role,
    required this.balance
  });

  UserModel.fromJson(Map<String, Object?> json)
      : this(
            name: json['name']! as String,
            username: json['username']! as String,
            password: json['password']! as String,
            role: json['role']! as String,
            balance: json['balance']! as int);

  UserModel copyWith({String? name, String? username, String? password, String? role, int? balance}) {
    return UserModel(
        name: name ?? this.name,
        username: username ?? this.username,
        password: password ?? this.password,
        role: role ?? this.role,
        balance: balance ?? this.balance);
  }

  Map<String, Object?> toJson() {
    return {
      'name' : name,
      'username' : username,
      'password' : password,
      'role' : role,
      'balance' : balance
    };
  }
}
