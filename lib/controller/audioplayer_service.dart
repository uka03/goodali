// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// class AudioPlayerService {


//   static Future<void> setAudio(String url, FileInfo? fileInfo) async {
//     try {
//       widget.audioPlayer.positionStream.listen((event) {
//         position = event;
//       });
//       widget.audioPlayer.durationStream.listen((event) {
//         duration = event ?? Duration.zero;
//       });

//       widget.audioPlayer.playingStream.listen((event) {
//         isPlaying = event;
//       });
//       if (fileInfo != null) {
//         audioFile = fileInfo.file;
//         duration =
//             await widget.audioPlayer.setFilePath(audioFile!.path).then((value) {
//                   return value;
//                 }) ??
//                 Duration.zero;
//       } else {
//         print(url);
//         widget.audioPlayer.setUrl(url).then((value) {
//           duration = value ?? Duration.zero;
//           getSavedPosition(widget.products.productId!).then((value) {
//             developer.log(value.toString());
//             if (value != Duration.zero) {
//               savedPosition = value;
//               position = savedPosition;
//               // if (position != Duration.zero) {
//               //   widget.audioPlayer.seek(position);
//               // }
//               widget.audioPlayer.setUrl(url, initialPosition: position);
//             } else {}
//           });
//         });

//         await widget.audioPlayer
//             .setAudioSource(AudioSource.uri(Uri.parse(url)));
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
// }