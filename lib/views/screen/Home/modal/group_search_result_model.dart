class GroupSearchResultModel {
  int? code;
  String? message;
  GroupSearchResultData? data;

  GroupSearchResultModel({this.code, this.message, this.data});

  GroupSearchResultModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? GroupSearchResultData.fromJson(json['data']) : null;
  }
}

class GroupSearchResultData {
  GroupSearchResultAttributes? attributes;

  GroupSearchResultData({this.attributes});

  GroupSearchResultData.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? GroupSearchResultAttributes.fromJson(json['attributes'])
        : null;
  }
}

class GroupSearchResultAttributes {
  List<GroupSearchResult>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  GroupSearchResultAttributes(
      {this.results,
        this.page,
        this.limit,
        this.totalPages,
        this.totalResults});

  GroupSearchResultAttributes.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <GroupSearchResult>[];
      json['results'].forEach((v) {
        results!.add(GroupSearchResult.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
  }
}

class GroupSearchResult {
  String? sId;
  String? name;
  String? description;
  String? privacy;
  String? coverImage;
  bool? isDeleted;
  CreatedBy? createdBy;
  List<Members>? members;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? joined;

  GroupSearchResult(
      {this.sId,
        this.name,
        this.description,
        this.privacy,
        this.coverImage,
        this.isDeleted,
        this.createdBy,
        this.members,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.joined});

  GroupSearchResult.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    privacy = json['privacy'];
    coverImage = json['coverImage'];
    isDeleted = json['isDeleted'];
    createdBy = json['createdBy'] != null
        ? CreatedBy.fromJson(json['createdBy'])
        : null;
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(Members.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    joined = json['joined'];
  }
}

class CreatedBy {
  String? sId;
  String? fullName;
  String? email;
  String? image;
  String? password;
  String? role;
  String? phoneNumber;
  bool? isEmailVerified;
  bool? isResetPassword;
  bool? isProfileCompleted;
  bool? isDeleted;
  int? iV;
  String? createdAt;
  String? updatedAt;
  String? address;
  String? dataOfBirth;
  bool? jobExperience;
  List<String>? jobLessCategory;
  Null? oneTimeCode;
  String? about;
  String? bio;
  String? gender;
  String? skills;

  CreatedBy(
      {this.sId,
        this.fullName,
        this.email,
        this.image,
        this.password,
        this.role,
        this.phoneNumber,
        this.isEmailVerified,
        this.isResetPassword,
        this.isProfileCompleted,
        this.isDeleted,
        this.iV,
        this.createdAt,
        this.updatedAt,
        this.address,
        this.dataOfBirth,
        this.jobExperience,
        this.jobLessCategory,
        this.oneTimeCode,
        this.about,
        this.bio,
        this.gender,
        this.skills});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
    image = json['image'];
    password = json['password'];
    role = json['role'];
    phoneNumber = json['phoneNumber'];
    isEmailVerified = json['isEmailVerified'];
    isResetPassword = json['isResetPassword'];
    isProfileCompleted = json['isProfileCompleted'];
    isDeleted = json['isDeleted'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    address = json['address'];
    dataOfBirth = json['dataOfBirth'];
    jobExperience = json['jobExperience'];
    jobLessCategory = json['jobLessCategory'].cast<String>();
    oneTimeCode = json['oneTimeCode'];
    about = json['about'];
    bio = json['bio'];
    gender = json['gender'];
    skills = json['skills'];
  }
}

class Members {
  String? userId;
  String? role;
  String? joinedAt;
  String? sId;

  Members({this.userId, this.role, this.joinedAt, this.sId});

  Members.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    role = json['role'];
    joinedAt = json['joinedAt'];
    sId = json['_id'];
  }
}
