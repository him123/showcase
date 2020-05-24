import 'package:sabon/constant/constant.dart';
import 'package:sabon/screens/tab_landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class VerifyCode extends StatefulWidget {
  @override
  _VerifyCodeState createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {

//  static PinBoxDecoration _pinBoxDecoration = (Color borderColor) {
//    return BoxDecoration(
//      shape: BoxShape.circle,
//      border: Border.all(
//        color: Color(0xffecedf1),
//        width: 1,
//      ),
//    );
//  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kColorPrimary,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, viewportConstraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Phone Verification',
                              style: TextStyle(
                                color: Color(0xff26315f),
                                fontSize: 35,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Enter your OTP code here',
                              style: TextStyle(
                                color: Color(0xff26315f),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            Center(
                              child: PinCodeTextField(
                                autofocus: false,
                                pinBoxHeight: 60,
                                pinBoxWidth: 60,
                                highlight: true,
                                highlightColor: Colors.blue,
                                defaultBorderColor: Colors.black,
                                hasTextBorderColor: Colors.green,
                                maxLength: 4,
                                onTextChanged: (text) {
                                  setState(() {
                                    //hasError = false;
                                  });
                                },
                                onDone: (text) {
                                  print('DONE $text');
                                },
                                wrapAlignment: WrapAlignment.start,
//                                pinBoxDecoration: _pinBoxDecoration,
                                pinTextStyle: TextStyle(
                                  fontFamily: 'ProximaNovaSoft',
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                                pinTextAnimatedSwitcherTransition:
                                    ProvidedPinBoxTextAnimation
                                        .scalingTransition,
                                pinTextAnimatedSwitcherDuration:
                                    Duration(milliseconds: 300),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                'Didn’t you received any code? ',
                                style: TextStyle(
                                  color: Color(0xffc7cad1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                            Center(
                              child: FlatButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.refresh,
                                      color: kColorPrimary,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Resent new code',
                                      style: TextStyle(
                                        color: kColorPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (BuildContext context) => TabLandingScreen()));
                          },
                          color: kColorPrimary,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
