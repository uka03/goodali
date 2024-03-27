import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goodali/pages/album/album_page.dart';
import 'package:goodali/pages/article/article_page.dart';
import 'package:goodali/pages/feel/feel_detail.dart';
import 'package:goodali/pages/lesson/lesson_detail.dart';
import 'package:goodali/pages/podcast/podcast_page.dart';
import 'package:goodali/pages/search/provider/search_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_animation.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/custom_input.dart';
import 'package:goodali/shared/components/empty_state.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  static String routeName = "/search_page";

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Timer? timer;
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, provider, _) {
      return GeneralScaffold(
        appBar: AppbarWithBackButton(),
        child: KeyboardHider(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: CustomInput(
                  iconColor: GoodaliColors.primaryColor,
                  hintText: "Нэрээр хайх",
                  onTap: () {},
                  onChanged: (value) {
                    timer?.cancel();
                    timer = Timer(Duration(milliseconds: 500), () async {
                      if (value.isNotEmpty) {
                        await provider.searchItem(value);
                      }
                    });
                    setState(() {});
                  },
                  controller: searchController,
                ),
              ),
              searchController.text.trim().isNotEmpty
                  ? provider.loading
                      ? customLoader()
                      : provider.items.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: provider.items.length,
                                itemBuilder: (context, index) {
                                  final item = provider.items[index];
                                  return CustomButton(
                                    onPressed: () {
                                      switch (item?.module) {
                                        case "post":
                                          Navigator.pushNamed(
                                              context, ArticlePage.routeName,
                                              arguments: {"id": item?.id});
                                          break;
                                        case "training":
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LessonDetail(
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
                                        case "mood":
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FeelDetail(
                                                  id: item?.id,
                                                ),
                                              ));
                                          break;
                                        case "podcast":
                                          Navigator.pushNamed(
                                              context, PodcastPage.routeName);
                                          break;
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item?.title ?? "",
                                                  style: GoodaliTextStyles
                                                      .titleText(context),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                VSpacer.sm(),
                                                Text(
                                                  item?.module ?? "",
                                                  style: GoodaliTextStyles
                                                      .bodyText(context,
                                                          textColor:
                                                              GoodaliColors
                                                                  .grayColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                          HSpacer(),
                                          Icon(
                                            Icons.keyboard_arrow_right_rounded,
                                            color: GoodaliColors.grayColor,
                                            size: 26,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : EmptyState(
                              title: "Уучлаарай, өөр үгээр хайна уу?",
                            )
                  : EmptyState(
                      imagePath: "assets/images/file_empty.png",
                      title: "Хайлтын түүх байхгүй",
                    ),
            ],
          ),
        ),
      );
    });
  }
}
