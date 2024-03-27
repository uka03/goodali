import 'package:flutter/material.dart';
import 'package:goodali/pages/auth/auth_page.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/modals.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';

class NotUser extends StatelessWidget {
  const NotUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                VSpacer(size: 40),
                Image.asset(
                  "assets/images/logo.png",
                  height: 50,
                ),
                VSpacer(size: 30),
                SizedBox(
                  width: 250,
                  child: Text(
                    "Сайн байна уу? Та дээрх үйлдлийг хийхийн тулд нэвтрэх хэрэгтэй.",
                    textAlign: TextAlign.center,
                    style: GoodaliTextStyles.bodyText(context),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                PrimaryButton(
                  height: 50,
                  borderRadius: 20,
                  text: "Нэвтрэх",
                  onPressed: () {
                    showModalSheet(
                      context,
                      isScrollControlled: true,
                      height: MediaQuery.of(context).size.height * 0.88,
                      child: AuthPage(
                        page: "login",
                      ),
                    );
                  },
                ),
                VSpacer(size: 10),
                PrimaryButton(
                  height: 50,
                  backgroundColor: GoodaliColors.inputColor,
                  textColor: GoodaliColors.blackColor,
                  borderRadius: 20,
                  text: "Бүртгүүлэх",
                  onPressed: () {
                    showModalSheet(
                      context,
                      isScrollControlled: true,
                      height: MediaQuery.of(context).size.height * 0.88,
                      child: AuthPage(
                        page: "register",
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
