import 'package:sabon/constant/constant.dart';
import 'package:flutter/material.dart';

class FreeDelivery extends StatefulWidget {
  final String discount;

  FreeDelivery({this.discount});

  @override
  _FreeDeliveryState createState() => _FreeDeliveryState();
}

class _FreeDeliveryState extends State<FreeDelivery> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: kColorPrimary,
      ),
      child: Text(
        widget.discount,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }
}
