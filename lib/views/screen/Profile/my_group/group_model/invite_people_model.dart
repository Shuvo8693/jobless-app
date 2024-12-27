class InvitePeopleListModel {
  String? message;
  String? status;
  int? statusCode;
  List<InvitePeopleListData>? data;

  InvitePeopleListModel(
      {this.message, this.status, this.statusCode, this.data});

  InvitePeopleListModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <InvitePeopleListData>[];
      json['data'].forEach((v) {
        data!.add(InvitePeopleListData.fromJson(v));
      });
    }
  }
}

class InvitePeopleListData {
  String? id;
  String? fullName;
  bool? jobExperience;
  List<String>? jobLessCategory;
  String? email;
  String? image;
  String? status;
  String? createdAt;

  InvitePeopleListData(
      {this.id,
        this.fullName,
        this.jobExperience,
        this.jobLessCategory,
        this.email,
        this.image,
        this.status,
        this.createdAt});

  InvitePeopleListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    jobExperience = json['jobExperience'];
    jobLessCategory = (json['jobLessCategory'] as List<dynamic>?)?.isNotEmpty == true
        ? List<String>.from(json['jobLessCategory'] as List)
        : [];
    email = json['email'];
    image = json['image'];
    status = json['status'];
    createdAt = json['createdAt'];
  }
}
