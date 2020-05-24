import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String DOMAIN = 'https://www.chippymahal.co.uk';
const String BASEURL = '$DOMAIN/appwebservicesflutter';
const String RESTUARANTNAME = 'chippymahal';

const kDashTabTextStyle = TextStyle(
    fontSize: 17.0,
    fontFamily: 'Raleway',
    color: Colors.white,
    fontWeight: FontWeight.bold);

const String BRANCH_ID = 'branch_id';

const kColorPrimary = Color(0xFFA33950);
const kColorForRoundedCornerContainer = Color(0xFFe1bee7);
const kColorBlue = Color(0xff26315f);
const kColorGrey = Color(0xff96969a);
const kColorGreen = Color(0xff10ca88);
const kColorBGPink = Color(0xFFf8bbd0);
const kColorBottomSheetBG = Color(0xFFf3e5f5);

const kHintTextForm = TextStyle(
  color: kColorGrey,
  fontSize: 18,
  fontWeight: FontWeight.w400,
  fontStyle: FontStyle.normal,
);


saveInPreference(String key, String val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, val);
}

Future<String> getSaveInPreference(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.get(key);
}

const String POUNDSYMBOL = '£';
const String APPVER = '1.0.1';
