
class GroupModel {
  int? code;
  String? message;
  GroupData? groupData;

  GroupModel({this.code, this.message, this.groupData});

  GroupModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    groupData = json['data'] != null ? GroupData.fromJson(json['data']) : null;
  }
}

class GroupData {
  GroupAttributes? groupAttributes;

  GroupData({this.groupAttributes});

  GroupData.fromJson(Map<String, dynamic> json) {
    groupAttributes = json['attributes'] != null
        ? GroupAttributes.fromJson(json['attributes'])
        : null;
  }
}

class GroupAttributes {
  List<GroupResults>? groupResults;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  GroupAttributes(
      {this.groupResults,
        this.page,
        this.limit,
        this.totalPages,
        this.totalResults});

  GroupAttributes.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      groupResults = <GroupResults>[];
      json['results'].forEach((v) {
        groupResults!.add(GroupResults.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
  }
}

class GroupResults {
  String? name;
  String? description;
  String? privacy;
  String? coverImage;
  bool? isDeleted;
  GroupCreatedBy? createdBy;
  List<GroupMembers>? members;
  String? createdAt;
  String? updatedAt;
  String? id;

  GroupResults(
      {this.name,
        this.description,
        this.privacy,
        this.coverImage,
        this.isDeleted,
        this.createdBy,
        this.members,
        this.createdAt,
        this.updatedAt,
        this.id});

  GroupResults.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    privacy = json['privacy'];
    coverImage = json['coverImage'];
    isDeleted = json['isDeleted'];
    createdBy = json['createdBy'] != null
        ? GroupCreatedBy.fromJson(json['createdBy'])
        : null;
    if (json['members'] != null) {
      members = <GroupMembers>[];
      json['members'].forEach((v) {
        members!.add(GroupMembers.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }
}

class GroupCreatedBy {
  bool? isBlock;
  String? fullName;
  String? email;
  String? image;
  String? role;
  String? phoneNumber;
  String? bio;
  String? skills;
  String? address;
  String? about;
  String? paymentStatus;
  String? dataOfBirth;
  String? gender;
  dynamic oneTimeCode;
  bool? jobExperience;
  List<String>? jobLessCategory;
  bool? isEmailVerified;
  bool? isResetPassword;
  bool? isProfileCompleted;
  String? subscriptionExpiryDate;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? futurePlan;
  String? pastExperiences;
  String? id;

  GroupCreatedBy(
      {this.isBlock,
        this.fullName,
        this.email,
        this.image,
        this.role,
        this.phoneNumber,
        this.bio,
        this.skills,
        this.address,
        this.about,
        this.paymentStatus,
        this.dataOfBirth,
        this.gender,
        this.oneTimeCode,
        this.jobExperience,
        this.jobLessCategory,
        this.isEmailVerified,
        this.isResetPassword,
        this.isProfileCompleted,
        this.subscriptionExpiryDate,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.futurePlan,
        this.pastExperiences,
        this.id});

  GroupCreatedBy.fromJson(Map<String, dynamic> json) {
    isBlock = json['isBlock'];
    fullName = json['fullName'];
    email = json['email'];
    image = json['image'];
    role = json['role'];
    phoneNumber = json['phoneNumber'];
    bio = json['bio'];
    skills = json['skills'];
    address = json['address'];
    about = json['about'];
    paymentStatus = json['paymentStatus'];
    dataOfBirth = json['dataOfBirth'];
    gender = json['gender'];
    oneTimeCode = json['oneTimeCode'];
    jobExperience = json['jobExperience'];
    jobLessCategory = json['jobLessCategory'].cast<String>();
    isEmailVerified = json['isEmailVerified'];
    isResetPassword = json['isResetPassword'];
    isProfileCompleted = json['isProfileCompleted'];
    subscriptionExpiryDate = json['subscriptionExpiryDate'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    futurePlan = json['futurePlan'];
    pastExperiences = json['pastExperiences'];
    id = json['id'];
  }
}

class GroupMembers {
  UserId? userId;
  String? role;
  String? joinedAt;
  String? sId;

  GroupMembers({this.userId, this.role, this.joinedAt, this.sId});

  GroupMembers.fromJson(Map<String, dynamic> json) {
    userId =
    json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    role = json['role'];
    joinedAt = json['joinedAt'];
    sId = json['_id'];
  }
}

class UserId {
  String? fullName;
  String? email;
  String? image;
  List<String>? jobLessCategory;
  String? id;

  UserId({this.fullName, this.email, this.image, this.jobLessCategory, this.id});

  UserId.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    image = json['image'];
    jobLessCategory = json['jobLessCategory'].cast<String>();
    id = json['id'];
  }
}


/*
class GroupModel {
  int? code;
  String? message;
  GroupData? groupData;

  GroupModel({this.code, this.message, this.groupData});

  GroupModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    groupData = json['data'] != null ? GroupData.fromJson(json['data']) : null;
  }
}

class GroupData {
  GroupAttributes? groupAttributes;

  GroupData({this.groupAttributes});

  GroupData.fromJson(Map<String, dynamic> json) {
    groupAttributes = json['attributes'] != null
        ? GroupAttributes.fromJson(json['attributes'])
        : null;
  }
}

class GroupAttributes {
  List<GroupResults>? groupResults;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  GroupAttributes(
      {this.groupResults,
        this.page,
        this.limit,
        this.totalPages,
        this.totalResults});

  GroupAttributes.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      groupResults = <GroupResults>[];
      json['results'].forEach((v) {
        groupResults!.add(GroupResults.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
  }
}

class GroupResults {
  String? name;
  String? description;
  String? privacy;
  String? coverImage;
  bool? isDeleted;
  GroupCreatedBy? createdBy;
  List<Members>? members;
  String? id;

  GroupResults(
      {this.name,
        this.description,
        this.privacy,
        this.coverImage,
        this.isDeleted,
        this.createdBy,
        this.members,
        this.id});

  GroupResults.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    privacy = json['privacy'];
    coverImage = json['coverImage'];
    isDeleted = json['isDeleted'];
    createdBy = json['createdBy'] != null
        ? GroupCreatedBy.fromJson(json['createdBy'])
        : null;
    if (json['members'] != null) {
      members = [];
      for (var v in json['members']) {
        members!.add(Members.fromJson(v));
      }
    } else {
      members = [];
    }
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
*/
