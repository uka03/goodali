import 'package:flutter/material.dart';
import 'package:goodali/pages/article/provider/article_provider.dart';
import 'package:goodali/pages/audio/provider/audio_provider.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/community/provider/community_provider.dart';
import 'package:goodali/pages/feel/provider/feel_provider.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/lesson/provider/lecture_provider.dart';
import 'package:goodali/pages/podcast/provider/podcast_provider.dart';
import 'package:goodali/pages/profile/provider/profile_provider.dart';
import 'package:goodali/pages/search/provider/search_provider.dart';
import 'package:goodali/pages/video/provider/video_provider.dart';
import 'package:goodali/routes/routes.dart';
import 'package:goodali/shared/components/custom_animation.dart';
import 'package:goodali/shared/provider/navigator_provider.dart';
import 'package:goodali/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:goodali/utils/globals.dart' as globals;

void main() {
  configLoading();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PodcastProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AudioProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => VideoProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ArticleProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FeelProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CommunityProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LessonProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: globals.appKey,
        title: 'goodali',
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        theme: theme(context),
        routes: routes,
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.custom
    ..displayDuration = const Duration(milliseconds: 1000)
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 60
    ..textColor = Colors.white
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.white
    ..maskColor = Colors.transparent
    ..userInteractions = false
    ..dismissOnTap = false
    ..animationStyle = EasyLoadingAnimationStyle.custom
    ..customAnimation = CustomAnimation();
}
