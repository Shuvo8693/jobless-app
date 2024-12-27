
class Profile {
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

  Profile(
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
        this.gender});

  Profile.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
