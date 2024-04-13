import 'package:flutter/material.dart';
import 'package:goodali/pages/album/album_page.dart';
import 'package:goodali/pages/article/article_page.dart';
import 'package:goodali/pages/menu/faq_page.dart';
import 'package:goodali/pages/menu/term_page.dart';
import 'package:goodali/pages/podcast/podcast_page.dart';
import 'package:goodali/pages/video/videos_page.dart';
import 'package:goodali/shared/provider/navigator_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(builder: (context, navigation, _) {
      return Container(
        padding: const EdgeInsets.only(left: 10, right: 155, top: 60, bottom: 34),
        height: 420,
        decoration: const BoxDecoration(color: Color(0xfffbf9f8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Image.asset("assets/images/logo.png", width: 113, height: 32),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Үндсэн",
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: Color(0xff84807d),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => const WebHomeScreen()));
                  },
                  child: const Text(
                    "Сэтгэл",
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0xff393837),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => const ForumScreen()));
                    navigation.selectTab(1);
                  },
                  child: const Text("Сэтгэлийн гэр",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff393837),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      )),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Контент",
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0xff84807d),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    )),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => const AlbumLecture()));
                    Navigator.pushNamed(context, AlbumPage.routeName);
                  },
                  child: const Text("Цомог",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff393837),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      )),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => Podcast(dataStore: HiveDataStore())));
                    Navigator.pushNamed(context, PodcastPage.routeName);
                  },
                  child: const Text("Подкаст",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff393837),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      )),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoList(isHomeScreen: true)));
                    Navigator.pushNamed(context, VideosPage.routeName);
                  },
                  child: const Text("Видео",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff393837),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      )),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => const ArticleScreen()));
                    Navigator.pushNamed(context, ArticlePage.routeName);
                  },
                  child: const Text("Бичвэр",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff393837),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      )),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Бусад",
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: Color(0xff84807d),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, TermPage.routeName);
                  },
                  child: Text(
                    "Үйлчилгээний нөхцөл",
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0xff393837),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => const FrequentlyQuestions()));
                    Navigator.pushNamed(context, FaqPage.routeName);
                  },
                  child: const Text("Тусламж",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff393837),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      )),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Апп татах",
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: Color(0xff84807d),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(height: 15),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: () {
                      launchUrl(Uri.parse("https://apps.apple.com/us/app/goodali/id1661415299"));
                    },
                    child: Image.asset(
                      "assets/images/app_store.png",
                      width: 140,
                      height: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: () {
                      launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.goodali.mn"));
                    },
                    child: Image.asset(
                      "assets/images/google_play.png",
                      width: 140,
                      height: 40,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
