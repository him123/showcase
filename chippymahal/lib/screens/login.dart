import 'package:carousel_slider/carousel_slider.dart';
import 'package:sabon/components/custom_button.dart';
import 'package:sabon/constant/constant.dart';
import 'package:sabon/screens/register.dart';
import 'package:sabon/screens/tab_landing_screen.dart';
import 'package:sabon/screens/forget_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'Welcome';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSecurityToken('$BASEURL/get_token_key.php');
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: <Widget>[
                CarouselSlider(
                  height: 339,
                  autoPlayCurve: Curves.linear,
                  viewportFraction: 1.0,
                  aspectRatio: 2.0,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  items: <Widget>[
                    Image.asset(
                      'assets/images/image_welcome.png',
                      height: 339,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      'assets/images/image_turkish_restaurant.png',
                      height: 339,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 312),
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Welcome back',
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
                        'Login to your account',
                        style: TextStyle(
                          color: Color(0xff96969a),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(
                        height: 33,
                      ),
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: kColorPrimary),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 13,
                            horizontal: 16,
                          ),
                          filled: true,
                          fillColor: Color(0xffecedf1),
                          hintText: 'Email',
                          hintStyle: kHintTextForm,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: kColorPrimary),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 13,
                            horizontal: 16,
                          ),
                          filled: true,
                          fillColor: Color(0xffecedf1),
                          hintText: 'Password',
                          hintStyle: kHintTextForm,
                        ),
                      ),
                      SizedBox(
                        height: 38,
                      ),
                      Container(
                        width: double.infinity,
                        child: CustomButton(
                          onPressed: () {

//                        Navigator.of(context).pushNamed('/verify_phone');
                            if(_usernameController.text==''){
                              showAlert(context, 'Enter Email Address');
                            }else if(_passwordController.text==''){
                              showAlert(context, 'Enter Password');
                            }else{
                              setState(() {
                                showSpinner = true;
                                login(_usernameController.text,
                                    _passwordController.text);
                              });
                            }
                          },
                          title: 'Login',
                          titleColor: Colors.white,
                          color: kColorPrimary,
                          borderRadius: 50,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) => ForgetPasswordScreen()));
                        },
                        child: Text(
                          'Forgot your password?',
                          style: TextStyle(
                            color: kColorBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      FlatButton(
                        onPressed: (){

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) => RegisterScreen()));
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Don’t have an account? ',
                                style: TextStyle(
                                  color: Color(0xff97979b),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              TextSpan(
                                text: 'Sign up',
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<String> getSecurityToken(String post) async {
    print('GET TOKEN API CALLED...');
    print('URL: ' + post);

    var response = await http.get(post);

    print('----------> TOKEN response: ${response.body}');

    dynamic data = json.decode(response.body)['response'];
//
    if (data['success'] == 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('-------> check token: ${data['token_key']}');
      prefs.setString('token', data['token_key']);
    }

    return "Success!";
  }

  Future<String> login(String email, String password) async {
    print('========= getData called ===========');
    var response = await http.get(
        '$BASEURL/login.php?&email=$email&password=$password&fcmtocken=123');

    print(response.body);

    if (json.decode(response.body)['response']['success'] == 0) {
      print('fail');
      showAlert(context, json.decode(response.body)['response']['message']);
    } else {
      print('success');

      String id = json.decode(response.body)['response']['userData']['u_id'];
      String f_name = json.decode(response.body)['response']['userData']['f_name'];
      String l_name = json.decode(response.body)['response']['userData']['l_name'];
      String email = json.decode(response.body)['response']['userData']['email'];
      String phone_no = json.decode(response.body)['response']['userData']['phone_no'];

      print('user id: $id');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('id', id);
      prefs.setString('f_name', f_name);
      prefs.setString('l_name', l_name);
      prefs.setString('email', email);
      prefs.setString('phone_no', phone_no);
      prefs.setString('login', '2');


      Future.delayed(Duration.zero, () {
        Navigator.pushNamedAndRemoveUntil(context, TabLandingScreen.id, (r) => false);
      });

//      Navigator.of(context).pop();
//
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//              fullscreenDialog: true,
//              builder: (BuildContext context) => TabLandingScreen()));
    }

    setState(() {
      showSpinner = false;
    });

    return "Success!";
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
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
