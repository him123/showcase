import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sabon/constant/constant.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
//    getNameAndImage();

    return Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text(
              'Name',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0),
            ),
            accountEmail: new Text('Email',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0)),
            decoration: new BoxDecoration(
              color: kColorPrimary,
//              image: new DecorationImage(
//                image: new ExactAssetImage('images/logo.jpg'),
//                fit: BoxFit.cover,
//              ),
            ),
            currentAccountPicture: ClipOval(
              child: Image.asset(
                'images/default_user.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          buildListTile('Home', Icons.home, () {
            Navigator.of(context).pop();
          }),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Divider(
              color: Colors.black,
              height: 1.0,
            ),
          ),
          buildListTile('My Profile', FontAwesomeIcons.cog, () {
            Navigator.of(context).pop();
          }),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Divider(
              color: Colors.black,
              height: 1.0,
            ),
          ),
          buildListTile('Categories', FontAwesomeIcons.mapMarkerAlt, () {
            Navigator.of(context).pop();
          }),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Divider(
              color: Colors.black,
              height: 1.0,
            ),
          ),
          buildListTile('Addresses', FontAwesomeIcons.envelope, () {
//            Navigator.of(context).pushReplacementNamed(OrdersScreen.id);
            Navigator.of(context).pop();
          }),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Divider(
              color: Colors.black,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
