import 'package:flutter/scheduler.dart';
import 'package:sabon/constant/constant.dart';
import 'package:sabon/screens/address_book.dart';
import 'package:sabon/screens/login.dart';
import 'package:sabon/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String login = '', fname = '', lname = '', email = '', mobile = '';
  bool isLoading = true;
  TextEditingController _controllerFName = new TextEditingController();
  TextEditingController _controllerLName = new TextEditingController();
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerMobile = new TextEditingController();

  String userId='';


  String token='';

  logout() async {
    print('new one 2');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();


//    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (r) => false);
//    SchedulerBinding.instance.addPostFrameCallback((_) {
//      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (r) => false);
//    });
    Future.delayed(Duration.zero, () {
      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (r) => false);
    });

  }
  getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    login = prefs.getString('login');
    token = prefs.getString('token');
    try {
      userId = prefs.getString('id');
      fname = prefs.getString('f_name');
      lname = prefs.getString('l_name');
      email = prefs.getString('email');
      mobile = prefs.getString('phone_no');

      _controllerFName.text = fname;
      _controllerLName.text = lname;
      _controllerEmail.text = email;
      _controllerMobile.text = mobile;
    } catch (_) {}
    setState(() {
      isLoading = false;
    });
    print('login ==== $userId');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/logo.png'),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Profile'),
                _status ? _getEditIcon() : new Text('')
              ],
            )),
        body: new Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  color: Color(0xffFFFFFF),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'First Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2 -
                                        50,
                                    child: TextField(
                                      controller: _controllerFName,
                                      onChanged: (val) {
//                                            f_name = val;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Enter First Name",
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Last Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2 -
                                        50,
                                    child: TextField(
                                      controller: _controllerLName,
                                      onChanged: (val) {
//                                            l_name = val;
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                    decoration: const InputDecoration(
                                        hintText: "Enter Email ID"),
                                    enabled: !_status,
                                    controller: _controllerEmail,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                    decoration: const InputDecoration(
                                        hintText: "Enter Mobile Number"),
                                    controller: _controllerMobile,
                                    enabled: !_status,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 25.0),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddressBook()),
                              );
                            },
                            child: Card(
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
                                        'Address Book',
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

                          ),
                        ),
                        !_status ? _getActionButtons() : new Container(),
                      ],
                    ),
                  ),
                ),
//              Column(
//                children: <Widget>[
//                  Container(
//                      decoration: new BoxDecoration(
//                          color: Colors.white70,
//                          borderRadius: new BorderRadius.all(
//                              Radius.circular(10.0)
//                          )
//                      ),
//
//                      child: Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Image.asset('assets/images/ace-logo.png', height: 80.0, width: 120.0,),
//                      )),
//                  Text('Version 1.0.1', style: TextStyle(fontWeight: FontWeight.w600),),
//                ],
//              ),
                FlatButton(
                    onPressed: (){

                      Alert(
                        context: context,
                        type: AlertType.info,
                        title: 'Sure, you want to logout?',
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
//                              setState(() {
//                                setState(() {
//                                  Navigator.pop(context);
                                  logout();
//                                });
//                              });
                            },
                            width: 120,
                            color: Colors.lightBlue,
                            radius: BorderRadius.circular(5.0),
                          ),
                        ],
                      ).show();



                    },
                    child: Text('Logout', style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),)),
                Text('App Version $APPVER'),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());

                    showProgress=true;

                    editProfile(userId, _controllerFName.text, _controllerLName.text,
                        _controllerEmail.text, _controllerMobile.text);
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.white,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: kColorPrimary,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  bool showProgress;

  Future<String> editProfile(
      String userid, String fname, String lname, String email, String phone_no) async {
    print('========= getData called ===========');
    var response = await http.get(
        '$BASEURL/edit_profile.php?&f_name=$fname&l_name=$lname&email=$email&phone_no=$phone_no', headers: {"token": token});

    print(response.body);

//    if (json.decode(response.body)['response']['success'] == 0) {
//      print('fail');
//      showAlert(context, json.decode(response.body)['response']['message']);
//    } else {
//      print('success');
//
//      String id = json.decode(response.body)['response']['userData']['u_id'];
//      String f_name = json.decode(response.body)['response']['userData']['f_name'];
//      String l_name = json.decode(response.body)['response']['userData']['l_name'];
//      String email = json.decode(response.body)['response']['userData']['email'];
//      String phone_no = json.decode(response.body)['response']['userData']['phone_no'];
//
//      print('user id: $id');
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      prefs.setString('id', id);
//      prefs.setString('f_name', f_name);
//      prefs.setString('l_name', l_name);
//      prefs.setString('email', email);
//      prefs.setString('phone_no', phone_no);
//      prefs.setString('login', '2');
//
//      Navigator.of(context).pop();
//
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//              fullscreenDialog: true,
//              builder: (BuildContext context) => TabLandingScreen()));
//    }

    setState(() {
      showProgress = false;
    });

    return "Success!";
  }
}
