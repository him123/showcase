import 'package:sabon/constant/constant.dart';
import 'package:sabon/model/order_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsScreen extends StatefulWidget {
  static String id = 'OrderDetailsScreen';
  final String orderId;

  OrderDetailsScreen({this.orderId});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool showProgress = false;

  String token = '';

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    getOrder('$BASEURL/view_order.php?orderid=${widget.orderId}');

//    getOrder('https://www.chippymahal.co.uk/appwebservicesflutter/view_order.php?orderid=1887');

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showProgress = true;

    getToken();
  }

  List<AdvanceDtls> getAdvanceList(dynamic details) {
    List<AdvanceDtls> innerOptionsList = (details as List)
        .map((data) => new AdvanceDtls.fromJson(data))
        .toList();

    print('check list of inner options : ${innerOptionsList.toString()}');
    return innerOptionsList;
  }

  String getDiscount(String discount, String discountType) {
    String finalStr = '';

    if (discountType == 'P') {
      finalStr = discount + ' %' + 'of $subTotal';
    } else {
      finalStr = '$POUNDSYMBOL' + discount;
    }

    return finalStr;
  }

  String calculateDiscount(String discount) {
    double dis = 0.0;
    if (discount != '')
      dis = double.parse(subTotal) * double.parse(discount) / 100;

    return dis.toStringAsFixed(2);
  }

  String calculateTax(String tax) {
    double finalTax = 0.0;

    if (tax != '') finalTax = double.parse(subTotal) * double.parse(tax) / 100;

    return finalTax.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        backgroundColor: kColorPrimary,
      ),
      inAsyncCall: showProgress,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order Details'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              /*ORDER ID*/ Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('#Order ID',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(orderId),
                  ],
                ),
              ),
              Divider(),

              /*ORDER AMOUNT*/ Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Order Amount',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('$POUNDSYMBOL $orderAmount'),
                  ],
                ),
              ),
              Divider(),
              /*ORDER DATE*/ Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Order Placed on',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(orderDate),
                  ],
                ),
              ),
              Divider(),
              /*ORDER TYPE*/ Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Order Type',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(orderType == 'P' ? 'Pickup' : 'Delivery'),
                  ],
                ),
              ),
              Divider(),
              /*INSTRUCTION*/ Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Instruction',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(child: Text(instruction)),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Item details of your order',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20.0,
              ),
              ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                  child: Text(items[index].size_menu_name +
                                      ' ' +
                                      items[index].order_items)),
                              Text('$POUNDSYMBOL ${items[index].amount}'),
                            ],
                          ),
                          ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount:
                                  getAdvanceList(items[index].advanceDtls)
                                      .length,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                          child: Text('+' +
                                              getAdvanceList(items[index]
                                                      .advanceDtls)[i]
                                                  .ad_menu_name)),
                                      Text(
                                          '$POUNDSYMBOL ${getAdvanceList(items[index].advanceDtls)[i].price}'),
                                    ],
                                  ),
                                );
                              })
                        ],
                      ),
                    );
                  }),
              SizedBox(
                height: 30.0,
              ),
              /*SUB TOTAL*/ Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Sub Total',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                    Text('$POUNDSYMBOL $subTotal'),
                  ],
                ),
              ),

              /*DISCOUNT*/ promo_code == ''
                  ? SizedBox()
                  : Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'Promocode' +
                                        '($promo_code)' +
                                        'Discount' +
                                        ' ( ${getDiscount(discount, discountType)})',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  width: 50.0,
                                ),
                                Text('-' + calculateDiscount(discount)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              Divider(),
              /*TAX*/ Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Tax' + '($tax %)',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                    Text(POUNDSYMBOL + '' + calculateTax(tax)),
                  ],
                ),
              ),
              Divider(),
              orderType == 'D'
                  ? Container(
                      child: Column(
                        children: <Widget>[
                          /*TIPS*/ Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Tips',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 50.0,
                                ),
                                Text(POUNDSYMBOL + '' + tips),
                              ],
                            ),
                          ),
                          Divider(),

                          /*DELIVERY CHARGES*/ Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Delivery Charges',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 50.0,
                                ),
                                Text(POUNDSYMBOL + '' + deliveryCharge),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    )
                  : SizedBox(),

              /*SERVICE CHARGES*/ Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Service Charges',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                    Text(POUNDSYMBOL + '' + additional_charge),
                  ],
                ),
              ),
              Divider(),

              /*TOTAL*/ Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                    Text(
                      '$POUNDSYMBOL $total',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<OrderItem> items = [];

  String orderId = '',
      orderAmount = '',
      orderDate = '',
      orderType = '',
      instruction = '',
      subTotal = '',
      tax = '',
      total = '',
      size,
      discountType = '',
      discount = '',
      additional_charge = '',
      promo_code = '',
      deliveryCharge = '',
      tips = '';

  Future<String> getOrder(String post) async {
    print('API calling waiting for response...');
    print('URL: ' + post);

    var response = await http.get(post, headers: {"token": token});
    print('response: ${response.body}');

    dynamic outerData = json.decode(response.body)['response']['orderDetails'];

    orderId = outerData['orderid'];
    orderAmount = outerData['amount'];
    orderDate = outerData['dateTime'];
    orderType = outerData['deliveryType'];
    instruction = outerData['special_note'];

    subTotal = outerData['subTotal'];
    tax = outerData['tax_amount'];
    total = outerData['amount'];
    discountType = outerData['discountType'];
    discount = outerData['discount'];
    additional_charge = outerData['additional_charge'];
    promo_code = outerData['promo_code'];
    deliveryCharge = outerData['deliveryCharge'];
    tips = outerData['tips'];

    dynamic data = json.decode(response.body)['response']['itemDetails'];

    items = (data as List).map((data) => new OrderItem.fromJson(data)).toList();
    setState(() {
      showProgress = false;
    });

    return "Success!";
  }
}
