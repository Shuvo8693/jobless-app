class MyGroupModel {
  int? code;
  String? message;
  MyGroupData? myGroupData;

  MyGroupModel({this.code, this.message, this.myGroupData});

  MyGroupModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    myGroupData = json['data'] != null ? MyGroupData.fromJson(json['data']) : null;
  }
}

class MyGroupData {
  List<MyGroupAttributes>? myGroupAttributes;

  MyGroupData({this.myGroupAttributes});

  MyGroupData.fromJson(Map<String, dynamic> json) {
    if (json['attributes'] != null) {
      myGroupAttributes = <MyGroupAttributes>[];
      json['attributes'].forEach((v) {
        myGroupAttributes!.add(MyGroupAttributes.fromJson(v));
      });
    }
  }
}

class MyGroupAttributes {
  String? name;
  String? description;
  String? privacy;
  String? coverImage;
  bool? isDeleted;
  GroupCreatedBy? createdBy;
  List<dynamic>? members;
  String? id;

  MyGroupAttributes(
      {this.name,
        this.description,
        this.privacy,
        this.coverImage,
        this.isDeleted,
        this.createdBy,
        this.members,
        this.id});

  MyGroupAttributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    privacy = json['privacy'];
    coverImage = json['coverImage'];
    isDeleted = json['isDeleted'];
    createdBy = json['createdBy'] != null
        ? GroupCreatedBy.fromJson(json['createdBy'])
        : null;
    members = json['members'] !=null?  json['members'].forEach((v) {
      members!.add(Members.fromJson(v));
    }):[] ;
    id = json['id'];
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['role'] = role;
    data['joinedAt'] = joinedAt;
    data['_id'] = sId;
    return data;
  }
}
class GroupCreatedBy {
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

  GroupCreatedBy(
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

  GroupCreatedBy.fromJson(Map<String, dynamic> json) {
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