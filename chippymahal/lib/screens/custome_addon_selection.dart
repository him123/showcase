import 'package:flutter/material.dart';
import 'package:sabon/components/cart.dart';
import 'package:sabon/constant/constant.dart';
import 'package:sabon/model/SizeItems.dart';
import 'package:sabon/model/addons.dart';
import 'package:sabon/model/menu.dart';
import 'package:sabon/model/options.dart';
import 'package:sabon/model/temp_addon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomeAddonSelection extends StatefulWidget {
  final userId;
  final Menu menu;
  final String id;
  final String itemName;
  final Cart cart;
  final bool isVeg;
  final price;
  final special_discount;

  CustomeAddonSelection(
      {this.userId,
      this.id,
      this.menu,
      this.itemName,
      this.cart,
      this.isVeg,
      this.price,
      this.special_discount});

  @override
  _CustomeAddonSelectionState createState() => _CustomeAddonSelectionState();
}

class _CustomeAddonSelectionState extends State<CustomeAddonSelection> {
  dynamic advanceMenu;

  String childOptionsName = '';
  String topName = '', sizeOptionAllow = '';
  String selectedChildMenu = '';
  String radioSelected = '';
  int quantity = 1;
  String previouslySelectedWhenOnlySizes = '';
  String sizeAddonoptionallow = '0';
  String sizeAddonminselection = '';

//  String sizeAddonoptionallowMenu = '0';
//  String sizeAddonminselectionMenu = '';

  String selectedSize = '';
  String selectedSizeOption = '';
  String selectedMenuOption = '';

  List<InnerOptions> innerOptionsList = [];
  List<Options> optionsList = List();
  List<Options> optionsListMenu = List();
  List<InnerOptions> menueList = List();
  List<TempAddon> selectedItemsByUser = [];
  List<TempAddon> tempAddonList = [];

  List<Addons> addonsCartListTEMP = [];
  List<Addons> addonsCartList = [];

  TempAddon tempAddon;

  bool isAllSet = false;

//  int indexCounter = 0;
  int indexInnerMenu = 0;
  int mainMenuIndex = 0;
  int sizeInnerIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    advanceMenu = widget.menu.advance_menu;
    print('check what comes: ${advanceMenu.toString()}');

    getToken();
    getSizeList();

    getMenusTotalCount(false);
  }

  reset() {
    selectedSize = '';
    selectedSizeOption = '';
    totalMenuOptions = 0;
    tempAddonList.clear();
    selectedItemsByUser.clear();
    getSizeList();
    getMenusTotalCount(false);
    isAllSet = false;
  }

  var options;
  bool doneWithSizeInnerOption = false;

  double getTotal() {
    double total = 0.0;
    for (int i = 0; i < selectedItemsByUser.length; i++) {
      total += double.parse(selectedItemsByUser[i].price);
    }
    double grandTotal = total + double.parse(widget.price);
    grandTotal = double.parse(grandTotal.toStringAsFixed(2));

    return grandTotal;
  }

  itemAddToTempCartArray(index) {
    addOn = Addons();
    addOn.prefix = childOptionsName;
    addOn.price = tempAddonList[index].price;
    addOn.name = tempAddonList[index].name;

    addonsCartListTEMP.add(addOn);
  }

  String token='';
  void getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  var addOn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.price == ''
            ? Text(
                widget.itemName,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Text(
                      widget.itemName,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(
                      '$POUNDSYMBOL ${widget.price}',
                    ),
                  ),
                ],
              ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              selectedItemsByUser.length == 0
                  ? SizedBox()
                  /*USER SELECTED LIST*/ : Column(
                      children: <Widget>[
                        ListView.builder(
                          itemCount: selectedItemsByUser.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (BuildContext context, int index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context).primaryColor,
                                    size: 30.0,
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    selectedItemsByUser[index].name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '$POUNDSYMBOL ${selectedItemsByUser[index].price}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        /*TOTAL ROW*/ Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Total',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19.0),
                              ),
                              Text(
                                '$POUNDSYMBOL ${getTotal()}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19.0),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
              selectedItemsByUser.length == 0
                  ? SizedBox()
                  : SizedBox(
                      height: 50.0,
                    ),
              /*TOP NAME*/ Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      topName,
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 2.0,
                        ),
                        sizeAddonminselection == 'Y' &&
                                tempAddonList.length != 0
                            ? Text(
                                '(Minimum selection $sizeAddonoptionallow)',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor),
                              )
                            : sizeAddonminselection != '' &&
                                    tempAddonList.length != 0
                                ? InkWell(
                                    onTap: () {
                                      if (selectedSize == '' &&
                                          optionsList.length > 0) {
                                        getSizeOptions(0);
                                      } else if (selectedSizeOption == '' &&
                                          innerOptionsList.length > 0) {
                                        if (totalMenuOptions > 0) {
                                          getMenusOptionItems(0);
                                        } else {
                                          isAllSet = true;
                                          topName = '';
                                          tempAddonList.clear();
                                        }
                                      } else {
                                        if (totalMenuOptions == 0) {
                                          isAllSet = true;
                                          topName = '';
                                          tempAddonList.clear();
                                        } else if (totalMenuOptions == 1) {
                                          isAllSet = true;
                                          topName = '';
                                          tempAddonList.clear();
                                        } else {
                                          print(
                                              'ELSEEEEE $totalMenuOptions $mainMenuIndex');
                                          mainMenuIndex++;
                                          if (totalMenuOptions !=
                                              mainMenuIndex) {
                                            indexInnerMenu = 0;
                                            getMenusOptionItems(mainMenuIndex);
                                          } else {
                                            indexInnerMenu = 0;
                                            isAllSet = true;
                                            topName = '';
                                            tempAddonList.clear();
                                          }
                                        }
                                        setState(() {});
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                              color: Colors.black, width: 2.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('SKIP'),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
              /*ITEM LIST*/ ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: tempAddonList.length,
                  itemBuilder: (BuildContext context, int index) => ListTile(
                        onTap: () {
                          print('check size lenth : ${optionsList.length}');
                          if (selectedSize == '' && optionsList.length > 0) {
                            print(
                                '======= FIST STEP SIZE SELECTION ==================== ');
                            selectedSize = tempAddonList[index].name;

                            print('selected $selectedSize');

                            selectedItemsByUser.add(tempAddonList[index]);

                            //Item adding in the temporary cart array
                            itemAddToTempCartArray(index);

                            getSizeOptions(index);

                          } else if (
                              !doneWithSizeInnerOption) {
                            print(
                                '======= SECOND STEP SIZE OPTION SELECTION =========== ');
                            print(sizeAddonminselection);
                            print(sizeAddonoptionallow);

                            if(sizeAddonoptionallow==''){
                              sizeAddonoptionallow='0';
                            }

                            int canSelectItems =
                                int.parse(sizeAddonoptionallow);

                            selectedSizeOption = tempAddonList[index].name;

                            if (sizeAddonminselection == 'Y' &&
                                canSelectItems >= 1) {
                              print('LIMITED SELECTION');


                              /*Check
                              * innerOptionsList list has more than item
                              * if more than one - get the next index list limit to given
                              * if selected item index and limit are same jump to menu
                              * 
                              * */

                              sizeInnerIndex++;
                              print(
                                  'Before if sizeInnerIndex: $sizeInnerIndex canSelectItems: $canSelectItems');
                              if (sizeInnerIndex == canSelectItems) {
                                print(
                                    'IF sizeInnerIndex: $sizeInnerIndex canSelectItems: $canSelectItems');
                                if (totalMenuOptions > 0) {
                                  doneWithSizeInnerOption = true;
                                  print('call Menus');
                                  getMenusOptionItems(mainMenuIndex);
                                } else {
                                  print('ALL set');
                                  isAllSet = true;
                                  topName = '';
                                  tempAddonList.clear();
                                }
                              } else {
                                print('ELSE Call the next index item');
                                selectedItemsByUser.add(tempAddonList[index]);

                                //Item adding in the temporary cart array
                                itemAddToTempCartArray(index);

                                tempAddonList.removeAt(index);
                                print('Should');

                              }
                            } else {
                              print('NO LIMITE SELECTION');

                              selectedItemsByUser.add(tempAddonList[index]);

                              //Item adding in the temporary cart array
                              itemAddToTempCartArray(index);

                              tempAddonList.removeAt(index);
                              print('Should ********** happening ${tempAddonList.length}');

                              //CALLING MENU LIST
                              if (tempAddonList.length==0) {
                                if(totalMenuOptions > 0) {
                                  doneWithSizeInnerOption=true;
                                  getMenusOptionItems(mainMenuIndex);
                                }else{
                                  doneWithSizeInnerOption=true;
                                  isAllSet = true;
                                  topName = '';
                                  tempAddonList.clear();
                                }
                              }

                            }
                          } else {
                            selectedMenuOption = tempAddonList[index].name;

                            print(
                                '======= THIRD STEP MENU SELECTION =========== ');
                            if (totalMenuOptions == 0) {
                              print('============= NO menu options');
                              isAllSet = true;
                              topName = '';
                              tempAddonList.clear();
                            } else if (totalMenuOptions == 1) {
                              print('============= MENU OPTIONS IS ONLY ONE');

                              if(sizeAddonoptionallow==''){
                                sizeAddonoptionallow='0';
                              }
                              int canSelectct = int.parse(sizeAddonoptionallow);


                              if (sizeAddonminselection == 'Y' &&
                                  canSelectct > 1) {
                                // IF THERE IS LIMIT TO ADD MENU ADDONS
                                print(
                                    'LIMITED SELECTION $sizeAddonminselection');

                                selectedItemsByUser.add(tempAddonList[index]);

                                //Item adding in the temporary cart array
                                itemAddToTempCartArray(index);

                                indexInnerMenu++;
                                tempAddonList.removeAt(index);

                                print('innermenu index: $indexInnerMenu');
                                print('innermenu index: $canSelectct');

                                if (canSelectct == indexInnerMenu) {
                                  isAllSet = true;
                                  topName = '';
                                  tempAddonList.clear();
                                }
                              } else {
                                // IF THERE IS NO LIMIT TO ADD MENU ADDONS
                                print('NO LIMIT SELECTION');
                                selectedItemsByUser.add(tempAddonList[index]);

                                //Item adding in the temporary cart array
                                itemAddToTempCartArray(index);

                                indexInnerMenu++;
                                tempAddonList.removeAt(index);

                                if (optionsListMenu.length == indexInnerMenu) {
                                  isAllSet = true;
                                  topName = '';
                                  tempAddonList.clear();
                                }
                              }
                            } else if (totalMenuOptions > 1) {
                              print(
                                  '============= MENU OPTIONS ARE MORE THAN ONE');

                              if(sizeAddonoptionallow==''){
                                sizeAddonoptionallow='0';
                              }
                              int canSelectct = int.parse(sizeAddonoptionallow);

                              print(
                                  'sizeAddonoptionallow: $sizeAddonoptionallow');
                              print(
                                  'sizeAddonminselection: $sizeAddonminselection');

                              if (sizeAddonminselection == 'Y' &&
                                  canSelectct >= 1) {
                                // IF THERE IS LIMIT TO ADD MENU ADDONS
                                print(
                                    'LIMITED SELECTION $sizeAddonminselection');

                                selectedItemsByUser.add(tempAddonList[index]);
                                //Item adding in the temporary cart array
                                itemAddToTempCartArray(index);

                                indexInnerMenu++; // MAKE INCREMENT TILL BECOME SAME AS LIMITED SELECTION
                                tempAddonList.removeAt(index);

                                print('innermenu index: $indexInnerMenu');
                                print('canSelectct index: $canSelectct');

                                /*if indexInnderMenu and canSelecte wll be same then move to next
                                step
                                => now if in the next step check totalMenuCount
                                => total menu count is more than one that's why you here
                                => show decide which menu are you in
                                if it is last menu then clear all and show cart
                                else move to the next menu items
                                * 
                                * */

                                if (canSelectct == indexInnerMenu) {
                                  mainMenuIndex++;
                                  print(
                                      'totalMenuOptions: $totalMenuOptions mainMenuIndex: $mainMenuIndex');
                                  if (mainMenuIndex == totalMenuOptions) {
                                    isAllSet = true;
                                    topName = '';
                                    tempAddonList.clear();
                                  } else {
                                    indexInnerMenu=0;
                                    getMenusOptionItems(mainMenuIndex);
                                  }
                                }
                              } else {
                                // IF THERE IS NO LIMIT TO ADD MENU ADDONS
                                print('NO LIMIT SELECTION');

                                selectedItemsByUser.add(tempAddonList[index]);

                                //Item adding in the temporary cart array
                                itemAddToTempCartArray(index);

                                indexInnerMenu++;
                                tempAddonList.removeAt(index);

                                if (optionsListMenu.length == indexInnerMenu) {
                                  /*checking here
                                  * if all selected then
                                  * check after this selection of main menu is there any one
                                  * if yes then show the next main menu items
                                  * else clear all and set show the card
                                  *
                                  *
                                  *
                                  * */

                                  mainMenuIndex++;
                                  print(
                                      'totalMenuOptions: $totalMenuOptions mainMenuIndex: $mainMenuIndex');

                                  if (mainMenuIndex == totalMenuOptions) {
                                    print('==========ALL CLERAR POINT=============');
                                    isAllSet = true;
                                    topName = '';
                                    tempAddonList.clear();
                                  } else {
                                    print('==========getMenusOptionItems POINT=============');
                                    indexInnerMenu=0;
                                    getMenusOptionItems(mainMenuIndex);
                                  }
                                }
                              }
                            }
                          }

                          setState(() {});
                        },
                        title: Text(
                          tempAddonList[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17.0),
                        ),
                        trailing: Text(
                            '$POUNDSYMBOL ${tempAddonList[index].price}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 17.0)),
                      )),
              isAllSet
                  /*ADD TO CART*/ ? InkWell(
                      onTap: () {
                        addonsCartList.addAll(addonsCartListTEMP);

                        widget.cart.addItemWithAddon(
                            widget.id,
                            getTotal(),
                            widget.itemName,
                            widget.isVeg,
                            true,
                            addonsCartList,
                            quantity);

                        List<String> finalListForaddon = [];
                        for (int i = 0; i < addonsCartList.length; i++) {
//                            print('addons ${addonsCartList[i].name}');

                          finalListForaddon.add(
                              '${addonsCartList[i].prefix}@@${addonsCartList[i].name}@@${addonsCartList[i].price}');
                        }

                        print(
                            'check final cart list ${finalListForaddon.join(', ')}');

                        addToCart(widget.id, finalListForaddon.join(', '),
                            quantity.toString(), widget.cart, true);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 150,
                        height: 45.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border:
                                Border.all(color: Colors.black, width: 2.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Add to cart',
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  getSizeList() {
    try {
      //SIZE
      if (advanceMenu != false && advanceMenu['Size'] != '') {
        topName = advanceMenu['Size']['size_options'][0]['topname'];
        sizeOptionAllow = advanceMenu['Size']['size_options'][0]['optionallow'];
        dynamic data = advanceMenu['Size']['size_options'][0]['options'];

        optionsList =
            (data as List).map((data) => new Options.fromJson(data)).toList();

        if (optionsList.length > 0) {
          tempAddonList.clear();

          for (int i = 0; i < optionsList.length; i++) {
            tempAddon = new TempAddon();

            tempAddon.name = optionsList[i].name;
            tempAddon.price = optionsList[i].price;

            tempAddonList.add(tempAddon);
          }
        } else {
          doneWithSizeInnerOption=true;
          getMenusOptionItems(0);
        }
      } else {
        doneWithSizeInnerOption=true;
        getMenusOptionItems(0);
      }
    } catch (_) {
      print("throwing new error SIZE");
    }
  }

  getSizeOptions(int sizeIndex) {
    try {
//      print('BEFORE %%%%%%%%%%%%%%%%%%%%%%%');
      dynamic data = advanceMenu['Size']['size_options'][0]['options']
          [sizeIndex]['addonoptions'];

//      print('AFTER %%%%%%%%%%%%%%%%%%%%%%% $data');
      if (data != null) {
        //OPTIONALLOW:
        sizeAddonoptionallow = advanceMenu['Size']['size_options'][0]['options']
            [sizeIndex]['addonoptions'][0]['optionallow'];

        //MINSELECTION:
        sizeAddonminselection = advanceMenu['Size']['size_options'][0]
            ['options'][sizeIndex]['addonoptions'][0]['minselection'];

//        print('AFTER ++ %%%%%%%%%%%%%%%%%%%%%%%');

        if (data != null) {
          innerOptionsList = (data as List)
              .map((data) => new InnerOptions.fromJson(data))
              .toList();

          if (innerOptionsList.length > 0) {
            topName = innerOptionsList[0].topname;
            childOptionsName = topName;
            tempAddonList.clear();
            for (int i = 0; i < innerOptionsList[0].child.length; i++) {
              tempAddon = new TempAddon();
              tempAddon.name = innerOptionsList[0].child[i].name;
              tempAddon.price = innerOptionsList[0].child[i].price;

              tempAddonList.add(tempAddon);
            }
          } else {
            isAllSet = true;
            topName = '';
            tempAddonList.clear();
          }
        }
      } else {
        doneWithSizeInnerOption=true;
        if (totalMenuOptions > 0) {
          getMenusOptionItems(0);
        } else {
          isAllSet = true;
          topName = '';
          tempAddonList.clear();
        }
      }
    } catch (_) {
      isAllSet = true;
      topName = '';
      tempAddonList.clear();
      print("throwing new error getSizeOptions");
    }
  }

  int totalMenuOptions = 0;
  int selectedMenu = 0;

  getMenusTotalCount(bool isSelected) {
    // GET ONLY COUNT
    try {
      //MENU GET ONLY COUNT
      if (advanceMenu != false && advanceMenu['Menue'] != '') {
        dynamic Menue = advanceMenu['Menue']['menu_options'];

        menueList = (Menue as List)
            .map((tempList) => new InnerOptions.fromJson(tempList))
            .toList();

        totalMenuOptions = menueList.length;
      }
    } catch (_) {
      print("throwing new error MENU");
    }
  }

  getMenusOptionItems(int index) {
    try {
      //MENU OPTION ITEMS
      if (advanceMenu != false && advanceMenu['Menue'] != '') {
//        dynamic Menue = advanceMenu['Menue']['menu_options'];

        dynamic data = advanceMenu['Menue']['menu_options'][index]['options'];

        //OPTIONALLOW:
        sizeAddonoptionallow =
            advanceMenu['Menue']['menu_options'][index]['optionallow'];

        //MINSELECTION:
        sizeAddonminselection =
            advanceMenu['Menue']['menu_options'][index]['minselection'];

        optionsListMenu =
            (data as List).map((data) => new Options.fromJson(data)).toList();

        topName = advanceMenu['Menue']['menu_options'][index]['topname'];

        tempAddonList.clear();
        for (int i = 0; i < optionsListMenu.length; i++) {
          tempAddon = new TempAddon();

          tempAddon.name = optionsListMenu[i].name;
          tempAddon.price = optionsListMenu[i].price;

          tempAddonList.add(tempAddon);
        }
      }
    } catch (_) {
      print("throwing new error MENU getMenusOptionItems");
    }
  }

  Future<String> addToCart(String itemId, String addonStr, String qty,
      Cart cart, bool isAdvance) async {
    String completeUrl = '$BASEURL/'
        'add_to_cart.php?user_id=${widget.userId.toString()}&item_id=$itemId&qty=$qty&advance_menu=$addonStr';

    print('========= Add to cart called ===========');
    print(completeUrl);

    var response = await http.get(completeUrl, headers: {"token": token});

    String newPrice = widget.price;
    if (json.decode(response.body)['response']['success'] == 1) {
      if (widget.special_discount != '0') {
        newPrice = calDiscount(
                double.parse(widget.price), int.parse(widget.special_discount))
            .toString();
      }
      if (isAdvance) {
//        cart.addItemWithAddon(widget.id, totAmount, widget.name, isVeg, true,
//            addonsCartList, quantity);
      } else {
        cart.addItem(
          widget.id,
          double.parse(newPrice),
          widget.itemName,
          widget.isVeg,
          false,
        );
      }
    } else {
      Toast.show('Item not added', context);
    }
    print(response.body);

//    setState(() {
//      isPlusProgress = false;
//      isMinusProgress = false;
//      isAddProgress = false;
//    });
    return "Success!";
  }

  double calDiscount(double price, int per) {
    var discount = price * per / 100;

    return price - discount;
  }
}
