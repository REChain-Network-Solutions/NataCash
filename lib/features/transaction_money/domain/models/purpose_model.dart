
class PurposeModel {
  PurposeModel({
    this.title = '',
    this.logo = '',
    this.color = '#f0fff6',
  });

  String? title;
  String? logo;
  String? color;

  factory PurposeModel.fromJson(Map<String, dynamic> json) => PurposeModel(
    title: json["title"],
    logo: json["logo"],
    color: json["color"],
  );
}
