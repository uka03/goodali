import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/screens/Auth/enable_biometric.dart';
import 'package:goodali/screens/Auth/reset_password.dart';
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
    biometric = Provider.of<Auth>(context, listen: false).checkBiometric();
    print("biometric $biometric");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Тохиргоо",
                style: TextStyle(
                    fontSize: 32,
                    color: MyColors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              leading: const Icon(
                Icons.fingerprint,
                color: MyColors.black,
                size: 28,
              ),
              title: const Text(
                "Биометрик",
                style: TextStyle(fontSize: 16, color: MyColors.black),
              ),
              trailing: Switch(
                  value: biometric,
                  onChanged: (bool newValue) {
                    setState(() {
                      biometric = newValue;
                    });
                    if (biometric == true) {
                      Provider.of<Auth>(context, listen: false)
                          .enableBiometric();
                    } else {
                      Provider.of<Auth>(context, listen: false)
                          .disableBiometric();
                    }
                  }),
            ),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResetPassword()));
                },
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                leading: const Icon(
                  IconlyLight.lock,
                  color: MyColors.black,
                  size: 28,
                ),
                title: const Text(
                  "Пин код солих",
                  style: TextStyle(fontSize: 16, color: MyColors.black),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded)),
            ListTile(
                onTap: () {},
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                leading: const Icon(
                  IconlyLight.info_square,
                  color: MyColors.black,
                  size: 28,
                ),
                title: const Text(
                  "Нийтлэг асуулт хариулт",
                  style: TextStyle(fontSize: 16, color: MyColors.black),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded)),
            ListTile(
                onTap: () {},
                leading: const Icon(
                  IconlyLight.paper,
                  color: MyColors.black,
                  size: 28,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                title: const Text(
                  "Үйлчилгээний нөхцөл",
                  style: TextStyle(fontSize: 16, color: MyColors.black),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded)),
            const Spacer(),
            ListTile(
                onTap: () {
                  showLogOutDialog();
                },
                leading: const Icon(
                  IconlyLight.logout,
                  color: MyColors.black,
                  size: 28,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                title: const Text(
                  "Гарах",
                  style: TextStyle(fontSize: 16, color: MyColors.black),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded)),
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
    );
  }

  showLogOutDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Та гарахдаа итгэлтэй байна уу?",
                textAlign: TextAlign.center,
                style: TextStyle(color: MyColors.black, fontSize: 18)),
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
