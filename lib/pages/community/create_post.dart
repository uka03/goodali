import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/colors.dart';
import 'package:goodali/connection/models/tag_response.dart';
import 'package:goodali/pages/auth/components/auth_input.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/community/provider/community_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/utils/modals.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  static String routeName = "/create_post";

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  late final AuthProvider authProvider;
  late final CommunityProvider communityProvider;

  final _formKey = GlobalKey<FormState>();
  bool titleTyping = false;
  bool descTyping = false;

  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    communityProvider = Provider.of<CommunityProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityProvider>(builder: (context, provider, _) {
      return GeneralScaffold(
        appBar: AppbarWithBackButton(title: "Пост нэмэх"),
        bottomBar: kIsWeb
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                child: PrimaryButton(
                  text: "Нийтлэх",
                  isEnable: authProvider.token.isNotEmpty == true,
                  height: 50,
                  textFontSize: 16,
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      onTagModal(tag: provider.tags);
                    }
                  },
                ),
              ),
        child: KeyboardHider(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * (kIsWeb ? 0.4 : 1),
                    height: MediaQuery.of(context).size.height * 0.95,
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Та юу бодож байна?",
                                style: GoodaliTextStyles.titleText(
                                  context,
                                  fontSize: 26,
                                ),
                              ),
                              VSpacer(size: 32),
                              AuthInput(
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                isEmail: false,
                                isTyping: titleTyping,
                                hintText: "Гарчиг",
                                onClose: () {
                                  titleController.clear();
                                  setState(() {
                                    titleTyping = false;
                                  });
                                },
                                maxLength: 30,
                                controller: titleController,
                                onChanged: (value) {
                                  setState(() {
                                    titleTyping = true;
                                  });
                                },
                              ),
                              VSpacer(size: 32),
                              AuthInput(
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                isEmail: false,
                                isTyping: descTyping,
                                hintText: "Үндсэн хэсэг",
                                onClose: () {
                                  descController.clear();
                                  setState(() {
                                    descTyping = false;
                                  });
                                },
                                maxLength: 1200,
                                isExpand: true,
                                controller: descController,
                                onChanged: (value) {
                                  setState(() {
                                    descTyping = true;
                                  });
                                },
                              ),
                            ],
                          ),
                          kIsWeb
                              ? Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: PrimaryButton(
                                        text: "Нийтлэх",
                                        height: 50,
                                        isEnable: authProvider.token.isNotEmpty == true,
                                        textFontSize: 16,
                                        onPressed: () {
                                          if (_formKey.currentState?.validate() == true) {
                                            onTagModal(tag: provider.tags);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text("Та өдөрт 2 удаа пост оруулах эрхтэй.", style: TextStyle(fontSize: 12, color: GoodaliColors.grayColor)),
                                    const SizedBox(height: 30)
                                  ],
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  onTagModal({required List<TagResponseData?> tag}) {
    List<TagResponseData?> selectedTags = [];
    showModalSheet(
      context,
      withExpanded: false,
      isScrollControlled: true,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Холбогдох сэдэв",
                  style: GoodaliTextStyles.titleText(context, fontSize: 24),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 10,
                runSpacing: 10,
                children: tag.map((e) {
                  final isSelected = selectedTags.contains(e);
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedTags.remove(e);
                        } else {
                          if (selectedTags.length >= 3) {
                            selectedTags.removeLast();
                          }
                          selectedTags.add(e);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? GoodaliColors.primaryColor : GoodaliColors.borderColor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? GoodaliColors.primaryColor : null,
                      ),
                      child: Text(
                        e?.name ?? "",
                        style: GoodaliTextStyles.titleText(
                          context,
                          fontSize: 16,
                          textColor: isSelected ? GoodaliColors.whiteColor : GoodaliColors.grayColor,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              VSpacer(),
              PrimaryButton(
                text: "Сонгох",
                height: 50,
                onPressed: () {
                  if (selectedTags.isEmpty) {
                    Toast.error(context, description: "Холбогдох сэдэв сонгоно уу?");
                  } else {
                    Navigator.pop(context);
                    onWherePostModal(selectedTags: selectedTags);
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }

  onWherePostModal({required List<TagResponseData?> selectedTags}) async {
    TypeItem? selectedItem;
    await authProvider.getMe();
    final hasTraining = authProvider.me?.hasTraing;
    showModalSheet(
      context,
      withExpanded: false,
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Хаана постлох вэ?",
                style: GoodaliTextStyles.titleText(context, fontSize: 24),
              ),
            ),
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: fireTypes.map(
                (e) {
                  if (hasTraining == false && e.index == 1) {
                    return SizedBox();
                  }

                  return CustomButton(
                    onPressed: () {
                      setState(() {
                        selectedItem = e;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(e.title),
                          ),
                          HSpacer(size: 10),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: selectedItem?.index == e.index ? GoodaliColors.primaryColor : GoodaliColors.whiteColor,
                              border: Border.all(color: selectedItem?.index == e.index ? GoodaliColors.primaryColor : GoodaliColors.borderColor, width: 2),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                size: 15,
                                color: GoodaliColors.whiteColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
            VSpacer(),
            PrimaryButton(
              text: "Сонгох",
              height: 50,
              onPressed: () async {
                print(selectedItem);
                if (selectedItem == null) {
                  Toast.error(context, description: "Хаана постлох вэ?");
                } else {
                  final respone = await communityProvider.createPost(
                    title: titleController.text,
                    body: descController.text,
                    postType: selectedItem?.index,
                    tags: selectedTags.map((e) => e?.id).toList(),
                  );
                  if (respone.status == 1) {
                    if (context.mounted) {
                      Toast.success(context, description: "Амжилттай пост нийтлэгдлээ.");
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  } else {
                    if (context.mounted) {
                      Toast.error(context, description: "Уучилаарай. Пост нийтлэх явцад алдаа гарлаа.");
                    }
                  }
                }
              },
            )
          ],
        );
      }),
    );
  }
}
