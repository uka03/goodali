import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Utils/utils.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/top_snack_bar.dart';
import 'package:goodali/screens/Auth/forgot_password.dart';
import 'package:goodali/screens/Auth/pincode_changed_success.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBottomSheet extends StatefulWidget {
  final bool isRegistered;
  const LoginBottomSheet({Key? key, required this.isRegistered}) : super(key: key);

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isTyping = false;
  bool isTyping1 = false;
  bool isTyping2 = false;
  bool toRemind = false;

  Color textFieldColor = MyColors.primaryColor;
  bool isRegistered = true;

  @override
  void initState() {
    _checkIsReminded();
    isRegistered = widget.isRegistered;

    super.initState();
  }

  Future<void> _checkIsReminded() async {
    var data = await Provider.of<Auth>(context, listen: false).getUserInfo();

    setState(() {
      if (!isRegistered) {
        toRemind = false;
        emailController.text = "";
      } else if (data["to_remind"]) {
        toRemind = data["to_remind"];
        emailController.text = data["email"];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(key: _formKey, child: isRegistered ? login() : register());
  }

  Widget login() {
    final focus = FocusScope.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          height: MediaQuery.of(context).size.height - 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(color: MyColors.gray, borderRadius: BorderRadius.circular(3)),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: const Icon(
                    Icons.close,
                    color: MyColors.black,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 30),
              const Text("Нэвтрэх", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: MyColors.black)),
              const SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                cursorColor: MyColors.primaryColor,
                onEditingComplete: () {
                  setState(() {
                    textFieldColor = MyColors.black;
                  });
                  focus.nextFocus();
                },
                onChanged: (value) => setState(() => isTyping = true),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: textFieldColor),
                decoration: InputDecoration(
                  hintText: "И-мэйл",
                  suffixIcon: isTyping
                      ? GestureDetector(
                          onTap: () {
                            emailController.text = "";
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
              const SizedBox(height: 20),
              Row(children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                      value: toRemind,
                      fillColor: MaterialStateProperty.all<Color>(MyColors.primaryColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      side: const BorderSide(color: MyColors.border1),
                      splashRadius: 5,
                      onChanged: (bool? value) {
                        setState(() {
                          toRemind = value!;
                        });
                      }),
                ),
                const SizedBox(width: 15),
                const Text("Сануулах", style: TextStyle(color: MyColors.black))
              ]),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                cursorColor: MyColors.primaryColor,
                onEditingComplete: () {
                  setState(() {
                    FocusManager.instance.primaryFocus?.unfocus();
                    textFieldColor = MyColors.black;
                  });
                },
                onChanged: (value) => setState(() => isTyping1 = true),
                obscureText: true,
                maxLength: 4,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                style: TextStyle(color: textFieldColor),
                decoration: InputDecoration(
                  hintText: "Пин код",
                  suffixIcon: isTyping1
                      ? GestureDetector(
                          onTap: () {
                            passwordController.text = "";
                            setState(() {
                              isTyping1 = false;
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
              const Spacer(),
              Column(
                children: [
                  CustomElevatedButton(
                      text: "Нэвтрэх",
                      onPress: () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        Utils.showLoaderDialog(context);
                        userSignin();
                      }),
                  const SizedBox(height: 30),
                  Center(
                    child: RichText(
                      text: TextSpan(text: 'Хаяг байхгүй?', style: const TextStyle(color: MyColors.gray), children: <TextSpan>[
                        TextSpan(
                            text: '  Бүртгүүлэх',
                            style: const TextStyle(color: MyColors.primaryColor, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  isRegistered = false;
                                  emailController.text = "";
                                  passwordController.text = "";
                                  nicknameController.text = "";
                                });
                              })
                      ]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 70),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword()));
                    },
                    child: const Text(
                      "Пин код мартсан",
                      style: TextStyle(color: MyColors.primaryColor),
                    )),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget register() {
    final focus = FocusScope.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          height: MediaQuery.of(context).size.height - 80,
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 40,
                    height: 6,
                    decoration: BoxDecoration(color: MyColors.gray, borderRadius: BorderRadius.circular(3)),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: const Icon(
                      Icons.close,
                      color: MyColors.black,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 30),
                const Text("Бүртгүүлэх", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: MyColors.black)),
                const SizedBox(height: 50),
                TextFormField(
                  controller: emailController,
                  cursorColor: MyColors.primaryColor,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    setState(() {
                      textFieldColor = MyColors.black;
                    });
                    focus.nextFocus();
                  },
                  onChanged: (value) => setState(() => isTyping = true),
                  style: TextStyle(color: textFieldColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Цахим шуудан оруулна уу";
                    }
                    if (isEmailCorrect(value) == false) {
                      return "Цахим шуудан буруу байна";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "И-мэйл",
                    suffixIcon: isTyping
                        ? GestureDetector(
                            onTap: () {
                              emailController.text = "";
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: nicknameController,
                  cursorColor: MyColors.primaryColor,
                  onEditingComplete: () {
                    setState(() {
                      textFieldColor = MyColors.black;
                    });
                    focus.nextFocus();
                  },
                  onChanged: (value) => setState(() => isTyping2 = true),
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: textFieldColor),
                  decoration: InputDecoration(
                    hintText: "Нууц нэр",
                    suffixIcon: isTyping2
                        ? GestureDetector(
                            onTap: () {
                              nicknameController.text = "";
                              setState(() {
                                isTyping2 = false;
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
                const SizedBox(height: 10),
                const Text(
                  "Та өөртөө хүссэн нэрээ өгөөрэй",
                  style: TextStyle(fontSize: 12, color: MyColors.gray),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  cursorColor: MyColors.primaryColor,
                  onChanged: (value) => setState(() => isTyping1 = true),
                  onEditingComplete: () {
                    setState(() {
                      FocusManager.instance.primaryFocus?.unfocus();
                      textFieldColor = MyColors.black;
                    });
                  },
                  validator: (value) {
                    if (value!.length < 4) {
                      return "4 оронтой байх";
                    }
                    if (value.isEmpty) {
                      return "Пин код оруулна уу.";
                    }
                    return null;
                  },
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(color: textFieldColor),
                  decoration: InputDecoration(
                    hintText: "Пин код",
                    suffixIcon: isTyping1
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                isTyping1 = false;
                              });
                              passwordController.text = "";
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
                const Spacer(),
                Column(children: [
                  CustomElevatedButton(
                      text: "Бүртгүүлэх",
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Utils.showLoaderDialog(context);
                          userRegister();
                        }
                      }),
                  const SizedBox(height: 30),
                  Center(
                    child: RichText(
                      text: TextSpan(text: 'Хаяг байгаа?', style: const TextStyle(color: MyColors.gray), children: <TextSpan>[
                        TextSpan(
                            text: '  Нэвтрэх',
                            style: const TextStyle(color: MyColors.primaryColor, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  isRegistered = true;
                                  emailController.text = "";
                                  passwordController.text = "";
                                });
                              })
                      ]),
                    ),
                  ),
                  const SizedBox(height: 160)
                ]),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Future<bool> userRegister() async {
    var sendData = {"email": emailController.text, "nickname": nicknameController.text, "password": passwordController.text};
    var data = await Connection.userRegister(context, sendData);
    Navigator.pop(context);
    if (data['success'] == true) {
      final pref = await SharedPreferences.getInstance();
      pref.remove("toRemind");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const PinCodeChangedSuccess(
                    successText: "Баяр хүргье",
                    descriptionText: "Бүртгэл амжилттай үүслээ.",
                    buttonText: "Эхлэх",
                  )));
      return true;
    } else {
      TopSnackBar.errorFactory(msg: data["message"]).show(context);
      return false;
    }
  }

  userSignin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var sendData = {"email": emailController.text, "password": passwordController.text};
    var data = await Provider.of<Auth>(context, listen: false).login(context, sendData, toRemind: toRemind);
    Navigator.pop(context);

    if (data['success'] == true) {
      if (!preferences.containsKey("first_biometric")) {
        Provider.of<Auth>(context, listen: false).canBiometrics();
      }
      Navigator.pop(context, data['userInfo']);
    } else {
      TopSnackBar.errorFactory(msg: data["message"]).show(context);
    }
  }
}
