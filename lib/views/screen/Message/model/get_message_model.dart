class GetMessageModel {
  int? code;
  String? message;
  GetMessageData? getMessageData;

  GetMessageModel({this.code, this.message, this.getMessageData});

  GetMessageModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    getMessageData = json['data'] != null ? GetMessageData.fromJson(json['data']) : null;
  }
}

class GetMessageData {
  GetMessageAttributes? getMessageAttributes;

  GetMessageData({this.getMessageAttributes});

  GetMessageData.fromJson(Map<String, dynamic> json) {
    getMessageAttributes = json['attributes'] != null
        ? GetMessageAttributes.fromJson(json['attributes'])
        : null;
  }
}

class GetMessageAttributes {
  List<MessageData>? messageData;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  GetMessageAttributes({this.messageData, this.page, this.limit, this.totalPages, this.totalResults});

  GetMessageAttributes.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      messageData = <MessageData>[];
      json['data'].forEach((v) {
        messageData!.add(MessageData.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
  }
}

class MessageData {
  Content? content;
  String? chatId;
  SenderId? senderId;
  DateTime? createdAt;
  String? updatedAt;
  String? id;

  MessageData(
      {this.content,
        this.chatId,
        this.senderId,
        this.createdAt,
        this.updatedAt,
        this.id});

  MessageData.fromJson(Map<String, dynamic> json) {
    content = json['content'] != null ? Content.fromJson(json['content']) : null;
    chatId = json['chatId'];
    senderId = json['senderId'] != null ? SenderId.fromJson(json['senderId']) : null;
    createdAt = DateTime.parse(json['createdAt'] as String);
    updatedAt = json['updatedAt'];
    id = json['id'];
  }
}

class Content {
  String? messageType;
  String? message;

  Content({this.messageType, this.message});

  Content.fromJson(Map<String, dynamic> json) {
    messageType = json['messageType'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['messageType'] = messageType;
    data['message'] = message;
    return data;
  }
}

class SenderId {
  String? fullName;
  String? email;
  String? image;
  String? id;

  SenderId({this.fullName, this.email, this.image, this.id});

  SenderId.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    image = json['image'];
    id = json['id'];
  }
}
