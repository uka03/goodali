import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/screens/Auth/pincode_changed_success.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isTyping = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb ? null : const SimpleAppBar(noCard: true),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              kIsWeb
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 155),
                              child: Image.asset("assets/images/title_logo.png", width: 113, height: 32),
                            ),
                            const Spacer(),
                            InkWell(
                              child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                      text: const TextSpan(children: [
                                    TextSpan(
                                        text: "Хаяг байгаа?",
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xff84807d),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                        )),
                                    TextSpan(
                                        text: " Нэвтрэх",
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          color: Color(0xfff96f5d),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                        )),
                                  ]))),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 145, top: 40),
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        )
                      ],
                    )
                  : Container(),
              Expanded(
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: kIsWeb ? 450 : double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: const Text("Пин код мартсан", style: TextStyle(color: MyColors.black, fontSize: 24, fontWeight: FontWeight.bold))),
                        const SizedBox(height: 20),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text("Та өөрийн и-мэйл хаягаа оруулснаар бид таньруу шинэ пин код илгээх болно.",
                              textAlign: kIsWeb ? TextAlign.start : TextAlign.center, style: TextStyle(color: MyColors.gray)),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: controller,
                          cursorColor: MyColors.primaryColor,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Цахим шуудан оруулна уу";
                            }
                            if (isEmailCorrect(value) == false) {
                              return "Цахим шуудан буруу байна";
                            }
                            return null;
                          },
                          onChanged: (value) => setState(() {
                            isTyping = true;
                          }),
                          decoration: InputDecoration(
                            hintText: "И-мэйл",
                            suffixIcon: isTyping
                                ? GestureDetector(
                                    onTap: () {
                                      controller.text = "";
                                      setState(() {
                                        isTyping = false;
                                      });
                                    },
                                    child: const Icon(Icons.close, color: MyColors.black))
                                : const SizedBox(),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: MyColors.border1),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: MyColors.primaryColor, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        SizedBox(
                          width: kIsWeb ? 176 : double.infinity,
                          child: CustomElevatedButton(
                              onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  Utils.showLoaderDialog(context);
                                  forgotPassword();
                                }
                              },
                              text: "Үргэлжлүүлэх"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future forgotPassword() async {
    var data = await Connection.forgotPassword(context, controller.text);

    Navigator.pop(context);
    if (data != {}) {
      if (data["success"] == true) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PinCodeChangedSuccess()));
      } else {
        TopSnackBar.errorFactory(msg: data["message"] ?? "Алдаа гарлаа дахин оролдоно уу.").show(context);
      }
    }
    return data;
  }
}
