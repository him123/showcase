import 'package:sabon/components/cart.dart';
import 'package:sabon/components/custom_restaurant_item_original.dart';
import 'package:sabon/constant/constant.dart';
import 'package:sabon/localdb/database_util.dart';
import 'package:sabon/model/menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';

import 'cart_screen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<String> idList = [];
  List<Menu> menuList = List();
  String ids = '';

  String token = '';

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    // getFavMenu() async {
    try {
      List<Menu> menuList = await DBProvider.db.getFavoriteMenu();

      for (int i = 0; i < menuList.length; i++) {
        idList.add(menuList[i].id);
      }

      ids = idList.join(',');
      print('check this id list: $ids');
    } catch (_) {}

    getMenus('$BASEURL/my_favourites.php?fav_ids=$ids');
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<Cart>(context);

    int totalCount = 0;
    if (bloc.itemCount > 0) {
      totalCount = bloc.itemCount;
    }
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: Scaffold(
        backgroundColor: Color(0xfff5f8fb),
        appBar: AppBar(
            actions: <Widget>[
              Stack(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (totalCount != 0) {
                        _settingModalBottomSheet(context);
                      } else {
                        Toast.show('Cart is Empty', context,
                            gravity: Toast.CENTER);
                      }
                    },
                  ),
                  totalCount == 0
                      ? Text('')
                      : Positioned(
                          child: Stack(
                          children: <Widget>[
                            Icon(Icons.brightness_1,
                                size: 20.0, color: Colors.white),
                            Positioned(
                                top: 2.0,
                                right: 6,
                                child: Center(
                                  child: Text(
                                    '$totalCount',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )),
                          ],
                        )),
                ],
              ),
            ],
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/logo.png'),
            ),
            title: Text('Favorites')),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: menuList.length == 0
              ? ShimmerMenuItem(
                  isMenuEmpty: isMenuEmpty,
                )
              : ListView.builder(
                  itemCount: menuList.length,
                  itemBuilder: (BuildContext context, int index) =>
                      RestaurantItemOriginal(
                    id: menuList[index].id,
                    imagePath: menuList[index].menu_image,
                    name: menuList[index].menu_title,
                    price: menuList[index].menu_price,
                    vegOrNoveg: menuList.length == 0
                        ? ''
                        : menuList[index].menu_veg_type,
                    special_discount:
                        menuList == 0 ? '' : menuList[index].special_discount,
                    menu: menuList[index],
                    is_advance_menu: menuList[index].is_advance_menu,
//                        getSelectedProduc: _onProductInsertedIntoCart,
                  ),
                ),
        ),
      ),
    );
  }

  bool showProgress = false;
  bool isMenuEmpty = false;

  Future<String> getMenus(String post) async {
    print('API calling waiting for response...');
    print('URL: ' + post);
    var response = await http.get(post, headers: {"token": token});
    print('response: $response');
    if (mounted) {
      setState(() {
        dynamic data = json.decode(response.body)['menu'];
        dynamic success = json.decode(response.body)['success'];

        if (success == 1 && response.statusCode == 200 && data != null) {
          showProgress = false;
          isMenuEmpty = false;
          menuList =
              (data as List).map((data) => new Menu.fromJson(data)).toList();
        } else {
          isMenuEmpty = true;
        }
      });
    }

    return "Success!";
  }
}

void _settingModalBottomSheet(context) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return Container(
            height: MediaQuery.of(context).size.height - 100.0,
            child: CartScreen());
      });
}

class ShimmerMenuItem extends StatelessWidget {
  final bool isMenuEmpty;

  ShimmerMenuItem({this.isMenuEmpty});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isMenuEmpty
          ? Center(
              child: Text(
              'No favorite item found',
              style: TextStyle(fontWeight: FontWeight.w600),
            ))
          : Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: Colors.grey[300],
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                          color: Colors.redAccent,
                        ),
                        width: 100.0,
                        height: 80,
                      ),
                      period: Duration(milliseconds: 800),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Shimmer.fromColors(
                          highlightColor: Colors.white,
                          baseColor: Colors.grey[300],
                          child: Container(
                            width: 200.0,
                            height: 20.0,
                            color: Colors.red,
                          ),
                          period: Duration(milliseconds: 800),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Shimmer.fromColors(
                          highlightColor: Colors.white,
                          baseColor: Colors.grey[300],
                          child: Container(
                            width: 200.0,
                            height: 20.0,
                            color: Colors.red,
                          ),
                          period: Duration(milliseconds: 800),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: Colors.grey[300],
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                          color: Colors.redAccent,
                        ),
                        width: 100.0,
                        height: 80,
                      ),
                      period: Duration(milliseconds: 800),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Shimmer.fromColors(
                          highlightColor: Colors.white,
                          baseColor: Colors.grey[300],
                          child: Container(
                            width: 200.0,
                            height: 20.0,
                            color: Colors.red,
                          ),
                          period: Duration(milliseconds: 800),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Shimmer.fromColors(
                          highlightColor: Colors.white,
                          baseColor: Colors.grey[300],
                          child: Container(
                            width: 200.0,
                            height: 20.0,
                            color: Colors.red,
                          ),
                          period: Duration(milliseconds: 800),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
