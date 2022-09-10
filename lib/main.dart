import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goodali/Providers/audio_provider.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/audio_player_handler.dart';
import 'package:goodali/screens/Auth/enable_biometric.dart';
import 'package:goodali/screens/blank.dart';
import 'package:goodali/screens/bottom_bar.dart';
import 'package:goodali/screens/intro_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late AudioHandler audioHandler;

Future<void> main() async {
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.example.audio',
      androidNotificationChannelName: 'Audio Service',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isFirstTime = false;

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
      ],
      child: Consumer<Auth>(
        builder: (context, value, child) {
          return MaterialApp(
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
                    print(snapshot.data?.getBool("isFirstTime"));
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Blank();
                      default:
                        if (!snapshot.hasError) {
                          return snapshot.data?.getBool("isFirstTime") == false
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
