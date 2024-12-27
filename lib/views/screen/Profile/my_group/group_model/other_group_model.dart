class OtherGroupModel {
  int? code;
  String? message;
  OtherGroupData? data;

  OtherGroupModel({this.code, this.message, this.data});

  OtherGroupModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? OtherGroupData.fromJson(json['data']) : null;
  }
}

class OtherGroupData {
  OtherGroupAttributes? attributes;

  OtherGroupData({this.attributes});

  OtherGroupData.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? OtherGroupAttributes.fromJson(json['attributes'])
        : null;
  }
}

class OtherGroupAttributes {
  List<OtherGroupResults>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  OtherGroupAttributes(
      {this.results,
        this.page,
        this.limit,
        this.totalPages,
        this.totalResults});

  OtherGroupAttributes.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <OtherGroupResults>[];
      json['results'].forEach((v) {
        results!.add(OtherGroupResults.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
  }
}

class OtherGroupResults {
  String? name;
  String? description;
  String? privacy;
  String? coverImage;
  bool? isDeleted;
  CreatedBy? createdBy;
  List<OtherGroupMembers>? members;
  String? id;

  OtherGroupResults(
      {this.name,
        this.description,
        this.privacy,
        this.coverImage,
        this.isDeleted,
        this.createdBy,
        this.members,
        this.id});

  OtherGroupResults.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    privacy = json['privacy'];
    coverImage = json['coverImage'];
    isDeleted = json['isDeleted'];
    createdBy = json['createdBy'] != null
        ? CreatedBy.fromJson(json['createdBy'])
        : null;
    if (json['members'] != null) {
      members = <OtherGroupMembers>[];
      json['members'].forEach((v) {
        members!.add(OtherGroupMembers.fromJson(v));
      });
    }
    id = json['id'];
  }
}

class CreatedBy {
  String? fullName;
  String? email;
  String? image;
  String? role;
  String? phoneNumber;
  bool? isEmailVerified;
  bool? isResetPassword;
  bool? isProfileCompleted;
  bool? isDeleted;
  String? address;
  String? dataOfBirth;
  bool? jobExperience;
  List<String>? jobLessCategory;
  dynamic oneTimeCode;
  String? about;
  String? bio;
  String? gender;
  String? skills;
  String? id;

  CreatedBy(
      {this.fullName,
        this.email,
        this.image,
        this.role,
        this.phoneNumber,
        this.isEmailVerified,
        this.isResetPassword,
        this.isProfileCompleted,
        this.isDeleted,
        this.address,
        this.dataOfBirth,
        this.jobExperience,
        this.jobLessCategory,
        this.oneTimeCode,
        this.about,
        this.bio,
        this.gender,
        this.skills,
        this.id});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    image = json['image'];
    role = json['role'];
    phoneNumber = json['phoneNumber'];
    isEmailVerified = json['isEmailVerified'];
    isResetPassword = json['isResetPassword'];
    isProfileCompleted = json['isProfileCompleted'];
    isDeleted = json['isDeleted'];
    address = json['address'];
    dataOfBirth = json['dataOfBirth'];
    jobExperience = json['jobExperience'];
    jobLessCategory = json['jobLessCategory'].cast<String>();
    oneTimeCode = json['oneTimeCode'];
    about = json['about'];
    bio = json['bio'];
    gender = json['gender'];
    skills = json['skills'];
    id = json['id'];
  }
}

class OtherGroupMembers {
  String? userId;
  String? role;
  String? joinedAt;
  String? sId;

  OtherGroupMembers({this.userId, this.role, this.joinedAt, this.sId});

  OtherGroupMembers.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    role = json['role'];
    joinedAt = json['joinedAt'];
    sId = json['_id'];
  }
}
