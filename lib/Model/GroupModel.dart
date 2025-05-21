import 'package:NegXus/Model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String? id;
  String? name;
  String? description;
  String? profileUrl;
  List<UserModel>? members;
  List<String>? membersIds;
  DateTime? createdAt; // changed from String?
  String? createdBy;
  String? status;
  String? lastMessage;
  DateTime? lastMessageTime; // changed from String?
  String? lastMessageBy;
  int? unReadCount;
  DateTime? timeStamp; // changed from String?

  GroupModel({
    this.id,
    this.name,
    this.description,
    this.profileUrl,
    this.members,
    this.membersIds,
    this.createdAt,
    this.createdBy,
    this.status,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageBy,
    this.unReadCount,
    this.timeStamp,
  });

  GroupModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    profileUrl = json["profileUrl"];

    if (json["members"] != null) {
      members = List<UserModel>.from(
        json["members"].map((memberJson) => UserModel.fromJson(memberJson)),
      );
    } else {
      members = [];
    }

    membersIds = json["membersIds"] != null ? List<String>.from(json["membersIds"]) : [];

    // Safely convert Timestamps
    createdAt = json["createdAt"] is Timestamp ? (json["createdAt"] as Timestamp).toDate() : null;

    lastMessageTime = json["lastMessageTime"] is Timestamp ? (json["lastMessageTime"] as Timestamp).toDate() : null;

    timeStamp = json["timeStamp"] is Timestamp ? (json["timeStamp"] as Timestamp).toDate() : null;

    createdBy = json["createdBy"];
    status = json["status"];
    lastMessage = json["lastMessage"];
    lastMessageBy = json["lastMessageBy"];
    unReadCount = json["unReadCount"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    _data["profileUrl"] = profileUrl;

    if (members != null) {
      _data["members"] = members!.map((e) => e.toJson()).toList();
    }

    if (membersIds != null) {
      _data["membersIds"] = membersIds;
    }

    // Save DateTimes as Firestore Timestamps or ISO strings
    _data["createdAt"] = createdAt;
    _data["lastMessageTime"] = lastMessageTime;
    _data["timeStamp"] = timeStamp;

    _data["createdBy"] = createdBy;
    _data["status"] = status;
    _data["lastMessage"] = lastMessage;
    _data["lastMessageBy"] = lastMessageBy;
    _data["unReadCount"] = unReadCount;

    return _data;
  }
}
