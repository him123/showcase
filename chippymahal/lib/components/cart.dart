import 'package:sabon/model/addons.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final bool isVeg;
  final String title;
  final int quantity;
  final double price;
  final bool isAddon;
  double saleTax;
  final List<Addons> addons;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price,
      @required this.isVeg,
      @required this.isAddon,
      this.saleTax,
      this.addons});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return _items;
  }

  makeEmpty(){
    _items.clear();
    notifyListeners();
  }

  CartItem getItemQty(String id) {
    return _items[id];
  }


  int get itemCount {
    return _items.length;
  }

  bool isItemExistIncart(String productId) {
    return _items.containsKey(productId);
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
//      if (!cartItem.isAddon) {
      total += cartItem.price * cartItem.quantity;
//      } else {
//        total += cartItem.price;
//      }
    });

    notifyListeners();

    return total;
  }

  double calSaleTax(double price) {
    return price * 20 / 100;
  }

  void addItemsFromAPI(String productId, double price, String title, bool isVeg,
      bool isAddon, int qty, List<Addons> addonList) {

    print('***************New approche to store cart');
    if(isAddon){
      addItemWithAddon(productId, price, title,
          isVeg, isAddon, addonList, qty);
    }else {
      _items.putIfAbsent(
        productId,
            () =>
            CartItem(
                id: productId,
                title: title,
                price: price,
                isVeg: isVeg,
                quantity: qty,
                isAddon: isAddon),
      );
    }
    notifyListeners();
  }

  void addItem(
      String productId, double price, String title, bool isVeg, bool isAddon) {
    print('=========== productId $productId');
    print('=========== price $price');
    print('=========== title $title');
    print('=========== isAddon $isAddon');
    if (_items.containsKey(productId)) {
      print('=========== update');
      // change quantity...
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            isVeg: isVeg,
            quantity: existingCartItem.quantity + 1,
            saleTax: calSaleTax(existingCartItem.price),
            isAddon: isAddon),
      );
    } else {
      print('============ new added');
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: productId,
            title: title,
            price: price,
            isVeg: isVeg,
            quantity: 1,
            isAddon: isAddon),
      );
    }
    notifyListeners();
  }

  void addItemWithAddon(String productId, double price, String title,
      bool isVeg, bool isAddon, List<Addons> addons, int qauntity) {
    print('=========== productId $productId');
    print('=========== price $price');
    print('=========== title $price');
    if (_items.containsKey(productId)) {
      print('=========== update');
      // change quantity...
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            isVeg: isVeg,
            quantity: qauntity,
            saleTax: calSaleTax(existingCartItem.price),
            isAddon: isAddon,
            addons: addons),
      );
    } else {
      print('============ new added');
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: productId,
            title: title,
            price: price,
            isVeg: isVeg,
            quantity: qauntity,
            isAddon: isAddon,
            addons: addons),
      );
    }
    notifyListeners();
  }

  void updateItemWithAddon(String productId, int qauntity) {
    print('ADDONS=========== productId $productId');
//    if (_items.containsKey(productId)) {
    print('ADDONS=========== update');
    // change quantity...
    _items.update(
      productId,
      (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quantity: qauntity,
        saleTax: calSaleTax(existingCartItem.price),
        addons: existingCartItem.addons,
        isVeg: existingCartItem.isVeg,
        isAddon: true,
      ),
    );
//    } else {
//      print('============ new added');
//      _items.putIfAbsent(
//        productId,
//            () => CartItem(
//            id: productId,
//            title: title,
//            price: price,
//            isVeg: isVeg,
//            quantity: qauntity,
//            isAddon: isAddon,
//            addons: addons),
//      );
//    }
    notifyListeners();
  }

  void removeItem(String productId, int qty) {
    print('========== removeItem ================$productId');
    if (_items.containsKey(productId) && qty > 0) {
      print('========== IF ================$productId');
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          isVeg: existingCartItem.isVeg,
          addons: existingCartItem.addons,
          isAddon: existingCartItem.isAddon,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      print('========== ELSE ================$productId');
      _items.remove(productId);
    }
    notifyListeners();
  }

//  void removeItemWithAddons(String productId, int qty) {
//    if (_items.containsKey(productId) && qty > 0) {
//      _items.update(
//        productId,
//            (existingCartItem) => CartItem(
//          id: existingCartItem.id,
//          title: existingCartItem.title,
//          price: existingCartItem.price,
//          isVeg: existingCartItem.isVeg,
//          quantity: existingCartItem.quantity - 1,
//              isAddon: true;
//        ),
//      );
//    } else {
//      _items.remove(productId);
//    }
//    notifyListeners();
//  }

  void removeItemFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
