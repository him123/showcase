class CategoryData {
  final String id;
  final String name;
  final String banner_image;
  final bool isSelected;

  CategoryData({
    this.name,
    this.banner_image,
    this.id,
    this.isSelected,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return new CategoryData(
      id: json['id'],
      name: json['name'],
      banner_image: json['banner_image'],
    );
  }
}
