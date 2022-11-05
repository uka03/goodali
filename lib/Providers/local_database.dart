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
      item.intro = products.intro;
      item.title = products.title;
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

  /// delete user
  Future<void> deleteProducts({required int index}) async {
    await box.deleteAt(index);
  }
}
