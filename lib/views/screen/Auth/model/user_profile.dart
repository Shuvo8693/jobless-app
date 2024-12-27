
class UserProfile {
  ProfileAttributes? profileAttributes;

  UserProfile({this.profileAttributes});

  UserProfile.fromJson(Map<String, dynamic> json) {
    profileAttributes = json['attributes'] != null
        ? ProfileAttributes.fromJson(json['attributes'])
        : null;
  }
}

class ProfileAttributes {
  Profile? profile;
  Tokens? tokens;

  ProfileAttributes({this.profile, this.tokens});

  ProfileAttributes.fromJson(Map<String, dynamic> json) {
    profile = json['user'] != null ? Profile.fromJson(json['user']) : null;
    tokens =
    json['tokens'] != null ? Tokens.fromJson(json['tokens']) : null;
  }
}

class Profile {
  String? fullName;
  String? email;
  String? image;
  String? role;
  String? phoneNumber;
  String? dataOfBirth;
  String? about;
  dynamic oneTimeCode;
  bool? jobExperience;
  List<String>? jobLessCategory;
  bool? isEmailVerified;
  bool? isResetPassword;
  bool? isProfileCompleted;
  bool? isDeleted;
  String? gender;
  String? bio;
  String? futurePlan;
  String? pastExperiences;
  String? skills;
  String? address;
  String? id;
  String? paymentStatus;
  DateTime?subscriptionExpiryDate;

  Profile(
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
        this.gender,
        this.about,
        this.address,
        this.bio,
        this.skills,
        this.id,
        this.paymentStatus,
        this.subscriptionExpiryDate
      });

  Profile.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    image = json['image'];
    role = json['role'];
    about = json['about'];
    phoneNumber = json['phoneNumber'];
    dataOfBirth = json['dataOfBirth'];
    oneTimeCode = json['oneTimeCode'];
    jobExperience = json['jobExperience'];
    jobLessCategory = json['jobLessCategory'].cast<String>();
    isEmailVerified = json['isEmailVerified'];
    isResetPassword = json['isResetPassword'];
    isProfileCompleted = json['isProfileCompleted'];
    isDeleted = json['isDeleted'];
    gender = json['gender'];
    address = json['address'];
    skills = json['skills'];
    bio = json['bio'];
    pastExperiences = json['pastExperiences'];
    futurePlan = json['futurePlan'];
    id = json['id'];
    paymentStatus=json['paymentStatus'];
    subscriptionExpiryDate= json['subscriptionExpiryDate'] != null && json['subscriptionExpiryDate'] != ''
        ? DateTime.tryParse(json['subscriptionExpiryDate'])
        : null;
  }
}

class Tokens {
  Access? access;

  Tokens({this.access});

  Tokens.fromJson(Map<String, dynamic> json) {
    access =
    json['access'] != null ? Access.fromJson(json['access']) : null;
  }
}

class Access {
  String? token;
  String? expires;

  Access({this.token, this.expires});

  Access.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expires = json['expires'];
  }
}
