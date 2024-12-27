class SubscriptionPackageModel {
  int? code;
  String? message;
  SubscriptionPackageData? data;

  SubscriptionPackageModel({this.code, this.message, this.data});

  SubscriptionPackageModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? SubscriptionPackageData.fromJson(json['data']) : null;
  }
}

class SubscriptionPackageData {
  SubscriptionPackageAttributes? attributes;

  SubscriptionPackageData({this.attributes});

  SubscriptionPackageData.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? SubscriptionPackageAttributes.fromJson(json['attributes'])
        : null;
  }
}

class SubscriptionPackageAttributes {
  List<SubscriptionPackageResults>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  SubscriptionPackageAttributes(
      {this.results, this.page, this.limit, this.totalPages, this.totalResults});

  SubscriptionPackageAttributes.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <SubscriptionPackageResults>[];
      json['results'].forEach((v) {
        results!.add(SubscriptionPackageResults.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
  }
}

class SubscriptionPackageResults {
  String? name;
  double? price;
  int? duration;
  String? description;
  List<String>? features;
  bool? isDeleted;
  bool? defaults;
  String? createdAt;
  String? updatedAt;
  String? id;

  SubscriptionPackageResults(
      {this.name,
        this.price,
        this.duration,
        this.description,
        this.features,
        this.isDeleted,
        this.defaults,
        this.createdAt,
        this.updatedAt,
        this.id});

  SubscriptionPackageResults.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if(json['price'] is int){
     price = (json['price'] as int).toDouble();
    }else{
      price= json['price'];
    }
    duration = json['duration'];
    description = json['description'];
    features = json['features'] != null ? List<String>.from(json['features']) : null;
    isDeleted = json['isDeleted'];
    defaults = json['default'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }
}


/*
class SubscriptionPackageModel {
  int? code;
  String? message;
  SubscriptionPackageData? data;

  SubscriptionPackageModel({this.code, this.message, this.data});

  SubscriptionPackageModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? SubscriptionPackageData.fromJson(json['data']) : null;
  }
}

class SubscriptionPackageData {
  SubscriptionPackageAttributes? attributes;

  SubscriptionPackageData({this.attributes});

  SubscriptionPackageData.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? SubscriptionPackageAttributes.fromJson(json['attributes'])
        : null;
  }
}

class SubscriptionPackageAttributes {
  List<SubscriptionPackageResults>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;

  SubscriptionPackageAttributes(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults});

  SubscriptionPackageAttributes.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <SubscriptionPackageResults>[];
      json['results'].forEach((v) {
        results!.add(SubscriptionPackageResults.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
  }
}

class SubscriptionPackageResults {
  String? name;
  double? price;
  int? duration;
  String? description;
  bool? isDeleted;
  bool? defaults;
  String? id;

  SubscriptionPackageResults(
      {this.name,
      this.price,
      this.duration,
      this.description,
      this.isDeleted,
      this.defaults,
      this.id});

  SubscriptionPackageResults.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    duration = json['duration'];
    description = json['description'];
    isDeleted = json['isDeleted'];
    defaults = json['default'];
    id = json['id'];
  }

}
*/
