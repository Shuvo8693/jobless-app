class GroupModel {
  int? code;
  String? message;
  Data? data;

  GroupModel({this.code, this.message, this.data});

  GroupModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<Attributes>? attributes;

  Data({this.attributes});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(Attributes.fromJson(v));
      });
    }
  }
}

class Attributes {
  String? name;
  String? description;
  String? privacy;
  String? coverImage;
  bool? isDeleted;
  CreatedBy? createdBy;
  List<String>? members; // Changed from List<Null> to List<String>
  String? id;

  Attributes(
      {this.name,
        this.description,
        this.privacy,
        this.coverImage,
        this.isDeleted,
        this.createdBy,
        this.members,
        this.id});

  Attributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    privacy = json['privacy'];
    coverImage = json['coverImage'];
    isDeleted = json['isDeleted'];
    createdBy = json['createdBy'] != null
        ? CreatedBy.fromJson(json['createdBy'])
        : null;
    if (json['members'] != null) {
      members = List<String>.from(json['members']); // Corrected member type
    }
    id = json['id'];
  }
}

class CreatedBy {
  String? bio;
  String? skills;
  String? about;
  String? gender;
  String? fullName;
  String? email;
  String? image;
  String? role;
  String? phoneNumber;
  String? dataOfBirth;
  String? oneTimeCode; // Changed from Null to String? for consistency
  bool? jobExperience;
  List<String>? jobLessCategory;
  bool? isEmailVerified;
  bool? isResetPassword;
  bool? isProfileCompleted;
  bool? isDeleted;
  String? address;
  String? id;

  CreatedBy(
      {this.bio,
        this.skills,
        this.about,
        this.gender,
        this.fullName,
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
        this.id});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    bio = json['bio'];
    skills = json['skills'];
    about = json['about'];
    gender = json['gender'];
    fullName = json['fullName'];
    email = json['email'];
    image = json['image'];
    role = json['role'];
    phoneNumber = json['phoneNumber'];
    dataOfBirth = json['dataOfBirth'];
    oneTimeCode = json['oneTimeCode'];
    jobExperience = json['jobExperience'];
    jobLessCategory = List<String>.from(json['jobLessCategory']);
    isEmailVerified = json['isEmailVerified'];
    isResetPassword = json['isResetPassword'];
    isProfileCompleted = json['isProfileCompleted'];
    isDeleted = json['isDeleted'];
    address = json['address'];
    id = json['id'];
  }
}
