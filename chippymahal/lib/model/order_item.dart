class OrderItem {
  final String order_items;
  final String amount;
  final String item_unit_price;
  final dynamic advanceDtls;
  final String size_menu;
  final String size_menu_name;

  OrderItem(
      {this.amount,
        this.order_items,
        this.item_unit_price,
        this.advanceDtls,
        this.size_menu,
        this.size_menu_name});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return new OrderItem(
      order_items: json['order_items'],
      amount: json['amount'],
      item_unit_price: json['item_unit_price'],
      advanceDtls: json['advance_dtls'],
      size_menu: json['size_menu'],
      size_menu_name: json['size_menu_name'],
    );
  }
}

class AdvanceDtls {
  final String ad_menu_name;
  final String qty;
  final String price;

  AdvanceDtls({this.ad_menu_name, this.qty, this.price});

  factory AdvanceDtls.fromJson(Map<String, dynamic> json) {
    return new AdvanceDtls(
      ad_menu_name: json['ad_menu_name'],
      qty: json['qty'],
      price: json['price'],
    );
  }

//  AdvanceDtls.fromJson(Map jsonMap)
//      : ad_menu_name = jsonMap['ad_menu_name'],
//        qty = jsonMap['qty'],
//        price = jsonMap['price'];
}
