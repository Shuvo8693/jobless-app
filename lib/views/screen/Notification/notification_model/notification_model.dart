class NotificationModel {
  int? code;
  String? message;
  NotificationData? data;

  NotificationModel({this.code, this.message, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new NotificationData.fromJson(json['data']) : null;
  }


}

class NotificationData {
  NotificationAttributes? attributes;

  NotificationData({this.attributes});

  NotificationData.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? new NotificationAttributes.fromJson(json['attributes'])
        : null;
  }

}

class NotificationAttributes {
  List<NotificationResults>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  int? unReadCount;

  NotificationAttributes(
      {this.results,
        this.page,
        this.limit,
        this.totalPages,
        this.totalResults,
        this.unReadCount});

  NotificationAttributes.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <NotificationResults>[];
      json['results'].forEach((v) {
        results!.add(new NotificationResults.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
    unReadCount = json['unReadCount'];
  }
}

class NotificationResults {
  String? sId;
  String? receiverId;
  String? friendId;
  String? friendRequestId;
  String? message;
  String? role;
  String? type;
  bool? viewStatus;
  DateTime? createdAt;
  String? updatedAt;
  int? iV;
  String? title;
  String? postId;

  NotificationResults(
      {this.sId,
        this.receiverId,
        this.friendRequestId,
        this.message,
        this.role,
        this.type,
        this.viewStatus,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.title,
        this.postId});

  NotificationResults.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    receiverId = json['receiverId'];
    friendId = json['friendId'];
    friendRequestId = json['friendRequestId'];
    message = json['message'];
    role = json['role'];
    type = json['type'];
    viewStatus = json['viewStatus'];
    createdAt = DateTime.tryParse(json['createdAt'] as String);
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    title = json['title'];
    postId = json['postId'];
  }
}
