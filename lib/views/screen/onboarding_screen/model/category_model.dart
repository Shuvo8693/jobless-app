
class CategoryModel {
  List<Attribute> attributes;

  CategoryModel({
    required this.attributes,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        attributes: json["attributes"] == null
            ? []
            : List<Attribute>.from(json["attributes"]!.map((x) => Attribute.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "attributes": attributes == null
            ? []
            : List<dynamic>.from(attributes.map((x) => x.toJson())),
      };
}

class Attribute {
  int? id;
  String? status;

  Attribute({
    this.id,
    this.status,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        id: json["id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
      };
}
