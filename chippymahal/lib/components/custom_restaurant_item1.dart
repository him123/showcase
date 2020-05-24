import 'package:sabon/constant/constant.dart';
import 'package:flutter/material.dart';

class RestaurantItem1 extends StatefulWidget {
  final String id;
  final String imagePath;
  final String name;
  final String address;
  final bool isBookmark;
  final double rating;
  final String price;
  final int ratings;
  final Function(int,
      String,
      String,
      String) getItem;

  const RestaurantItem1(
      {Key key,
      @required this.id,
      @required this.imagePath,
      @required this.name,
      @required this.address,
      @required this.isBookmark,
      @required this.rating,
      @required this.ratings,
      @required this.price,
      @required this.getItem})
      : super(key: key);

  @override
  _RestaurantItem1State createState() => _RestaurantItem1State();
}

class _RestaurantItem1State extends State<RestaurantItem1> {
  bool isBookmark;
  int _itemCount = 0;
  double totalPrice=0.0;

  void onDataChange(int itemCount) {
    setState(() {
      itemCount = _itemCount;
    });
  }

  @override
  void initState() {
    super.initState();
    isBookmark = widget.isBookmark;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      height: 160,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Color(0x1c000000),
              offset: Offset(0, 2),
              blurRadius: 9,
              spreadRadius: 0),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          widget.imagePath == ''
              ? Image.asset('assets/images/logo.png',height: 100.0,)
              : Image.network(
                  widget.imagePath,
                  width: 98,
                  height: 98,
                ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.name,
                        style: TextStyle(
                          color: kColorBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,

                        ),
                      ),
                    ),
//                    SizedBox(
//                      width: 10,
//                    ),
//                    GestureDetector(
//                      onTap: () {
//                        setState(() {
//                          isBookmark = !isBookmark;
//                        });
//                      },
//                      child: Icon(
//                        isBookmark ? Icons.bookmark : Icons.bookmark_border,
//                        color: kColorBlue,
//                      ),
//                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.attach_money,
                      color: kColorGrey,
                      size: 15,
                    ),
                    Expanded(
                      child: Text(
                        widget.address,
                        style: TextStyle(
                          color: kColorGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Color(0xfffdc900),
                      size: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: RichText(
                        text: new TextSpan(
                          children: [
                            TextSpan(
                              text: '${widget.rating} ',
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
//                            TextSpan(
//                              text: '(${widget.ratings} ratings)',
//                              style: TextStyle(
//                                color: Color(0xffb9bdc5),
//                                fontSize: 10,
//                                fontWeight: FontWeight.w500,
//                                fontStyle: FontStyle.normal,
//                              ),
//                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Row(
                      children: <Widget>[
                        _itemCount != 0
                            ? new IconButton(
                                icon: new Icon(Icons.remove),
                                onPressed: () => setState(() {
                                  _itemCount--;
//
//                                  double singleItemWithQtyPrice = _itemCount *
//                                      double.parse(widget.price);
//                                  totalPrice +=singleItemWithQtyPrice;
//                                  print('Single tot price: $singleItemWithQtyPrice');

                                  widget.getItem(_itemCount, widget.name,
                                      widget.id, widget.price);
                                }),
                              )
                            : new Container(),
                        new Text(_itemCount.toString()),
                        new IconButton(
                            icon: new Icon(Icons.add),
                            onPressed: () => setState(() {
                                  _itemCount++;

                                  double singleItemWithQtyPrice = _itemCount *
                                      double.parse(widget.price);

                                  totalPrice += singleItemWithQtyPrice;

                                  print('Single tot price: $singleItemWithQtyPrice');
//                                  print('Grand tot price: $totalPrice');
                                  widget.getItem(_itemCount, widget.name,
                                      widget.id, widget.price);
                                }))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
