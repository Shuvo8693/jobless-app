class SinglePostGroupModel {
  int? code;
  String? message;
  Data? data;

  SinglePostGroupModel({this.code, this.message, this.data});

  SinglePostGroupModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  SinglePostGroupAttributes? attributes;

  Data({this.attributes});

  Data.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? SinglePostGroupAttributes.fromJson(json['attributes'])
        : null;
  }
}

class SinglePostGroupAttributes {
  String? name;
  String? description;
  String? privacy;
  String? coverImage;
  bool? isDeleted;
  SinglePostGroupCreatedBy? createdBy;
  List<SinglePostGroupMembers>? members;
  String? id;

  SinglePostGroupAttributes(
      {this.name,
        this.description,
        this.privacy,
        this.coverImage,
        this.isDeleted,
        this.createdBy,
        this.members,
        this.id});

  SinglePostGroupAttributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    privacy = json['privacy'];
    coverImage = json['coverImage'];
    isDeleted = json['isDeleted'];
    createdBy = json['createdBy'] != null
        ? SinglePostGroupCreatedBy.fromJson(json['createdBy'])
        : null;
    if (json['members'] != null) {
      members = <SinglePostGroupMembers>[];
      json['members'].forEach((v) {
        members!.add(SinglePostGroupMembers.fromJson(v));
      });
    }else{
      members=[];
    }
    id = json['id'];
  }
}

class SinglePostGroupCreatedBy {
  String? fullName;
  String? email;
  String? image;
  String? role;
  String? phoneNumber;
  String? dataOfBirth;
  dynamic oneTimeCode;
  bool? jobExperience;
  List<String>? jobLessCategory;
  bool? isEmailVerified;
  bool? isResetPassword;
  bool? isProfileCompleted;
  bool? isDeleted;
  String? address;
  String? gender;
  String? bio;
  String? skills;
  String? about;
  String? id;

  SinglePostGroupCreatedBy(
      {this.fullName,
        this.email,
        this.image,
        this.role,
        this.phoneNumber,
        this.dataOfBirth,
        this.oneTimeCode,
        this.jobExperience,
        this.jobLessCategory,
        this.isEmailVerified,
        this.isResetPassword,
        this.isProfileCompleted,
        this.isDeleted,
        this.address,
        this.gender,
        this.bio,
        this.skills,
        this.about,
        this.id});

  SinglePostGroupCreatedBy.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    image = json['image'];
    role = json['role'];
    phoneNumber = json['phoneNumber'];
    dataOfBirth = json['dataOfBirth'];
    oneTimeCode = json['oneTimeCode'];
    jobExperience = json['jobExperience'];
    if (json['jobLessCategory'] != null) {
      jobLessCategory = <String>[];
      jobLessCategory = List<String>.from(json['jobLessCategory']);
    }else{
      jobLessCategory=[];
    }
    isEmailVerified = json['isEmailVerified'];
    isResetPassword = json['isResetPassword'];
    isProfileCompleted = json['isProfileCompleted'];
    isDeleted = json['isDeleted'];
    address = json['address'];
    gender = json['gender'];
    bio = json['bio'];
    skills = json['skills'];
    about = json['about'];
    id = json['id'];
  }
}

class SinglePostGroupMembers {
  UserId? userId;
  String? role;
  String? joinedAt;
  String? sId;

  SinglePostGroupMembers({this.userId, this.role, this.joinedAt, this.sId});

  SinglePostGroupMembers.fromJson(Map<String, dynamic> json) {
    userId =
    json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    role = json['role'];
    joinedAt = json['joinedAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userId != null) {
      data['userId'] = userId!.toJson();
    }
    data['role'] = role;
    data['joinedAt'] = joinedAt;
    data['_id'] = sId;
    return data;
  }
}

class UserId {
  String? fullName;
  String? email;
  String? image;
  String? id;

  UserId({this.fullName, this.email, this.image, this.id});

  UserId.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    image = json['image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['email'] = email;
    data['image'] = image;
    data['id'] = id;
    return data;
  }
}