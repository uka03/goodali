import 'package:goodali/models/products_model.dart';
import 'package:goodali/repository.dart/productState.dart';
import 'package:goodali/repository.dart/repository.dart';

abstract class MainService {
  final Repository repository;

  MainService({
    required this.repository,
  });

  Future<List<Products>> loadEpisodes();
  Future<void> toggleEpisodePlayed(Products episode);
  Future<Products> saveEpisode(Products episode);

  late Stream<ProductState> episodeListener;
}
