import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/auth/components/auth_input.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/shared/components/keyboard_hider.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/modals.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  static String routeName = "/edit";

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late AuthProvider authProvider;
  final name = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? fileImage;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final me = await authProvider.getMe();
      name.text = me?.nickname ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        final me = provider.me;
        return KeyboardHider(
          child: GeneralScaffold(
            appBar: AppbarWithBackButton(),
            child: SingleChildScrollView(
              child: Container(
                margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 155, vertical: 20) : null,
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                height: MediaQuery.of(context).size.height - 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: fileImage == null
                                    ? CachedNetworkImage(
                                        imageUrl: me?.avatar.toUrl(isUser: true) ?? placeholder,
                                        width: 170,
                                        height: 170,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        fileImage!,
                                        width: 170,
                                        height: 170,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              VSpacer(),
                              CustomButton(
                                onPressed: () {
                                  pckerImage(context);
                                },
                                child: Text(
                                  "Зураг солих",
                                  style: GoodaliTextStyles.bodyText(
                                    context,
                                    fontSize: 14,
                                    textColor: GoodaliColors.primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        VSpacer(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "И-мэйл хаяг",
                            style: GoodaliTextStyles.bodyText(
                              context,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        AuthInput(
                          keyboardType: TextInputType.emailAddress,
                          dismiss: true,
                          isTyping: false,
                          onClose: () {},
                          controller: TextEditingController(text: me?.email ?? ""),
                          onChanged: (value) {},
                        ),
                        VSpacer(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Нууц нэр",
                            style: GoodaliTextStyles.bodyText(
                              context,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        AuthInput(
                          keyboardType: TextInputType.name,
                          isTyping: false,
                          onClose: () {},
                          controller: name,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Та өөртөө хүссэн нэрээ өгөөрэй.",
                            style: GoodaliTextStyles.bodyText(context),
                          ),
                        ),
                      ],
                    ),
                    PrimaryButton(
                      isEnable: name.text != me?.nickname || fileImage != null,
                      text: "Хадгалах",
                      borderRadius: 16,
                      onPressed: () async {
                        showLoader();
                        await authProvider.updateUser(context, image: fileImage, name: name.text);
                        dismissLoader();
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  pckerImage(BuildContext context) {
    showModalSheet(
      context,
      // title: "Зураг солих",
      withExpanded: true,
      height: 250,
      child: Column(
        children: [
          VSpacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Зураг солих",
                style: GoodaliTextStyles.titleText(
                  context,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          VSpacer(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: pickerBtn(
                    context,
                    onPressed: () async {
                      final imageFile = await _picker.pickImage(source: ImageSource.camera);
                      if (imageFile != null) {
                        setState(() {
                          fileImage = File(imageFile.path);
                        });
                      }
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    iconPath: "assets/icons/ic_camera.png",
                    title: 'Камер',
                  ),
                ),
                HSpacer(),
                Expanded(
                  child: pickerBtn(
                    context,
                    onPressed: () async {
                      final imageFile = await _picker.pickImage(source: ImageSource.gallery);
                      if (imageFile != null) {
                        setState(() {
                          fileImage = File(imageFile.path);
                        });
                      }
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    iconPath: "assets/icons/ic_image.png",
                    title: 'Галлерей',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomButton pickerBtn(
    BuildContext context, {
    required Function() onPressed,
    required String iconPath,
    required String title,
  }) {
    return CustomButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: GoodaliColors.borderColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                width: 60,
                height: 60,
              ),
              VSpacer.sm(),
              Text(
                title,
                style: GoodaliTextStyles.bodyText(
                  context,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
