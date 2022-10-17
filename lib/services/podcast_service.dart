import 'package:goodali/models/products_model.dart';
import 'package:goodali/repository.dart/productState.dart';
import 'package:goodali/repository.dart/repository.dart';
import 'package:goodali/services/main_service.dart';

class PodcastService extends MainService {
  PodcastService({
    required Repository repository,
  }) : super(repository: repository);

  @override
  Future<List<Products>> loadEpisodes() async {
    return repository.findAllProducts();
  }

  @override
  Future<Products> toggleEpisodePlayed(Products episode) async {
    episode.played = episode.played != null ? !episode.played! : false;
    episode.position = 0;
    return repository.saveEpisode(episode);
  }

  @override
  Future<Products> saveEpisode(Products episode) async {
    return repository.saveEpisode(episode);
  }

  @override
  Stream<ProductState> get episodeListener => repository.productListener;
}
