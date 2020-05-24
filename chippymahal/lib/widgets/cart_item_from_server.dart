import 'package:sabon/components/cart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sabon/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartListItemFromServer extends StatefulWidget {
  final String userId;
  final String id;
  final String productId;
  double price;
  double unit_price;
  int quantity;
  final String title;
  final String veg_type;
  final String menuItems;
  final String sizeItems;

  CartListItemFromServer(
      this.userId,
      this.id,
      this.productId,
      this.price,
      this.unit_price,
      this.quantity,
      this.title,
      this.veg_type,
      this.menuItems,
      this.sizeItems);

  @override
  _CartListItemFromServerState createState() => _CartListItemFromServerState();
}

class _CartListItemFromServerState extends State<CartListItemFromServer> {

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
//    isAddon = cart.getItemQty(widget.id).isAddon;
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.veg_type == 'V'
                          ? Image.asset('assets/images/veg.png')
                          : Image.asset('assets/images/nonveg.png'),
                      SizedBox(
                        width: 5.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width-150,
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
//                  cart.getItemQty(widget.id).isAddon
//                      ? Text('')
//                      :

                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      '£ ${widget.unit_price}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              /*PLUS-MINUS LAYOUT*/ Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  //CART
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
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (widget.quantity > 0) {
                                widget.quantity -= 1;

                                updateCart(widget.userId, widget.productId,
                                    widget.quantity.toString());

                                setState(() {
                                  widget.price =
                                      widget.quantity * widget.unit_price;

                                  cart.removeItem(
                                      widget.productId, widget.quantity);
                                });

//                                if (cart.items == 0) {
//                                  Navigator.pop(context);
//                                }
//                                if(isAddon){
//
//                                }else{

//                                }
                              }
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 6.0, left: 6.0),
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
                        InkWell(
                          onTap: () {
                            setState(() {
                              setState(() {
                                widget.quantity += 1;
                                print('increased qty ${widget.quantity}');


                                updateCart(widget.userId, widget.productId,
                                    widget.quantity.toString());
                                widget.price =
                                    widget.quantity * widget.unit_price;

                                cart.addItem(
                                    widget.productId,
                                    widget.price,
                                    widget.title,
                                    widget.veg_type == 'V' ? true : false,
                                    false);
                              });

//                              if(isAddon){
//                                print('YES');
//                                cart.updateItemWithAddon(widget.id,
//                                    widget.quantity, widget.price);
//                              }else{
//                                print('NO');

//                              }
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 6.0, right: 6.0),
                            child: Icon(FontAwesomeIcons.plus,
                                size: 13.0, color: kColorPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*TOTAL PRICE*/ Text(
//                    cart.getItemQty(widget.id).isAddon
//                        ? '£ ${cart.getItemQty(widget.id).price}'
//                        : ''
//                        ''
                    '£ ${widget.price}',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          /*ADDONS*/ Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text(widget.menuItems), Text(widget.sizeItems)],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  Future<String> updateCart(String userId, String itemId, String qty) async {
    String completeUrl = '$BASEURL/'
        'edit_cart.php?user_id=${userId.toString()}&item_id=$itemId&qty=$qty';

    print('========= Add to cart called ===========');
    print(completeUrl);
    var response = await http.get(completeUrl, headers: {"token": token});

    print(response.body);

    return "Success!";
  }
}
