import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(noCard: true),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            const SizedBox(height: 20),
            const Text("Пин код мартсан",
                style: TextStyle(
                    color: MyColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Та и-мэйл хаягаа оруулна уу",
                style: TextStyle(color: MyColors.gray)),
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
              },
              decoration: const InputDecoration(
                hintText: "И-мэйл",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MyColors.border1, width: 0.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MyColors.primaryColor),
                ),
              ),
            )
          ]),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomElevatedButton(
            onPress: () {
              if (_formKey.currentState!.validate()) {
                Utils.showLoaderDialog(context);
                forgotPassword();
              }
            },
            text: "Үргэлжлүүлэх"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future forgotPassword() async {
    var data = await Connection.forgotPassword(context, controller.text);

    Navigator.pop(context);
    if (data != {}) {
      if (data["success"] == true) {
        showTopSnackBar(
            context,
            const CustomTopSnackBar(
                type: 1, text: "   Шинэ нууц үг и-мэйлээр илгээгдлээ"));
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        showTopSnackBar(
            context,
            CustomTopSnackBar(
                type: 0,
                text:
                    data["message"] ?? "   Алдаа гарлаа, дахин оролдоно уу."));
      }
    }
    return data;
  }
}
