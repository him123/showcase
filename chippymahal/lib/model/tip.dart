class Tip {
  final String tips;

  Tip({this.tips});

  factory Tip.fromJson(Map<String,
      dynamic> json) {
    return new Tip(
      tips: json['tips'],
    );
  }

}
