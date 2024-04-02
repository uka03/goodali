import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goodali/pages/auth/login_pincode.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/menu/change_password.dart';
import 'package:goodali/pages/menu/faq_page.dart';
import 'package:goodali/pages/menu/term_page.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/modals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/toasts.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  static String routeName = "/menu_page";

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late final AuthProvider authProvider;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: AppbarWithBackButton(),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Тохиргоо",
                    style: GoodaliTextStyles.titleText(
                      context,
                      fontSize: 32,
                    ),
                  ),
                ),
                menuItem(
                  iconPath: "assets/icons/ic_lock.png",
                  title: "Пин код солих",
                  onPressed: () {
                    Navigator.pushNamed(context, ChangePassword.routeName);
                  },
                ),
                menuItem(
                  iconPath: "assets/icons/ic_info_menu.png",
                  title: "Нийтлэг асуулт хариулт",
                  onPressed: () {
                    Navigator.pushNamed(context, FaqPage.routeName);
                  },
                ),
                menuItem(
                  iconPath: "assets/icons/ic_paper.png",
                  title: "Үйлчилгээний нөхцөл",
                  onPressed: () {
                    Navigator.pushNamed(context, TermPage.routeName);
                  },
                ),
                menuItem(
                  iconPath: "assets/icons/ic_trash.png",
                  title: "Бүртгэл устгах",
                  isLogout: true,
                  onPressed: () {
                    showAlertDialog(
                      context,
                      title: Text(
                        "Та бүртгэлээ устгахдаа итгэлтэй байна уу?",
                      ),
                      okText: "Устгах",
                      cancelText: "Буцах",
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      content: Text(
                        "Та бүртгэлээ устгахдаа итгэлтэй байна ?",
                        style:
                            GoodaliTextStyles.bodyText(context, fontSize: 14),
                      ),
                      onOk: () {
                        Navigator.pop(context);
                        showModalSheet(
                          context,
                          isScrollControlled: true,
                          height: MediaQuery.of(context).size.height * 0.88,
                          child: Pincode(
                            onleading: () {},
                            onCompleted: (value) async {
                              final storage = FlutterSecureStorage();
                              final pincode =
                                  await storage.read(key: 'pincode');
                              if (pincode == value) {
                                final response =
                                    await authProvider.accountDelete();
                                if (response && context.mounted) {
                                  authProvider.logout();
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                  Toast.success(context,
                                      description: "Амжилттай устгагдлаа.");
                                }
                              } else {
                                if (context.mounted) {
                                  Toast.error(context,
                                      description: "Пинкод буруу байна.");
                                }
                              }
                            },
                            title: "Бүртгэлээ устгахын тулд Пинкод оруулна уу?",
                            withLeading: false,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            Column(
              children: [
                authProvider.token?.isNotEmpty == true
                    ? menuItem(
                        iconPath: "assets/icons/ic_logout.png",
                        title: "Гарах",
                        isLogout: true,
                        onPressed: () {
                          authProvider.logout();
                          Navigator.pop(context);
                        },
                      )
                    : SizedBox(),
                Text("version 2.0.1")
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget menuItem({
    required String iconPath,
    required String title,
    required VoidCallback onPressed,
    bool isLogout = false,
  }) {
    return CustomButton(
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 30,
              height: 30,
              color: isLogout
                  ? GoodaliColors.errorColor
                  : GoodaliColors.blackColor,
            ),
            HSpacer(size: 20),
            Expanded(
              child: Text(
                title,
                style: GoodaliTextStyles.titleText(
                  context,
                  textColor: isLogout
                      ? GoodaliColors.errorColor
                      : GoodaliColors.blackColor,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: isLogout
                  ? GoodaliColors.errorColor
                  : GoodaliColors.blackColor,
              size: 26,
            )
          ],
        ),
      ),
    );
  }
}
