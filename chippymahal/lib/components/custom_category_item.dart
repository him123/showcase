import 'dart:math';

import 'package:sabon/constant/constant.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatefulWidget {
  final String iconPath;
  final String name;
  final String id;
  final String selectedId;
  final Function(String, String) getSelectedCat;

  const CategoryItem(
      {Key key,
      @required this.iconPath,
      @required this.name,
      @required this.id,
      @required this.selectedId,
      @required this.getSelectedCat})
      : super(key: key);

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {

  List<String> images = [
    'assets/images/icon_pizza.png',
    'assets/images/icon_hamburger.png',
    'assets/images/icon_meat.png',
    'assets/images/icon_spaguetti.png'
  ];

  Random random = new Random();
  int randomNumber=0;




  bool isSelected = false;
  List<String> selectedCatList = [];

  bool checkIsSelected(String id) {
    if (selectedCatList.contains(id)) {
      return true;
    } else {
      return false;
    }
  }

  Widget getText(String id) {
    if (widget.selectedId == id) {
      return Text(
        widget.name,
        maxLines: 1,
        style: TextStyle(
          color: kColorPrimary, // isSelected? Colors.pink:
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
      );
    } else {
      return Text(
        widget.name,
        maxLines: 1,
        style: TextStyle(
          color: kColorBlue, // isSelected? Colors.pink:
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    randomNumber = random.nextInt(images.length);
  }
  @override
  Widget build(BuildContext context) {
    print('=========== id in the cat list: ${widget.selectedId}');
    return InkWell(
      onTap: () {
        widget.getSelectedCat(widget.id, widget.name);
        selectedCatList.clear();
        setState(() {
          selectedCatList.add(widget.id);
        });
      },
      child: Card(
        elevation: 3.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 65,
              height: 50,
              child: Center(
                child: widget.iconPath == ''
                    ? Image.asset(
                        images[randomNumber],
                        width: 34,
                      )
                    : Image.network(
                  '$DOMAIN/upload-images/$RESTUARANTNAME/' +widget.iconPath,
                        width: 34,
                      ),
              ),
            ),
            Center(
              child: getText(widget.id),
            )
          ],
        ),
      ),
    );
  }
}
