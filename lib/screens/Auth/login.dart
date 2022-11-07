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
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginBottomSheet extends StatefulWidget {
  final bool isRegistered;
  const LoginBottomSheet({Key? key, required this.isRegistered})
      : super(key: key);

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Color textFieldColor = MyColors.primaryColor;
  bool isRegistered = true;

  @override
  void initState() {
    isRegistered = widget.isRegistered;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(key: _formKey, child: isRegistered ? login() : register());
  }

  Widget login() {
    final focus = FocusScope.of(context);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          height: MediaQuery.of(context).size.height - 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(Icons.close),
                  color: MyColors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  iconSize: 28,
                ),
              ),
              const SizedBox(height: 20),
              const Text("Нэвтрэх",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: MyColors.black)),
              const SizedBox(height: 50),
              TextFormField(
                controller: emailController,
                cursorColor: MyColors.primaryColor,
                onEditingComplete: () {
                  setState(() {
                    textFieldColor = MyColors.black;
                  });
                  focus.nextFocus();
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: TextStyle(color: textFieldColor),
                decoration: const InputDecoration(
                  hintText: "И-мэйл",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors.border1, width: 0.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: passwordController,
                cursorColor: MyColors.primaryColor,
                onEditingComplete: () {
                  setState(() {
                    FocusManager.instance.primaryFocus?.unfocus();
                    textFieldColor = MyColors.black;
                  });
                },
                obscureText: true,
                maxLength: 4,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                style: TextStyle(color: textFieldColor),
                decoration: const InputDecoration(
                  hintText: "Пин код",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors.border1, width: 0.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors.primaryColor),
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
                      text: TextSpan(
                          text: 'Хаяг байхгүй?',
                          style: const TextStyle(color: MyColors.gray),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Бүртгүүлэх',
                                style: const TextStyle(
                                    color: MyColors.primaryColor,
                                    fontWeight: FontWeight.bold),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()));
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
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  alignment: Alignment.topRight,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.close),
                    color: MyColors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    iconSize: 28,
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Бүртгүүлэх",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: MyColors.black)),
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
                  style: TextStyle(color: textFieldColor),
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
                      borderSide:
                          BorderSide(color: MyColors.border1, width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primaryColor),
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
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: textFieldColor),
                  decoration: const InputDecoration(
                    hintText: "Нууц нэр",
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: MyColors.border1, width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primaryColor),
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
                  decoration: const InputDecoration(
                    hintText: "Пин код",
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: MyColors.border1, width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: MyColors.primaryColor),
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
                      text: TextSpan(
                          text: 'Хаяг байгаа?',
                          style: const TextStyle(color: MyColors.gray),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Нэвтрэх',
                                style: const TextStyle(
                                    color: MyColors.primaryColor,
                                    fontWeight: FontWeight.bold),
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
    var sendData = {
      "email": emailController.text,
      "nickname": nicknameController.text,
      "password": passwordController.text
    };
    print(sendData);
    var data = await Connection.userRegister(context, sendData);
    Navigator.pop(context);
    if (data['success'] == true) {
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
      showTopSnackBar(
          context, CustomTopSnackBar(type: 0, text: data["message"] ?? ""));
      return false;
    }
  }

  userSignin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var sendData = {
      "email": emailController.text,
      "password": passwordController.text
    };
    var data = await Provider.of<Auth>(context, listen: false)
        .login(context, sendData);
    Navigator.pop(context);

    if (data['success'] == true) {
      print("firstbio ${preferences.containsKey("first_biometric")}");
      if (!preferences.containsKey("first_biometric")) {
        Provider.of<Auth>(context, listen: false).canBiometrics();
      }
      Navigator.pop(context, data['userInfo']);
    } else {
      showTopSnackBar(
          context, CustomTopSnackBar(type: 0, text: data['message']));
    }
  }
}
