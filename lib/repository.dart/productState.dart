// Copyright 2020-2022 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:goodali/models/products_model.dart';

abstract class ProductState {
  final Products product;

  ProductState(this.product);
}

class ProductUpdateState extends ProductState {
  ProductUpdateState(Products product) : super(product);
}

class ProductDeleteState extends ProductState {
  ProductDeleteState(Products product) : super(product);
}
