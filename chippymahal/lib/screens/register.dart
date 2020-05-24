import 'package:sabon/constant/constant.dart';
import 'package:sabon/screens/tab_landing_screen.dart';
import 'package:sabon/screens/verify_code.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';
import 'package:sabon/components/custom_button.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'RegisterScreen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
//  bool _status = true;

  final FocusNode myFocusNode = FocusNode();
  String f_name = '';
  String l_name = '';
  String email_address = '';
  String password = '';
  String mobile = '';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: new Scaffold(
          appBar: AppBar(
              title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Sign Up'),
            ],
          )),
          body: SingleChildScrollView(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    new Container(
                      color: Color(0xffFFFFFF),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'First Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                50,
                                        child: TextField(
                                          onChanged: (val) {
                                            f_name = val;
                                          },
                                          decoration: const InputDecoration(
                                            hintText: "Enter First Name",
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Last Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                50,
                                        child: TextField(
                                          onChanged: (val) {
                                            l_name = val;
                                          },
                                          decoration: const InputDecoration(
                                            hintText: "Enter Last Name",
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Email ID',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        onChanged: (val) {
                                          email_address = val;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Enter Email ID"),
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Password',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        onChanged: (val) {
                                          password = val;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Enter password",
                                            suffixIcon:
                                                Icon(Icons.remove_red_eye)),
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Mobile',
                                          style: TextStyle(

                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) {
                                          mobile = val;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Enter Mobile Number"),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Center(
                  child: Container(
                    width: 200.0,
                    child: CustomButton(
                      onPressed: () {
                        setState(() {
                          if (f_name == '') {
                            Toast.show('Enter first name', context, gravity: Toast.CENTER);
                          } else if (l_name == '') {
                            Toast.show('Enter last name', context, gravity: Toast.CENTER);
                          } else if (!isEmail(email_address)) {
                            Toast.show('enter valid email address', context, gravity: Toast.CENTER);
                          } else if (password == '') {
                            Toast.show('enter password', context, gravity: Toast.CENTER);
                          } else if (mobile == '') {
                            Toast.show('enter mobile number', context, gravity: Toast.CENTER);
                          } else {
                            showSpinner = true;
                            createPost(context, '$BASEURL/register.php');
                          }
                        });
                      },
                      title: 'Submit',
                      titleColor: Colors.white,
                      color: kColorPrimary,
                      borderRadius: 50,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  bool showSpinner = false;

  void createPost(BuildContext context, String url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['first_name'] = f_name;
    request.fields['last_name'] = l_name;
    request.fields['email'] = email_address;
    request.fields['password'] = password;
    request.fields['phone'] = mobile;

    print('Check this request: ${request.toString()}');

    http.Response response =
        await http.Response.fromStream(await request.send());

    print(response.body);

    if (json.decode(response.body)['response']['success'] == 1) {
      String id = json.decode(response.body)['response']['user_id'];
      String fname =
          json.decode(response.body)['response']['userData']['first_name'];
      String lname =
          json.decode(response.body)['response']['userData']['last_name'];
      String email =
          json.decode(response.body)['response']['userData']['email'];
      String phone =
          json.decode(response.body)['response']['userData']['phone'];

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('id', id);
      prefs.setString('f_name', fname);
      prefs.setString('l_name', lname);
      prefs.setString('email', email);
      prefs.setString('phone_no', phone);
      prefs.setString('login', '2');

      Toast.show("Successfully registered!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);


      Future.delayed(Duration.zero, () {
        Navigator.pushNamedAndRemoveUntil(context, TabLandingScreen.id, (r) => false);
      });

//      Navigator.pop(context);
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//              fullscreenDialog: true,
//              builder: (BuildContext context) => TabLandingScreen()));
    } else {
      showAlert(context, json.decode(response.body)['response']['message']);
    }

    setState(() {
      showSpinner = false;
    });
  }

  void showAlert(BuildContext context, String msg) {
    Alert(
      context: context,
      type: AlertType.error,
      title: msg,
//      desc: msg,

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
