import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/lesson/components/Lesson_item.dart';
import 'package:goodali/pages/menu/menu.dart';
import 'package:goodali/pages/podcast/components/podcast_item.dart';
import 'package:goodali/pages/profile/profile_edit.dart';
import 'package:goodali/pages/profile/provider/profile_provider.dart';
import 'package:goodali/shared/components/action_item.dart';
import 'package:goodali/shared/components/custom_appbar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthProvider authProvider;
  late ProfileProvider profileProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (authProvider.token?.isNotEmpty == true) {
        showLoader();
        await profileProvider.getLectures();
        dismissLoader();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      profileProvider.boughtDatas = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final appbar = kIsWeb
        ? CustomWebAppbar()
        : CustomAppbar(
            title: "Би",
            actions: [
              ActionItem(
                iconPath: "assets/icons/ic_horizontal_dots.png",
                onPressed: () {
                  Navigator.pushNamed(context, MenuPage.routeName);
                },
              ),
              HSpacer(size: 8)
            ],
          ) as PreferredSizeWidget;
    return Scaffold(
      backgroundColor: GoodaliColors.primaryBGColor,
      appBar: appbar,
      body: Consumer<AuthProvider>(
        builder: (context, provider, _) {
          return Consumer<ProfileProvider>(builder: (context, proProvider, _) {
            return RefreshIndicator(
              onRefresh: () async {
                await profileProvider.getLectures();
              },
              color: GoodaliColors.primaryColor,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl:
                                  provider.me?.avatar.toUrl() ?? placeholder,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            ),
                          ),
                          HSpacer(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.me?.nickname ?? "",
                                  style: GoodaliTextStyles.titleText(
                                    context,
                                    fontSize: 20,
                                  ),
                                ),
                                VSpacer.sm(),
                                Text(
                                  provider.me?.email ?? "",
                                  style: GoodaliTextStyles.bodyText(
                                    context,
                                    fontSize: 14,
                                    textColor: GoodaliColors.grayColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          HSpacer(),
                          CustomButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, ProfileEdit.routeName);
                            },
                            child: Text(
                              "Засах",
                              style: GoodaliTextStyles.bodyText(
                                context,
                                fontSize: 14,
                                textColor: GoodaliColors.primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      VSpacer(),
                      proProvider.boughtDatas.isNotEmpty
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: proProvider.boughtDatas.length,
                              itemBuilder: (context, index) {
                                final data = profileProvider.boughtDatas[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VSpacer(),
                                    Text(
                                      data.lectureName,
                                      style: GoodaliTextStyles.titleText(
                                        context,
                                        fontSize: 20,
                                      ),
                                    ),
                                    kIsWeb
                                        ? GridView.builder(
                                            padding: EdgeInsets.all(16),
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: data.items.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio:
                                                  data.isOnline ? 2 : 16 / 8,
                                              crossAxisCount:
                                                  data.isOnline ? 2 : 3,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                            ),
                                            itemBuilder: (context, index) {
                                              final item = data.items[index];
                                              return data.isOnline
                                                  ? LessonItem(
                                                      lesson: item,
                                                      isBought: true,
                                                    )
                                                  : PodcastItem(
                                                      podcast: item,
                                                      isbought: true,
                                                    );
                                            },
                                          )
                                        : ListView.separated(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12),
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: data.items.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    data.isOnline
                                                        ? SizedBox()
                                                        : Divider(),
                                            itemBuilder: (context, index) {
                                              final item = data.items[index];
                                              return data.isOnline
                                                  ? LessonItem(
                                                      lesson: item,
                                                      isBought: true,
                                                    )
                                                  : PodcastItem(
                                                      podcast: item,
                                                      isbought: true,
                                                    );
                                            },
                                          )
                                  ],
                                );
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Divider(),
                                  VSpacer(size: 80),
                                  Image.asset(
                                    "assets/images/file_empty.png",
                                    height: 190,
                                  ),
                                  VSpacer(),
                                  Text(
                                    "Авсан бүтээгдэхүүн байхгүй...",
                                    style: GoodaliTextStyles.bodyText(context,
                                        fontSize: 14),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
