/*
class GroupTimelinePostModel {
  int? code;
  String? message;
  GroupTimelinePostData? data;

  GroupTimelinePostModel({this.code, this.message, this.data});

  GroupTimelinePostModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? GroupTimelinePostData.fromJson(json['data']) : null;
  }
}

class GroupTimelinePostData {
  List<GroupTimelinePostAttributes>? groupTimelinePostAttributes;

  GroupTimelinePostData({this.groupTimelinePostAttributes});

  GroupTimelinePostData.fromJson(Map<String, dynamic> json) {
    if (json['attributes'] != null) {
      groupTimelinePostAttributes = <GroupTimelinePostAttributes>[];
      json['attributes'].forEach((v) {
        groupTimelinePostAttributes!.add(GroupTimelinePostAttributes.fromJson(v));
      });
    }
  }
}

class GroupTimelinePostAttributes {
  String? image;
  String? postFileType;
  String? content;
  Author? author;
  String? privacy;
  String? postType;
  dynamic groupId;
  int? sharesCount;
  int? commentsCount;
  int? likesCount;
  bool? isDeleted;
  dynamic id;

  GroupTimelinePostAttributes(
      {this.image,
        this.postFileType,
        this.content,
        this.author,
        this.privacy,
        this.postType,
        this.groupId,
        this.sharesCount,
        this.commentsCount,
        this.likesCount,
        this.isDeleted,
        this.id});

  GroupTimelinePostAttributes.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    postFileType = json['postFileType'];
    content = json['content'];
    author =
    json['author'] != null ? Author.fromJson(json['author']) : null;
    privacy = json['privacy'];
    postType = json['postType'];
    groupId = json['groupId'];
    sharesCount = json['sharesCount'];
    commentsCount = json['commentsCount'];
    likesCount = json['likesCount'];
    isDeleted = json['isDeleted'];
    id = json['id'];
  }
}

class Author {
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
  dynamic oneTimeCode;
  bool? jobExperience;
  List<String>? jobLessCategory;
  bool? isEmailVerified;
  bool? isResetPassword;
  bool? isProfileCompleted;
  bool? isDeleted;
  String? address;
  dynamic id;

  Author(
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

  Author.fromJson(Map<String, dynamic> json) {
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
    jobLessCategory = json['jobLessCategory'].cast<String>();
    isEmailVerified = json['isEmailVerified'];
    isResetPassword = json['isResetPassword'];
    isProfileCompleted = json['isProfileCompleted'];
    isDeleted = json['isDeleted'];
    address = json['address'];
    id = json['id'];
  }
}

*/


class GroupTimeLinePostModal {
  int? code;
  String? message;
  GroupTimelinePostData? data;

  GroupTimeLinePostModal({this.code, this.message, this.data});

  GroupTimeLinePostModal.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new GroupTimelinePostData.fromJson(json['data']) : null;
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

class GroupTimelinePostData {
  GroupTimeLInePostAttributes? attributes;

  GroupTimelinePostData({this.attributes});

  GroupTimelinePostData.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? new GroupTimeLInePostAttributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (attributes != null) {
      data['attributes'] = attributes!.toJson();
    }
    return data;
  }
}

class GroupTimeLInePostAttributes {
  List<GroupTimeLinePostResults>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  GroupTimeLInePostAttributes(
      {this.results,
        this.page,
        this.limit,
        this.totalPages,
        this.totalResults});

  GroupTimeLInePostAttributes.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <GroupTimeLinePostResults>[];
      json['results'].forEach((v) {
        results!.add(new GroupTimeLinePostResults.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    return data;
  }
}

class GroupTimeLinePostResults {
  String? sId;
  String? content;
  String? image;
  String? postFileType;
  Author? author;
  String? privacy;
  String? postType;
  String? groupId;
  int? sharesCount;
  int? commentsCount;
  int? likesCount;
  bool? isDeleted;
  DateTime? createdAt;
  String? updatedAt;
  int? iV;
  bool? isLiked;

  GroupTimeLinePostResults(
      {this.sId,
        this.content,
        this.image,
        this.postFileType,
        this.author,
        this.privacy,
        this.postType,
        this.groupId,
        this.sharesCount,
        this.commentsCount,
        this.likesCount,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.isLiked});

  GroupTimeLinePostResults.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    image = json['image'];
    postFileType = json['postFileType'];
    author =
    json['author'] != null ? new Author.fromJson(json['author']) : null;
    privacy = json['privacy'];
    postType = json['postType'];
    groupId = json['groupId'];
    sharesCount = json['sharesCount'];
    commentsCount = json['commentsCount'];
    likesCount = json['likesCount'];
    isDeleted = json['isDeleted'];
    createdAt = DateTime.parse(json['createdAt'] as String);
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isLiked = json['isLiked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['content'] = content;
    data['image'] = image;
    data['postFileType'] = postFileType;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    data['privacy'] = privacy;
    data['postType'] = postType;
    data['groupId'] = groupId;
    data['sharesCount'] = sharesCount;
    data['commentsCount'] = commentsCount;
    data['likesCount'] = likesCount;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['isLiked'] = isLiked;
    return data;
  }
}

class Author {
  String? sId;
  String? fullName;
  String? email;
  String? image;
  String? address;

  Author({this.sId, this.fullName, this.email, this.image, this.address});

  Author.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
    image = json['image'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['fullName'] = fullName;
    data['email'] = email;
    data['image'] = image;
    data['address'] = address;
    return data;
  }
}

