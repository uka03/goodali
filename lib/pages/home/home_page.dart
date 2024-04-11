import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/pages/album/album_page.dart';
import 'package:goodali/pages/article/article_page.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/cart/cart_page.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/feel/feel_detail.dart';
import 'package:goodali/pages/home/components/home_banner.dart';
import 'package:goodali/pages/home/feel_page.dart';
import 'package:goodali/pages/home/lesson_page.dart';
import 'package:goodali/pages/home/listen_page.dart';
import 'package:goodali/pages/home/components/type_bar.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/home/read_page.dart';
import 'package:goodali/pages/lesson/lesson_detail.dart';
import 'package:goodali/pages/podcast/components/podcast_item.dart';
import 'package:goodali/pages/podcast/components/podcast_skeleton.dart';
import 'package:goodali/pages/podcast/podcast_page.dart';
import 'package:goodali/pages/search/search_page.dart';
import 'package:goodali/shared/components/action_item.dart';
import 'package:goodali/shared/components/custom_appbar.dart';
import 'package:goodali/shared/components/custom_input.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String routeName = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  late HomeProvider homeProvider;
  late AuthProvider authProvider;
  int bannerIndex = 0;
  int selectedType = 0;

  @override
  void initState() {
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await authProvider.getMe();
      homeProvider.getHomeData(isAuth: authProvider.token.isNotEmpty);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        final widgets = [
          ListenPage(homeProvider: provider),
          ReadPage(homeProvider: provider),
          FeelPage(homeProvider: provider),
          LessonPage(homeProvider: provider),
        ];

        final appbar = kIsWeb
            ? CustomWebAppbar()
            : CustomAppbar(
                title: "Сэтгэл",
                actions: [
                  authProvider.token.isEmpty == true || authProvider.me?.email?.toLowerCase() == "surgalt9@gmail.com"
                      ? SizedBox()
                      : Consumer<CartProvider>(builder: (context, cartProviderConsumer, _) {
                          return ActionItem(
                            iconPath: 'assets/icons/ic_cart.png',
                            onPressed: () {
                              Navigator.of(context).pushNamed(CartPage.routeName);
                            },
                            isDot: cartProviderConsumer.products.isNotEmpty,
                            count: cartProviderConsumer.products.length,
                          );
                        }),
                  HSpacer()
                ],
              ) as PreferredSizeWidget;

        final banners = provider.banners ?? [];
        return DefaultTabController(
          length: types.length,
          child: KeyboardHider(
            child: GeneralScaffold(
              withSafearea: !kIsWeb,
              backgroundColor: GoodaliColors.primaryBGColor,
              appBar: appbar,
              child: RefreshIndicator(
                onRefresh: () async {
                  await homeProvider.getHomeData(isAuth: authProvider.token.isNotEmpty);
                },
                color: GoodaliColors.primaryColor,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      VSpacer(),
                      HomeBanner(
                        banners: banners,
                        bannerIndex: bannerIndex,
                        onChanged: (index) {
                          setState(
                            () {
                              bannerIndex = index;
                            },
                          );
                        },
                      ),
                      Skeleton(
                        isLoading: provider.specialList.isEmpty == true,
                        skeleton: Container(
                          height: 170,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: PodcastSkeleton(),
                        ),
                        child: Container(
                          height: 160,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.specialList.length,
                            itemBuilder: (context, index) {
                              final item = provider.specialList[index];
                              return PodcastItem(
                                podcast: item,
                                ontap: () {
                                  switch (item?.type) {
                                    case "post":
                                      Navigator.pushNamed(context, ArticlePage.routeName, arguments: {
                                        "id": item?.id
                                      });
                                      break;
                                    case "training":
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LessonDetail(
                                              id: item?.id,
                                            ),
                                          ));
                                      break;
                                    case "album":
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AlbumPage(
                                              id: item?.id,
                                            ),
                                          ));
                                      break;
                                    case "lecture":
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AlbumPage(
                                              id: item?.albumId,
                                            ),
                                          ));
                                      break;
                                    case "mood":
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FeelDetail(
                                              id: item?.id,
                                            ),
                                          ));
                                      break;
                                    case "podcast":
                                      Navigator.pushNamed(context, PodcastPage.routeName);
                                      break;
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      VSpacer(size: 14),
                      mobileHome(context, widgets),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Column mobileHome(BuildContext context, List<StatelessWidget> widgets) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CustomInput(
            readOnly: true,
            onTap: () {
              Navigator.pushNamed(context, SearchPage.routeName);
            },
            controller: controller,
          ),
        ),
        VSpacer(),
        TypeBar(
          selectedType: selectedType,
          onChanged: (int index) {
            setState(() {
              selectedType = index;
            });
          },
          typeItems: types,
        ),
        Divider(height: 0),
        VSpacer(),
        widgets[selectedType],
        VSpacer(),
      ],
    );
  }
}
