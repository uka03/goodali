import 'package:flutter/material.dart';

import '../Utils/styles.dart';

class Info extends StatelessWidget {
  final String? title;
  final String? information;
  const Info({Key? key, this.title, this.information}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title ?? " ",
            style: const TextStyle(fontSize: 12, color: MyColors.gray)),
        const SizedBox(height: 14),
        Text(information ?? " ",
            style: const TextStyle(fontSize: 16, color: MyColors.black)),
        const SizedBox(height: 16),
        const Divider(height: 0.5, color: MyColors.border1),
        const SizedBox(height: 16),
      ],
    );
  }
}
