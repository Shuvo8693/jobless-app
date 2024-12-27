class MyFriendSearchModel {
  int? code;
  String? message;
  MyFriendSearchData? data;

  MyFriendSearchModel({this.code, this.message, this.data});

  MyFriendSearchModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? MyFriendSearchData.fromJson(json['data']) : null;
  }
}

class MyFriendSearchData {
  MyFriendSearchAttributes? attributes;

  MyFriendSearchData({this.attributes});

  MyFriendSearchData.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? MyFriendSearchAttributes.fromJson(json['attributes'])
        : null;
  }
}

class MyFriendSearchAttributes {
  List<Friends>? friends;
  int? totalFriends;
  int? currentPage;
  int? pageSize;
  int? totalPages;

  MyFriendSearchAttributes(
      {this.friends,
        this.totalFriends,
        this.currentPage,
        this.pageSize,
        this.totalPages});

  MyFriendSearchAttributes.fromJson(Map<String, dynamic> json) {
    if (json['friends'] != null) {
      friends = <Friends>[];
      json['friends'].forEach((v) {
        friends!.add(Friends.fromJson(v));
      });
    }
    totalFriends = json['totalFriends'];
    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
    totalPages = json['totalPages'];
  }
}

class Friends {
  String? id;
  String? fullName;
  bool? jobExperience;
  List<String>? jobLessCategory;
  String? email;
  String? image;
  String? status;
  String? createdAt;

  Friends(
      {this.id,
        this.fullName,
        this.jobExperience,
        this.jobLessCategory,
        this.email,
        this.image,
        this.status,
        this.createdAt});

  Friends.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    jobExperience = json['jobExperience'];
    jobLessCategory = json['jobLessCategory'].cast<String>();
    email = json['email'];
    image = json['image'];
    status = json['status'];
    createdAt = json['createdAt'];
  }
}
