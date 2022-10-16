import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:goodali/Providers/audio_download_provider.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Providers/podcast_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/default_audio_handler.dart';

import 'package:goodali/screens/Auth/enable_biometric.dart';
import 'package:goodali/screens/blank.dart';
import 'package:goodali/screens/bottom_bar.dart';
import 'package:goodali/screens/intro_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

Future<void> main() async {
  await initAudioHandler();

  WidgetsFlutterBinding.ensureInitialized();
  CacheManager.logLevel = CacheManagerLogLevel.verbose;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
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
        ChangeNotifierProvider<PodcastProvider>(
            create: (_) => PodcastProvider()),
      ],
      child: Consumer<Auth>(
        builder: (context, value, child) {
          return MaterialApp(
              // navigatorKey: navigatorKey,
              title: 'Goodali',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  // fontFamily: 'Gilroy',
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
                      default:
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
                    }
                  }));
        },
      ),
    );
  }
}
