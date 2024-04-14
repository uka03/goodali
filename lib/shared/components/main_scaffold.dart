import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/community/community_page.dart';
import 'package:goodali/pages/home/home_page.dart';
import 'package:goodali/pages/home/home_page_web.dart';
import 'package:goodali/pages/profile/not_login_page.dart';
import 'package:goodali/pages/profile/profile_page.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/navigator_provider.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  static String routeName = "/";

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late AuthProvider authProvider;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authprovider, _) {
      return Consumer<NavigationProvider>(builder: (context, provider, _) {
        List<Widget> widgetOptions = <Widget>[
          kIsWeb ? HomePageWeb() : HomePage(),
          CommunityPage(),
          authprovider.token.isNotEmpty == true ? ProfilePage() : NotUser(),
        ];
        return Scaffold(
          backgroundColor: kIsWeb ? GoodaliColors.primaryColor : GoodaliColors.primaryBGColor,
          body: LayoutBuilder(builder: (context, constraint) {
            if (kIsWeb && constraint.maxWidth <= 1100) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      VSpacer.lg(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/logo_white.png",
                            scale: 16 / 9,
                          ),
                        ],
                      ),
                      VSpacer(),
                      Text(
                        "Та GOODALI аппликашинаа App store болон Google Play - ээс \n татан авж ашиглах боломжтой",
                        style: GoodaliTextStyles.titleText(context, textColor: GoodaliColors.whiteColor),
                        textAlign: TextAlign.center,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                            HSpacer.lg(),
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
                      ),
                    ],
                  ),
                ),
              );
            }
            return SafeArea(child: widgetOptions[provider.selectedTab]);
          }),
          bottomNavigationBar: kIsWeb ? null : bottomBar(provider),
        );
      });
    });
  }

  Container bottomBar(NavigationProvider provider) {
    return Container(
      height: 85,
      color: GoodaliColors.primaryBGColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          bottomBarItem(
            icon: "assets/icons/ic_union.png",
            title: "Сэтгэл",
            index: 0,
            provider: provider,
          ),
          bottomBarItem(
            icon: "assets/icons/ic_soundwave.png",
            title: "Түүдэг гал",
            index: 1,
            provider: provider,
          ),
          bottomBarItem(
            icon: "assets/icons/ic_profile.png",
            title: "Би",
            index: 2,
            provider: provider,
          ),
        ],
      ),
    );
  }

  Expanded bottomBarItem({
    required String icon,
    required String title,
    required int index,
    required NavigationProvider provider,
  }) {
    return Expanded(
      child: CustomButton(
        onPressed: () {
          authProvider.getMe();
          provider.selectTab(index);
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              Image.asset(
                icon,
                height: 30,
                color: provider.selectedTab == index ? GoodaliColors.primaryColor : GoodaliColors.grayColor,
              ),
              VSpacer.sm(),
              Text(
                title,
                style: GoodaliTextStyles.bodyText(
                  context,
                  fontWeight: FontWeight.w500,
                  textColor: provider.selectedTab == index ? GoodaliColors.primaryColor : GoodaliColors.grayColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
