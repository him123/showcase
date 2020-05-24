import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sabon/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'order.dart';

class OrderBloc {
  //sink to add in pipe
  //stream to get data from pipe
  //by pipe i mean data flow

  List<Order> _orderList = [];
  final _orderListStreamController = StreamController<List<Order>>();

  Stream<List<Order>> get orderStreamList => _orderListStreamController.stream;

  StreamSink<List<Order>> get orderListSink => _orderListStreamController.sink;

  String token='';
  void getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  OrderBloc() {
    getToken();
    getOrders(
        '$BASEURL/my_order.php?user_id=147');
  }

  Future<String> getOrders(String post) async {
    print('API calling waiting for response...');
    print('URL: ' + post);
    var response = await http.get(post, headers: {"token": token});
    print('response: ${response.body}');
    dynamic data = json.decode(response.body)['response']['orderList'];

    _orderList = (data as List).map((data) => new Order.fromJson(data)).toList();
    _orderListStreamController.add(_orderList);
    return "Success!";
  }

  void dispose() {
    _orderListStreamController.close();
  }
}
