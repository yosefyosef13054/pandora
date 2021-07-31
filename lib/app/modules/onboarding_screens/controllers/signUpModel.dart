// To parse this JSON data, do
//
//     final signUpRequest = signUpRequestFromJson(jsonString);

import 'dart:convert';

SignUpRequest signUpRequestFromJson(String str) =>
    SignUpRequest.fromJson(json.decode(str));

String signUpRequestToJson(SignUpRequest data) => json.encode(data.toJson());

class SignUpRequest {
  SignUpRequest({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  Data data;
  String message;

  factory SignUpRequest.fromJson(Map<String, dynamic> json) => SignUpRequest(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    this.user,
  });

  User user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
      };
}

class User {
  User({
    this.id,
    this.username,
    this.age,
    this.gender,
    this.image,
    this.token,
  });

  String id;
  String username;
  String age;
  String gender;
  String image;
  String token;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        age: json["age"],
        gender: json["gender"],
        image: json["image"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "age": age,
        "gender": gender,
        "image": image,
        "token": token,
      };
}
