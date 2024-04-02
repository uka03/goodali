import 'package:flutter/material.dart';
import 'package:goodali/pages/album/album_detail.dart';
import 'package:goodali/pages/album/album_page.dart';
import 'package:goodali/pages/article/article_detail.dart';
import 'package:goodali/pages/article/article_page.dart';
import 'package:goodali/pages/audio/audio_page.dart';
import 'package:goodali/pages/auth/auth_web_page.dart';
import 'package:goodali/pages/cart/cart_page.dart';
import 'package:goodali/pages/community/create_post.dart';
import 'package:goodali/pages/home/home_page.dart';
import 'package:goodali/pages/lesson/lessons_page.dart';
import 'package:goodali/pages/menu/change_password.dart';
import 'package:goodali/pages/menu/faq_page.dart';
import 'package:goodali/pages/menu/menu.dart';
import 'package:goodali/pages/menu/term_page.dart';
import 'package:goodali/pages/payment/card_page.dart';
import 'package:goodali/pages/payment/payment_page.dart';
import 'package:goodali/pages/payment/qpay_page.dart';
import 'package:goodali/pages/podcast/podcast_page.dart';
import 'package:goodali/pages/profile/profile_edit.dart';
import 'package:goodali/pages/search/search_page.dart';
import 'package:goodali/pages/video/video_player.dart';
import 'package:goodali/pages/video/videos_page.dart';
import 'package:goodali/shared/components/main_scaffold.dart';

final Map<String, WidgetBuilder> routes = {
  MainScaffold.routeName: (context) => MainScaffold(),
  HomePage.routeName: (context) => HomePage(),
  AlbumPage.routeName: (context) => AlbumPage(),
  AlbumDetail.routeName: (context) => AlbumDetail(),
  PodcastPage.routeName: (context) => PodcastPage(),
  AudioPage.routeName: (context) => AudioPage(),
  VideosPage.routeName: (context) => VideosPage(),
  VideoPlayer.routeName: (context) => VideoPlayer(),
  ArticlePage.routeName: (context) => ArticlePage(),
  ArticleDetail.routeName: (context) => ArticleDetail(),
  ProfileEdit.routeName: (context) => ProfileEdit(),
  LessonsPage.routeName: (context) => LessonsPage(),
  CartPage.routeName: (context) => CartPage(),
  PaymentPage.routeName: (context) => PaymentPage(),
  QpayPage.routeName: (context) => QpayPage(),
  CardPage.routeName: (context) => CardPage(),
  CreatePost.routeName: (context) => CreatePost(),
  MenuPage.routeName: (context) => MenuPage(),
  ChangePassword.routeName: (context) => ChangePassword(),
  FaqPage.routeName: (context) => FaqPage(),
  SearchPage.routeName: (context) => SearchPage(),
  AuthWebPage.routeName: (context) => AuthWebPage(),
  TermPage.routeName: (context) => TermPage(),
};
