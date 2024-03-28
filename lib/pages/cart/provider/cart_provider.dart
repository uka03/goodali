import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/models/payment_response.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/utils/globals.dart';

class CartProvider extends ChangeNotifier {
  final _dioClient = DioClient();
  List<ProductResponseData> products = [];
  PaymentResponse paymentDetail = PaymentResponse();

  bool addProduct(ProductResponseData? data) {
    if (data != null) {
      List<ProductResponseData> itemsToRemove = [];

      if (!containsProduct(data)) {
        if (data.productId == data.albumId) {
          for (var item in products) {
            if (item.albumId == data.productId) {
              itemsToRemove.add(item);
            }
          }
          products.removeWhere((item) => itemsToRemove.contains(item));
          products.add(data);
          notifyListeners();
          return true;
        } else {
          for (var item in products) {
            if (item.productId == data.albumId) {
              return false;
            }
          }
          products.add(data);
        }
        notifyListeners();
        return true;
      }
    }
    notifyListeners();
    return false;
  }

  bool removeProduct(ProductResponseData? data) {
    if (data != null) {
      if (containsProduct(data)) {
        products.remove(data);
        notifyListeners();
        return true;
      }
    }
    notifyListeners();
    return false;
  }

  bool containsProduct(ProductResponseData? data) {
    if (data != null) {
      if (products.any((e) => e.productId == data.productId)) {
        return true;
      }
    }
    notifyListeners();
    return false;
  }

  int getTotalPrice() {
    int totalPrice = 0;
    for (var i = 0; i < products.length; i++) {
      totalPrice += products[i].price ?? 0;
    }
    return totalPrice;
  }

  Future<PaymentResponse> createOrder({required int invoiceType}) async {
    paymentDetail = PaymentResponse();
    showLoader();
    final productIDs = getProductIds();
    final response = await _dioClient.createOrder(
        invoiceType: invoiceType, productIDs: productIDs);

    paymentDetail = response;

    dismissLoader();
    notifyListeners();
    return response;
  }

  List<int?> getProductIds() {
    final response = products.map((e) {
      return e.productId;
    }).toList();

    return response;
  }
}
