import 'package:sabon/components/custom_button.dart';
import 'package:sabon/components/custom_dialog.dart';
import 'package:sabon/components/custom_payment_method_item.dart';
import 'package:sabon/constant/constant.dart';
import 'package:flutter/material.dart';

enum PayMethod {
  paypal,
  visa,
  masterCard,
}

class Checkout extends StatelessWidget {
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(22, 42, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'assets/images/image_checked.png',
                  width: 124,
                  height: 124,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Your order is successfully.',
                  style: TextStyle(
                    color: Color(0xff26315f),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'You can track the delivery in the “Orders” section.',
                  style: TextStyle(
                    color: Color(0xff26315f),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 33,
                ),
                Container(
                  width: double.infinity,
                  child: CustomButton(
                    onPressed: () {},
                    title: 'Continue Shopping',
                    titleColor: Colors.white,
                    color: kColorPrimary,
                    borderRadius: 6,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: RawMaterialButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(color: Color(0xffe5e5e5), width: 1),
                    ),
                    padding: EdgeInsets.only(
                      top: 14,
                      bottom: 15,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    fillColor: Colors.white,
                    child: Text(
                      'Got to orders',
                      style: TextStyle(
                        color: Color(0xffbabec6),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff5f8fb),
        appBar: AppBar(
          backgroundColor: kColorPrimary,
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Checkout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1c000000),
                        offset: Offset(0, 2),
                        blurRadius: 9,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'DELIVERY ADDRESS',
                        style: TextStyle(
                          color: kColorBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffe7f9f5),
                          border:
                              Border.all(color: Color(0xff10ca87), width: 1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'HOME ADDRESS',
                                    style: TextStyle(
                                      color: kColorGreen,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  Text(
                                    '214 Levent\\Besiktas Apt.002',
                                    style: TextStyle(
                                      color: kColorBlue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: kColorGreen,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 37,
                      ),
                      Text(
                        'PAYMENT METHOD',
                        style: TextStyle(
                          color: kColorBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      PaymentMethods(),
                      SizedBox(
                        height: 52,
                      ),
                      Container(
                        width: double.infinity,
                        child: CustomButton(
                          onPressed: () {
                            _showDialog(context);
                          },
                          title: 'Payment',
                          titleColor: Colors.white,
                          color: kColorPrimary,
                          borderRadius: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 23,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/image_fingerprint.png',
                    width: 47,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      'Pay with Touch ID ',
                      style: TextStyle(
                        color: Color(0xff26315f),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentMethods extends StatefulWidget {
  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  PayMethod _payMethod = PayMethod.visa;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PaymentMethodItem(
          account: 'bhr.tawfik@gmail.com',
          checked: _payMethod == PayMethod.paypal,
          imageName: 'image_paypal.png',
          onTap: () {
            setState(() {
              _payMethod = PayMethod.paypal;
            });
          },
        ),
        SizedBox(
          height: 16,
        ),
        PaymentMethodItem(
          account: '**** **** **** 1234',
          checked: _payMethod == PayMethod.visa,
          imageName: 'image_visa.png',
          onTap: () {
            setState(() {
              _payMethod = PayMethod.visa;
            });
          },
        ),
        SizedBox(
          height: 16,
        ),
        PaymentMethodItem(
          account: '**** **** **** 1234',
          checked: _payMethod == PayMethod.masterCard,
          imageName: 'image_mastercard.png',
          onTap: () {
            setState(() {
              _payMethod = PayMethod.masterCard;
            });
          },
        ),
      ],
    );
  }
}
