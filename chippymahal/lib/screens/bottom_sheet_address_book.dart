import 'dart:convert';
import 'package:sabon/constant/constant.dart';
import 'package:sabon/model/address.dart';
import 'package:sabon/screens/add_address_simple.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressBookBottomSheet extends StatefulWidget {
  static String id = 'AddressBook';
  final Function(String, String) getSelectedAddress;

  AddressBookBottomSheet({this.getSelectedAddress}) : super();

  @override
  _AddressBookBottomSheetState createState() => _AddressBookBottomSheetState();
}

class _AddressBookBottomSheetState extends State<AddressBookBottomSheet> {
  int selectedIndex;
  String id = '';
  bool isLoading = true;
  bool exitOnSelection=false;

  String token='';

  getLoginStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      id = prefs.getString('id');
      token = prefs.getString('token');

      getAddress(
          '$BASEURL/get_user_address.php?userid=$id');
    } catch (_) {}
    setState(() {
      isLoading = false;
    });
    print('login id==== $id');
  }

//  Future<bool> _onWillPop() async {
//
//    Navigator.pop(context, 'from addressbook');
//
//    return true;
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showProgress = true;
    getLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showProgress,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: kColorPrimary,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new AddAddressSimpleScreen()),
                ).then((value) {
                  setState(() {
                    print('===== Check');
                    showProgress = true;
                    getAddress(
                        '$BASEURL/get_user_address.php?userid=$id');
                  });
                });
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 18.0, top: 15.0, bottom: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.plus, size: 14.0, color: kColorPrimary),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Add Address',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
            Divider(),
            Container(
              child: Text(
                isEmpty
                    ? 'Please add address'
                    : 'Select address by tapping on it.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            isEmpty
                ? Text('')
                : Expanded(
                    child: ListView.builder(
                      itemCount: addressList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Address item = addressList[index];
                        print('***** item is selected ${item.isSelected}');

                        return InkWell(
                          onTap: () async {
                            setState(() {
                              exitOnSelection=true;
                              setState(() {
                                selectedIndex = index;
                                showProgress = true;
                                makeAddressSelection(
                                    context,
                                    '$BASEURL/update_logged_user_address.php',
                                    id,
                                    item.id);
                              });
                            });
                          },
                          child: Card(
                            color: item.isSelected == '1'
                                ? kColorBGPink
                                : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        item.isSelected == '1'
                                            ? 'Delivers to this place'
                                            : '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                     /*EDIT AND DELETE*/ Row(
                                        children: <Widget>[
                                          InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) => new AddAddressSimpleScreen(address: addressList[index],)),
                                                ).then((value) {
                                                  setState(() {
                                                    print('===== Check');
                                                    showProgress=true;
                                                    getAddress(
                                                        '$BASEURL/get_user_address.php?userid=$id');
                                                  });
                                                });
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.purple,
                                              )),
                                          SizedBox(width: 8.0,),
                                          InkWell(
                                              onTap: () {
                                                Alert(
                                                  context: context,
                                                  type: AlertType.warning,
                                                  title: 'Sure, you want to delete?',
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
                                                      onPressed: () async {
                                                        setState(() {
                                                          setState(() {
                                                            selectedIndex = index;
                                                            showProgress = true;
                                                            deleteAddress(
                                                                context,
                                                                '$BASEURL/update_logged_user_address.php',
                                                                id,
                                                                item.id);
                                                            Navigator.pop(context);
                                                          });
                                                        });
                                                      },
                                                      width: 120,
                                                      color: Colors.lightBlue,
                                                      radius: BorderRadius.circular(5.0),
                                                    ),
                                                  ],
                                                ).show();
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.purple,
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                  Text(
                                      '${item.apt_suite_floor}, ${item.address}'),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    item.name.replaceAll('@@@@', ', '),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }

  List<Address> addressList = List();
  bool showProgress;
  bool isEmpty = false;

  Future<List<Address>> getAddress(String post) async {
    print('Get Address API calling waiting for response...');

    print('API url: $post');
    var response = await http.get(post, headers: {"token": token});
    print('response: ${response.body}');
    if (mounted) {
      setState(() {
        dynamic data = json.decode(response.body)['response']['addressList'];

        try {
          addressList =
              (data as List).map((data) => new Address.fromJson(data)).toList();

          if (addressList.length == 0) {
            isEmpty = true;
          } else {
            for (int i = 0; i < addressList.length; i++) {
              if (addressList[i].isSelected == '1') {
                addToselectedAddress(
                    '${addressList[i].apt_suite_floor}, ${addressList[i].address}',
                    addressList[i].id);
                if(exitOnSelection){
                  Navigator.pop(context);
                }
              }
            }
            isEmpty = false;
          }
        } catch (_) {
          isEmpty = true;
        }
        showProgress = false;
      });
    }

    return addressList;
  }

  void addToselectedAddress(String address, String addressId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('address', address);
    prefs.setString('address_id', addressId);

    widget.getSelectedAddress(addressId, address);
  }

  void makeAddressSelection(
      BuildContext context, String url, String userId, String addressId) async {
    print('Selecting address api called .....');
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['userid'] = userId;
    request.fields['callType'] = 'setdefault';
    request.fields['address_id'] = addressId;
    request.headers.addAll({"token": token});

    print('Check this request: ${request.toString()}');

    http.Response response =
        await http.Response.fromStream(await request.send());

    print(response.body);

    dynamic data = json.decode(response.body)['response']['success'];

    setState(() {
//      showProgress = false;
      if (data == 1) {
        print('successfully updated');
        getAddress(
            '$BASEURL/get_user_address.php?userid=$id');
      } else {
        print('not updated successfully');
      }
    });

//    Navigator.pop(context);
  }

  void deleteAddress(
      BuildContext context, String url, String userId, String addressId) async {
    print('Selecting address api called .....');
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['userid'] = userId;
    request.fields['callType'] = 'delete';
    request.fields['address_id'] = addressId;

    print('Check this request: ${request.toString()}');

    http.Response response =
        await http.Response.fromStream(await request.send());

    print(response.body);

    dynamic data = json.decode(response.body)['response']['success'];

    setState(() {
//      showProgress = false;
      if (data == 1) {
        print('successfully updated');
        getAddress(
            '$BASEURL/get_user_address.php?userid=$id');
      } else {
        print('not updated successfully');
      }
    });
  }
}
