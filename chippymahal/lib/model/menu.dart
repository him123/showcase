class Menu {
  final String id;
  final String branch_id;
  final String category_id;
  final String menu_title;
  final String menu_description;
  final String menu_image;
  final String menu_price;
  final String menu_veg_type;
  final String special_discount;
  final int is_advance_menu;
  final dynamic advance_menu;

  Menu({
    this.id,
    this.branch_id,
    this.category_id,
    this.menu_title,
    this.menu_description,
    this.menu_image,
    this.menu_price,
    this.menu_veg_type,
    this.special_discount,
    this.is_advance_menu,
    this.advance_menu});

  factory Menu.fromJson(Map<String,
      dynamic> json) {
    return new Menu(
        id: json['id'],
        branch_id: json['branch_id'],
        category_id: json['category_id'],
        menu_title: json['menu_title'],
        menu_description: json['menu_description'],
        menu_image: json['menu_image'],
        menu_price: json['menu_price'],
        menu_veg_type: json['menu_veg_type'],
        special_discount: json['special_discount'],
        is_advance_menu: json['is_advance_menu'],
        advance_menu: json['advance_menu']
    );
  }

  factory Menu.fromMap(Map<String, dynamic> json) =>
      new Menu(
        id: json['product_id'],
        branch_id: json['branch_id'],
        category_id: json['category_id'],
        menu_title: json['menu_title'],
        menu_description: json['menu_description'],
        menu_image: json['menu_image'],
        menu_price: json['menu_price'],
        menu_veg_type: json['menu_veg_type'],
        special_discount: json['special_discount'],
      );
}

//class size_options {
//  final String topname;
//  final String optionallow;
////  final List<Options> options;
//
//  size_options({this.topname, this.optionallow});
//
//  size_options.fromJson(Map jsonMap)
//      : topname = jsonMap['topname'],
//        optionallow = jsonMap['optionallow'];
////        options = (jsonMap['options'] as List)
////            .map((i) => Options.fromJson(i))
////            .toList();
//}
//
//class Options {
//  final String name;
//  final String price;
//
//  Options({this.name, this.price});
//
//  Options.fromJson(Map jsonMap)
//      : name = jsonMap['name'],
//        price = jsonMap['price'];
//}

//class addonoptions {
//  final String topname;
//  final String price;
//
//  addonoptions({this.name, this.price});
//
//  addonoptions.fromJson(Map jsonMap)
//      : name = jsonMap['name'],
//        price = jsonMap['price'];
//}
