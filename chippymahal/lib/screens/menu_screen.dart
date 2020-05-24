import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabon/components/cart.dart';
import 'package:sabon/components/custom_restaurant_item_original.dart';
import 'package:sabon/model/menu.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';

import 'cart_screen.dart';

class MenuScreen extends StatefulWidget {
  static String id = 'MenuScreen';
  final List<Menu> menus;
  final String resName;

  MenuScreen({this.menus, this.resName});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    showProgress = true;
//    getMenus('https://www.chippymahal.co.uk/appwebservices/all_menu.php');
  }

  List<String> cartItems = [];
  String selectedItem,
      selectedItemId,
      selectedItemPrice;

  int selectedItemQty = 0;
  bool isFail = false;

  void _onProductInsertedIntoCart(String id, String name, bool isAddedToCart) {
    setState(() {
      print('selectted $name with id $id is added : $isAddedToCart');
      print('Product selectted $name with id $id');

      if (isAddedToCart) {
        cartItems.add(id);
      } else {
        cartItems.remove(id);
      }
    });
  }

  void onItemSelected(int itemQty, String id, String title, String price) {
    setState(() {
      selectedItemQty = itemQty;
      selectedItemId = id;
      selectedItem = title;
      selectedItemPrice = price;

//      _settingModalBottomSheet(
//        context: context,
//        price: selectedItemPrice,
//        id: selectedItemId,
//        itemName: selectedItem,
//        itemQty: selectedItemQty,
//      );


      print('Item name: $selectedItem with QTY: $selectedItemQty');
    });
  }




  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: MediaQuery.of(context).size.height-100.0,
              child: CartScreen());
        });
  }

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<Cart>(context);

    int totalCount = 0;
    if (bloc.itemCount > 0) {
      totalCount = bloc.itemCount;
    }
    return Scaffold(
      backgroundColor: Color(0xfff5f8fb),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
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
                        Toast.show('Cart is Empty', context, gravity: Toast.CENTER);
                      }
                    },
                  ),
                  totalCount==0?Text(''):Positioned(
                      child:  Stack(
                        children: <Widget>[
                          Icon(Icons.brightness_1, size: 20.0, color: Colors.white),
                          Positioned(
                              top: 2.0,
                              right: 6,
                              child:  Center(
                                child:  Text(
                                  '$totalCount',
                                  style:  TextStyle(
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
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.resName),
              background: Container(
                width: double.infinity,
                child: CarouselSlider(
                  height: 310,
                  autoPlayCurve: Curves.linear,
                  viewportFraction: 1.0,
                  aspectRatio: 2.0,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  items: <Widget>[
                    Image.asset(
                      'assets/images/image_welcome.png',
                      height: 238,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      'assets/images/image_turkish_restaurant.png',
                      height: 238,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.all(16),
                child: widget.menus.length == 0
                    ? ShimmerList(
                  isFail: isFail,
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.menus.length,
                  itemBuilder: (BuildContext context, int index) =>
                      RestaurantItemOriginal(
                        id: widget.menus[index].id,
                        imagePath: widget.menus[index].menu_image,
                        name: widget.menus[index].menu_title,
                        price: widget.menus[index].menu_price,
                        vegOrNoveg: widget.menus.length == 0
                            ? ''
                            : widget.menus[index].menu_veg_type,
                        special_discount: widget.menus.length == 0
                            ? ''
                            : widget.menus[index].special_discount,
                        menu: widget.menus[index],
                        is_advance_menu: widget.menus[index].is_advance_menu,
//                        getSelectedProduc: _onProductInsertedIntoCart,
                      ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

//  bool showProgress = false;
//  List<Menu> widget.menus = List();
//
//  Future<String> getMenus(String post) async {
//    print('API calling waiting for response...');
//    var response = await http.get(post);
//    print('response: $response');
//    if (mounted) {
//      setState(() {
//        dynamic data = json.decode(response.body)['menu'];
////        dynamic trending = data['trending'];
//
//        if (response.statusCode == 200 && data != null) {
//          isFail = false;
//          showProgress = false;
//
//          widget.menus =
//              (data as List).map((data) => new Menu.fromJson(data)).toList();
//        } else {
//          isFail = true;
//        }
//      });
//    }
//
//    return "Success!";
//  }
}

class ShimmerList extends StatelessWidget {
  final isFail;

  ShimmerList({this.isFail});

  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return isFail == true
        ? Center(
            child: Text(
            'No Agent Found',
            style: TextStyle(fontSize: 25.0),
          ))
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (BuildContext context, int index) {
              offset += 5;
              time = 800 + offset;

              print(time);

              return Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.grey[300],
                child: ShimmerLayout(),
                period: Duration(milliseconds: time),
              );
            },
          );
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerWidth = 100;
    double containerHeight = 15;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 50.0,
            backgroundColor: Colors.grey,
          ),
          SizedBox(
            width: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: containerHeight,
                  width: containerWidth,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: containerHeight,
                  width: containerWidth,
                  color: Colors.grey,
                ),
                Container(
                  height: containerHeight,
                  width: containerWidth,
                  color: Colors.grey,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
