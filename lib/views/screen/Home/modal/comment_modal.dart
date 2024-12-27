class CommentModel {
  List<Comments>? comments;

  CommentModel({this.comments});

  CommentModel.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
  }
}

class Comments {
  String? sId;
  String? postId;
  UserId? userId;
  String? content;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Comments(
      {this.sId,
        this.postId,
        this.userId,
        this.content,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Comments.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    postId = json['postId'];
    userId =
    json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    content = json['content'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}

class UserId {
  String? fullName;
  String? image;
  String? id;

  UserId({this.fullName, this.image, this.id});

  UserId.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    image = json['image'];
    id = json['id'];
  }
}
