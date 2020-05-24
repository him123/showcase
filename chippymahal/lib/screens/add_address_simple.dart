import 'package:sabon/components/custom_button.dart';
import 'package:sabon/constant/constant.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sabon/model/address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:toast/toast.dart';

class AddAddressSimpleScreen extends StatefulWidget {
  final Address address;

  AddAddressSimpleScreen({this.address});

  @override
  _AddAddressSimpleScreenState createState() => _AddAddressSimpleScreenState();
}

class _AddAddressSimpleScreenState extends State<AddAddressSimpleScreen> {
  TextEditingController _controllerHounseName = new TextEditingController();
  TextEditingController _controllerStreetName = new TextEditingController();
  TextEditingController _controllerCity = new TextEditingController();
  TextEditingController _controllerPostCode = new TextEditingController();

  String id = '';
  bool isLoading = true;
  String tokenKey = '';

  getLoginStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      id = prefs.getString('id');
      tokenKey = prefs.getString('token');
    } catch (_) {}
    setState(() {
      isLoading = false;
    });
    print('login id==== $id');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginStatus();

    if (widget.address != null) {
      _controllerHounseName.text = widget.address.apt_suite_floor;
      _controllerStreetName.text = widget.address.address;

      var arr = widget.address.name.split('@@@@');
      _controllerCity.text = arr[0];
      _controllerPostCode.text = arr[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add address'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'House/Flat No',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 50,
                        child: TextField(
                          controller: _controllerHounseName,
                          onChanged: (val) {
//                                            f_name = val;
                          },
                          decoration: const InputDecoration(
                            hintText: "",
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Street Name',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 50,
                        child: TextField(
                          controller: _controllerStreetName,
                          onChanged: (val) {
//                                            l_name = val;
                          },
                          decoration: const InputDecoration(
                            hintText: "",
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'City',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 50,
                        child: TextField(
                          controller: _controllerCity,
                          onChanged: (val) {
//                                            f_name = val;
                          },
                          decoration: const InputDecoration(
                            hintText: "",
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Postcode',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 50,
                        child: TextField(
                          controller: _controllerPostCode,
                          onChanged: (val) {
//                                            l_name = val;
                          },
                          decoration: const InputDecoration(
                            hintText: "",
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 38,
            ),
            Container(
                width: 200.0,
                child: Center(
                  child: Container(
                      child: new RaisedButton(
                    child: new Text(
                      "Submit",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18.0),
                    ),
                    textColor: Colors.white,
                    color: kColorPrimary,
                    onPressed: () {
                      setState(() {
                        showProgress = true;
                        postAddress(
                            context, '$BASEURL/update_logged_user_address.php');
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(7.0)),
                  )),
                )

//              CustomButton(
//                onPressed: () {
//                  setState(() {
//                    showProgress=true;
//                  });
//                  postAddress(context,
//                      'https://www.sabon758.co.uk/appwebservices/update_logged_user_address.php');
//                },
//                title: 'Save',
//                titleColor: Colors.white,
//                color: kColorPink,
//                borderRadius: 50,
//              ),
                ),
          ],
        ),
      ),
    );
  }

  bool showProgress = false;

  void postAddress(BuildContext context, String url) async {
    print('Adding address api called .....');
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['userid'] = id;

    request.fields['callType'] = 'add';
    if (widget.address != null) {
      request.fields['address_id'] = widget.address.id;
      request.fields['callType'] = 'update';
    }
    request.fields['apt_suite_floor'] = _controllerHounseName.text;
    request.fields['street_address'] = _controllerStreetName.text;
    request.fields['city'] = _controllerCity.text;
    request.fields['state'] = '';
    request.fields['postcode'] = _controllerPostCode.text;
    request.headers.addAll({"token": tokenKey});

    print('Check this request: ${request.toString()}');

    http.Response response =
        await http.Response.fromStream(await request.send());

    print(response.body);

    if (json.decode(response.body)['response']['success'] == 1) {
      Navigator.pop(context);
    } else {
      Toast.show(json.decode(response.body)['response']['message'], context,
          gravity: Toast.CENTER);
    }

    setState(() {
      showProgress = false;
    });
  }
}
