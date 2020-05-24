import 'package:sabon/constant/constant.dart';
import 'package:sabon/model/promo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PromocodeScreen extends StatefulWidget {
  static String id = 'PromocodeScreen';

  @override
  _PromocodeScreenState createState() => _PromocodeScreenState();
}

class _PromocodeScreenState extends State<PromocodeScreen> {
  List<Promo> promoList = [];

  String token='';
  void getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    getPromos('$BASEURL/all_promocode.php');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promo'),
      ),
      body: promoList.length == 0
          ? Center(
              child: CircularProgressIndicator(
              backgroundColor: kColorPrimary,
            ))
          : ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: promoList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Card(
                            elevation: 1.0,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                "${promoList[index].promo_code.toString()}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0),
                              ),
                            ),
                          ),
                          Text(
                            'Get ${promoList[index].discount.toString()} ${promoList[index].discount_type == 'P' ? '%' : '£'} discount on your order.',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14.0),
                          ),
//                  Text('Amount: £${promoList[index].amount.toString()}'),
                        ],
                      ),
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context, promoList[index]);
                          },
                          child: Text(
                            'Apply',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: kColorPrimary,
                                fontSize: 16.0),
                          )),
                    ],
                  ),
                );
              }),
    );
  }

  Future<String> getPromos(String post) async {
    print('API calling waiting for response...');
    print('URL: ' + post);
    var response = await http.get(post, headers: {"token": token});
    print('response: ${response.body}');
    dynamic data = json.decode(response.body)['response']['promocodelist'];

    promoList = (data as List).map((data) => new Promo.fromJson(data)).toList();

    setState(() {});

    return "Success!";
  }
}
