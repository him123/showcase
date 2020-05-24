import 'dart:ui';

import 'package:sabon/components/cart.dart';
import 'package:sabon/constant/constant.dart';
import 'package:sabon/localdb/database_util.dart';
import 'package:sabon/model/options.dart';
import 'package:sabon/model/addons.dart';
import 'package:sabon/model/menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'dart:convert';

import '../screens/custome_addon_selection.dart';
import 'free_delivery.dart';

class RestaurantItemOriginal extends StatefulWidget {
  final String imagePath;
  final String name;
  final String id;
  String price;
  final String vegOrNoveg;
  final String special_discount;
  final int is_advance_menu;
  final Menu menu;

//  final Function(String, String, bool) getSelectedProduc;

  RestaurantItemOriginal({
    Key key,
    @required this.imagePath,
    @required this.name,
    @required this.id,
    @required this.price,
    @required this.vegOrNoveg,
    @required this.special_discount,
    @required this.is_advance_menu,
    @required this.menu,
//    @required this.getSelectedProduc,
  }) : super(key: key);

  @override
  _RestaurantItemOriginalState createState() => _RestaurantItemOriginalState();
}

class _RestaurantItemOriginalState extends State<RestaurantItemOriginal> {
  String userId;

//  bool isAddedToCart = false;

//  List<String> types;
  bool isVeg = false;
  int qty = 0;

  @override
  void initState() {
    super.initState();
    isFave();
    getLoginStatus();

//    print('===========this is icons: ${widget.vegOrNoveg}');
  }



  bool isPlusProgress = false;
  bool isAddProgress = false;
  bool isMinusProgress = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  double calDiscount(double price, int per) {
    var discount = price * per / 100;

    return price - discount;
  }

  String token='';

  bool isFav = false;

  isFave() async {
    isFav = await DBProvider.db.checkIsFav(widget.id);
//    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('build called $isFav');
    final cart = Provider.of<Cart>(context, listen: false);
    CartItem cartItem = cart.getItemQty(widget.id);

    if (cartItem != null && cartItem.quantity > 0) {
//      print('**** Qty exist *****');
      qty = cartItem.quantity;
    } else {
//      print('***** Qty doesnt exist ******  $qty');
      qty = 0;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Container(
        padding: EdgeInsets.only(right: 5),
        width: double.infinity,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Color(0x1c000000),
                offset: Offset(0, 2),
                blurRadius: 9,
                spreadRadius: 0),
          ],
        ),
        child: Column(
          children: <Widget>[
            /*PRODUCT IMAGE AND NAME ROW*/ Row(
              children: <Widget>[
                /*PRODUCT IMAGE*/ widget.imagePath != ''
                    ? Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image:
                                        new NetworkImage(widget.imagePath)))),
                      )
                    : SizedBox(
                        width: 10.0,
                      ),
                SizedBox(
                  width: 5.0,
                ),
                /*PRODUCT NAME COLUMN*/ Expanded(
                  /*PRODUCT NAME AND MONEY COLUMN*/
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        widget.name,
                        style: TextStyle(
                          color: kColorBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                        // overflow: TextOverflow.ellipsis,
                      ),
                      /*MONEY*/ Padding(
                        padding: EdgeInsets.only(left: 2.0),
                        child: Row(
                          children: <Widget>[
                            /*MAIN PRICE*/
                            widget.price == '0.00'
                                ? SizedBox()
                                : Row(
                                    children: <Widget>[
                                      Text(
                                        '£',
                                        style: widget.special_discount == '0'
                                            ? TextStyle(
                                                fontWeight: FontWeight.bold)
                                            : TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                      ),
                                      widget.special_discount == '0'
                                          ? Text(
                                              widget.price,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            )
                                          : Text(
                                              widget.price,
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.red,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                    ],
                                  ),
                            /*DISCOUNT PRICE*/
                            SizedBox(
                              width: 10.0,
                            ),
                            widget.special_discount == '0'
                                ? Text('')
                                : Row(
                                    children: <Widget>[
                                      Text(
                                        '£',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${calDiscount(double.parse(widget.price), int.parse(widget.special_discount)).toString()}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      /*FOOD ICONS*/ Padding(
                        padding: EdgeInsets.only(left: 2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              children: getRowOFIcons(widget.vegOrNoveg),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                /*HEART ICON*/ Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: InkWell(
                    onTap: () {
                      var menu = Menu();
                      menu = widget.menu;
                      print('isFav $isFav');

                      setState(() {
                        if (isFav) {
                          print('INSIDE IF');
                          isFav = false;
                          DBProvider.db.deleteFavorite(widget.id);
                        } else {
                          print('INSIDE ELSE');
                          isFav = true;
                          DBProvider.db.insertFavorite(menu);
                        }
                      });
                    },
                    child: isFav
                        ? Image.asset(
                            'assets/images/selected_heart.png',
                            height: 20.0,
                          )
                        : Image.asset('assets/images/heart.png', height: 20.0),
                  ),
                ),
              ],
            ),
            /*CART*/ Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Spacer(),
                  //CART
                  Column(
                    children: <Widget>[
                      Container(
                        width: 100.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            border: Border.all(
                                color: qty == 0 ? Colors.black12 : Colors.black,
                                width: 2.0)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            /*MINUS*/ isMinusProgress
                                ? Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: SizedBox(
                                      width: 15.0,
                                      height: 15.0,
                                      child: CircularProgressIndicator(
                                        backgroundColor: kColorPrimary,
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (qty > 0) {
                                          isMinusProgress = true;
                                          qty -= 1;
//                                        isAddedToCart = false;
//                                        widget.getSelectedProduc(widget.id,
//                                            widget.name, isAddedToCart);

//                                            cart.removeItem(widget.id, qty);

                                          if (widget.is_advance_menu == 1) {
                                            updateCart(
                                                widget.id,
                                                qty.toString(),
                                                false,
                                                cart,
                                                true);
                                          } else {
                                            updateCart(
                                                widget.id,
                                                qty.toString(),
                                                false,
                                                cart,
                                                false);
                                          }
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 8.0, left: 8.0),
                                      child: qty != 0
                                          ? Icon(
                                              FontAwesomeIcons.minus,
                                              size: 15.0,
                                              color: kColorPrimary,
                                            )
                                          : Text(''),
                                    ),
                                  ),
                            /*ADD*/ Expanded(
                              child: Container(
                                color: qty == 0 ? Colors.white : Colors.black12,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: isAddProgress
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: SizedBox(
                                            width: 15.0,
                                            height: 15.0,
                                            child: CircularProgressIndicator(
                                              backgroundColor: kColorPrimary,
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (qty == 0) {
                                                if (widget.is_advance_menu ==
                                                    1) {
//                                                    print(
//                                                        '======show advance menu--');
//                                                  _settingModalBottomSheet(
//                                                      context,
//                                                      widget.name,
//                                                      widget.menu,
//                                                      widget.id,
//                                                      double.parse(
//                                                          widget.price),
//                                                      isVeg,
//                                                      cart);

                                                  showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      context: context,
                                                      builder: (BuildContext bc) {
                                                        return Container(
                                                            height: MediaQuery.of(context).size.height - 100.0,
                                                            child: CustomeAddonSelection(
                                                              userId: userId,
                                                              menu: widget.menu,
                                                              itemName:
                                                              widget.name,
                                                              isVeg: isVeg,
                                                              id: widget.id,
                                                              special_discount: widget.special_discount,
                                                              price: widget.price,
                                                              cart: cart,

                                                            ));
                                                      });

//                                                  Navigator.push(
//                                                    context,
//                                                    MaterialPageRoute(
//                                                        builder: (context) =>
//                                                            CustomeAddonSelection(
//                                                              userId: userId,
//                                                              menu: widget.menu,
//                                                              itemName:
//                                                                  widget.name,
//                                                              isVeg: isVeg,
//                                                              id: widget.id,
//                                                              special_discount: widget.special_discount,
//                                                              price: widget.price,
//                                                              cart: cart,
//
//                                                            )),
//                                                  );
                                                } else {
                                                  isAddProgress = true;
//                                                    print(
//                                                        '=======no advance menu');
                                                  qty += 1;
//                                                    cart.addItem(
//                                                      widget.id,
//                                                      double.parse(
//                                                          widget.price),
//                                                      widget.name,
//                                                      isVeg,
//                                                      false,
//                                                    );

                                                  addToCart(
                                                      widget.id,
                                                      '',
                                                      qty.toString(),
                                                      cart,
                                                      false);
                                                }
                                              }
                                            });
                                          },
                                          child: Text(
                                            qty == 0 ? 'ADD' : qty.toString(),
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            /*PLUS*/ isPlusProgress
                                ? Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: SizedBox(
                                      width: 15.0,
                                      height: 15.0,
                                      child: CircularProgressIndicator(
                                        backgroundColor: kColorPrimary,
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      setState(() {
//                                          _settingModalBottomSheet(context,
//                                              widget.name, widget.menu);
//
                                        if (widget.is_advance_menu == 1) {
                                          if (cart
                                              .isItemExistIncart(widget.id)) {
                                            //Item is already exist ipdate the qty
                                            isPlusProgress = true;
                                            qty += 1;
//                                                    cart.addItem(
//                                                      widget.id,
//                                                      double.parse(
//                                                          widget.price),
//                                                      widget.name,
//                                                      isVeg,
//                                                      false,
//                                                    );

                                            updateCart(
                                                widget.id,
                                                qty.toString(),
                                                true,
                                                cart,
                                                true);
                                          } else {
//                                            _settingModalBottomSheet(
//                                                context,
//                                                widget.name,
//                                                widget.menu,
//                                                widget.id,
//                                                double.parse(widget.price),
//                                                isVeg,
//                                                cart);

                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (BuildContext bc) {
                                                  return Container(
                                                      height: MediaQuery.of(context).size.height - 100.0,
                                                      child: CustomeAddonSelection(
                                                        userId: userId,
                                                        menu: widget.menu,
                                                        itemName:
                                                        widget.name,
                                                        isVeg: isVeg,
                                                        id: widget.id,
                                                        special_discount: widget.special_discount,
                                                        price: widget.price,
                                                        cart: cart,

                                                      ));
                                                });
                                          }
                                        } else {
                                          isPlusProgress = true;
//                                            print('=======no advance menu');
                                          qty += 1;

//                                            cart.addItem(
//                                              widget.id,
//                                              double.parse(widget.price),
//                                              widget.name,
//                                              isVeg,
//                                              false,
//                                            );

                                          if (qty == 1) {
                                            addToCart(widget.id, '',
                                                qty.toString(), cart, false);
                                          } else {
                                            updateCart(
                                                widget.id,
                                                qty.toString(),
                                                true,
                                                cart,
                                                false);
                                          }
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Icon(FontAwesomeIcons.plus,
                                          size: 15.0, color: kColorPrimary),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      widget.is_advance_menu == 1
                          ? Text(
                              'customizable',
                              style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w400,
                                  color: kColorPrimary),
                            )
                          : SizedBox(
                              height: 2.0,
                            )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Options> optionsList = List();
  List<InnerOptions> menueList = List();
  List<dynamic> tempList = List();

  void _settingModalBottomSheet(context, String title, Menu menu, String id,
      double price, bool isVeg, Cart cart) {
    dynamic advanceMenu = menu.advance_menu;

    String childOptionsName = '';
    List<String> optionsNameList = [];
    List<String> optionsNamePriceList = [];
    List<String> childOptionsNameList = [];
    List<String> childOptionsPriceList = [];
    List<InnerOptions> innerOptionsList = [];
    String topName = '', sizeOptionAllow = '';

    List<String> menueNameList = [];
    List<String> childMenuNameList = [];
    List<String> childMenuPriceList = [];

    String selectedChildMenu = '';
    List<Addons> addonsCartList = [];
    double totAmount = price;

    String radioSelected = '';
//    var sizedNamePriceList;
    int quantity = 1;
    String previouslySelectedWhenOnlySizes = '';

    List<String> checkedAddonsForSize = [];
    String sizeAddonoptionallow = '0';
    String sizeAddonminselection = '';

    List<String> finalCardItems = [];

    try {
      //SIZE
      if (advanceMenu != false && advanceMenu['Size'] != '') {
        topName = advanceMenu['Size']['size_options'][0]['topname'];
        sizeOptionAllow = advanceMenu['Size']['size_options'][0]['optionallow'];
//        print('advance menu ${advanceMenu['Size']['size_options'][0]}');
        dynamic data = advanceMenu['Size']['size_options'][0]['options'];
        optionsList =
            (data as List).map((data) => new Options.fromJson(data)).toList();

        for (int i = 0; i < optionsList.length; i++) {
          optionsNameList.add(optionsList[i].name);
          optionsNamePriceList.add(optionsList[i].price);
//          sizedNamePriceList = {optionsList[i].name, optionsList[i].price};
        }

        print('optionsNameList ff ${optionsNameList.length}');
      }
    } catch (_) {
      print("throwing new error SIZE");
    }

    try {
      //Menue
      if (advanceMenu != false && advanceMenu['Menue'] != '') {
//      print('menu e ${advanceMenu['menu_options']['3']['topname']}');
        dynamic Menue = advanceMenu['Menue']['menu_options'];

//        if (Menue.toString() == '[]') {
//        } else {
//          Menue.forEach((final String key, final value) {
//            tempList.add(value);
//          });
//        }

        menueList = (Menue as List)
            .map((tempList) => new InnerOptions.fromJson(tempList))
            .toList();

        radioSelected = menueList[0].topname;

        print('@@@@@ menu list: ${menueList.length}');

        for (int i = 0; i < menueList.length; i++) {
          menueNameList.add(menueList[i].topname);
        }
      }
    } catch (_) {
      print("throwing new error MENU");
    }
    print('Size checkbox list  ${optionsNameList.length}');
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState
                  /*You can rename this!*/) {
            return Container(
              color: kColorBottomSheetBG,
              height: MediaQuery.of(context).size.height - 200,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 5.0,
                          ),
                          /*SELECTED PRODUCT*/
                          /*PRODUCT NAME*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              /*VEG NON VEG ICON*/ Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    isVeg == true
                                        ? Image.asset(
                                            'assets/icons/veg.png',
                                            height: 20.0,
                                            width: 20.0,
                                          )
                                        : Image.asset(
                                            'assets/icons/nonveg.png',
                                            height: 20.0,
                                            width: 20.0,
                                          ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.name,
                                        style: TextStyle(
                                          color: kColorBlue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                flex: 3,
                              ),
                              /*CART*/ Flexible(
                                child: Container(
                                  width: 80.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      border: Border.all(
                                          color: quantity == 0
                                              ? Colors.black12
                                              : Colors.black,
                                          width: 2.0)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      /*MINUS PRESS*/
                                      isMinusProgress
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 6.0, right: 6.0),
                                              child: SizedBox(
                                                width: 13.0,
                                                height: 13.0,
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor:
                                                      kColorPrimary,
                                                ),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                setState(() {
//                                                isMinusProgress = true;
                                                  if (quantity > 0) {
//                                              print(
//                                                  '=======PLUS totamount: $totAmount');
//                                              print(
//                                                  '=======PLUS price: $price');
                                                    quantity -= 1;
                                                    totAmount -= price;
//                                              print('in minus : $quantity');

                                                    if (quantity == 0) {
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 6.0, left: 6.0),
                                                child: quantity != 0
                                                    ? Icon(
                                                        FontAwesomeIcons.minus,
                                                        size: 13.0,
                                                        color: kColorPrimary,
                                                      )
                                                    : Text(''),
                                              ),
                                            ),
                                      Expanded(
                                        child: Container(
                                          color: quantity == 0
                                              ? Colors.white
                                              : Colors.black12,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Text(
                                              quantity == 0
                                                  ? 'ADD'
                                                  : quantity.toString(),
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                      /*PLUS PRESS*/
                                      isPlusProgress
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 6.0, right: 6.0),
                                              child: SizedBox(
                                                width: 13.0,
                                                height: 13.0,
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor:
                                                      kColorPrimary,
                                                ),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                setState(() {
//                                                isPlusProgress = true;
//                                            print(
//                                                '=======PLUS totamount: $totAmount');
//                                            print('=======PLUS price: $price');
                                                  quantity += 1;
//                                            double totlaItemPrice =
//                                                price * quantity;
                                                  totAmount += price;
//                                            totAmount = totlaItemPrice;
//                                            print(
//                                                'increased price $totlaItemPrice');
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 6.0, right: 6.0),
                                                child: Icon(
                                                    FontAwesomeIcons.plus,
                                                    size: 13.0,
                                                    color: kColorPrimary),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                flex: 1,
                              ),
                            ],
                          ),
                          /*MONEY*/
                          widget.price == '0.00'
                              ? SizedBox()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 25.0,
                                    ),
                                    Text(
                                      '£',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.price,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: optionsNameList.length != 0
                                  ? Text(
                                      topName +
                                          ' (Select any $sizeOptionAllow)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800))
                                  : SizedBox()),
                          /*OUTER SIZE CHECKBOXES*/
                          optionsNameList.length != 0
                              ? CheckboxGroup(
                                  activeColor: kColorPrimary,
                                  labels: optionsNameList,
                                  itemBuilder: (Checkbox cb, Text txt, int i) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[cb, txt],
                                        ),
                                        Text('£ ${optionsNamePriceList[i]}')
                                      ],
                                    );
                                  },
                                  onChange: (s, d, g) {
                                    print('$s : $d : $g');

                                    print(
                                        '**** similir price ${optionsNamePriceList[g]}');
                                    String selectedPrice =
                                        optionsNamePriceList[g];
                                    optionsNameList.clear();
                                    optionsNamePriceList.clear();

                                    setState(() {
                                      optionsNameList.add(d);
                                      optionsNamePriceList.add(selectedPrice);
                                    });

                                    childOptionsNameList.clear();
                                    childOptionsPriceList.clear();

                                    try {
                                      dynamic data = advanceMenu['Size']
                                              ['size_options'][0]['options'][g]
                                          ['addonoptions'];

                                      sizeAddonoptionallow = advanceMenu['Size']
                                              ['size_options'][0]['options'][g]
                                          ['addonoptions'][0]['optionallow'];

                                      sizeAddonminselection =
                                          advanceMenu['Size']['size_options'][0]
                                                  ['options'][g]['addonoptions']
                                              [0]['minselection'];

                                      print(
                                          '****** sizeOptionAllow $sizeAddonoptionallow');

                                      print(
                                          '****** sizeAddonminselection $sizeAddonminselection');

                                      if (data != null) {
                                        innerOptionsList = (data as List)
                                            .map((data) =>
                                                new InnerOptions.fromJson(data))
                                            .toList();
                                        childOptionsName =
                                            innerOptionsList[0].topname;
                                        for (int i = 0;
                                            i <
                                                innerOptionsList[0]
                                                    .child
                                                    .length;
                                            i++) {
                                          childOptionsNameList.add(
                                              innerOptionsList[0]
                                                  .child[i]
                                                  .name);
                                          childOptionsPriceList.add(
                                              innerOptionsList[0]
                                                  .child[i]
                                                  .price);
                                        }
                                      }
                                    } catch (_) {
                                      print('Exception occured');
                                    }

                                    Addons addOn;
//
                                    setState(() {
                                      if (s) {
                                        totAmount +=
                                            double.parse(selectedPrice);

                                        addOn = Addons();
                                        addOn.prefix = topName;
                                        addOn.price = selectedPrice;
                                        addOn.name = d;
                                        addonsCartList.add(addOn);
                                      } else {
                                        totAmount -=
                                            double.parse(selectedPrice);

                                        addonsCartList.removeWhere(
                                            (item) => item.name == d);
                                      }
                                    });
                                  },
                                )
                              : SizedBox(),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                childOptionsName,
                                style: TextStyle(fontWeight: FontWeight.w800),
                              )),
                          /*SIZE INTERNAL CHECKBOXES*/
                          childOptionsNameList.length == 0
                              ? SizedBox()
                              : CheckboxGroup(
                                  activeColor: kColorPrimary,
                                  labels: childOptionsNameList,
                                  itemBuilder: (Checkbox cb, Text txt, int i) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[cb, txt],
                                        ),
                                        Text('£ ${childOptionsPriceList[i]}')
                                      ],
                                    );
                                  },
                                  onChange: (s, d, g) {
//                                      print('$s : $d : $g');
                                    var addOn;

                                    setState(() {
                                      checkedAddonsForSize.add(d);

                                      print(
                                          'size of checkedAddonsForSize: ${checkedAddonsForSize.length}');
                                      print(
                                          'size of sizeAddonoptionallow: $sizeAddonoptionallow');
                                      if (checkedAddonsForSize.length <
                                          int.parse(sizeAddonoptionallow)) {
                                      } else {
                                        childOptionsNameList.clear();
                                        childOptionsNameList
                                            .addAll(checkedAddonsForSize);
                                      }
                                    });

                                    setState(() {
                                      if (s) {
                                        totAmount += double.parse(
                                            childOptionsPriceList[
                                                childOptionsNameList
                                                    .indexOf(d)]);

                                        addOn = Addons();
                                        addOn.prefix = childOptionsName;
                                        addOn.price = childOptionsPriceList[
                                            childOptionsNameList.indexOf(d)];
                                        addOn.name = d;
                                        addonsCartList.add(addOn);
                                      } else {
                                        totAmount -= double.parse(
                                            childOptionsPriceList[
                                                childOptionsNameList
                                                    .indexOf(d)]);

                                        addonsCartList.removeWhere(
                                            (item) => item.name == d);
                                      }
                                    });
                                  },
                                ),
//                          /*MENU LABEL*/
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  menueNameList.length != 0 ? 'Menu' : '',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w800))),
//                          /*MENU RADIO*/
                          menueNameList.length != 0
                              ? RadioButtonGroup(
                                  activeColor: Colors.deepPurpleAccent,
                                  labelStyle: TextStyle(fontSize: 12.0),
                                  labels: menueNameList,
                                  picked: radioSelected,
                                  padding: EdgeInsets.all(1.0),
                                  itemBuilder: (Radio rb, Text txt, int i) {
                                    return Row(
                                      children: <Widget>[rb, txt],
                                    );
                                  },
                                  onSelected: (String selected) {
                                    radioSelected = selected;
                                    childMenuNameList.clear();
                                    childMenuPriceList.clear();
                                    selectedChildMenu = selected;
//                                      print(
//                                          'selected menu lenght ${menueList[menueNameList.indexOf(selected)].child.length}');
                                    setState(() {
                                      for (int i = 0;
                                          i <
                                              menueList[menueNameList
                                                      .indexOf(selected)]
                                                  .child
                                                  .length;
                                          i++) {
//                                          print(
//                                              'child menu added : ${menueList[menueNameList.indexOf(selected)].child[i].name}');
                                        childMenuNameList.add(menueList[
                                                menueNameList.indexOf(selected)]
                                            .child[i]
                                            .name);
                                        childMenuPriceList.add(menueList[
                                                menueNameList.indexOf(selected)]
                                            .child[i]
                                            .price);
                                      }
                                    });
                                  },
                                )
                              : SizedBox(),
//                          /*SELECTED MENU RADIO*/
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(selectedChildMenu,
                                  style:
                                      TextStyle(fontWeight: FontWeight.w800))),
                          /*MENU CHECKBOX*/
                          childMenuNameList.length == 0
                              ? SizedBox()
                              : CheckboxGroup(
                                  activeColor: kColorPrimary,
                                  labels: childMenuNameList,
                                  itemBuilder: (Checkbox cb, Text txt, int i) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[cb, txt],
                                        ),
                                        Text('£ ${childMenuPriceList[i]}')
                                      ],
                                    );
                                  },
                                  onChange: (s, d, g) {
//                                      print('$s : $d : $g');

                                    setState(() {
                                      if (s) {
//                                          print(
//                                              'Execute 1 ${childMenuPriceList[childMenuNameList.indexOf(d)]}');

                                        totAmount += double.parse(
                                            childMenuPriceList[
                                                childMenuNameList.indexOf(d)]);

//                                          print('Execute 2');

                                        var addOn = Addons();
                                        addOn.prefix = selectedChildMenu;
                                        addOn.price = childMenuPriceList[
                                            childMenuNameList.indexOf(d)];
                                        addOn.name = d;
//                                          print('Execute 3');
                                        addonsCartList.add(addOn);
//                                          print('Execute 4');
                                      } else {
                                        totAmount -= double.parse(
                                            childMenuPriceList[
                                                childMenuNameList.indexOf(d)]);

                                        addonsCartList.removeWhere(
                                            (item) => item.name == d);
                                      }
                                    });
                                  },
                                  onSelected: (List<String> checked) =>
                                      print(checked.toString())),
                          SizedBox(
                            height: 60.0,
                          )
                        ],
                      ),
                    ),
                  ),
                  /*ADD BUTTON*/ Positioned(
                    bottom: 5.0,
                    child: FlatButton(
                      onPressed: () {
                        print('check cart list: $addonsCartList');
                        if (addonsCartList.length != 0) {
                          cart.addItemWithAddon(
                              widget.id,
                              totAmount,
                              widget.name,
                              isVeg,
                              true,
                              addonsCartList,
                              quantity);

                          print(
                              'this item going to go to the server: ${widget.id}'
                              ' $totAmount ${widget.name} '
                              '');

                          List<String> finalListForaddon = [];
                          for (int i = 0; i < addonsCartList.length; i++) {
//                            print('addons ${addonsCartList[i].name}');

                            finalListForaddon.add(
                                '${addonsCartList[i].prefix}@@${addonsCartList[i].name}@@${addonsCartList[i].price}');
                          }

                          print(
                              'check final cart list ${finalListForaddon.join(', ')}');

                          addToCart(widget.id, finalListForaddon.join(', '),
                              quantity.toString(), cart, true);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: addonsCartList.length == 0
                                ? Colors.black26
                                : kColorPrimary,
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0))),
                        height: 40.0,
                        width: MediaQuery.of(context).size.width - 50,
                        child: Center(
                            child: Text(
                          'Add(£ $totAmount)',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 17.0),
                        )),
                      ),
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
//    userId = '';
    try {
      userId = prefs.getString('id');
    } catch (_) {}
    print('login id==== $userId');
  }

  Future<String> addToCart(String itemId, String addonStr, String qty,
      Cart cart, bool isAdvance) async {
    String completeUrl = '$BASEURL/'
        'add_to_cart.php?user_id=${userId.toString()}&item_id=$itemId&qty=$qty&advance_menu=$addonStr';

    print('========= Add to cart called ===========');
    print(completeUrl);

    var response = await http.get(completeUrl, headers: {"token": token});

    String newPrice = widget.price;
    if (json.decode(response.body)['response']['success'] == 1) {
      if (widget.special_discount != '0') {
        newPrice = calDiscount(
                double.parse(widget.price), int.parse(widget.special_discount))
            .toString();
      }
      if (isAdvance) {
//        cart.addItemWithAddon(widget.id, totAmount, widget.name, isVeg, true,
//            addonsCartList, quantity);
      } else {
        cart.addItem(
          widget.id,
          double.parse(newPrice),
          widget.name,
          isVeg,
          false,
        );
      }
    } else {
      Toast.show('Item not added', context);
    }
    print(response.body);
    setState(() {
      isPlusProgress = false;
      isMinusProgress = false;
      isAddProgress = false;
    });
    return "Success!";
  }

  Future<String> updateCart(
      String itemId, String qty, bool isPlus, Cart cart, bool isAdvance) async {
    String completeUrl = '$BASEURL/'
        'edit_cart.php?user_id=${userId.toString()}&item_id=$itemId&qty=$qty';

    print('========= Add to cart called ===========');
    print(completeUrl);
    String newPrice = widget.price;
    
    var response = await http.get(completeUrl, headers: {"token": token});

    if (json.decode(response.body)['response']['success'] == 1) {
      if (widget.special_discount != '0') {
        newPrice = calDiscount(
                double.parse(widget.price), int.parse(widget.special_discount))
            .toString();
        print(
            '************ inside price ******************* ${widget.price} with the discount ${widget.special_discount}');
      }
      if (isPlus) {
        //Increase
        if (isAdvance) {
          cart.updateItemWithAddon(widget.id, int.parse(qty));
        } else {
          cart.addItem(
            itemId,
            double.parse(newPrice),
            widget.name,
            isVeg,
            false,
          );
        }
      } else {
        //Decrease
        cart.removeItem(widget.id, int.parse(qty));
      }
    } else {
      Toast.show('Item not added', context);
    }
    print(response.body);
    setState(() {
      isPlusProgress = false;
      isMinusProgress = false;
    });

    return "Success!";
  }

  List<Widget> getRowOFIcons(String vegnonveg) {
    double height = 15.0;
    double weight = 15.0;
//    print('check vegnonveg : $vegnonveg');
    List<Widget> icons = [];
    List<String> types = vegnonveg.split(",").toList();

//    print('check the type: ${types[0]}');

    for (int i = 0; i < types.length; i++) {
//      print('check icon name: ${types[i]}');

      Image icon;
      switch (types[i]) {
        case 'Popular':
          icon = Image.asset(
            'assets/icons/popular.png',
            height: height,
            width: weight,
          );
          break;
        case 'Mild':
          icon = Image.asset(
            'assets/icons/mild.png',
            height: height,
            width: weight,
          );
          break;
        case 'Contain Nuts':
          icon = Image.asset(
            'assets/icons/nut.png',
            height: height,
            width: weight,
          );
          break;
        case 'Medium Hot':
          icon = Image.asset(
            'assets/icons/1chilli.png',
            height: height,
            width: weight,
          );
          break;
        case 'Fairly Hot':
          icon = Image.asset(
            'assets/icons/2chilli.png',
            height: height,
            width: weight,
          );
          break;
        case 'Very Hot':
          icon = Image.asset(
            'assets/icons/3chilli.png',
            height: height,
            width: weight,
          );
          break;
        case 'Extremly Hot':
          icon = Image.asset(
            'assets/icons/4chilli.png',
            height: height,
            width: weight,
          );
          break;
        case 'Gluten':
          icon = Image.asset(
            'assets/icons/Gluten.png',
            height: height,
            width: weight,
          );
          break;
        case 'Eggs':
          icon = Image.asset(
            'assets/icons/Eggs.png',
            height: height,
            width: weight,
          );
          break;
        case 'Octopus':
          icon = Image.asset(
            'assets/icons/Octopus.png',
            height: height,
            width: weight,
          );
          break;
        case 'Peanuts':
          icon = Image.asset(
            'assets/icons/Peanuts.png',
            height: height,
            width: weight,
          );
          break;
        case 'Fish':
          icon = Image.asset(
            'assets/icons/Fish.png',
            height: height,
            width: weight,
          );
          break;
        case 'Oyster':
          icon = Image.asset(
            'assets/icons/Oyster.png',
            height: height,
            width: weight,
          );
          break;
        case 'Nuts':
          icon = Image.asset(
            'assets/icons/Nuts.png',
            height: height,
            width: weight,
          );
          break;
        case 'Crab':
          icon = Image.asset(
            'assets/icons/Crab.png',
            height: height,
            width: weight,
          );
          break;
        case 'Scallop':
          icon = Image.asset(
            'assets/icons/Scallop.png',
            height: height,
            width: weight,
          );
          break;
        case 'Milk':
          icon = Image.asset(
            'assets/icons/Milk.png',
            height: height,
            width: weight,
          );
          break;
        case 'Shrimps':
          icon = Image.asset(
            'assets/icons/Shrimps.png',
            height: height,
            width: weight,
          );
          break;
        case 'Sesame':
          icon = Image.asset(
            'assets/icons/Sesame.png',
            height: height,
            width: weight,
          );
          break;
        case 'Soya':
          icon = Image.asset(
            'assets/icons/Soya.png',
            height: height,
            width: weight,
          );
          break;
        case 'Squid':
          icon = Image.asset(
            'assets/icons/Squid.png',
            height: height,
            width: weight,
          );
          break;
        case 'Celery':
          icon = Image.asset(
            'assets/icons/Celery.png',
            height: height,
            width: weight,
          );
          break;
        case 'Mustard':
          icon = Image.asset(
            'assets/icons/Mustard.png',
            height: height,
            width: weight,
          );
          break;
        case 'Mussels':
          icon = Image.asset(
            'assets/icons/Mussels.png',
            height: height,
            width: weight,
          );
          break;
        case 'Sulphite':
          icon = Image.asset(
            'assets/icons/Sulphite.png',
            height: height,
            width: weight,
          );
          break;
        case 'Vegetarian':
          icon = Image.asset(
            'assets/icons/veg.png',
            height: height,
            width: weight,
          );
          isVeg = true;
          break;

        case 'nonVegetarian':
          icon = Image.asset(
            'assets/icons/nonveg.png',
            height: height,
            width: weight,
          );
          break;
        default:
//          print('defualt ${types[i]}');
          icon = Image.asset(
            '',
            height: 0.0,
            width: 0.0,
          );
      }

      icons.add(icon);
      icons.add(SizedBox(
        width: 2.0,
      ));
    }
    return icons;
  }
}
