//import 'package:flutter/material.dart';
//import 'package:sabon/model/SizeItems.dart';
//import 'package:sabon/model/addons.dart';
//import 'package:sabon/model/menu.dart';
//import 'package:sabon/model/options.dart';
//
//class CustomeAddonSelection extends StatefulWidget {
//  final Menu menu;
//
//  CustomeAddonSelection({this.menu});
//
//  @override
//  _CustomeAddonSelectionState createState() => _CustomeAddonSelectionState();
//}
//
//class _CustomeAddonSelectionState extends State<CustomeAddonSelection> {
//  dynamic advanceMenu;
//
//  String childOptionsName = '';
//  List<InnerOptions> innerOptionsList = [];
//  String topName = '',
//      sizeOptionAllow = '';
//
//  List<String> menueNameList = [];
//  List<String> childMenuNameList = [];
//  List<String> childMenuPriceList = [];
//
//  String selectedChildMenu = '';
//  List<Addons> addonsCartList = [];
//
////  double totAmount = price;
//
//  String radioSelected = '';
//
////    var sizedNamePriceList;
//  int quantity = 1;
//  String previouslySelectedWhenOnlySizes = '';
//
//  List<String> checkedAddonsForSize = [];
//  String sizeAddonoptionallow = '0';
//  String sizeAddonminselection = '';
//
//  List<Options> optionsList = List();
//  List<InnerOptions> menueList = List();
//  List<dynamic> tempList = List();
//
//  List<SizeItem> sizeItems = [];
//
//  SizeItem sizeItem;
//  String selectedSize = '';
//  String selectedSizeOption = '';
//  List<String> selectedItemsByUser = [];
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    advanceMenu = widget.menu.advance_menu;
//    print('check what comes: ${advanceMenu.toString()}');
//
//    getSizeList();
//    getMenus();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Select Addons'),
//      ),
//      body: Column(
//        children: <Widget>[
//          selectedItemsByUser.length == 0 ? SizedBox() : ListView.builder(
//            itemCount: selectedItemsByUser.length,
//            shrinkWrap: true,
//            itemBuilder: (BuildContext context, int index) =>
//                Row(
//                  children: <Widget>[
//                    Icon(Icons.check_circle, color: Theme
//                        .of(context)
//                        .primaryColor,),
//                    SizedBox(width: 5.0,),
//                    Text(selectedItemsByUser[index]),
//                  ],
//                ),
//          ),
//          Text(
//            topName,
//            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
//          ),
//          ListView.builder(
//              shrinkWrap: true,
//              itemCount: sizeItems.length,
//              itemBuilder: (BuildContext context, int index) =>
//                  ListTile(
//                    onTap: () {
//                      if (selectedSize == '') {
//                        print(
//                            '======= FIST STEP SIZE SELECTION ==================== ');
//                        selectedSize = sizeItems[index].name;
//
//                        print('selected $selectedSize');
//
//                        selectedItemsByUser.add(selectedSize);
//                        getSizeOptions(index);
//
////                        sizeItems.removeAt(sizeItems.indexOf(sizeItems[index]));
//
//                      } else if (selectedSizeOption == '' ||
//                          int.parse(sizeAddonoptionallow)!=0) {
//                        print('======= SECOND STEP SIZE OPTION SELECTION =========== ');
//                        print(sizeAddonminselection);
//                        print(sizeAddonoptionallow);
//
//                        int canSelectItems = int.parse(sizeAddonoptionallow);
//                        canSelectItems--;
//                        sizeAddonoptionallow = canSelectItems.toString();
//
//
//                        if (sizeAddonminselection == 'Y') {
//                          selectedSizeOption =sizeItems[index].name;
//                          selectedItemsByUser.add(selectedSizeOption);
//                        }
//
//                        getMenus();
//                      }else{
//                        print(
//
//                            '======= THIRD STEP MENU SELECTION =========== ');
//                      }
//
//                      setState(() {});
//                    },
//                    title: Text(sizeItems[index].name),
//                    trailing: Text(sizeItems[index].price),
//                  )),
//        ],
//      ),
//    );
//  }
//
//  getSizeList() {
//    try {
//      //SIZE
//      if (advanceMenu != false && advanceMenu['Size'] != '') {
//        topName = advanceMenu['Size']['size_options'][0]['topname'];
//        sizeOptionAllow = advanceMenu['Size']['size_options'][0]['optionallow'];
//        dynamic data = advanceMenu['Size']['size_options'][0]['options'];
//        optionsList =
//            (data as List).map((data) => new Options.fromJson(data)).toList();
//
//        sizeItems.clear();
//        for (int i = 0; i < optionsList.length; i++) {
//          sizeItem = new SizeItem();
//          sizeItem.name = optionsList[i].name;
//          sizeItem.price = optionsList[i].price;
//
//          sizeItems.add(sizeItem);
//        }
//      }
//    } catch (_) {
//      print("throwing new error SIZE");
//    }
//  }
//
//  getSizeOptions(int sizeIndex) {
//    try {
//      dynamic data = advanceMenu['Size']['size_options'][0]['options']
//      [sizeIndex]['addonoptions'];
//
//      //OPTIONALLOW:
//      sizeAddonoptionallow = advanceMenu['Size']['size_options'][0]['options']
//      [sizeIndex]['addonoptions'][0]['optionallow'];
//
//      //MINSELECTION:
//      sizeAddonminselection = advanceMenu['Size']['size_options'][0]['options']
//      [sizeIndex]['addonoptions'][0]['minselection'];
//
//      if (data != null) {
//        innerOptionsList = (data as List)
//            .map((data) => new InnerOptions.fromJson(data))
//            .toList();
//        topName = innerOptionsList[0].topname;
//        sizeItems.clear();
//        for (int i = 0; i < innerOptionsList[0].child.length; i++) {
//          sizeItem = new SizeItem();
//          sizeItem.name = innerOptionsList[0].child[i].name;
//          sizeItem.price = innerOptionsList[0].child[i].price;
//
//          sizeItems.add(sizeItem);
//        }
//      }
//    } catch (_) {
//      print("throwing new error getSizeOptions");
//    }
//  }
//
//  getMenus() {
//    try {
//      //MENU
//      if (advanceMenu != false && advanceMenu['Menue'] != '') {
//        dynamic Menue = advanceMenu['Menue']['menu_options'];
//
////        menueList = (Menue as List)
////            .map((tempList) => new InnerOptions.fromJson(tempList))
////            .toList();
//
//        optionsList =
//            (Menue as List).map((data) => new Options.fromJson(data)).toList();
//
//        topName = Menue['topname'];
//
//        print('@@@@@ menu list: ${topName}');
//
////        for (int i = 0; i < menueList.length; i++) {
////          menueNameList.add(menueList[i].topname);
////
////          sizeItem = new SizeItem();
////          sizeItem.name = optionsList[i].name;
////          sizeItem.price = optionsList[i].price;
////
////          sizeItems.add(sizeItem);
////        }
//      }
//    } catch (_) {
//      print("throwing new error MENU");
//    }
//  }
//}
