import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:goodali/Providers/audio_download_provider.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Providers/forum_tag_notifier.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/audioplayer_controller.dart';
import 'package:goodali/controller/default_audio_handler.dart';
import 'package:goodali/models/products_model.dart';

import 'package:goodali/screens/Auth/enable_biometric.dart';
import 'package:goodali/screens/blank.dart';
import 'package:goodali/screens/bottom_bar.dart';
import 'package:goodali/screens/intro_screen.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

Future<void> main() async {
  await initAudioHandler();
  AudioPlayerController audioPlayerController = AudioPlayerController();
  audioPlayerController.initiliaze();
  await FlutterDownloader.initialize(debug: true);
  WidgetsFlutterBinding.ensureInitialized();
  CacheManager.logLevel = CacheManagerLogLevel.verbose;
  await Hive.initFlutter();
  Hive.registerAdapter<Products>(ProductsAdapter());
  await Hive.openBox<Products>("podcasts");
  await Hive.openBox<Products>("bought_podcasts");
  await Hive.openBox<Products>("mood_podcasts");

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
        print("app in resumed from background");
        break;
      case AppLifecycleState.inactive:
        print("app is in inactive state");
        break;
      case AppLifecycleState.paused:
        print("app is in paused state");
        break;
      case AppLifecycleState.detached:
        print("app is removed");
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
        ChangeNotifierProvider<AudioPlayerProvider>(
            create: (_) => AudioPlayerProvider()),
        ChangeNotifierProvider<AudioDownloadProvider>(
            create: (_) => AudioDownloadProvider()),
        ChangeNotifierProvider<ForumTagNotifier>(
            create: (_) => ForumTagNotifier()),
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
                      unselectedLabelStyle:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                      selectedLabelStyle: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w300))),
              home: FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder:
                      (context, AsyncSnapshot<SharedPreferences> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        print("Connection none");
                        return const Blank();
                      case ConnectionState.waiting:
                        return const Blank();
                      case ConnectionState.done:
                        if (!snapshot.hasError) {
                          developer.log(
                              "biometric ${snapshot.data?.getBool("first_biometric")}");
                          developer.log(
                              "intro ${snapshot.data?.getBool("isFirstTime")}");
                          return snapshot.data?.getBool("isFirstTime") == null
                              ? const IntroScreen()
                              : snapshot.data?.getBool("first_biometric") ==
                                      true
                                  ? const EnableBiometric()
                                  : const BottomTabbar();
                        } else {
                          return const BottomTabbar();
                        }
                      case ConnectionState.active:
                        return const Blank();
                    }
                  }));
        },
      ),
    );
  }
}
