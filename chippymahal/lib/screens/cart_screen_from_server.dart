import 'package:sabon/components/cart.dart';
import 'package:sabon/constant/constant.dart';
import 'package:sabon/localdb/database_util.dart';
import 'package:sabon/model/address.dart';
import 'package:sabon/model/server_cart_item.dart';
import 'package:sabon/screens/address_book.dart';
import 'package:sabon/screens/checkout.dart';
import 'package:sabon/screens/login.dart';
import 'package:sabon/widgets/cart_item.dart';
import 'package:sabon/widgets/cart_item_from_server.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:shimmer/shimmer.dart';

class CartScreenFromServer extends StatefulWidget {
  static String id = 'CartScreen';

  @override
  _CartScreenFromServerState createState() => _CartScreenFromServerState();
}

class _CartScreenFromServerState extends State<CartScreenFromServer> {
  // Declare this variable
  int selectedRadio1;
  int selectedRadio2;
  int selectedRadioPayment;
  String cookInstuctions = 'Add coocking instruction';
  double saleTax = 0.0;
  double grandTot = 0.0;
  String login = '';
  String userId = '';

  // Changes the selected value on 'onChanged' click on each radio button
  setSelectedRadio1(int val) {
    setState(() {
      selectedRadio1 = val;
    });
  }

  setSelectedRadioPay(int val) {
    setState(() {
      selectedRadioPayment = val;
    });
  }

  List<String> orderType = ['Collection', 'Delivery'];
  String selectedOrderType = 'Collection';

  setSelectedRadio2(int val) {
    setState(() {
      selectedRadio2 = val;
    });
  }

  String token='';
  getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    login = prefs.getString('login');
    userId = prefs.getString('id');
    token = prefs.getString('token');

    getCartItems(
        '$BASEURL/get_cart.php?user_id=$userId');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    saleTax = cart.totalAmount * 20 / 100;
    grandTot = cart.totalAmount + 11.0 + saleTax;

    return Scaffold(
      bottomNavigationBar: Container(
        color: kColorPrimary,
        height: 80.0,
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            if (login == '1' || login == '') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => LoginScreen()));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => Checkout()));
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              /*PAY TYPE*/ Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                        child: Radio(
                          value: 1,
                          groupValue: selectedRadioPayment,
                          activeColor: Colors.white,
                          onChanged: (val) {
                            print("Radio $val");
                            setSelectedRadioPay(val);
                          },
                        ),
                      ),
                      Text(
                        'Cash Payment',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                        child: Radio(
                          value: 2,
                          groupValue: selectedRadioPayment,
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          activeColor: Colors.white,
                          onChanged: (val) {
                            print("Radio $val");
                            setSelectedRadioPay(val);
                          },
                        ),
                      ),
                      Text(
                        'Pay by Card',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
              /*TOTAL*/ Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('CHECKOUT',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 19.0)),
                        Text(
                          '(£ $grandTot)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 21.0),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),

      body: serverCartItemList.length == 0
          ? ShimmerList(isFail: isCartEmpty,)
          : SingleChildScrollView(
              child: Container(
                color: kColorBottomSheetBG,
                child: Column(
                  children: <Widget>[
                    /*ITEMS*/
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: serverCartItemList.length,
                      itemBuilder: (ctx, i) => CartListItemFromServer(
                          userId,
                          serverCartItemList[i].id,
                          serverCartItemList[i].item_id,
                          double.parse(serverCartItemList[i].amount),
                          double.parse(serverCartItemList[i].item_unit_price),
                          int.parse(serverCartItemList[i].quantity),
                          serverCartItemList[i].order_items,
                          serverCartItemList[i].veg_type,
                          serverCartItemList[i].advance_menu_name,
                          serverCartItemList[i].size_menu_name),
                    ),
                   /*ADD COOKING INSTRUCTION*/ FlatButton(
                      onPressed: () {
                        _settingModalBottomSheet(context);
                      },
                      child: Text(
                        cookInstuctions,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),

                    /*PRICE CALCULATION*/ Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Sub total: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '£ ${cart.totalAmount}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Service Charge: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '£ 11.00',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Sales Tax: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '£ $saleTax',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Grand Total',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17.0),
                                  ),
                                  Text(
                                    '£ $grandTot',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17.0),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    /*APPLY COUPON*/
                    Container(
                      color: Colors.white70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            width: 200.0,
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'Enter coupon code'),
                            ),
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                side: BorderSide(color: Colors.red)),
                            onPressed: () {},
                            focusColor: kColorPrimary,
                            color: kColorPrimary,
                            splashColor: kColorPrimary,
                            child: Text(
                              'Apply',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /*PICKUP TIME*/
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            height: 30.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio(
                                    value: 1,
                                    groupValue: selectedRadio1,
                                    activeColor: Colors.green,
                                    onChanged: (val) {
                                      print("Radio $val");
                                      setSelectedRadio1(val);
                                    },
                                  ),
                                  Text('Pickup (15min)'),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Radio(
                                    value: 2,
                                    groupValue: selectedRadio2,
                                    activeColor: Colors.blue,
                                    onChanged: (val) {
                                      print("Radio $val");
                                      setSelectedRadio2(val);
                                    },
                                  ),
                                  Text('ASAP'),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio(
                                    value: 3,
                                    groupValue: selectedRadio1,
                                    activeColor: Colors.green,
                                    onChanged: (val) {
                                      print("Radio $val");
                                      setSelectedRadio1(val);
                                    },
                                  ),
                                  Text('Delivery (45min)'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Radio(
                                    value: 4,
                                    groupValue: selectedRadio2,
                                    activeColor: Colors.blue,
                                    onChanged: (val) {
                                      print("Radio $val");
                                      setSelectedRadio2(val);
                                    },
                                  ),
                                  Text('Specific Time'),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                        ],
                      ),
                    ),

                    /*ORDER TYPE*/
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Order Type:',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            new Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2.0)),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () {
                                    Widget setupAlertDialoadContainer() {
                                      return Container(
                                        height: 100.0,
                                        // Change as per your requirement
                                        width: 200.0,
                                        // Change as per your requirement
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: orderType.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              onTap: () {
                                                print(
                                                    'selected ${orderType[index]}');
                                                setState(() {
                                                  selectedOrderType =
                                                      orderType[index];

                                                  String message = '';
                                                  if (selectedOrderType ==
                                                      'Delivery') {
                                                    message =
                                                        'Please allow us 45 minutes to prepare your meal and delivery';
                                                  } else {
                                                    message =
                                                        'Please allow us 15 minutes to prepare your meal.';
                                                  }
//                                          Navigator.pop(context);
                                                  showAlert(context, message);
                                                });
                                              },
                                              child: ListTile(
                                                selected: true,
                                                title: Text(orderType[index]),
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
                                            title: Text('Order Type'),
                                            content:
                                                setupAlertDialoadContainer(),
                                          );
                                        });
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Text(selectedOrderType),
                                      Image.asset(
                                        'assets/images/arrow_down.png',
                                        height: 20.0,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    /*ADDRESS*/
                    selectedOrderType == 'Delivery'
                        ? Container(
                            color: Color(0xFFf8bbd0),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FutureBuilder(
                                    future: DBProvider.db.getSelectedAddress(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<Address> snapshot) {
                                      if (snapshot.hasData == null ||
                                          snapshot.hasData) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new AddressBook()),
                                            ).then((value) {
                                              setState(() {
                                                print('===== Check');
                                              });
                                            });
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    'DELIVERY AT',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13.0),
                                                  ),
                                                  Icon(
                                                    FontAwesomeIcons.pencilAlt,
                                                    size: 18.0,
                                                    color: Colors.black,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Text(snapshot.data.address,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16.0)),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new AddressBook()),
                                            ).then((value) {
                                              setState(() {
                                                print('===== Check');
//                                    color =
//                                    color == Colors.white ? Colors.grey : Colors
//                                        .white;
                                              });
                                            });
                                          },
                                          child: Card(
                                            color: kColorBGPink,
                                            elevation: 1.0,
                                            child: Container(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    top: 18.0,
                                                    bottom: 18.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      'Please add/select Address',
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_right,
                                                      color: kColorBlue,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    })),
                          )
                        : Text(''),
                  ],
                ),
              ),
            ),
    );
  }

  void showAlert(BuildContext context, String msg) {
    Alert(
      context: context,
      type: AlertType.success,
      title: msg,
//      desc: msg,

      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2);
          },
          width: 120,
          color: Colors.lightBlue,
          radius: BorderRadius.circular(5.0),
        )
      ],
    ).show();
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Special cooking instructions',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18.0),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              FontAwesomeIcons.times,
                              size: 19.0,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: TextField(
                      onChanged: (val) {
                        cookInstuctions = val;
                      },
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(7.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          fillColor: Colors.white70),
                    ),
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.red)),
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    focusColor: kColorPrimary,
                    color: kColorPrimary,
                    splashColor: kColorPrimary,
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      'Allergy Advice: If you have an allergy that could harm your health we strongly advise you to contact the restaurant before you place your order. View More',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 12.0),
                    )),
                  ),
                ],
              ),
            ),
          );
        });
  }

  List<ServerCartItem> serverCartItemList = [];
  bool isCartEmpty = false;

  Future<String> getCartItems(String post) async {
    print('API calling waiting for response...');
    print('URL: ' + post);
    var response = await http.get(post, headers: {"token": token});
    print('response: ${response.body}');
    if (mounted) {
      setState(() {
        dynamic data = json.decode(response.body)['response']['cart_item'];

        if (response.statusCode == 200 && data != null) {
//          isFail = false;
//          showProgress = false;
//          isBranchAPILoading = false;
          serverCartItemList = (data as List)
              .map((data) => new ServerCartItem.fromJson(data))
              .toList();

          if (serverCartItemList.length == 0) {
            isCartEmpty = true;
          }
        } else {
//          isBranchAPILoading = false;
//          isFail = true;
        }
      });
    }

    return "Success!";
  }
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
            'Cart is empty',
            style: TextStyle(fontSize: 20.0),
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
    double containerWidth = MediaQuery.of(context).size.width - 80;
    double containerHeight = 15;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
