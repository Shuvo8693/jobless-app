class MyFriendModel {
  int? code;
  String? message;
  MyFriendData? data;

  MyFriendModel({this.code, this.message, this.data});

  MyFriendModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? MyFriendData.fromJson(json['data']) : null;
  }
}

class MyFriendData {
  MyFriendAttributes? attributes;

  MyFriendData({this.attributes});

  MyFriendData.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? MyFriendAttributes.fromJson(json['attributes'])
        : null;
  }
}

class MyFriendAttributes {
  List<Friends>? friends;
  int? totalFriends;
  int? currentPage;
  int? pageSize;
  int? totalPages;

  MyFriendAttributes(
      {this.friends,
        this.totalFriends,
        this.currentPage,
        this.pageSize,
        this.totalPages});

  MyFriendAttributes.fromJson(Map<String, dynamic> json) {
    if (json['friends'] != null) {
      friends = <Friends>[];
      json['friends'].forEach((v) {
        friends!.add(new Friends.fromJson(v));
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
    jobLessCategory = json['jobLessCategory']!=null? json['jobLessCategory'].cast<String>():[];
    email = json['email'];
    image = json['image'];
    status = json['status'];
    createdAt = json['createdAt'];
  }
}
