// To parse this JSON data, do
//
//     final homeData = homeDataFromJson(jsonString);

import 'dart:convert';

HomeData homeDataFromJson(String str) => HomeData.fromJson(json.decode(str));

String homeDataToJson(HomeData data) => json.encode(data.toJson());

class HomeData {
  HomeData({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  Data data;
  String message;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
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
    this.myRooms,
    this.trendRooms,
    this.discoverRooms,
  });

  List<Room> myRooms;
  List<Room> trendRooms;
  List<Room> discoverRooms;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        myRooms: List<Room>.from(json["myRooms"].map((x) => Room.fromJson(x))),
        trendRooms:
            List<Room>.from(json["trendRooms"].map((x) => Room.fromJson(x))),
        discoverRooms:
            List<Room>.from(json["discoverRooms"].map((x) => Room.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "myRooms": List<dynamic>.from(myRooms.map((x) => x.toJson())),
        "trendRooms": List<dynamic>.from(trendRooms.map((x) => x.toJson())),
        "discoverRooms":
            List<dynamic>.from(discoverRooms.map((x) => x.toJson())),
      };
}

class Room {
  Room({
    this.id,
    this.name,
    this.color,
    this.members,
    this.favourites,
  });

  int id;
  String name;
  String color;
  int members;
  int favourites;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["id"],
        name: json["name"],
        color: json["color"],
        members: json["members"],
        favourites: json["favourites"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
        "members": members,
        "favourites": favourites,
      };
}
