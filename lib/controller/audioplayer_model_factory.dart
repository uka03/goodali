// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:goodali/controller/connection_controller.dart';
// import 'package:goodali/models/audio_player_model.dart';
// import 'package:goodali/models/mood_item.dart';

// class AudioPlayerModelFactory {
//   static Future<List<AudioPlayerModel>> getAudioPlayerModels(
//       BuildContext context, String id) async {
//     List<AudioPlayerModel> audioPlayerModelList = [];
//     var data = await Connection.getMoodItem(context, id);

//     List<MoodItem> moodItemList = data["moodItemList"];
//     moodItemList.map((e) {
//       AudioPlayerModel audioPlayerModel = AudioPlayerModel(
//           productID: e.id,
//           isPlaying: e.isPlaying,
//           audio: Audio("https://staging.goodali.mn" + e.audio!,
//               metas: Metas(
//                 id: e.id.toString(),
//                 title: e.title,
//                 // image: MetasImage.network("https://staging.goodali.mn" + e.banner!)
//               )));
//       audioPlayerModelList.add(audioPlayerModel);
//     });
//     return audioPlayerModelList;
//   }
// }
