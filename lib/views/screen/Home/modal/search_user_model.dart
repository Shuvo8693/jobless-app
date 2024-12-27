class UserModel {
  int? code;
  String? message;
  Data? data;

  UserModel({this.code, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<User>? userList;

  Data({this.userList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['attributes'] != null) {
      userList = <User>[];
      json['attributes'].forEach((v) {
        userList!.add(User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userList != null) {
      data['attributes'] = userList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
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
  String? oneTimeCode;
  String? friendRequestStatus;
  String? gender;
  String? bio;
  String? skill;
  String? about;

  User(
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
        this.friendRequestStatus,
        this.bio,
        this.about,
        this.skill,
        this.gender});

  User.fromJson(Map<String, dynamic> json) {
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
    friendRequestStatus = json['friendRequestStatus'];
    gender = json['gender'];
    gender = json['bio'];
    gender = json['skills'];
    gender = json['about'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['fullName'] = fullName;
    data['email'] = email;
    data['image'] = image;
    data['password'] = password;
    data['role'] = role;
    data['phoneNumber'] = phoneNumber;
    data['isEmailVerified'] = isEmailVerified;
    data['isResetPassword'] = isResetPassword;
    data['isProfileCompleted'] = isProfileCompleted;
    data['isDeleted'] = isDeleted;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['address'] = address;
    data['dataOfBirth'] = dataOfBirth;
    data['jobExperience'] = jobExperience;
    data['jobLessCategory'] = jobLessCategory;
    data['oneTimeCode'] = oneTimeCode;
    data['friendRequestStatus'] = friendRequestStatus;
    data['gender'] = gender;
    data['bio']=bio;
    data['skills']=skill;
    data['about']=about;
    return data;
  }
}
