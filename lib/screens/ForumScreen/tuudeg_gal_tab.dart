import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/screens/ForumScreen/create_post_screen.dart';
import 'package:iconly/iconly.dart';

class NuutsBulgem extends StatefulWidget {
  const NuutsBulgem({Key? key}) : super(key: key);

  @override
  State<NuutsBulgem> createState() => _NuutsBulgemState();
}

class _NuutsBulgemState extends State<NuutsBulgem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 280,
            child: Text(
              "Та онлайн сургалтанд бүртгүүлснээр нууцлалтай ярианд нэгдэх боломжтой",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: MyColors.gray),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
              child: const Text(
                "Сургалт харах",
              ),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                  elevation: 0,
                  primary: MyColors.primaryColor)),
        ],
      )),
      floatingActionButton: floatActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget floatActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: MyColors.primaryColor,
            child: IconButton(
              splashRadius: 10,
              onPressed: () {},
              icon: const Icon(IconlyLight.filter, color: Colors.white),
            ),
          ),
          const SizedBox(width: 18),
        ],
      ),
    );
  }
}
