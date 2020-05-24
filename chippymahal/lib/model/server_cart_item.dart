class ServerCartItem {
  final String id;
  final String order_items;
  final String quantity;
  final String amount;
  final String item_id;
  final String item_unit_price;
  final String advance_menu;
  final String advance_menu_name;
  final String size_menu;
  final String size_menu_name;
  final String veg_type;

  ServerCartItem(
      {this.id,
      this.order_items,
      this.quantity,
      this.amount,
      this.item_id,
      this.item_unit_price,
      this.advance_menu,
      this.advance_menu_name,
      this.size_menu,
      this.size_menu_name,
      this.veg_type});

  factory ServerCartItem.fromJson(Map<String, dynamic> json) {
    return new ServerCartItem(
      id: json['id'],
      order_items: json['order_items'],
      quantity: json['quantity'],
      amount: json['amount'],
      item_id: json['item_id'],
      item_unit_price: json['item_unit_price'],
      advance_menu: json['advance_menu'],
      advance_menu_name: json['advance_menu_name'],
      size_menu: json['size_menu'],
      size_menu_name: json['size_menu_name'],
      veg_type: json['veg_type'],
    );
  }
}
