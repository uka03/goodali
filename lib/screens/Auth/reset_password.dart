import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/screens/HomeScreen/header_widget.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword1 = false;
  bool _showPassword2 = false;
  bool _showPassword3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb
          ? null
          : const SimpleAppBar(title: "Пин код солих", noCard: true),
      body: Column(
        children: [
          const Visibility(
            visible: kIsWeb,
            child: HeaderWidget(
              title: 'Пин код солих',
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * (kIsWeb ? 0.4 : 1),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: !_showPassword1,
                            controller: oldPassController,
                            keyboardType: TextInputType.number,
                            cursorColor: MyColors.primaryColor,
                            maxLength: 4,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  _showPassword1
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: MyColors.primaryColor,
                                ),
                                onTap: () {
                                  setState(() {
                                    _showPassword1 = !_showPassword1;
                                  });
                                },
                              ),
                              hintText: 'Одоогийн Пин код',
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: MyColors.border1),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyColors.primaryColor, width: 1.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Пин код оруулна уу';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            obscureText: !_showPassword2,
                            controller: newPassController,
                            keyboardType: TextInputType.number,
                            cursorColor: MyColors.primaryColor,
                            maxLength: 4,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  _showPassword2
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: MyColors.primaryColor,
                                ),
                                onTap: () {
                                  setState(() {
                                    _showPassword2 = !_showPassword2;
                                  });
                                },
                              ),
                              hintText: "Шинэ Пин код",
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: MyColors.border1),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyColors.primaryColor, width: 1.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Пин код оруулна уу';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            obscureText: !_showPassword3,
                            controller: confirmPassController,
                            keyboardType: TextInputType.number,
                            cursorColor: MyColors.primaryColor,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  _showPassword3
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: MyColors.primaryColor,
                                ),
                                onTap: () {
                                  setState(() {
                                    _showPassword3 = !_showPassword3;
                                  });
                                },
                              ),
                              hintText: "Пин код давтах",
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: MyColors.border1),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyColors.primaryColor, width: 1.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Пин код оруулна уу';
                              }
                              if (value != newPassController.text) {
                                return 'Пин код таарахгүй байна';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: (MediaQuery.of(context).size.width * 0.3)),
        child: CustomElevatedButton(
          onPress: () {
            if (_formKey.currentState!.validate()) {
              reset();
              Utils.showLoaderDialog(context);
            }
          },
          text: "Үргэлжлүүлэх",
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  reset() async {
    var sendData = {
      "new_password": newPassController.text,
      'old_password': oldPassController.text
    };

    var data = await Connection.resetPassword(context, sendData);
    Navigator.pop(context);
    if (data['success'] == true) {
      Navigator.pop(context);
      TopSnackBar.successFactory(title: "Амжилттай шинэчлэгдлээ").show(context);
    } else {
      TopSnackBar.errorFactory(msg: data["message"]).show(context);
    }
  }
}
