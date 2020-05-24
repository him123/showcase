import 'package:flutter/foundation.dart';

class Addons with ChangeNotifier{

  String prefix;
  String name;
  String price;
  bool isRadio;

  Addons({this.prefix, this.name, this.price, this.isRadio});

}
