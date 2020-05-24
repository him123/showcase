import 'package:sabon/constant/constant.dart';
import 'package:flutter/material.dart';


class FeaturedItem extends StatelessWidget {
  final String imageName;
  final String name;
  final double price;

  const FeaturedItem(
      {Key key,
      @required this.imageName,
      @required this.name,
      @required this.price})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.asset(
          'assets/images/$imageName',
          width: 192,
          height: 122,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          name,
          style: TextStyle(
            color: kColorBlue,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          ),
        ),
        Text(
          '\$$price',
          style: TextStyle(
            color: kColorGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          ),
        ),
      ],
    );
  }
}
