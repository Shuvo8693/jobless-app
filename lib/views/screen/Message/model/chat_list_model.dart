class ChatListModel {
  int? code;
  String? message;
  ChatListData? data;

  ChatListModel({this.code, this.message, this.data});

  ChatListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? ChatListData.fromJson(json['data']) : null;
  }
}

class ChatListData {
  List<ChatListAttributes>? attributes;

  ChatListData({this.attributes});

  ChatListData.fromJson(Map<String, dynamic> json) {
    if (json['attributes'] != null) {
      attributes = <ChatListAttributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(ChatListAttributes.fromJson(v));
      });
    }
  }
}

class ChatListAttributes {
  String? sId;
  List<String>? participants;
  String? type;
  DateTime? createdAt;
  String? updatedAt;
  int? iV;
  OtherParticipant? otherParticipant;

  ChatListAttributes(
      {this.sId,
        this.participants,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.otherParticipant});

  ChatListAttributes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    participants = json['participants'].cast<String>();
    type = json['type'];
    createdAt = DateTime.parse(json['createdAt'] as String);
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    otherParticipant = json['otherParticipant'] != null
        ? OtherParticipant.fromJson(json['otherParticipant'])
        : null;
  }
}

class OtherParticipant {
  String? fullName;
  String? image;
  String? id;

  OtherParticipant({this.fullName, this.image});

  OtherParticipant.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    image = json['image'];
    id = json['id'];
  }
}
