import 'package:sabon/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CheckoutSuccessScreen extends StatefulWidget {
  static String id = 'CheckoutSuccessScreen';
  final String orderId;

  CheckoutSuccessScreen({this.orderId});

  @override
  _CheckoutSuccessScreenState createState() => _CheckoutSuccessScreenState();
}

class _CheckoutSuccessScreenState extends State<CheckoutSuccessScreen> {
  int orderStatus = 3;

  String order_ready = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getToken();
    getOrderStatus(widget.orderId);

  }

  String token='';
  void getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }


  String titleMessage(int status) {
    if (status == 1) {
      return 'Order Accpted';
    } else if (status == 2) {
      return 'Order Rejected';
    } else if (status == 3) {
      return '';
    } else {
      return 'Order Auto Rejected';
    }
  }

  String mainMessage(int status) {
    if (status == 1) {
      return 'Your order has been accepted. Your food will be ready by ${order_ready}';
    } else if (status == 2) {
      return 'Sorry, you order has been rejected by restuarant';
    } else if (status == 3) {
      //Pending
      return 'Please wait we are processing your order.';
    } else {
      return 'Sorry, you order has been rejected due to not taken any action by restaurant';
    }
  }

  Widget getGif(int status){
    if (status == 1) {
      return Image.asset(
        'assets/images/cooking2.gif',
        height: 200.0,
      );
    } else if (status == 2) {
      return Container(
          width: 150.0,
          height: 150.0,
          decoration: new BoxDecoration(
              color: Colors.black,
              borderRadius:
              new BorderRadius.all(Radius.circular(10.0))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/logo.png'),
          ));
    } else if (status == 3) {
      //Pending
      return Image.asset(
        'assets/images/loader.gif',
        height: 200.0,
      );
    } else {
      return Container(
          width: 150.0,
          height: 150.0,
          decoration: new BoxDecoration(
              color: Colors.black,
              borderRadius:
              new BorderRadius.all(Radius.circular(10.0))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/logo.png'),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5EFF1),
      appBar: AppBar(
        title: Text('Order Placed'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50.0,
            ),
            Text(
              titleMessage(orderStatus),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 21.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.0,
            ),
            getGif(orderStatus),
            SizedBox(
              height: 40.0,
            ),
            Column(
              children: <Widget>[
                Text(
                  mainMessage(orderStatus),
                  style: TextStyle(
                      color: kColorPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                orderStatus == 2
                    ? FlatButton(
                  hoverColor: kColorPrimary,
                  color: kColorPrimary,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Continue Ordering',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ):SizedBox()

              ],
            )
          ],
        ),
      ),
    );
  }

  Future<String> getOrderStatus(String orderId) async {
    print('==== getTips API called ====');
    String completeUrl =
        '$BASEURL/get_order_status.php?orderid=$orderId';

    print(completeUrl);
    var response = await http.get(completeUrl, headers: {"token": token});
    dynamic data = json.decode(response.body)['response'];

    setState(() {
      if (data['success'] == 1) {
        if (data['order_status'] == 'Accepted') {
          orderStatus = 1;
          order_ready = data['order_ready'];
        } else if (data['order_status'] == 'Rejected') {
          orderStatus = 2;
        } else if (data['order_status'] == 'Pending') {
          orderStatus = 3;
          getOrderStatus(widget.orderId);
        } else {
          // AUTO REJECTED
          orderStatus = 4;
        }
      }
    });

    print(response.body);

    return "Success!";
  }
}
