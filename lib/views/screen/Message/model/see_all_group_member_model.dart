class AllGroupMessageMember {
  int? code;
  String? message;
  AllGroupMessageData? data;

  AllGroupMessageMember({this.code, this.message, this.data});

  AllGroupMessageMember.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? AllGroupMessageData.fromJson(json['data']) : null;
  }
}

class AllGroupMessageData {
  AllGroupMessageAttributes? attributes;

  AllGroupMessageData({this.attributes});

  AllGroupMessageData.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? AllGroupMessageAttributes.fromJson(json['attributes'])
        : null;
  }

}

class AllGroupMessageAttributes {
  List<AllGroupChatParticipants>? participants;
  String? name;
  String? type;
  String? groupImage;
  String? createdAt;
  String? updatedAt;
  String? id;

  AllGroupMessageAttributes(
      {this.participants,
        this.name,
        this.type,
        this.groupImage,
        this.createdAt,
        this.updatedAt,
        this.id});

  AllGroupMessageAttributes.fromJson(Map<String, dynamic> json) {
    if (json['participants'] != null) {
      participants = <AllGroupChatParticipants>[];
      json['participants'].forEach((v) {
        participants!.add(new AllGroupChatParticipants.fromJson(v));
      });
    }
    name = json['name'];
    type = json['type'];
    groupImage = json['groupImage'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }
}

class AllGroupChatParticipants {
  String? fullName;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? id;

  AllGroupChatParticipants(
      {this.fullName, this.image, this.createdAt, this.updatedAt, this.id});

  AllGroupChatParticipants.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    image = json['image'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }
}
