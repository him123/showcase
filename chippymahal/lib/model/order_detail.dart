import 'package:sabon/bloc/order.dart';

class OrderDetails {
  String orderid;
  String amount;
  String tax_amount;
  String tips;
  String discount;
  String delivery_time;
  String pickup_time;
  String advance_order;
  String advance_order_date;
  String advance_order_time;
  String special_note;
  String deliveryType;
  String subTotal;
  String taxAmount;
  String dateTime;
  String deliveryCharge;

  OrderDetails({
    this.tips,
    this.discount,
    this.subTotal,
    this.amount,
    this.deliveryCharge,
    this.advance_order,
    this.advance_order_date,
    this.advance_order_time,
    this.dateTime,
    this.delivery_time,
    this.deliveryType,
    this.orderid,
    this.pickup_time,
    this.special_note,
    this.tax_amount,
    this.taxAmount,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return new OrderDetails(
      tips: json['tips'],
      discount: json['discount'],
      subTotal: json['subTotal'],
      amount: json['amount'],
      deliveryCharge: json['deliveryCharge'],
      advance_order: json['advance_order'],
      advance_order_date: json['advance_order_date'],
      advance_order_time: json['advance_order_time'],
      dateTime: json['dateTime'],
      delivery_time: json['delivery_time'],
      deliveryType: json['deliveryType'],
      orderid: json['orderid'],
      pickup_time: json['pickup_time'],
      tax_amount: json['tax_amount'],
      taxAmount: json['taxAmount'],
    );
  }
}
