import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/album/album_page.dart';
import 'package:goodali/pages/article/article_page.dart';
import 'package:goodali/pages/article/components/article_item.dart';
import 'package:goodali/pages/feel/feel_detail.dart';
import 'package:goodali/pages/home/components/footer_widget.dart';
import 'package:goodali/pages/home/components/home_banner.dart';
import 'package:goodali/pages/home/components/lecture_card.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/lesson/components/Lesson_item.dart';
import 'package:goodali/pages/lesson/lesson_detail.dart';
import 'package:goodali/pages/podcast/components/podcast_item.dart';
import 'package:goodali/pages/podcast/components/podcast_skeleton.dart';
import 'package:goodali/pages/podcast/podcast_page.dart';
import 'package:goodali/pages/video/components/video_item.dart';
import 'package:goodali/pages/video/videos_page.dart';
import 'package:goodali/shared/components/custom_appbar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/custom_title.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

class HomePageWeb extends StatefulWidget {
  const HomePageWeb({super.key});
  static String routeName = "/home_web";
  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  late final HomeProvider _homeProvider;

  int bannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeProvider.getHomeData(isAuth: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, _) {
      return GeneralScaffold(
        appBar: CustomWebAppbar(),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              sliver: SliverToBoxAdapter(
                child: HomeBanner(
                  banners: provider.banners ?? [],
                  bannerIndex: bannerIndex,
                  onChanged: (index) {
                    setState(
                      () {
                        bannerIndex = index;
                      },
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 155),
                  child: Column(
                    children: [
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
                      CustomTitle(
                        title: 'Цомог лекц',
                        onArrowPressed: () {
                          Navigator.pushNamed(context, AlbumPage.routeName);
                        },
                      ),
                      VSpacer(),
                      SizedBox(
                        height: 250,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: getListViewlength(provider.lectures?.length, max: provider.lectures?.length),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          separatorBuilder: (context, index) => HSpacer(),
                          itemBuilder: (context, index) {
                            final lecture = provider.lectures?[index];
                            return LectureCard(lecture: lecture);
                          },
                        ),
                      ),
                      CustomTitle(
                        title: 'Подкаст',
                        onArrowPressed: () {
                          Navigator.pushNamed(context, PodcastPage.routeName);
                        },
                      ),
                      VSpacer(),
                      GridView.builder(
                        padding: EdgeInsets.all(16),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: getListViewlength(provider.moodList?.length, max: 6),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 2,
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final podcast = provider.podcasts?[index];
                          return podcast != null
                              ? PodcastItem(
                                  podcast: podcast,
                                  isSaved: true,
                                )
                              : SizedBox();
                        },
                      ),
                      CustomTitle(
                        title: 'Видео',
                        onArrowPressed: () {
                          Navigator.pushNamed(context, VideosPage.routeName);
                        },
                      ),
                      VSpacer(),
                      GridView.builder(
                        padding: EdgeInsets.all(16),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: getListViewlength(provider.videos?.length, max: 3),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          Navigator.pushNamed(context, ArticlePage.routeName);
                        },
                      ),
                      GridView.builder(
                        padding: EdgeInsets.all(16),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: getListViewlength(provider.articles?.length, max: 6),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1.5,
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final article = provider.articles?[index];
                          return ArticleItem(article: article);
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Мүүд",
                                  style: GoodaliTextStyles.titleText(
                                    context,
                                    fontSize: 24,
                                  ),
                                ),
                                VSpacer(size: 20),
                                provider.moodMain?.isNotEmpty == true
                                    ? SizedBox(
                                        width: 300,
                                        child: PodcastItem(
                                          podcast: provider.moodMain?.first,
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            HSpacer(size: 40),
                            Expanded(
                              child: GridView.builder(
                                padding: EdgeInsets.all(16),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: provider.moodList?.length ?? 0,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.7,
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                                itemBuilder: (context, index) {
                                  final mood = provider.moodList?[index];
                                  return CustomButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FeelDetail(
                                            data: mood,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(80),
                                            child: CachedNetworkImage(
                                              imageUrl: mood?.banner?.toUrl() ?? "",
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.cover,
                                            )),
                                        const SizedBox(height: 10),
                                        Text(
                                          mood?.title ?? "",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: GoodaliColors.blackColor,
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomTitle(
                          title: "Онлайн сургалт",
                        ),
                      ),
                      VSpacer(),
                      GridView.builder(
                        padding: EdgeInsets.all(16),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: getListViewlength(provider.lessons?.length, max: 4),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.all(10),
              sliver: SliverToBoxAdapter(
                child: FooterWidget(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
