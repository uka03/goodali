import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/screens/Auth/reset_password.dart';
import 'package:goodali/screens/HomeScreen/header_widget.dart';
import 'package:goodali/screens/ProfileScreen/faQ.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool biometric = false;

  @override
  void initState() {
    checkBiometric();
    super.initState();
  }

  Future<void> checkBiometric() async {
    biometric = Provider.of<Auth>(context, listen: false).loginWithBio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb ? null : const SimpleAppBar(noCard: true),
      body: Column(
        children: [
          const Visibility(
            visible: kIsWeb,
            child: HeaderWidget(
              title: 'Тохиргоо',
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * (kIsWeb ? 0.4 : 1),
                child: Column(
                  children: [
                    Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Тохиргоо",
                          style: TextStyle(fontSize: 32, color: MyColors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPassword())),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.fingerprint,
                              color: MyColors.black,
                            ),
                            const SizedBox(width: 20),
                            const Text(
                              "Биометрик",
                              style: TextStyle(fontSize: 16, color: MyColors.black),
                            ),
                            const Spacer(),
                            Switch(
                                value: biometric,
                                activeColor: MyColors.primaryColor,
                                onChanged: (bool newValue) {
                                  setState(() {
                                    biometric = newValue;
                                  });
                                  if (biometric == true) {
                                    Provider.of<Auth>(context, listen: false).enableBiometric(context);
                                  } else {
                                    Provider.of<Auth>(context, listen: false).disableBiometric();
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPassword())),
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Icon(
                              IconlyLight.lock,
                              color: MyColors.black,
                            ),
                            SizedBox(width: 20),
                            Text(
                              "Пин код солих",
                              style: TextStyle(fontSize: 16, color: MyColors.black),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: MyColors.gray),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FrequentlyQuestions())),
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Icon(
                              IconlyLight.info_square,
                              color: MyColors.black,
                            ),
                            SizedBox(width: 20),
                            Text(
                              "Нийтлэг асуулт хариулт",
                              style: TextStyle(fontSize: 16, color: MyColors.black),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: MyColors.gray),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Icon(
                              IconlyLight.paper,
                              color: MyColors.black,
                            ),
                            SizedBox(width: 20),
                            Text(
                              "Үйлчилгээний нөхцөл",
                              style: TextStyle(fontSize: 16, color: MyColors.black),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: MyColors.gray),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: showLogOutDialog,
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Icon(
                              IconlyLight.logout,
                              color: MyColors.black,
                            ),
                            SizedBox(width: 20),
                            Text(
                              "Гарах",
                              style: TextStyle(fontSize: 16, color: MyColors.black),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: MyColors.gray),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        "App version 2.0.1",
                        style: TextStyle(color: MyColors.gray, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showLogOutDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Та гарахдаа итгэлтэй байна уу?", textAlign: TextAlign.center, style: TextStyle(color: MyColors.black, fontSize: 18)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "ҮГҮЙ",
                    style: TextStyle(color: MyColors.primaryColor),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Provider.of<Auth>(context, listen: false).logOut(context);
                    Provider.of<CartProvider>(context, listen: false).removeAllProducts();
                  },
                  child: const Text(
                    "ТИЙМ",
                    style: TextStyle(color: MyColors.primaryColor),
                  )),
            ],
          );
        });
  }
}
