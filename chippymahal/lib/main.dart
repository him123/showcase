import 'package:sabon/components/cart.dart';
import 'package:sabon/screens/address_book.dart';
import 'package:sabon/screens/cart_screen.dart';
import 'package:sabon/screens/google_map_pick_address.dart';
import 'package:sabon/screens/order_details_screen.dart';
import 'package:sabon/screens/promocode_list_screen.dart';
import 'package:sabon/screens/register.dart';
import 'package:sabon/screens/tab_landing_screen.dart';
import 'package:sabon/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  String login = prefs.getString('login');

  print('check login status: $login');
//  // Set default home.
  Widget _defaultHome;

  if (login == null) {
    login = '0';
  }

  if (login == '0') {
    _defaultHome = new LoginScreen();
  } else if (login == '1') {
    _defaultHome = new LoginScreen();
  } else {
    _defaultHome = new TabLandingScreen();
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(
        value: Cart(),
      ),
    ],
    child: MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFA33950),
        accentColor: Colors.white,
        canvasColor: Color.fromRGBO(255, 255, 255, 1),
        fontFamily: 'Poppins',
        textTheme: ThemeData.light().textTheme.copyWith(
            body1: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            body2: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            title: TextStyle(
              fontSize: 20,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            )),
      ),
//      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      // initialRoute: LoginScreen.id,
      home: _defaultHome,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        TabLandingScreen.id: (context) => TabLandingScreen(),
        CartScreen.id: (context) => CartScreen(),
        AddressBook.id: (context) => AddressBook(),
        GoogleMapPickAddress.id: (context) => GoogleMapPickAddress(),
        OrderDetailsScreen.id: (context) => OrderDetailsScreen(),
        PromocodeScreen.id: (context) => PromocodeScreen(),
      },
    ),
  ));
}
