// Copyright 2020-2022 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:developer';

import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/podcast_state.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/repository.dart/database_service.dart';
import 'package:goodali/repository.dart/productState.dart';
import 'package:goodali/repository.dart/repository.dart';

import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';

/// An implementation of [Repository] that is backed by Sembast.
class SembastRepository extends Repository {
  final _episodeSubject = BehaviorSubject<ProductState>();
  final _productStore = intMapStoreFactory.store('product');

  DatabaseService? _databaseService;

  Future<Database> get _db async => _databaseService!.database;

  SembastRepository({
    String databaseName = 'goodali.db',
  }) {
    _databaseService = DatabaseService(
      databaseName: databaseName,
    );
  }

  @override
  Future<List<Products>> findAllProducts() async {
    final finder = Finder(
      sortOrders: [SortOrder('id', true)],
    );

    final recordSnapshots = await _productStore.find(await _db, finder: finder);

    final results = recordSnapshots.map((snapshot) {
      final episode = Products.fromJson(snapshot.value);

      return episode;
    }).toList();

    return results;
  }

  @override
  Future<Products?> findEpisodeById(int id) async {
    final snapshot = await _productStore.record(id).get(await _db);

    if (snapshot == null) {
      return null;
    } else {
      return Products.fromJson(snapshot);
    }
  }

  @override
  Future<Products?> findEpisodeByGuid(String guid) async {
    final finder = Finder(filter: Filter.equals('guid', guid));

    final snapshot = await _productStore.findFirst(await _db, finder: finder);

    return snapshot == null ? null : Products.fromJson(snapshot.value);
  }

  @override
  Future<void> deleteEpisode(Products episode) async {
    final finder = Finder(filter: Filter.byKey(episode.id));

    final snapshot = await _productStore.findFirst(await _db, finder: finder);

    if (snapshot == null) {
      // Oops!
    } else {
      await _productStore.delete(await _db, finder: finder);
      _episodeSubject.add(ProductDeleteState(episode));
    }
  }

  @override
  Future<Products> saveEpisode(Products episode,
      [bool updateIfSame = false]) async {
    var e = await _saveEpisode(episode, updateIfSame);
    _episodeSubject.add(ProductUpdateState(e));
    var data = await findAllProducts();
    podcastsNotifier.value = PodcastState(data, true);
    return e;
  }

  Future<Products> _saveEpisode(Products episode, bool updateIfSame) async {
    final finder = Finder(filter: Filter.byKey(episode.id));

    final snapshot = await _productStore.findFirst(await _db, finder: finder);

    if (snapshot == null) {
      episode.id = await _productStore.add(await _db, episode.toJson());
    } else {
      var e = Products.fromJson(snapshot.value);
      if (updateIfSame || episode != e) {
        if (e.duration != null && e.duration != 0) {
          episode.duration = e.duration;
        }
        if ((episode.position == null || episode.position == 0) &&
            (e.position != null && e.position != 0)) {
          episode.position = e.position;
        }
        if (episode.played == null && episode.played == false) {
          episode.played = e.played ?? false;
        }

        log("saved item: \n${episode.title} \npostion: ${episode.position}/${episode.duration}");

        await _productStore.update(await _db, episode.toJson(), finder: finder);
      }
    }

    return episode;
  }

  @override
  Future<void> close() async {
    final d = await _db;

    await d.close();
  }

  @override
  Stream<ProductState> get productListener => _episodeSubject.stream;
}
