import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:goodali/controller/audio_player_handler.dart';
import 'package:goodali/controller/page_manager.dart';
import 'package:goodali/controller/playlist_reposetory.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<AudioHandler>(await initAudioService());

  // services
  getIt.registerLazySingleton<PlaylistRepository>(() => Playlist());

  // page state
  getIt.registerLazySingleton<PageManager>(() => PageManager());
}
