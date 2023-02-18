// class UserModel {
//   String? uid;
//   String? name;
//   String? email;
//   String? photoUrl;
//   String? status;
//   String? creationTime;
//   String? lastSignInTime;
//   String? updateTime;

//   UserModel(
//       {this.uid,
//       this.name,
//       this.email,
//       this.photoUrl,
//       this.status,
//       this.creationTime,
//       this.lastSignInTime,
//       this.updateTime});

//   UserModel.fromJson(Map<String, dynamic> json) {
//     uid = json['uid'];
//     name = json['name'];
//     email = json['email'];
//     photoUrl = json['photoUrl'];
//     status = json['status'];
//     creationTime = json['creationTime'];
//     lastSignInTime = json['lastSignInTime'];
//     updateTime = json['updateTime'];
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['uid'] = uid;
//     data['name'] = name;
//     data['email'] = email;
//     data['photoUrl'] = photoUrl;
//     data['status'] = status;
//     data['creationTime'] = creationTime;
//     data['lastSignInTime'] = lastSignInTime;
//     data['updateTime'] = updateTime;
//     return data;
//   }
// }

// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.uid,
    this.name,
    this.keyName,
    this.email,
    this.creationTime,
    this.lastSignInTime,
    this.photoUrl,
    this.status,
    this.updateTime,
    this.chats,
  });

  String? uid;
  String? name;
  String? keyName;
  String? email;
  String? creationTime;
  String? lastSignInTime;
  String? photoUrl;
  String? status;
  String? updateTime;
  List<ChatUser>? chats;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        name: json["name"],
        keyName: json["keyName"],
        email: json["email"],
        creationTime: json["creationTime"],
        lastSignInTime: json["lastSignInTime"],
        photoUrl: json["photoUrl"],
        status: json["status"],
        updateTime: json["updateTime"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "keyName": keyName,
        "email": email,
        "creationTime": creationTime,
        "lastSignInTime": lastSignInTime,
        "photoUrl": photoUrl,
        "status": status,
        "updatedTime": updateTime,
      };
}

class ChatUser {
  ChatUser({
    this.chatId,
    this.connection,
    this.lastTime,
    this.total_unread,
  });

  String? connection;
  String? chatId;
  String? lastTime;
  int? total_unread;

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        chatId: json["chat_id"],
        connection: json["connection"],
        lastTime: json["lastTime"],
        total_unread: json["total_unread"],
      );

  Map<String, dynamic> toJson() => {
        "connection": connection,
        "chat_id": chatId,
        "lastTime": lastTime,
        "total_unread": total_unread,
      };
}
