import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodali/models/cart_item.dart';
import 'package:goodali/models/products_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  List<Products> _items = [];
  List<Products> get items => _items;

  List<int> _productsId = [];
  List<int> get productsId => _productsId;

  bool _sameItemCheck = false;
  bool get sameItemCheck => _sameItemCheck;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  int _counter = 0;
  int get counter => _counter;

  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedProducts =
        _items.map((res) => json.encode(res.toJson())).toList();
    List<String> productIdString =
        _productsId.map((el) => el.toString()).toList();

    prefs.setStringList("product_list_ids", productIdString);
    prefs.setStringList("product_list", encodedProducts);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> decodedProductsString =
        prefs.getStringList("product_list") ?? [];
    List<Products> decodedProduct = decodedProductsString
        .map((res) => Products.fromJson(json.decode(res)))
        .toList();
    _items = decodedProduct;

    List<String> stringId = prefs.getStringList('product_list_ids') ?? [];
    _productsId = stringId.map(int.parse).toList();
    _counter = stringId.length;
    _totalPrice = _productsId.isEmpty ? 0 : prefs.getDouble('total_price') ?? 0;
    notifyListeners();
  }
  //badge

  int getCounter() {
    _getPrefItems();
    return _counter;
  }

// total price
  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefItems();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    _setPrefItems();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPrefItems();

    return _totalPrice;
  }

// products items
  void addItemsIndex(int index) {
    print(index);
    print(_productsId);
    print(_productsId.any((index) => index == index));
    if (_productsId.any((element) => element == index)) {
      _sameItemCheck = true;
      notifyListeners();
    } else {
      _productsId.add(index);
      _sameItemCheck = false;
      _setPrefItems();
      notifyListeners();
    }
    _getPrefItems();
    notifyListeners();
  }

  void addProducts(Products cartItem) {
    _items.add(cartItem);
    _setPrefItems();
    notifyListeners();
  }
  //  void addProductList(List<Products> cartItem) {
  //   _items.add(cartItem);
  //   _setPrefItems();
  //   notifyListeners();
  // }

  void removeCartProduct(Products cartItem) {
    _productsId.remove(cartItem.productId);
    _items.remove(cartItem);
    _items.removeWhere((element) => element.productId == cartItem.productId);
    _setPrefItems();
    notifyListeners();
  }

  void removeAllProducts() {
    _productsId.clear();
    _items.clear();
    _setPrefItems();
    notifyListeners();
  }

  List<Products> get cartItem {
    _getPrefItems();
    return _items;
  }

  List<int> get cartItemId {
    _getPrefItems();
    return _productsId;
  }
}
