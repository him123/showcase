import 'dart:math';

import 'package:sabon/constant/constant.dart';
import 'package:flutter/material.dart';

class CategoryListItem extends StatelessWidget {

  final String iconPath;
  final String name;
  final int places;



  const CategoryListItem(
      {Key key,
        @required this.iconPath,
        @required this.name,
        @required this.places})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<String> images = [
      'assets/images/icon_pizza.png',
      'assets/images/icon_hamburger.png',
      'assets/images/icon_meat.png',
      'assets/images/icon_spaguetti.png'
    ];
    var rng = new Random();


    return Card(
      elevation: 7.0,
      child: Row(
        children: <Widget>[
          Container(
            width: 88,
            height: 80.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Color(0x26000000),
                  offset: Offset(0, 2),
                  blurRadius: 9,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                images[rng.nextInt(3)],
                width: 44,
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 200,
                child: Text(
                  name,
                  maxLines: 5,
                  style: TextStyle(
                    color: kColorBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Text(
                '$places places',
                style: TextStyle(
                  color: kColorGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
