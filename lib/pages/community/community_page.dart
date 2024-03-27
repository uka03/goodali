import 'package:flutter/material.dart';
import 'package:goodali/connection/models/login_response.dart';
import 'package:goodali/connection/models/post_response.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/community/components/fire_type_bar.dart';
import 'package:goodali/pages/community/components/post_item.dart';
import 'package:goodali/pages/community/create_post.dart';
import 'package:goodali/pages/community/provider/community_provider.dart';
import 'package:goodali/pages/lesson/lessons_page.dart';
import 'package:goodali/shared/components/custom_animation.dart';
import 'package:goodali/shared/components/custom_appbar.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/custom_input.dart';
import 'package:goodali/shared/components/empty_state.dart';
import 'package:goodali/shared/components/filter_page.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/modals.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late CommunityProvider communityProvider;
  late AuthProvider authProvider;
  LoginResponse? me;
  int selectedType = 0;

  @override
  void initState() {
    super.initState();
    communityProvider = Provider.of<CommunityProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final me = await authProvider.getMe();
      if (authProvider.token?.isNotEmpty == true) {
        setState(() {
          this.me = me;
        });
      }
      communityProvider.getTags();
    });
  }

  @override
  void dispose() {
    super.dispose();
    communityProvider.selectedTags.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityProvider>(
      builder: (context, provider, _) {
        return Selector<AuthProvider, bool>(
          selector: (context, auth) => auth.token?.isNotEmpty == true,
          builder: (context, isAuth, _) {
            return DefaultTabController(
              length: fireTypes.length,
              child: KeyboardHider(
                child: GeneralScaffold(
                  appBar: CustomAppbar(
                    title: "Түүдэг гал",
                  ),
                  child: Stack(
                    children: [
                      NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                              pinned: false,
                              expandedHeight: 80,
                              collapsedHeight:
                                  provider.selectedTags.isNotEmpty ? 130 : 90,
                              flexibleSpace: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: CustomInput(
                                      readOnly: true,
                                      controller: TextEditingController(),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, CreatePost.routeName);
                                      },
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Image.asset(
                                            "assets/icons/ic_edit.png",
                                            color: GoodaliColors.grayColor,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      hintText: "Пост нэмэх",
                                    ),
                                  ),
                                  provider.selectedTags.isNotEmpty
                                      ? SizedBox(
                                          height: 50,
                                          child: ListView.separated(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                provider.selectedTags.length,
                                            separatorBuilder:
                                                (context, index) => HSpacer(),
                                            itemBuilder: (context, index) {
                                              final tag =
                                                  provider.selectedTags[index];
                                              return Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: GoodaliColors
                                                                .blackColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 6,
                                                            horizontal: 12),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(tag?.name ?? ""),
                                                        HSpacer(size: 5),
                                                        CustomButton(
                                                          onPressed: () {
                                                            provider
                                                                .removeTag(tag);
                                                          },
                                                          child: Icon(
                                                            Icons.close,
                                                            size: 16,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: FireTypeBar(
                                onChanged: (int index) {
                                  setState(() {
                                    selectedType = index;
                                  });
                                },
                                selectedType: selectedType,
                                typeItems: fireTypes,
                              ),
                            ),
                          ];
                        },
                        body: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            buildItems(
                                getData: provider.getNaturePosts(),
                                provider: provider,
                                isAuth: isAuth,
                                hasTraining: true),
                            buildItems(
                              getData: provider.getSecretPosts(),
                              provider: provider,
                              isAuth: isAuth,
                              hasTraining: me?.hasTraing ?? false,
                              noneTrainingText:
                                  "Та онлайн сургалтанд бүртгүүлснээр \nнууцлалтай ярианд нэгдэх боломжтой",
                            ),
                            buildItems(
                              getData: provider.getMyPosts(),
                              provider: provider,
                              isAuth: isAuth,
                              hasTraining: true,
                              noneTrainingText:
                                  "Ирээдүйн өөртөө зориулж хэлэх үгээ \nта энд үлдээгээрэй. Та онлайн сургалтанд \nхамрагдсанаар дээрх боломж\nнээгдэх юм шүү. ",
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        right: 20,
                        child: CustomButton(
                          onPressed: () {
                            showModalSheet(
                              context,
                              isScrollControlled: true,
                              height: MediaQuery.of(context).size.height * 0.88,
                              withExpanded: true,
                              child: FilterPage(
                                tags: provider.tags,
                                selectedTags: provider.selectedTags,
                                onFinished: (tags) {
                                  provider.setTags(tags);
                                },
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: GoodaliColors.primaryColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Image.asset(
                              "assets/icons/ic_filter.png",
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildItems(
      {required Future<List<PostResponseData?>> getData,
      required CommunityProvider provider,
      required bool isAuth,
      required bool hasTraining,
      String? noneTrainingText}) {
    return isAuth
        ? hasTraining
            ? FutureBuilder<List<PostResponseData?>>(
                future: getData,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.done) {
                    final List<PostResponseData?> filteredPost =
                        provider.filteredPost(snap.data ?? []);
                    return snap.data?.isNotEmpty == true
                        ? ListView.separated(
                            padding: EdgeInsets.all(16),
                            itemCount: filteredPost.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Divider(),
                            ),
                            itemBuilder: (context, index) {
                              final post = filteredPost[index];
                              return PostItem(
                                provider: provider,
                                post: post,
                              );
                            },
                          )
                        : Center(
                            child: EmptyState(
                              title: "Одоогоор энэхүү хэсэг хоосон байна.",
                            ),
                          );
                  } else {
                    return Center(
                      child: customLoader(),
                    );
                  }
                },
              )
            : Center(
                child: Column(
                  children: [
                    EmptyState(
                      title: noneTrainingText ??
                          "Сайн байна уу? Та дээрх үйлдлийг \n хийхийн тулд сургалт авсан байх хэрэгтэй.",
                    ),
                    VSpacer(size: 50),
                    PrimaryButton(
                      width: 300,
                      text: "Сургалт харах",
                      onPressed: () {
                        Navigator.pushNamed(context, LessonsPage.routeName);
                      },
                    )
                  ],
                ),
              )
        : Center(
            child: Column(
              children: const [
                EmptyState(
                  title:
                      "Сайн байна уу? Та дээрх үйлдлийг \n хийхийн тулд нэвтэрсэн  байх хэрэгтэй.",
                ),
              ],
            ),
          );
  }
}
