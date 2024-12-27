class FriendRequestModel {
  int? code;
  String? message;
  FriendRequestData? friendRequestData;

  FriendRequestModel({this.code, this.message, this.friendRequestData});

  FriendRequestModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    friendRequestData = json['data'] != null ? FriendRequestData.fromJson(json['data']) : null;
  }
}

class FriendRequestData {
  List<FriendRequestAttributes>? friendRequestAttributes;

  FriendRequestData({this.friendRequestAttributes});

  FriendRequestData.fromJson(Map<String, dynamic> json) {
    if (json['attributes'] != null) {
      friendRequestAttributes = <FriendRequestAttributes>[];
      json['attributes'].forEach((v) {
        friendRequestAttributes!.add(FriendRequestAttributes.fromJson(v));
      });
    }
  }
}

class FriendRequestAttributes {
  String? sId;
  String? sender;
  String? receiver;
  String? status;
  DateTime? createdAt;
  String? updatedAt;
  int? iV;

  FriendRequestAttributes(
      {this.sId,
        this.sender,
        this.receiver,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV});

  FriendRequestAttributes.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sender = json['sender'];
    receiver = json['receiver'];
    status = json['status'];
    createdAt = DateTime.parse(json['createdAt'] as String);
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}
