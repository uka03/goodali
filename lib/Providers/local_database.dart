import 'dart:async';
import 'dart:developer' as developer;

import 'package:goodali/Utils/urls.dart';
import 'package:goodali/models/products_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HiveDataStore {
  static const boxName = "podcasts";

  // Get reference to an already opened box
  static Box<Products> box = Hive.box<Products>(boxName);

  /// Add new user
  Future<void> addProduct({required Products products}) async {
    var datas = box.values
        .where((c) => c.title == products.title && c.id == products.id)
        .toList();

    if (datas.isEmpty) {
      await box.add(products);
    }
  }

  /// show user list
  Future<Products?> getProducts({required Products id}) async {
    return box.get(id);
  }

  Future<Products> getProductsFromUrl({required String url}) async {
    Products products = Products();
    var datas = box.values;
    for (var element in datas) {
      if (element.audio == url) {
        products = element;
      }
    }
    return products;
  }

  Future<bool> isDownloaded({required String title}) async {
    Products? products;
    for (var element in box.values) {
      if (element.title == title) {
        products = element;
      }
    }

    developer.log(products!.title!, name: "downloaded podcast");
    if (products.isDownloaded == true) {
      return true;
    } else {
      return false;
    }
  }

  /// update user data
  Future<void> updateProducts(
      {required int index, required Products userModel}) async {
    await box.putAt(index, userModel);
  }

  Future<void> updatePosition(String title, int id, int position) async {
    var datas =
        box.values.where((c) => c.title == title && c.id == id).toList();
    if (datas.isNotEmpty) {
      var item = box.get(datas.first.key);
      item!.position = position;
      await item.save();
    }
  }

  /// delete user
  Future<void> deleteProducts({required int index}) async {
    await box.deleteAt(index);
  }
}

class HiveBoughtDataStore {
  static const boxName = "bought_podcasts";

  // Get reference to an already opened box
  static Box<Products> box = Hive.box<Products>(boxName);

  /// Add new user
  Future<void> addProduct({required Products products}) async {
    var datas = box.values
        .where((c) =>
            c.title == products.title &&
            c.id == products.id &&
            c.albumTitle == products.albumTitle)
        .toList();

    if (datas.isEmpty) {
      await box.add(products);
    } else {
      var item = box.get(datas.first.key);
      item!.isBought = products.isBought;
      item.audio = products.audio;
      item.productId = products.productId;
      item.title = products.title;
      await item.save();
    }
  }

  void deleteBoxes() async {
    if (box.values.isNotEmpty) {
      box.clear();
    }
  }

  Future<Products?> getProductsFromUrl({required String url}) async {
    Products products = Products();
    print(url);
    var datas = box.values;
    developer.log(datas.length.toString());
    for (var element in datas) {
      if ((Urls.networkPath + element.audio!) == url) {
        products = element;
      }
    }
    return products;
  }

  Future<bool> isDownloaded({required String title}) async {
    Products? products;
    for (var element in box.values) {
      if (element.title == title) {
        products = element;
      }
    }

    developer.log(products?.title ?? "", name: "downloaded podcast");
    if (products!.isDownloaded == true) {
      return true;
    } else {
      return false;
    }
  }

  /// show user list
  Future<void> getProducts({required String id}) async {
    box.get(id);
  }

  /// update user data
  Future<void> updateProducts(
      {required int index, required Products userModel}) async {
    await box.putAt(index, userModel);
  }

  Future<void> updatePosition(String title, int id, int position) async {
    var datas =
        box.values.where((c) => c.title == title && c.id == id).toList();
    if (datas.isNotEmpty) {
      var item = box.get(datas.first.key);
      item!.position = position;

      await item.save();
    }
  }

  /// delete user
  Future<void> deleteProducts({required int index}) async {
    await box.deleteAt(index);
  }
}

class HiveMoodDataStore {
  static const boxName = "mood_podcasts";

  // Get reference to an already opened box
  static Box<Products> box = Hive.box<Products>(boxName);

  /// Add new user
  Future<void> addProduct({required Products products}) async {
    print("box length ${box.values.length}");
    var datas = box.values
        .where(
            (c) => c.id == products.id && c.moodListId == products.moodListId)
        .toList();
    if (datas.isEmpty) {
      await box.add(products);
    }
  }

  List<Map<dynamic, int>> moodAudioList = [];

  Future<void> updatePosition(String title, int id, int position) async {
    var datas = box.values.where((c) => c.id == id).toList();

    if (datas.isNotEmpty) {
      var item = box.get(datas.first.key);
      item!.position = position;

      await item.save();
    }
  }

  /// show user list
  Future<List<Products>> getMoodListfromBox(int moodListID) async {
    List<Products> list = [];
    for (var i = 0; i < box.length; i++) {
      final item = box.get(i);
      if (item!.moodListId == moodListID) {
        list.add(box.get(i)!);
      }
    }
    return list;
  }

  /// update user data
  Future<void> updateProducts(
      {required int index, required Products userModel}) async {
    await box.putAt(index, userModel);
  }

  /// delete user
  Future<void> deleteProducts({required int index}) async {
    await box.deleteAt(index);
  }
}

class HiveIntroDataStore {
  static const boxName = "intro_lecture";

  // Get reference to an already opened box
  static Box<Products> box = Hive.box<Products>(boxName);

  /// Add new user
  Future<void> addProduct({required Products products}) async {
    var datas = box.values
        .where((c) =>
            c.title == products.title &&
            c.id == products.id &&
            c.albumTitle == products.albumTitle)
        .toList();

    if (datas.isEmpty) {
      await box.add(products);
    } else {
      var item = box.get(datas.first.key);
      item!.isBought = products.isBought;
      item.audio = products.audio;
      item.title = products.title;
      item.productId = products.productId;
      await item.save();
    }
  }

  /// show user list
  Future<void> getProducts({required String id}) async {
    box.get(id);
  }

  /// update user data
  Future<void> updateProducts(
      {required int index, required Products userModel}) async {
    await box.putAt(index, userModel);
  }

  Future<void> updatePosition(String title, int id, int position) async {
    var datas =
        box.values.where((c) => c.title == title && c.id == id).toList();
    if (datas.isNotEmpty) {
      var item = box.get(datas.first.key);
      item!.position = position;
      await item.save();
    }
  }
}
