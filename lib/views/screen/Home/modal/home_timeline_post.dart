

class TimeLinePostModal {
  TimelinePost? timeLinePost;

  TimeLinePostModal({this.timeLinePost});

  TimeLinePostModal.fromJson(Map<String, dynamic> json) {
    timeLinePost = json['attributes'] != null
        ? TimelinePost.fromJson(json['attributes'])
        : null;
  }
}
///=======from here====
class TimelinePost {
  List<Results>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  TimelinePost({this.results, this.page, this.limit, this.totalPages, this.totalResults});

  TimelinePost.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results?.add(Results.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
  }
}

class Results {
  String? postType;
  int? sharesCount;
  int? rewardCount;
  String? sId;
  String? content;
  String? privacy;
  Author? author;
  List<dynamic>? likes;
  List<dynamic>? comments;
  List<dynamic>? shares;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? iV;
  int? likesCount;
  int? commentsCount;
  bool? isLiked;
  String? image;
  String? groupId;

  Results({
    this.postType,
    this.sharesCount,
    this.sId,
    this.content,
    this.privacy,
    this.author,
    this.likes,
    this.comments,
    this.shares,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.likesCount,
    this.commentsCount,
    this.isLiked,
    this.image,
    this.groupId,
  });

 Results.fromJson(Map<String, dynamic> json) {
    postType = json['postType'];
    sharesCount = json['sharesCount'];
    rewardCount = json['rewardCount'];
    sId = json['_id'];
    content = json['content'];
    privacy = json['privacy'];
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    likes = json['likes'] != null ? List<dynamic>.from(json['likes']) : [0];
    comments = json['comments'] != null ? List<dynamic>.from(json['comments']) : [0];
    shares = json['shares'] != null ? List<dynamic>.from(json['shares']) : [0];
    isDeleted = json['isDeleted'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
    iV = json['__v'];
    likesCount = json['likesCount'];
    commentsCount = json['commentsCount'];
    isLiked = json['isLiked'];
    image = json['image'];
    groupId = json['groupId'];
  }
}

class Author {
  String? sId;
  String? fullName;
  String? email;
  String? image;
  String? address;
  String? paymentStatus;


  Author({this.sId, this.fullName, this.email, this.image,this.address,this.paymentStatus});

  Author.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
    image = json['image'];
    address= json['address'];
    paymentStatus = json['paymentStatus'];
  }
}
