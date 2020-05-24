import 'package:flutter/material.dart';
import 'package:sabon/screens/checkout_success_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sabon/constant/constant.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final _key = UniqueKey();

  bool isFail = false;
  String failMessage = '';
  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: kColorPrimary,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Make Payment'),
        ),
        body: Column(
          children: [
            Expanded(
                child: isFail
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(height: 50.0,),
                    Column(
                      children: <Widget>[
                        Text(
                          failMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 21.0,
                          ),
                        ),
                        RaisedButton(
                          color: kColorPrimary,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Back To Cart',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white, fontSize: 16.0),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 50.0,),
                  ],
                )
                    : WebView(
                  onPageStarted: (val) {
                    print('==========Page started $val=============');
                    setState(() {
                      showProgress = true;
                    });
                  },
                  onPageFinished: (val) {
                    print('==========Page finished $val=============');
                    setState(() {
                      showProgress = false;
                    });
                  },
                  key: _key,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: widget.url,
                  javascriptChannels: Set.from([
                    JavascriptChannel(
                        name: 'Print',
                        onMessageReceived: (JavascriptMessage message) {
                          try {
                            print(
                                'Message ===> ${message.message.toString()}');

                            //~!~
                            var messageStr = message.message.toString();
                            List rr = messageStr.split('~!~');

                            print('STATUS  ===> ${rr[0].toString()}');
                            if (rr[0].toString() == 'Success') {
                              //redirect to success screen
//                                  Toast.show('Success ==> ${rr[1]}', context);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (BuildContext context) =>
                                          CheckoutSuccessScreen(
                                            orderId: rr[2].toString(),
                                          )));
                            } else {
                              //redirect to fail screen
                              setState(() {
//                                    Toast.show('Fail ==> ${rr[1]}', context);
                                isFail = true;
                                failMessage = rr[1].toString();
                              });
                            }
                          } catch (e, s) {
                            print(s);
                          }
                        })
                  ]),
                ))
          ],
        ),
      ),
    );
  }
}
