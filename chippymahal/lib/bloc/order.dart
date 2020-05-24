class Order {
//  String get u_id => _u_id;
//
//  String get transaction_id => _transaction_id;
//
//  set transaction_id(String value) {
//    _transaction_id = value;
//  }

  Order(
      {this.transaction_id,
      this.u_id,
      this.amount,
      this.date,
      this.order_time,
      this.order_status});

//  set u_id(String value) {
//    _u_id = value;
//  }
//
//  String get date => _date;
//
//  set date(String value) {
//    _date = value;
//  }
//
//  String get order_time => _order_time;
//
//  set order_time(String value) {
//    _order_time = value;
//  }
//
//  String get amount => _amount;
//
//  set amount(String value) {
//    _amount = value;
//  }

  String transaction_id;
  String u_id;
  String date;
  String order_time;
  String amount;
  String order_status;

  factory Order.fromJson(Map<String, dynamic> json) {
    return new Order(
      transaction_id: json['transaction_id'],
      u_id: json['u_id'],
      date: json['date'],
      order_time: json['order_time'],
      amount: json['amount'],
      order_status: json['order_status'],
    );
  }
}
