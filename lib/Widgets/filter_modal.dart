import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/models/tag_model.dart';

class FilterModal extends StatefulWidget {
  final VoidCallback onFilter;
  final List<TagModel> tagList;

  const FilterModal({Key? key, required this.onFilter, required this.tagList})
      : super(key: key);

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 6,
                decoration: BoxDecoration(
                    color: MyColors.gray,
                    borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 20),
              const Text("Шүүлтүүр",
                  style: TextStyle(
                      fontSize: 22,
                      color: MyColors.black,
                      fontWeight: FontWeight.bold)),
              Expanded(
                  child: ListView.builder(
                      itemCount: tagList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CheckboxListTile(
                            activeColor: MyColors.primaryColor,
                            checkColor: MyColors.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            side: const BorderSide(color: MyColors.border1),
                            title: Text(
                              tagList[index].name ?? "",
                              style: const TextStyle(color: MyColors.black),
                            ),
                            onChanged: (bool? value) {
                              if (value == true) {
                                setState(() {
                                  if (!checkedTag.contains(tagList[index].id)) {
                                    checkedTag.add(tagList[index].id ?? 0);
                                  }
                                });
                              } else {
                                setState(() {
                                  checkedTag.remove(tagList[index].id);
                                });
                              }
                            },
                            value: checkedTag.contains(tagList[index].id));
                      })),
              CustomElevatedButton(text: "Шүүх", onPress: widget.onFilter),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
