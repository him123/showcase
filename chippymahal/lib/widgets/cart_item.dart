import 'package:sabon/components/cart.dart';
import 'package:sabon/constant/constant.dart';
import 'package:sabon/model/addons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:convert';

class CartListItem extends StatefulWidget {
  final String id;
  final String productId;
  double price;
  int quantity;
  final String title;
  final String userid;
  final bool isVeg;
  final Function(
      String,
      ) onDataChange;

  CartListItem(
      this.id,
      this.productId,
      this.price,
      this.quantity,
      this.title,
      this.userid,
      this.isVeg,
      this.onDataChange,
      ) : super();

  @override
  _CartListItemState createState() => _CartListItemState();
}

class _CartListItemState extends State<CartListItem> {

  List<Widget> getAddonRow(List<Addons> addons) {
//    print('check adons list: ${addons.length}');
    List<Widget> widget = [];
    print('############# ------>>>>> Check addons: ${addons.length}');
    for (int i = 0; i < addons.length; i++) {

      widget.add(addons[i].price == null
          ? Text(
        '+ ${addons[i].name.replaceAll('@', ' ')} F1',
        style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600),
      )
          : Text(
        '+ ${addons[i].name} $POUNDSYMBOL${addons[i].price} F2',
        style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w600),
      ));
    }
    return widget;
  }

  bool isAddon = false;
  bool isPlusProgress = false;
  bool isMinusProgress = false;
  double totToDisplay = 0.00;

  String token='';
  void getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);


//    print('Addons in this cart ------------> ${cart.getItemQty((widget.id)).addons}');

    List<Addons> list = cart.getItemQty((widget.id)).addons;

    list.forEach((element) {
      print('Addons in this cart ------------> ${element.name}');
    });


    if (cart.items.length == 0) {
      Navigator.pop(context);
    } else {
      isAddon = cart.getItemQty(widget.id).isAddon;

      totToDisplay = cart.getItemQty(widget.id).price * widget.quantity;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
//                      widget.isVeg
//                          ? Image.asset('assets/images/veg.png')
//                          : Image.asset('assets/images/nonveg.png'),
                      SizedBox(
                        width: 5.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 150,
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                  /*SINGLE PRICE*/
                  /*IF CONTAIN ADDONS -> NO SINGLE AMOUNT*/
                  cart.getItemQty(widget.id).isAddon
                      ? Text('')
                      : Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      '£ ${cart.getItemQty(widget.id).price}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              /*PLUS-MINUS LAYOUT*/ Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  /*TOTAL PRICE*/ Text(
//                    cart.getItemQty(widget.id).isAddon
//                        ? '£ ${cart.getItemQty(widget.id).price}'
//                        : ''
//                        ''
                    '£ ${totToDisplay.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  /*PLUS-MINUS*/ Container(
                    width: 80.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(
                            color: widget.quantity == 0
                                ? Colors.black12
                                : Colors.black,
                            width: 2.0)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        isMinusProgress
                            ? Padding(
                          padding: EdgeInsets.only(left: 6.0, right: 6.0),
                          child: SizedBox(
                            width: 13.0,
                            height: 13.0,
                            child: CircularProgressIndicator(
                              backgroundColor: kColorPrimary,
                            ),
                          ),
                        )
                            : InkWell(
                          onTap: () {
                            setState(() {
                              isMinusProgress = true;
                              if (widget.quantity > 0) {
                                widget.quantity -= 1;

                                updateCart(
                                    widget.userid,
                                    widget.productId,
                                    widget.quantity.toString(),
                                    false,
                                    cart,
                                    false);
                              }
                            });
                          },
                          child: Padding(
                            padding:
                            EdgeInsets.only(right: 6.0, left: 6.0),
                            child: widget.quantity != 0
                                ? Icon(
                              FontAwesomeIcons.minus,
                              size: 13.0,
                              color: kColorPrimary,
                            )
                                : Text(''),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: widget.quantity == 0
                                ? Colors.white
                                : Colors.black12,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                widget.quantity == 0
                                    ? 'ADD'
                                    : widget.quantity.toString(),
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        isPlusProgress
                            ? Padding(
                          padding: EdgeInsets.only(left: 6.0, right: 6.0),
                          child: SizedBox(
                            width: 13.0,
                            height: 13.0,
                            child: CircularProgressIndicator(
                              backgroundColor: kColorPrimary,
                            ),
                          ),
                        )
                            : InkWell(
                          onTap: () {
                            setState(() {
                              isPlusProgress = true;
                              widget.quantity += 1;

//                              updateCart(
//                                widget.userid,
//                                widget.productId,
//                                widget.quantity.toString(),
//                              );

                              if (isAddon) {
                                print('YES');

//                                cart.updateItemWithAddon(
//                                    widget.id, widget.quantity);
                                updateCart(
                                    widget.userid,
                                    widget.productId,
                                    widget.quantity.toString(),
                                    true,
                                    cart,
                                    true);
                              } else {
                                print('NO');
//                                cart.addItem(widget.id, widget.price,
//                                    widget.title, widget.isVeg, false);.
                                updateCart(
                                    widget.userid,
                                    widget.productId,
                                    widget.quantity.toString(),
                                    true,
                                    cart,
                                    false);
                              }
                            });
                          },
                          child: Padding(
                            padding:
                            EdgeInsets.only(left: 6.0, right: 6.0),
                            child: Icon(FontAwesomeIcons.plus,
                                size: 13.0, color: kColorPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          /*ADDONS*/ cart.getItemQty((widget.id)).isAddon
              ? Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: getAddonRow(cart.getItemQty((widget.id)).addons),
            ),
          )
              : Text(''),
//          cart.getItemQty((widget.id)).isAddon
//              ? Padding(
//                  padding: const EdgeInsets.only(left: 22.0),
//                  child: Text(
//                    '£ ${cart.getItemQty(widget.id).price}',
//                    style: TextStyle(fontWeight: FontWeight.w600),
//                  ),
//                )
//              : SizedBox(),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  Future<String> updateCart(String userId, String itemId, String qty,
      bool isPlus, Cart cart, bool isAdvance) async {
    String completeUrl = '$BASEURL/'
        'edit_cart.php?user_id=${userId.toString()}&item_id=$itemId&qty=$qty';

    print('========= Add to cart called ===========');
    print(completeUrl);
    var response = await http.get(completeUrl, headers: {"token": token});

    if (json.decode(response.body)['response']['success'] == 1) {
      if (isPlus) {
        //Increase
        if (isAdvance) {
          cart.updateItemWithAddon(widget.id, int.parse(qty));
        } else {
          cart.addItem(
            itemId,
            widget.price,
            widget.title,
            widget.isVeg,
            false,
          );
        }
      } else {
        //Decrease
        cart.removeItem(widget.id, int.parse(qty));
      }

      widget.onDataChange('This is title of property');
    } else {
      Toast.show('Item not added', context);
    }
    print(response.body);
    setState(() {
      isPlusProgress = false;
      isMinusProgress = false;
    });

    return "Success!";
  }

//  Future<String> updateCart(String userId, String itemId, String qty) async {
//    String completeUrl = 'https://www.sabon758.co.uk/appwebservicesflutter/'
//        'edit_cart.php?user_id=${userId.toString()}&item_id=$itemId&qty=$qty';
//
//    print('========= Add to cart called ===========');
//    print(completeUrl);
//    var response = await http.get(completeUrl);
//
//   setState(() {
//     isMinusProgress=false;
//     isPlusProgress=false;
//   });
//    print(response.body);
//
//    return "Success!";
//  }
}
