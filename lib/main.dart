import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:goodali/screens/HomeScreen/web_home_screen.dart';
import 'Utils/downloader_stub.dart' if (dart.library.io) 'Utils/downloader.dart';

import 'package:goodali/Providers/audio_download_provider.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Providers/forum_tag_notifier.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/controller/download_controller.dart';
import 'package:goodali/models/products_model.dart';

import 'package:goodali/screens/Auth/enable_biometric.dart';
import 'package:goodali/screens/bottom_bar.dart';
import 'package:goodali/screens/intro_screen.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await initAudioHandler();
  AudioPlayerController audioPlayerController = AudioPlayerController();
  audioPlayerController.initiliaze();
  WidgetsFlutterBinding.ensureInitialized();

  final downloader = Downloader();
  await downloader.initialize();

  CacheManager.logLevel = CacheManagerLogLevel.verbose;
  await Hive.initFlutter();
  Hive.registerAdapter<Products>(ProductsAdapter());
  await Hive.openBox<Products>("podcasts");
  await Hive.openBox<Products>("bought_podcasts");
  await Hive.openBox<Products>("mood_podcasts");
  await Hive.openBox<Products>("intro_lecture");
  await Hive.openBox<Products>("special_list");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        Downloader.cancelAll();
        removeTokenWhenAppKilled();
        break;
    }
  }

  removeTokenWhenAppKilled() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("token");
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (_) => Auth()),
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider<AudioPlayerProvider>(create: (_) => AudioPlayerProvider()),
        ChangeNotifierProvider<AudioDownloadProvider>(create: (_) => AudioDownloadProvider()),
        ChangeNotifierProvider<ForumTagNotifier>(create: (_) => ForumTagNotifier()),
        if (!kIsWeb)
          ChangeNotifierProvider<DownloadController>(
            lazy: false,
            create: (_) => DownloadController(),
          )
      ],
      child: Consumer<Auth>(
        builder: (context, value, child) {
          return MaterialApp(
              title: 'Goodali',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  fontFamily: "Gilroy",
                  scaffoldBackgroundColor: Colors.white,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  primaryColor: MyColors.primaryColor,
                  primarySwatch: Colors.blue,
                  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                      backgroundColor: Colors.white,
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: MyColors.primaryColor,
                      unselectedItemColor: Colors.black,
                      unselectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                      selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w300))),
              home: Consumer<Auth>(builder: (context, value, _) {
                if (kIsWeb) {
                  return const WebHomeScreen();
                } else {
                  if (value.isFirstTime) {
                    return const IntroScreen();
                  } else if (value.isBiometricEnabled) {
                    return const EnableBiometric();
                  } else {
                    return const BottomTabbar();
                  }
                }
              }));
        },
      ),
    );
  }
}
