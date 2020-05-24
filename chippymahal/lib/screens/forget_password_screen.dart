import 'package:sabon/components/custom_button.dart';
import 'package:sabon/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool showSpinner = false;
  final _usernameController = TextEditingController();

//  String token='';
//  void getToken() async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    token = prefs.getString('token');
//  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Forget password'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Please enter your registered email address',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
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
                  height: 20,
                ),
                Container(
                  width: 200.0,
                  child: CustomButton(
                    onPressed: () {
                      print(_usernameController.text);
                      if (_usernameController.text == null ||
                          _usernameController.text == '') {
                        print('inside if');
                        Toast.show(
                            'Please enter registred email address', context, gravity: Toast.CENTER);
                      } else {
                        print('else');
                        forgetPassword(_usernameController.text);
                      }
                    },
                    title: 'Submit',
                    titleColor: Colors.white,
                    color: kColorPrimary,
                    borderRadius: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> forgetPassword(String email) async {
    print('========= getData called ===========');
    var response = await http.get('$BASEURL/forgot_password.php?&email=$email');

    print(response.body);

    showAlert(context, json.decode(response.body)['response']['message'],
        json.decode(response.body)['response']['success']);

    setState(() {
      showSpinner = false;
    });

    return "Success!";
  }

  void showAlert(BuildContext context, String msg, int success) {
    Alert(
      context: context,
      type: success == 0 ? AlertType.error : AlertType.success,
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
            if(success==1){
              _usernameController.text='';
            }
            Navigator.pop(context);
          },
          width: 120,
          color: Colors.lightBlue,
          radius: BorderRadius.circular(5.0),
        )
      ],
    ).show();
  }
}
