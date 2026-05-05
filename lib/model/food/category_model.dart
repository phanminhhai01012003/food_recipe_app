class CategoryModel {
  late String image;
  late String tag;
  CategoryModel({
    this.image = "",
    this.tag = ""
  });
  CategoryModel.fromMap(Map<String, dynamic> data) {
    image = data['image'] ?? "";
    tag = data['tag'] ?? "";
  }
}