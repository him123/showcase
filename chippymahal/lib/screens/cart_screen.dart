import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sabon/components/cart.dart';
import 'package:sabon/constant/constant.dart';
import 'package:sabon/model/promo.dart';
import 'package:sabon/model/tip.dart';
import 'package:sabon/screens/bottom_sheet_address_book.dart';
import 'package:sabon/screens/checkout_success_screen.dart';
import 'package:sabon/screens/promocode_list_screen.dart';
import 'package:sabon/screens/webview_screen.dart';
import 'package:sabon/widgets/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:stripe_payment/stripe_payment.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CartScreen extends StatefulWidget {
  static String id = 'CartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Declare this variable
  static int selectedRadio1 = 1;
  static int selectedRadio2;
  static int selectedRadioPayment;
  String cookInstuctions = 'Add coocking instruction';
  double saleTax = 0.0,
      deliveryCharges = 0.0,
      additionalCharges = 0.0,
      subTotal = 0.0,
      tip = 0;

  double grandTot = 0.0;
  static String login = '',
      userId = '',
      selectedAddress = '',
      addressId = '',
      branch_id,
      stripeToken = '',
      discountType = '',
      discount = '0.0',
      discountAmount = '0.0',
      promoCode = '',
      tax = '0.0';

  double roundedContainersWidth = 160.0;
  static String orderType = 'P', paymentType = '';
  TextEditingController controller = TextEditingController();
  bool isCheckoutPressed = false;
  List<String> tips = ['1', '2', '3', '4', '5', '6', ''];

  static String selectedTip = '0.00';
  bool isStoreOpen = true;
  String shopCloseMsg = '';

  String token = '';

//  static String consSelectedTip='0.0';

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

  setSelectedRadio2(int val) {
    setState(() {
      selectedRadio2 = val;
    });
  }

  bool showProgress = false;

  getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    login = prefs.getString('login');
    userId = prefs.getString('id');
    selectedAddress = prefs.getString('address');
    addressId = prefs.getString('address_id');
    branch_id = prefs.getString(BRANCH_ID);
    token = prefs.getString('token');

    checkPaymentMethodAllowByAdmin('$BASEURL/payment_method.php');

    checkShopStatus('$BASEURL/shop_status.php');
    Future.delayed(Duration.zero, () {
      cart = Provider.of<Cart>(context, listen: false);
      subTotal = cart.totalAmount;

      if (orderType == 'D') {
        checkDeliveryAvailable(addressId, userId, branch_id);
        getCharges(orderType, addressId, userId, cart.totalAmount.toString());
      } else {
        getCharges(orderType, addressId, userId, cart.totalAmount.toString());
      }
    });
    controller.text = '0.0';

    checkIfUserSelectedAnyAddress(
        '$BASEURL/get_user_current_delivery_address.php?userid=$userId');

//    StripePayment.setOptions(StripeOptions(
//      publishableKey: "pk_test_xGilOGTNy1RXHexnc5YHHSgN00azMzD2Nc",
//      merchantId: "",
//      androidPayMode: 'test',
//    ));

    getTips();

    print(
        'selected address $selectedAddress id $addressId branchID: $branch_id');
  }

  Cart cart;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLoginStatus();
  }

  void getSelectedAddress(String addId, String add) {
    print('BOTTOM SHEET ---> selected address id $addId address $add');
    selectedAddress = add;
    addressId = addId;

    setState(() {
      checkDeliveryAvailable(addressId, userId, branch_id);
      getCharges(orderType, addressId, userId, cart.totalAmount.toString());
    });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: MediaQuery.of(context).size.height - 100.0,
              child: AddressBookBottomSheet(
                getSelectedAddress: getSelectedAddress,
              ));
        });
  }

  void onDataChange(String str) {
    print('===========================ondatachage claedd');
    setState(() {
      cart = Provider.of<Cart>(context, listen: false);
      subTotal = cart.totalAmount;
      getCharges(orderType, addressId, userId, cart.totalAmount.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    checkRestaurantStatus(
        '$BASEURL/check_res_status.php?order_type=$orderType&branch_id=$branch_id');
//    final cart = Provider.of<Cart>(context, listen: false);

//    saleTax = cart.totalAmount * 20 / 100;
//    grandTot = cart.totalAmount + 11.0 + saleTax;

    void setError(dynamic error) {
      print(error.toString());
//      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString())));
      setState(() {
//        _error = error.toString();
      });
    }

    ScrollController _controller = ScrollController();
    //Token _paymentToken;

    print('Order type: $orderType');
    print('IsDelevery: $isDevAvailable');
    return Scaffold(
      bottomNavigationBar: Container(
        color: kColorPrimary,
        height: 60.0,
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            print('@@ Order type: $orderType');
            print('@@ payment type: $paymentType');

            if (orderType == '') {
              Toast.show('Please select Order Type', context,
                  gravity: Toast.CENTER);
            } else if (paymentType == '') {
              Toast.show('Please select Payment mode', context,
                  gravity: Toast.CENTER);
            } else {
              if (orderType == 'D' && !isDevAvailable && paymentType != '') {
                Toast.show('Delivery is not availalbe at this address', context,
                    gravity: Toast.CENTER);
              } else {
                if (paymentType == 'Card') {
                  //******
                  // ************************* ONLINE PAYMENT ***********************

                  if (isStoreOpen) {
                    webView(
                        userId,
                        addressId,
                        subTotal.toString(),
                        grandTot.toString(),
                        saleTax.toString(),
                        selectedTip,
                        deliveryCharges.toString(),
                        orderType,
                        paymentType,
                        stripeToken,
                        discountType,
                        discountAmount,
                        promoCode,
                        branch_id);
                  } else {
                    showAlertShopClose(context, shopCloseMsg);
                  }

//                  Toast.show('Stripe payment initializing...', context,
//                      gravity: Toast.CENTER);

//                  if (Platform.isIOS) {
//                    _controller.jumpTo(450);
//                  }

//                  StripePayment.paymentRequestWithNativePay(
//                    androidPayOptions: AndroidPayPaymentRequest(
//                      total_price: '1.20',
//                      currency_code: 'INR',
//                    ),
//                    applePayOptions: ApplePayPaymentOptions(
//                      countryCode: 'IN',
//                      currencyCode: 'INR',
//                      items: [
//                        ApplePayItem(
//                          label: 'Test',
//                          amount: '13',
//                        )
//                      ],
//                    ),
//                  ).then((token) {
//                    setState(() {
////                    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
//                      _paymentToken = token;
//                      print('native pay token: ${token.tokenId.toString()}');
//                      stripeToken = token.tokenId.toString();
//
//                      if (isStoreOpen) {
//                        checkout(
//                            userId,
//                            addressId,
//                            subTotal.toString(),
//                            grandTot.toString(),
//                            saleTax.toString(),
//                            selectedTip,
//                            deliveryCharges.toString(),
//                            orderType,
//                            paymentType,
//                            stripeToken,
//                            discountType,
//                            discountAmount,
//                            promoCode,
//                            branch_id);
//                      } else {
//                        showAlertShopClose(context, shopCloseMsg);
//                      }
//                    });
//                  }).catchError(setError);
                } else {
                  setState(() {
                    isCheckoutPressed = true;
                  });

                  if (isStoreOpen) {
                    checkout(
                        userId,
                        addressId,
                        subTotal.toString(),
                        grandTot.toString(),
                        saleTax.toString(),
                        selectedTip,
                        deliveryCharges.toString(),
                        orderType,
                        paymentType,
                        stripeToken,
                        discountType,
                        discountAmount,
                        promoCode,
                        branch_id);
                  } else {
                    showAlertShopClose(context, shopCloseMsg);
                  }
                }
              }
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /*CHECKOUT*/ orderType == 'D'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: isDevAvailable
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('CHECKOUT',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontSize: 19.0)),
                                    Text(
                                      '(£${grandTot.toStringAsFixed(2)})',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          fontSize: 21.0),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Delivery is not available at this address',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 16.0)),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        isCheckoutPressed && isDevAvailable && isStoreOpen
                            ? CircularProgressIndicator()
                            : SizedBox()
                      ],
                    )
                  : Row(
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
                                '(£${grandTot.toStringAsFixed(2)})',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 21.0),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        isCheckoutPressed && isDevAvailable && isStoreOpen
                            ? CircularProgressIndicator()
                            : SizedBox()
                      ],
                    ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: kColorBottomSheetBG,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Alert(
                    context: context,
                    type: AlertType.info,
                    title: 'Sure, you want to empty cart?',
                    //      desc: msg,
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        width: 120,
                        color: Colors.lightBlue,
                        radius: BorderRadius.circular(5.0),
                      ),
                      DialogButton(
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          removeCart(userId);
                        },
                        width: 120,
                        color: Colors.lightBlue,
                        radius: BorderRadius.circular(5.0),
                      ),
                    ],
                  ).show();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Remove All',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.delete),
                    ],
                  ),
                ),
              ),
              /*ITEMS*/
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) => CartListItem(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].title,
                  userId,
                  cart.items.values.toList()[i].isVeg,
                  onDataChange,
                ),
              ),

              /*PICKUP AND PAYMENT*/ Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: 30.0,
                    ),
                    /*PICKUP & DEL*/ Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /*Pickup*/ Container(
                          width: roundedContainersWidth,
                          decoration: BoxDecoration(
                              color: kColorForRoundedCornerContainer,
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(20.0))),
                          child: Row(
                            children: <Widget>[
                              Radio(
                                value: 1,
                                groupValue: selectedRadio1,
                                activeColor: Colors.green,
                                onChanged: (val) {
                                  print("Radio $val");
                                  setSelectedRadio1(val);
                                  setState(() {
                                    orderType = 'P';
                                    getCharges(orderType, addressId, userId,
                                        cart.totalAmount.toString());
                                  });
                                },
                              ),
                              Text(
                                'Pickup',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        /*CASH*/ Container(
                          width: roundedContainersWidth,
                          decoration: BoxDecoration(
                              color: isCaseAllowByAdmin
                                  ? kColorForRoundedCornerContainer
                                  : Colors.grey,
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(20.0))),
                          child: Row(
                            children: <Widget>[
                              Radio(
                                value: 2,
                                groupValue: selectedRadio2,
                                activeColor: Colors.blue,
                                onChanged: (val) {
                                  if (isCaseAllowByAdmin) {
                                    print("Radio $val");
                                    setSelectedRadio2(val);
                                    setState(() {
                                      paymentType = 'Cash';
                                    });
                                  }
                                },
                              ),
                              Text(
                                'CASH',
                                style: isCaseAllowByAdmin
                                    ? TextStyle(
                                        fontWeight: FontWeight.w600,
                                      )
                                    : TextStyle(
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.lineThrough),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    /*CASH & CARD*/ Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /*DELIVERY*/ Container(
                          width: roundedContainersWidth,
                          decoration: BoxDecoration(
                              color: kColorForRoundedCornerContainer,
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(20.0))),
                          child: Row(
                            children: <Widget>[
                              Radio(
                                value: 3,
                                groupValue: selectedRadio1,
                                activeColor: Colors.green,
                                onChanged: (val) {
                                  print("Radio $val");
                                  setSelectedRadio1(val);
                                  setState(() {
                                    orderType = 'D';
                                    checkDeliveryAvailable(
                                        addressId, userId, branch_id);
                                    getCharges(orderType, addressId, userId,
                                        cart.totalAmount.toString());
                                  });
                                },
                              ),
                              Text(
                                'Delivery',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        /*CARD*/ Container(
                          width: roundedContainersWidth,
                          decoration: BoxDecoration(
                              color: isCardAllowByAdmin
                                  ? kColorForRoundedCornerContainer
                                  : Colors.grey,
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(20.0))),
                          child: Row(
                            children: <Widget>[
                              Radio(
                                value: 4,
                                groupValue: selectedRadio2,
                                activeColor: Colors.blue,
                                onChanged: (val) {
                                  if (isCardAllowByAdmin) {
                                    print("Radio $val");
                                    setSelectedRadio2(val);
                                    setState(() {
                                      paymentType = 'Card';
                                    });
                                  }
                                },
                              ),
                              Text(
                                'CARD',
                                style: isCardAllowByAdmin
                                    ? TextStyle(
                                        fontWeight: FontWeight.w600,
                                      )
                                    : TextStyle(
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.lineThrough),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                  ],
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Sub total: ',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '£ ${subTotal.toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      orderType == 'D'
                          /*DELIVERY CHARGE*/ ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Delivery Charges: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '£ $deliveryCharges',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Service Charges: ',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '$additionalCharges',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      /*SALE TAX*/ Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Sales Tax: ',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '£ ${saleTax.toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      /*DISCOUNT*/ discount == ''
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Coupon Discount: ($discount${discountType == 'P' ? '%' : '£'})',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: kColorPrimary),
                                  ),
                                  Text(
                                    '£ ${double.parse(discountAmount).toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: kColorPrimary),
                                  )
                                ],
                              ),
                            ),
                      /*TIP*/ Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Tip:',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  '£',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                DropdownButton(
                                  value: selectedTip,
                                  items: tipsListStr
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      selectedTip = newValue;
//                                      consSelectedTip = newValue;
                                      getCharges(orderType, addressId, userId,
                                          cart.totalAmount.toString());
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      showProgress ? CircularProgressIndicator() : SizedBox(),
                      /*GRAND TOT*/ Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Grand Total',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 17.0),
                            ),
                            Text(
                              '£ ${grandTot.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 17.0),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 35.0,
                width: MediaQuery.of(context).size.width - 100,
                child: TextField(
                  onChanged: (val) {
                    cookInstuctions = val;
                  },
                  textAlign: TextAlign.start,
                  decoration: new InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(7.0),
                        ),
                      ),
                      filled: true,
                      hintText: 'Add coocking instruction',
                      fillColor: Colors.white70),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              /*APPLY COUPON*/
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new PromocodeScreen()),
                  ).then((value) {
                    setState(() {
//                      promoCode = value;
                      Promo promo = value as Promo;
                      discountType = promo.discount_type;

                      promoCode = promo.promo_code;
                      discount = promo.discount;

//                      if (discountType == 'P') {
//                        double amount =
//                            subTotal * double.parse(promo.discount) / 100;
//                        discountAmount = amount.toString();
//                      } else {
//                        discountAmount = promo.discount;
//                      }

//                      grandTot = grandTot - double.parse(discountAmount);
                      getCharges(orderType, addressId, userId,
                          cart.totalAmount.toString());

                      print(
                          '===== discountType $discountType discount: ${promo.discount} discount amount: $discountAmount');
                    });
                  });
                },
                child: Container(
                  color: Colors.white70,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 20.0,
                              ),
                              Icon(
                                FontAwesomeIcons.tags,
                                color: kColorPrimary,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                'Appy Coupon',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              promoCode == ''
                  ? Text('')
                  : Text(
                      '$promoCode Promocode Applied',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
              /*ADDRESS*/
              orderType == 'D'
                  ? selectedAddress != null
                      ? Container(
                          color: Color(0xFFf8bbd0),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  _settingModalBottomSheet(context);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'DELIVERY AT',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
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
                                    Text(
                                        selectedAddress.replaceAll(
                                            '@@@@', ', '),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.0)),
                                  ],
                                ),
                              )),
                        )
                      : InkWell(
                          onTap: () {
                            _settingModalBottomSheet(context);
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
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Please add/select Address',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
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

  bool isDevAvailable = true;

  Future<String> checkDeliveryAvailable(
    String user_address_id,
    String user_id,
    String branch_id,
  ) async {
    showProgress = true;
    print('==== getCharges API called ====');
    String completeUrl = '$BASEURL/check_delivery_exists.php?'
        'branch_id=$branch_id&address_id=$user_address_id&userid=$user_id';

    print(completeUrl);
    var response = await http.get(completeUrl, headers: {"token": token});
    var status = json.decode(response.body)['response']['success'];

    if (status != 1) {
      Toast.show('Delivery is not avaialble at this address', context);
      isDevAvailable = false;
    } else {
      isDevAvailable = true;
    }
    setState(() {});

    showProgress = false;

    return "Success!";
  }

  Future<String> getCharges(
    String order_type,
    String user_address_id,
    String user_id,
    String food_total_amount,
  ) async {
    showProgress = true;
    print('==== getCharges API called ====');
    String completeUrl = '$BASEURL/'
        'charges_details.php?order_type=$order_type&user_address_id=$user_address_id'
        '&user_id=$user_id&food_total_amount=$food_total_amount';

    print(completeUrl);
    var response = await http.get(completeUrl, headers: {"token": token});

    tax = json.decode(response.body)['response']['tax'];
    var deliverycharge =
        json.decode(response.body)['response']['deliverycharge'];
    var min_order_amount =
        json.decode(response.body)['response']['min_order_amount'];
    var additional_charge =
        json.decode(response.body)['response']['additional_charge'];

    setState(() {
      if (discountType == 'P') {
        double amount = subTotal * double.parse(discount) / 100;
        discountAmount = amount.toString();
      } else {
        discountAmount = discount;
      }

      saleTax = subTotal * double.parse(tax) / 100;
      deliveryCharges = double.parse(deliverycharge);
      additionalCharges = double.parse(additional_charge);

      grandTot = subTotal +
          saleTax +
          deliveryCharges +
          additionalCharges -
          double.parse(discountAmount) +
          double.parse(selectedTip);

      showProgress = false;
    });

    print(response.body);

    return "Success!";
  }

  List<Tip> tipsList = [];
  List<String> tipsListStr = [];

  Future<String> getTips() async {
    try {
      print('==== getTips API called ====');
      String completeUrl = '$BASEURL/get_tips.php';

      print(completeUrl);
      var response = await http.get(completeUrl, headers: {"token": token});
      dynamic data = json.decode(response.body)['response']['tips'];

      tipsList = (data as List).map((data) => new Tip.fromJson(data)).toList();
      for (int i = 0; i < tipsList.length; i++) {
        tipsListStr.add(tipsList[i].tips);
      }
      setState(() {});
      print(response.body);
    } catch (_) {
      getTips();
    }

    return "Success!";
  }

  Future<String> removeCart(String userId) async {
    try {
      print('==== getTips API called ====');
      String completeUrl = '$BASEURL/empty_cart.php?user_id=$userId';

      print(completeUrl);
      var response = await http.get(completeUrl, headers: {"token": token});
      print(response.body);
      if (json.decode(response.body)['response']['success'] == 1) {
        cart.clear();
        int count = 0;
        Toast.show(json.decode(response.body)['response']['message'], context,
            duration: 2);
        Navigator.of(context).popUntil((_) => count++ >= 2);
      }
    } catch (_) {
//      getTips();
    }

    return "Success!";
  }

  void webView(
      String userid,
      String user_address_id,
      String subTotalAmount,
      String grandTotalAmount,
      String salesTax,
      String tipValue,
      String deliveryCharge,
      String orderType,
      String paymentType,
      String stripeToken,
      String discountType,
      String discountAmount,
      String promoCode,
      String branch_id) {
    String completeUrl = '$BASEURL/mobile_app_breathe_payment.php?'
        'userid=$userid'
        '&addressId=$user_address_id'
        '&subTotalAmount=$subTotalAmount'
        '&grandTotalAmount=$grandTotalAmount'
        '&salesTax=$tax'
        '&tipValue=$selectedTip'
        '&deliveryCharge=$deliveryCharge'
        '&instructionsVal=${cookInstuctions == 'Add coocking instruction' ? '' : cookInstuctions}'
        '&orderType=$orderType'
        '&paymentType=$paymentType'
        '&stripeToken=$stripeToken'
        '&discountType=$discountType'
        '&discountAmount=$discount'
        '&promoCode=$promoCode'
        '&additional_charge=$additionalCharges'
        '&branch_id=$branch_id';

    print('Check CompletedURL: $completeUrl');

    Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) => WebViewScreen(
                  url: completeUrl,
                )));
  }

  Future<String> checkout(
      String userid,
      String user_address_id,
      String subTotalAmount,
      String grandTotalAmount,
      String salesTax,
      String tipValue,
      String deliveryCharge,
      String orderType,
      String paymentType,
      String stripeToken,
      String discountType,
      String discountAmount,
      String promoCode,
      String branch_id) async {
    print('==== Checkout API called ====');
    String completeUrl = '$BASEURL/final_checkout.php?'
        'userid=$userid'
        '&addressId=$user_address_id'
        '&subTotalAmount=$subTotalAmount'
        '&grandTotalAmount=$grandTotalAmount'
        '&salesTax=$tax'
        '&tipValue=$selectedTip'
        '&deliveryCharge=$deliveryCharge'
        '&instructionsVal=${cookInstuctions == 'Add coocking instruction' ? '' : cookInstuctions}'
        '&orderType=$orderType'
        '&paymentType=$paymentType'
        '&stripeToken=$stripeToken'
        '&discountType=$discountType'
        '&discountAmount=$discount'
        '&promoCode=$promoCode'
        '&additional_charge=$additionalCharges'
        '&branch_id=$branch_id';

    print(completeUrl);
    var response = await http.get(completeUrl, headers: {"token": token});

    if (json.decode(response.body)['response']['success'] == 1) {
      cart.makeEmpty();
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) => CheckoutSuccessScreen(
                    orderId: json.decode(response.body)['response']['order_id'],
                  )));
    } else {
      Toast.show('Something wend wrong', context, gravity: Toast.CENTER);
    }

    print(response.body);

    return "Success!";
  }

  //CHECK STORE IS OPEN OR NOT
  Future<String> checkShopStatus(String post) async {
    print('===============checkShopStatus API CALLED...');
    print('URL: ' + post);
    var response = await http.get(post, headers: {"token": token});
    print('response: ${response.body}');
    dynamic data = json.decode(response.body)['response'];

    if (response.statusCode == 200 && data != null) {
      if (data['is_active'] != '1') {
        isStoreOpen = false;
        shopCloseMsg = data['deactivate_text'];
//        showAlert(context, data['deactivate_text']);

      } else {
        isStoreOpen = true;
      }
    }

    print('===========check shop is open: $isStoreOpen');
    return "Success!";
  }

  //CHECK STORE IS OPEN OR NOT
  Future<String> checkRestaurantStatus(String post) async {
    print('===============checkRestaurantStatus API CALLED...');
    print('URL: ' + post);
    var response = await http.get(post, headers: {"token": token});
    print('response: ${response.body}');
    dynamic data = json.decode(response.body)['response'];

    if (response.statusCode == 200 && data != null) {
      if (data['success'] != 1) {
        isStoreOpen = false;
        shopCloseMsg = data['message'];
//        showAlert(context, data['deactivate_text']);

      } else {
        isStoreOpen = true;
      }
    }

    print('===========check shop is open: $isStoreOpen');
    return "Success!";
  }

  bool isCaseAllowByAdmin = true;
  bool isCardAllowByAdmin = true;

  //CHECK WHICH ONLINE PAYMENT HAS BEEN ALLOWED BY ADMIN
  Future<String> checkPaymentMethodAllowByAdmin(String post) async {
    print('===============checkPaymentMethodAllowByAdmin API CALLED...');
    print('URL: ' + post);
    print('---------> check token: $token');

    var response = await http.get(post, headers: {"token": token});

    print('response: ${response.body}');

    dynamic data = json.decode(response.body)[0];

    if (response.statusCode == 200 && data != null) {
      isCaseAllowByAdmin = data['is_cash'];
      isCardAllowByAdmin = data['is_card'];
    }

    if (isCardAllowByAdmin) {
      selectedRadio1 = 1;
    }

    setState(() {});

    print('===========check isCaseAllowByAdmin: $isCaseAllowByAdmin');
    return "Success!";
  }

  //CHECK IF USER HAS SELECTED ANY ADDRESS
  Future<String> checkIfUserSelectedAnyAddress(String post) async {
    print('===============checkIfUserSelectedAnyAddress API CALLED...');
    print('URL: ' + post);
    print('---------> check token: $token');

    var response = await http.get(post, headers: {"token": token});

    print('response: ${response.body}');

    dynamic data = json.decode(response.body)['response']['address'];



    if (response.statusCode == 200 && data != null) {

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('address',  data['apt_suite_floor'] +', '+ data['street_address']);
      prefs.setString('address_id', data['id']);

      selectedAddress= data['apt_suite_floor'] + data['street_address'];
    }


    setState(() {});

    print('===========check isCaseAllowByAdmin: $isCaseAllowByAdmin');
    return "Success!";
  }

  void showAlertShopClose(BuildContext context, String msg) {
    Alert(
      context: context,
      type: AlertType.error,
      title: msg,
//      desc: msg,
      closeFunction: () {
        Navigator.pop(context);
      },
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
          color: Colors.lightBlue,
          radius: BorderRadius.circular(5.0),
        )
      ],
    ).show();
  }
}
