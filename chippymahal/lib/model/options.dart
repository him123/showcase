class Options {
  final String name;
  final String price;

  Options({this.name, this.price});

  factory Options.fromJson(Map<String, dynamic> json) {
    return new Options(
      name: json['name'],
      price: json['price'],
    );
  }
}

class InnerOptions {
  final String topname;
  final String optionallow;
  final List<ChildOption> child;

  InnerOptions({this.topname, this.optionallow, this.child});

  factory InnerOptions.fromJson(Map<String, dynamic> json) {
    return new InnerOptions(
      topname: json['topname'],
      optionallow: json['optionallow'],
      child: (json['options'] as List).map((i) => ChildOption.fromJson(i)).toList(),
    );
  }
}


class ChildOption {
  final String name;
  final String price;

  ChildOption({this.name, this.price});

  ChildOption.fromJson(Map jsonMap)
      : name = jsonMap['name'],
        price = jsonMap['price'];
//
//  Child.fromJson(Map jsonMap) : slug = jsonMap['slug'];

}
