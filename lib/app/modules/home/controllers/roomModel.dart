// To parse this JSON data, do
//
//     final roomData = roomDataFromJson(jsonString);

import 'dart:convert';

RoomData roomDataFromJson(String str) => RoomData.fromJson(json.decode(str));

String roomDataToJson(RoomData data) => json.encode(data.toJson());

class RoomData {
  RoomData({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  Data data;
  String message;

  factory RoomData.fromJson(Map<String, dynamic> json) => RoomData(
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
    this.id,
    this.name,
    this.color,
    this.members,
    this.favourites,
    this.chats,
  });

  int id;
  String name;
  String color;
  int members;
  int favourites;
  List<Chat> chats;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        color: json["color"],
        members: json["members"],
        favourites: json["favourites"],
        chats: List<Chat>.from(json["chats"].map((x) => Chat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
        "members": members,
        "favourites": favourites,
        "chats": List<dynamic>.from(chats.map((x) => x.toJson())),
      };
}

class Chat {
  Chat({
    this.id,
    this.userId,
    this.username,
    this.image,
    this.message,
    this.duration,
    this.isFavourite,
    this.createdAt,
  });

  int id;
  String userId;
  String username;
  String image;
  String message;
  int duration;
  bool isFavourite;
  DateTime createdAt;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["id"],
        userId: json["user_id"],
        username: json["username"],
        image: json["image"],
        message: json["message"],
        duration: json["duration"],
        isFavourite: json["IsFavourite"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "username": username,
        "image": image,
        "message": message,
        "duration": duration,
        "IsFavourite": isFavourite,
        "created_at": createdAt.toIso8601String(),
      };
}
