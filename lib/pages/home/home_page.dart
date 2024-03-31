import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/album/album_page.dart';
import 'package:goodali/pages/article/article_page.dart';
import 'package:goodali/pages/article/components/article_item.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/cart/cart_page.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/feel/feel_detail.dart';
import 'package:goodali/pages/home/components/footer_widget.dart';
import 'package:goodali/pages/home/components/home_banner.dart';
import 'package:goodali/pages/home/components/lecture_card.dart';
import 'package:goodali/pages/home/feel_page.dart';
import 'package:goodali/pages/home/lesson_page.dart';
import 'package:goodali/pages/home/listen_page.dart';
import 'package:goodali/pages/home/components/type_bar.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/home/read_page.dart';
import 'package:goodali/pages/lesson/components/Lesson_item.dart';
import 'package:goodali/pages/podcast/components/podcast_item.dart';
import 'package:goodali/pages/podcast/podcast_page.dart';
import 'package:goodali/pages/search/search_page.dart';
import 'package:goodali/pages/video/components/video_item.dart';
import 'package:goodali/pages/video/videos_page.dart';
import 'package:goodali/shared/components/action_item.dart';
import 'package:goodali/shared/components/custom_appbar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/custom_input.dart';
import 'package:goodali/shared/components/custom_title.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

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
      homeProvider.getHomeData(isAuth: authProvider.token?.isNotEmpty);
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
                  Consumer<CartProvider>(
                      builder: (context, cartProviderConsumer, _) {
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
                  await homeProvider.getHomeData(
                      refresh: true, isAuth: authProvider.token?.isNotEmpty);
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
                      VSpacer(size: 14),
                      kIsWeb
                          ? Column(
                              children: [
                                VSpacer(),
                                VSpacer(size: 50),
                                Column(
                                  children: [
                                    CustomTitle(
                                      title: 'Цомог лекц',
                                      onArrowPressed: () {
                                        Navigator.pushNamed(
                                            context, AlbumPage.routeName);
                                      },
                                    ),
                                    VSpacer(),
                                    SizedBox(
                                      height: 250,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: getListViewlength(
                                            provider.lectures?.length,
                                            max: provider.lectures?.length),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        separatorBuilder: (context, index) =>
                                            HSpacer(),
                                        itemBuilder: (context, index) {
                                          final lecture =
                                              provider.lectures?[index];
                                          return LectureCard(lecture: lecture);
                                        },
                                      ),
                                    ),
                                    CustomTitle(
                                      title: 'Подкаст',
                                      onArrowPressed: () {
                                        Navigator.pushNamed(
                                            context, PodcastPage.routeName);
                                      },
                                    ),
                                    VSpacer(),
                                    GridView.builder(
                                      padding: EdgeInsets.all(16),
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: getListViewlength(
                                          homeProvider.moodList?.length,
                                          max: 6),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 2,
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                      ),
                                      itemBuilder: (context, index) {
                                        final podcast =
                                            provider.podcasts?[index];
                                        return podcast != null
                                            ? PodcastItem(podcast: podcast)
                                            : SizedBox();
                                      },
                                    ),
                                    CustomTitle(
                                      title: 'Видео',
                                      onArrowPressed: () {
                                        Navigator.pushNamed(
                                            context, VideosPage.routeName);
                                      },
                                    ),
                                    VSpacer(),
                                    GridView.builder(
                                      padding: EdgeInsets.all(16),
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: getListViewlength(
                                          provider.videos?.length,
                                          max: 3),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 1,
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                      ),
                                      itemBuilder: (context, index) {
                                        final video = provider.videos?[index];
                                        return VideoItem(video: video);
                                      },
                                    ),
                                    Container(),
                                    CustomTitle(
                                      title: "Бичвэр",
                                      onArrowPressed: () {
                                        Navigator.pushNamed(
                                            context, ArticlePage.routeName);
                                      },
                                    ),
                                    GridView.builder(
                                      padding: EdgeInsets.all(16),
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: getListViewlength(
                                          homeProvider.moodList?.length,
                                          max: 6),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 2,
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                      ),
                                      itemBuilder: (context, index) {
                                        final article =
                                            homeProvider.articles?[index];
                                        return ArticleItem(article: article);
                                      },
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: GoodaliColors.inputColor,
                                      ),
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Мүүд",
                                                style:
                                                    GoodaliTextStyles.titleText(
                                                  context,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              VSpacer(size: 20),
                                              provider.moodMain?.isNotEmpty ==
                                                      true
                                                  ? SizedBox(
                                                      width: 300,
                                                      child: PodcastItem(
                                                        podcast: provider
                                                            .moodMain?.first,
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                          HSpacer(size: 40),
                                          Expanded(
                                            child: GridView.builder(
                                              padding: EdgeInsets.all(16),
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: homeProvider
                                                      .moodList?.length ??
                                                  0,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 0.7,
                                                crossAxisCount: 4,
                                                mainAxisSpacing: 10,
                                                crossAxisSpacing: 10,
                                              ),
                                              itemBuilder: (context, index) {
                                                final mood = homeProvider
                                                    .moodList?[index];
                                                return CustomButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            FeelDetail(
                                                          data: mood,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Column(
                                                    children: [
                                                      ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(80),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: mood
                                                                    ?.banner
                                                                    ?.toUrl() ??
                                                                "",
                                                            width: 150,
                                                            height: 150,
                                                            fit: BoxFit.cover,
                                                          )),
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(
                                                        mood?.title ?? "",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: GoodaliColors
                                                              .blackColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: CustomTitle(
                                        title: "Онлайн сургалт",
                                      ),
                                    ),
                                    VSpacer(),
                                    GridView.builder(
                                      padding: EdgeInsets.all(16),
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: getListViewlength(
                                          provider.lessons?.length,
                                          max: 4),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 16 / 8,
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                      ),
                                      itemBuilder: (context, index) {
                                        final lesson = provider.lessons?[index];
                                        return LessonItem(lesson: lesson);
                                      },
                                    )
                                  ],
                                ),
                                VSpacer(),
                                FooterWidget()
                              ],
                            )
                          : mobileHome(context, widgets),
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
