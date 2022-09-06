// import 'dart:async';

// // import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:goodali/controller/audioplayer_repository.dart';
// import 'package:goodali/models/audio_player_model.dart';

// part 'audio_player_event.dart';
// part 'audio_player_state.dart';

// class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
//   // final AssetsAudioPlayer assetsAudioPlayer;
//   final AudioPlayerRepository audioPlayerRepository;

//   List<StreamSubscription> playerSubscription = [];

//   AudioPlayerBloc(
//       {required this.assetsAudioPlayer, required this.audioPlayerRepository})
//       : super(const AudioPlayerInitial()) {
//     playerSubscription.add(assetsAudioPlayer.playerState.listen((event) {
//       if (event == PlayerState.stop) {
//         add(const AudioStopped());
//       }
//       if (event == PlayerState.pause) {
//         add(AudioPaused(
//             assetsAudioPlayer.current.value?.audio.audio.metas.id ?? ""));
//       }
//       if (event == PlayerState.play) {
//         add(AudioPlayed(
//             assetsAudioPlayer.current.value?.audio.audio.metas.id ?? ""));
//       }
//     }));
//     on<AudioPlayerEvent>((event, emit) async {
//       emit(const AudioPlayerLoading());
//       if (event is InitializeAudio) {
//         final audioList = await audioPlayerRepository.getAll();
//         emit(AudioPlayerReady(audioList));
//       }
//       if (event is AudioPlayed) {
//         final List<AudioPlayerModel> currentList =
//             await audioPlayerRepository.getAll();
//         final List<AudioPlayerModel> updatedList = currentList
//             .map((e) => e.audio?.metas.id == event.audioModelMetaId
//                 ? e.copyWithIsPlaying(true)
//                 : e.copyWithIsPlaying(false))
//             .toList();
//         await audioPlayerRepository.updateAllModels(updatedList);
//         final AudioPlayerModel currentlyPlaying = updatedList.firstWhere(
//             (element) => element.audio?.metas.id == event.audioModelMetaId);
//         emit(AudioPlayerPlaying(updatedList, currentlyPlaying));
//       }
//       if (event is AudioPaused) {
//         final List<AudioPlayerModel> currentList =
//             await audioPlayerRepository.getAll();
//         final List<AudioPlayerModel> updatedList = currentList
//             .map((e) => e.audio?.metas.id == event.audioModelMetaId
//                 ? e.copyWithIsPlaying(true)
//                 : e.copyWithIsPlaying(false))
//             .toList();
//         await audioPlayerRepository.updateAllModels(updatedList);
//         final AudioPlayerModel currentlyPlaying = updatedList.firstWhere(
//             (element) => element.audio?.metas.id == event.audioModelMetaId);
//         emit(AudioPlayerPaused(updatedList, currentlyPlaying));
//       }
//       if (event is AudioStopped) {
//         final List<AudioPlayerModel> currentList =
//             await audioPlayerRepository.getAll();
//         final List<AudioPlayerModel> updatedList = currentList
//             .map((e) => e.isPlaying ?? false ? e.copyWithIsPlaying(false) : e)
//             .toList();

//         emit(AudioPlayerReady(updatedList));
//         audioPlayerRepository.updateAllModels(updatedList);
//       }
//       if (event is TriggeredPlayAudio) {
//         final AudioPlayerModel updatedModel =
//             event.audioPlayerModel.copyWithIsPlaying(true);
//         final updatedList =
//             await audioPlayerRepository.updateModel(updatedModel);
//         // await assetsAudioPlayer.open(updatedModel.audio,
//         //     showNotification: true);
//       }
//       if (event is TriggeredPauseAudio) {
//         final AudioPlayerModel updatedModel =
//             event.audioPlayerModel.copyWithIsPlaying(false);
//         final updatedList =
//             await audioPlayerRepository.updateModel(updatedModel);

//         await assetsAudioPlayer.pause();

//         emit(AudioPlayerPaused(updatedList, updatedModel));
//       }
//     });
//   }
// }
