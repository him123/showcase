import 'package:sabon/bloc/order.dart';
import 'package:sabon/bloc/order_bloc.dart';
import 'package:sabon/constant/constant.dart';
import 'package:sabon/screens/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrderScreen extends StatefulWidget {
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
//  final OrderBloc _orderBloc = OrderBloc();
//
//  @override
//  void dispose() {
//    _orderBloc.dispose();
//    super.dispose();
//  }
  List<Order> orderList = [];

  String token='';
  getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id');
    token = prefs.getString('token');

    getOrders(
        '$BASEURL/my_order.php?user_id=$userId');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showProgress = true;
    getLoginStatus();
  }

  TextStyle getStatusText(String status) {
    if (status == 'Pending') {
      return TextStyle(
          fontWeight: FontWeight.w600, color: Colors.blue, fontSize: 16.0);
    } else if (status == 'Auto Rejected') {
      return TextStyle(
          fontWeight: FontWeight.w600, color: Colors.redAccent, fontSize: 16.0);
    } else if (status == 'Accepted') {
      return TextStyle(
          fontWeight: FontWeight.w600, color: Colors.green, fontSize: 16.0);
    } else if (status == 'Rejected') {
      return TextStyle(
          fontWeight: FontWeight.w600, color: Colors.redAccent, fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: kColorPrimary,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/logo.png'),
            ),
            title: Text('Orders')),
        body: isEmpty
            ? Center(
                child: Text(
                'No Order found',
                style: TextStyle(fontWeight: FontWeight.w600),
              ))
            : ListView.builder(
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (BuildContext context) =>
                                  OrderDetailsScreen(
                                    orderId: orderList[index].u_id,
                                  )));
                    },
                    child: Card(
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "#Order id: ${orderList[index].u_id.toString()}",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  orderList[index].date,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
//                            Padding(
//                              padding: const EdgeInsets.all(15.0),
//                              child: Align(
//                                alignment: Alignment.topRight,
//                                child: Text(
//                                    'Amount: £${orderList[index].amount.toString()}',
//                                    style: TextStyle(
//                                        fontWeight: FontWeight.w600,
//                                        color: Colors.black)),
//                              ),
//                            ),
                          SizedBox(height: 10.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[

                                Text(
                                    'Amount: £${orderList[index].amount.toString()}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                              ],
                            ),
                            Divider(),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Order ${orderList[index].order_status.toString()}',
                                    style: getStatusText(orderList[index].order_status),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text('Repeat Order', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey,),),
                                      Icon(Icons.arrow_forward_ios, color: Colors.grey,size: 15.0,)
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }

  String changeDateFormate(String date) {
    var datetime = DateTime.parse(date);
    var formatter = new DateFormat('dd MMM yyyy');
    return formatter.format(datetime);
  }

  bool isEmpty = false;
  bool showProgress = false;

  Future<String> getOrders(String post) async {
    print('API calling waiting for response...');
    print('URL: ' + post);
    var response = await http.get(post, headers: {"token": token});
    print('response: ${response.body}');
    dynamic data = json.decode(response.body)['response']['orderList'];

    try {
      orderList =
          (data as List).map((data) => new Order.fromJson(data)).toList();
      showProgress = false;
      setState(() {
        if (orderList.length == 0) {
          isEmpty = true;
        } else {}
      });
    } catch (_) {
      setState(() {
        showProgress = false;
        isEmpty = true;
      });
    }
    return "Success!";
  }
}
