import 'package:goodali/controller/audioplayer_repository.dart';
import 'package:goodali/models/audio_player_model.dart';

class InMemoryAudioPlayerRepositore implements AudioPlayerRepository {
  late final List<AudioPlayerModel> audioPlayerModels;

  InMemoryAudioPlayerRepositore({required this.audioPlayerModels});
  @override
  Future<List<AudioPlayerModel>> getAll() async {
    return Future.value(audioPlayerModels);
  }

  @override
  Future<AudioPlayerModel> getById(String audioPlayerID) {
    return Future.value(audioPlayerModels.firstWhere(
        (element) => element.productID.toString() == audioPlayerID));
  }

  @override
  Future<List<AudioPlayerModel>> updateAllModels(
      List<AudioPlayerModel> updatedList) {
    audioPlayerModels.clear();
    audioPlayerModels.addAll(updatedList);

    return Future.value(audioPlayerModels);
  }

  @override
  Future<List<AudioPlayerModel>> updateModel(AudioPlayerModel updatedModel) {
    audioPlayerModels[audioPlayerModels.indexWhere(
            (element) => element.productID == updatedModel.productID)] =
        updatedModel;
    return Future.value(audioPlayerModels);
  }
}
