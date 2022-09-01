import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:provider/provider.dart';

class EnableBiometric extends StatefulWidget {
  const EnableBiometric({Key? key}) : super(key: key);

  @override
  State<EnableBiometric> createState() => _EnableBiometricState();
}

class _EnableBiometricState extends State<EnableBiometric> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 5),
            const CircleAvatar(
              radius: 70,
              backgroundColor: MyColors.input,
              child: Icon(Icons.fingerprint,
                  size: 80, color: MyColors.primaryColor),
            ),
            const SizedBox(height: 40),
            const Text(
              "Хурууны хээ / царай таниулах",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: MyColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "Ингэснээр та цаашид хялбар нэвтрэх боломжтой болно.",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: MyColors.gray, height: 1.7, fontSize: 14),
              ),
            ),
            const Spacer(),
            CustomElevatedButton(
                onPress: () {
                  Provider.of<Auth>(context, listen: false).enableBiometric();
                },
                text: "Таниулах"),
            const SizedBox(height: 10),
            TextButton(
                onPressed: () {
                  Provider.of<Auth>(context, listen: false)
                      .firstBiometricScreen();
                },
                child: const Text(
                  "Алгасах",
                  style: TextStyle(
                      color: MyColors.primaryColor,
                      fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
