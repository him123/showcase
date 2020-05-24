import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:sabon/components/cart.dart';
import 'package:sabon/components/custom_category_item.dart';
import 'package:sabon/components/custom_restaurant_item_original.dart';
import 'package:sabon/constant/constant.dart';
import 'package:sabon/model/branch.dart';
import 'package:sabon/model/category_data.dart';
import 'package:sabon/model/menu.dart';
import 'package:sabon/screens/cart_screen.dart';
import 'package:sabon/screens/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  List<String> sortBy = [
    'Top Rated',
    'Near Me',
    'Cost High To Low',
    'Cost Low To High',
  ];

  String token='';

  void getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    getBranches('$BASEURL/choose_branch.php');
    getCategories('$BASEURL/choose_category.php');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showProgress = true;
    isBranchAPILoading = true;

    getToken();

//    getMenusForShowAll('$BASEURL/all_menu.php', false);
//    getMenusForShowAll('$BASEURL/all_menu_test.php', false);
  }

//  List<String> branches = ['Branch 1', 'Branch 2', 'Branch 3'];
  String selectedBranch = 'Select branch';
  String selectedCategory = '';
  String selectedBranchId = '',
      selectedCategoryId = '';

  int checkedIndex = -1;
  List<String> cartItems = [];

  void _onCatSelected(String id, String name) {
    setState(() {
      selectedCategory = name;
      selectedCategoryId = id;
      menuList.clear();

      getMenus(
          '$BASEURL/all_menu.php?branch_id=$selectedBranchId&category_id=$selectedCategoryId',
          true);
    });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height - 100.0,
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
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: branchList.length > 1
            ? InkWell(
          onTap: () {
            Widget setupAlertDialoadContainer() {
              return Container(
                height: 180.0, // Change as per your requirement
                width: 200.0, // Change as per your requirement
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: branchList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        print(
                            'selected ${branchList[index].branch_name}');
                        setState(() {
                          selectedBranch = branchList[index].branch_name;
                          selectedBranchId = branchList[index].id;
                          saveInPreference(BRANCH_ID, selectedBranchId);
                          catList.clear();
                          menuList.clear();

                          getCategories(
                              '$BASEURL/choose_category.php?branch_id=$selectedBranchId');
                          getMenus(
                              '$BASEURL/all_menu.php?branch_id=$selectedBranchId&category_id=$selectedCategoryId',
                              true);
                        });
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        selected: true,
                        title: Text(branchList[index].branch_name),
                      ),
                    );
                  },
                ),
              );
            }

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Choose branch'),
                    content: setupAlertDialoadContainer(),
                  );
                });
          },
          child: Row(
            children: <Widget>[
              Text(selectedBranch),
              Image.asset(
                'assets/images/arrow_down.png',
                height: 20.0,
                color: Colors.white,
              )
            ],
          ),
        )
            : Text(isBranchAPILoading ? '' : branchList[0].branch_name),
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
//          SizedBox(
//            width: 20.0,
//          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CarouselSlider(
                height: 230,
                autoPlayCurve: Curves.linear,
                viewportFraction: 1.0,
                aspectRatio: 2.0,
                autoPlay: true,
                enlargeCenterPage: false,
                items: <Widget>[
                  Image.asset(
                    'assets/images/banner_images.jpg',
                    height: 230,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
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
              /*CATEGORIES LABLE*/ Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              /*CATEGORIES ROW*/ Container(
                height: 80,
                child: catList.length == 0
                    ? ShimmerListForCat(
                  isFail: isBranchEmpty,
                )
                    : Center(
                  /*CATEGORY LIST*/
                  child: ListView.builder(
                    itemCount: catList.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) =>
                        CategoryItem(
                          iconPath: catList[index].banner_image,
                          name: catList[index].name,
                          id: catList[index].id,
                          selectedId: selectedCategoryId,
                          getSelectedCat: _onCatSelected,
                        ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              /*FOOD ITEM LIST VIEW*/ Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            selectedCategory,
                            style: TextStyle(
                              color: kColorPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
//                        InkWell(
//                          onTap: () {
//                            print(menuList.length);
//                            if (menuList.length != 0)
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) => MenuScreen(
//                                          menus: menuList,
//                                          resName: selectedBranch,
//                                        )),
//                              );
//                          },
//                          child: Row(
//                            children: <Widget>[
//                              Text(
//                                'Show all',
//                                style: TextStyle(
//                                  color: kColorBlue,
//                                  fontSize: 16,
//                                  fontWeight: FontWeight.w400,
//                                  fontStyle: FontStyle.normal,
//                                ),
//                              ),
//                              SizedBox(
//                                width: 5,
//                              ),
//                              Icon(
//                                Icons.arrow_right,
//                                color: kColorBlue,
//                              ),
//                            ],
//                          ),
//                        ),
                      ],
                    ),
                    menuList.length == 0
                        ? ShimmerMenuItem()
                        : !isMenuEmpty
                        ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: menuList.length,
                      itemBuilder:
                          (BuildContext context, int index) =>
                          RestaurantItemOriginal(
                            id: menuList[index].id,
                            imagePath: menuList[index].menu_image,
                            name: menuList[index].menu_title,
                            price: menuList[index].menu_price,
                            vegOrNoveg: menuList.length == 0
                                ? ''
                                : menuList[index].menu_veg_type,
                            special_discount: menuList.length == 0
                                ? ''
                                : menuList[index].special_discount,
                            menu: menuList[index],
                            is_advance_menu:
                            menuList[index].is_advance_menu,
//                        getSelectedProduc: _onProductInsertedIntoCart,
                          ),
                    )
                        : Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        child: Center(
                            child: Text(
                              'No menu found',
                              style:
                              TextStyle(fontWeight: FontWeight.w500),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool showProgress = false;
  List<CategoryData> catList = List();
  bool isMenuEmpty = false;

  Future<String> getCategories(String post) async {
    print('API calling waiting for response...');
    print('URL: ' + post);
    var response = await http.get(post, headers: {"token": token});
    print('response: ${response.body}');
    if (mounted) {
      setState(() {
        dynamic data = json.decode(response.body)['response']['categoryData'];

        print('data: $data');
//        dynamic trending = data['trending'];

        if (response.statusCode == 200 && data != null) {
//          isFail = false;
          showProgress = false;

          catList = (data as List)
              .map((data) => new CategoryData.fromJson(data))
              .toList();

          print('category: ${catList[0].name}');
          if (catList.length > 0) {
            selectedCategory = catList[0].name;
            selectedCategoryId = catList[0].id;
            getMenus(
                '$BASEURL/all_menu.php?branch_id=$selectedBranchId&category_id=$selectedCategoryId',
                true);
          } else {
            getMenus('$BASEURL/all_menu.php', false);
          }
        } else {
//          isFail = true;
        }
      });
    }

    return "Success!";
  }

  List<Menu> menuList = List();
  List<Menu> allMenuList = List();

//  List<Menu> showAllMenuList = List();

  Future<String> getMenus(String post, bool isCat) async {
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

          if (!isCat) allMenuList.addAll(menuList);
        } else {
          isMenuEmpty = true;
        }
      });
    }

    return "Success!";
  }

//  Future<String> getMenusForShowAll(String post, bool isCat) async {
//    print('API calling waiting for response...');
//    print('URL: ' + post);
//    var response = await http.get(post);
//    print('response: $response');
//    if (mounted) {
//      setState(() {
//        dynamic data = json.decode(response.body)['menu'];
//        dynamic success = json.decode(response.body)['success'];
//
//        if (success == 1 && response.statusCode == 200 && data != null) {
//          showProgress = false;
//          isMenuEmpty = false;
//          showAllMenuList =
//              (data as List).map((data) => new Menu.fromJson(data)).toList();
//        } else {
//          isMenuEmpty = true;
//        }
//      });
//    }
//
//    return "Success!";
//  }

  List<Branch> branchList = List();
  bool isBranchAPILoading = false;
  bool isBranchEmpty;

  Future<String> getBranches(String post) async {
    print('BRance api called...');
    print('Branch API URL: ' + post);
    var response = await http.get(post, headers: {"token": token});
    print('response: $response');
    if (mounted) {
      setState(() {
        dynamic data = json.decode(response.body)['response']['branchData'];

        if (response.statusCode == 200 && data != null) {
//          isFail = false;
          showProgress = false;
          isBranchAPILoading = false;
          branchList =
              (data as List).map((data) => new Branch.fromJson(data)).toList();

          saveInPreference(BRANCH_ID, branchList[0].id);
          selectedBranch = branchList[0].branch_name;

          if (selectedBranch.length == 0) {
            isBranchEmpty = true;
          }
        } else {
          isBranchAPILoading = false;
//          isFail = true;
        }
      });
    }

    return "Success!";
  }

//  Future<String> addToCart(String post) async {
//    print('API calling waiting for response...');
//    print('URL: ' + post);
//    var response = await http.get(post);
//    print('response: $response');
//    if (mounted) {
//      setState(() {
//        dynamic data = json.decode(response.body)['response']['branchData'];
//
//        if (response.statusCode == 200 && data != null) {
////          isFail = false;
//          showProgress = false;
//
//          branchList =
//              (data as List).map((data) => new Branch.fromJson(data)).toList();
//        } else {
////          isFail = true;
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
    return isFail == true
        ? Center(
        child: Text(
          'No item  Found',
          style: TextStyle(fontSize: 25.0),
        ))
        : ListView.builder(
      itemCount: 4,
      padding: EdgeInsets.only(left: 16, right: 16, top: 13),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return ShimmerMenuItem();
      },
    );
  }
}

class ShimmerMenuItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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

class ShimmerListForCat extends StatelessWidget {
  final isFail;

  ShimmerListForCat({this.isFail});

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
      itemCount: 4,
      padding: EdgeInsets.only(left: 16, right: 16, top: 13),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 100,
        height: 10.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Color(0x26000000),
              offset: Offset(0, 2),
              blurRadius: 9,
              spreadRadius: 0,
            ),
          ],
        ),
      ),
    );
  }
}
