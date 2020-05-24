import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sabon/bloc/order_bloc.dart';
import 'package:sabon/components/cart.dart';
import 'package:sabon/constant/constant.dart';
import 'package:sabon/model/addons.dart';
import 'package:sabon/model/server_cart_item.dart';
import 'package:sabon/screens/discover.dart';
import 'package:sabon/screens/favorite_screen.dart';
import 'package:sabon/screens/my_order_screen.dart';
import 'package:sabon/screens/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabLandingScreen extends StatefulWidget {
  static String id = 'TabLandingScreen';

  @override
  _TabLandingScreenState createState() => _TabLandingScreenState();
}

class _TabLandingScreenState extends State<TabLandingScreen> {
  int selectedIndex = 0;
  final pages = [
    Discover(),
    MyOrderScreen(),
    FavoriteScreen(),
    MyProfileScreen(),
  ];

  getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id');

    getSecurityToken('$BASEURL/get_token_key.php');

  }

  @override
  void initState() {
    super.initState();

    getLoginStatus();
  }

  Widget navBarItem(String image, String text, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/images/$image',
                width: 24,
                height: 24,
                color: selectedIndex == index ? kColorPrimary : kColorGrey),
            Text(
              text,
              style: TextStyle(
                color: selectedIndex == index ? kColorPrimary : kColorGrey,
                fontSize: 10,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
//      appBar: AppBar(title: Text('Chippy Mahal'),),
        body: pages.elementAt(selectedIndex),
//      drawer: MainDrawer(),
        bottomNavigationBar: BottomAppBar(
          color: Color(0xfff8f8f8),
          elevation: 20,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: navBarItem('menu.png', 'Menu', 0),
              ),
              Expanded(
                flex: 1,
                child: navBarItem('icon_my_order.png', 'My Orders', 1),
              ),
              Expanded(
                flex: 1,
                child: navBarItem('icon_favorite.png', 'Favorite', 2),
              ),
              Expanded(
                flex: 1,
                child: navBarItem('icon_profile.png', 'Profile', 3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ServerCartItem> serverCartItemList = [];

//  Future<String> getCartItems(String post) async {
//    final cart = Provider.of<Cart>(context, listen: false);
//    print('GET CART API CALLED...');
//    print('URL: ' + post);
////    Map<String, String> headers = {"Content-type": "application/json"};
//    var response = await http.get(post, headers: {"token": token});
//
//    print('response: ${response.body}');
//
//    dynamic data = json.decode(response.body)['response']['cart_item'];
//
//    if (response.statusCode == 200 && data != null) {
//      serverCartItemList = (data as List)
//          .map((data) => new ServerCartItem.fromJson(data))
//          .toList();
//
//      if (serverCartItemList.length != 0) {
//        var addons = Addons();
//        List<Addons> addonList = [];
//        for (int i = 0; i < serverCartItemList.length; i++) {
//          if (serverCartItemList[i].advance_menu != '') {
//            addons.name = serverCartItemList[i].advance_menu.trim();
//            addonList.add(addons);
//          }
//
//          cart.addItemsFromAPI(
//              serverCartItemList[i].item_id,
//              double.parse(serverCartItemList[i].item_unit_price),
//              serverCartItemList[i].order_items,
//              serverCartItemList[i].veg_type == 'V' ? true : false,
//              serverCartItemList[i].advance_menu == '' ? false : true,
//              int.parse(serverCartItemList[i].quantity),
//              addonList);
//        }
//      }
//    } else {}
//
//    return "Success!";
//  }

  Future<String> checkShopStatus(String post, String token) async {

    print('GET CART API CALLED...');
    print('URL: ' + post);
    var response = await http.get(post, headers: {"token": token});
    print('response: ${response.body}');
    dynamic data = json.decode(response.body)['response'];

    if (response.statusCode == 200 && data != null) {
      if (data['is_active'] != '1') {
        showAlert(context, data['deactivate_text']);
      }
    }

    return "Success!";
  }

  void showAlert(BuildContext context, String msg) {
    Alert(
      context: context,
      type: AlertType.error,
      title: msg,
//      desc: msg,
      closeFunction: () {
        SystemNavigator.pop();
      },
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onPressed: () => SystemNavigator.pop(),
          width: 120,
          color: Colors.lightBlue,
          radius: BorderRadius.circular(5.0),
        )
      ],
    ).show();
  }

  Future<String> getSecurityToken(String post) async {
    print('GET TOKEN API CALLED...');
    print('URL: ' + post);

    var response = await http.get(post);

    print('----------> TOKEN response: ${response.body}');

    dynamic data = json.decode(response.body)['response'];
//
    if (data['success'] == 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('-------> check token: ${data['token_key']}');
      prefs.setString('token', data['token_key']);
    }

    checkShopStatus('$BASEURL/shop_status.php',  data['token_key'].toString());

    return "Success!";
  }
}
