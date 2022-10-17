// Copyright 2020-2022 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:goodali/models/products_model.dart';
import 'package:goodali/repository.dart/productState.dart';

/// An abstract class that represent the actions supported by the chosen
/// database or storage implementation.
abstract class Repository {
  /// General
  Future<void> close();

  /// Episodes
  Future<List<Products>> findAllProducts();
  Future<Products?> findEpisodeById(int id);
  Future<Products?> findEpisodeByGuid(String guid);
  Future<Products> saveEpisode(Products episode, [bool updateIfSame]);
  Future<void> deleteEpisode(Products episode);

  /// Event listeners
  late Stream<ProductState> productListener;
}
