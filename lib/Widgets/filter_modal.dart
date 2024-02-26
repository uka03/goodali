import 'package:flutter/material.dart';
import 'package:goodali/Providers/forum_tag_notifier.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/models/tag_model.dart';
import 'package:provider/provider.dart';

typedef OnTap = Function(List<Map<String, dynamic>> checkTag);

class FilterModal extends StatefulWidget {
  final List<TagModel> tagList;
  final OnTap? onTap;

  const FilterModal({Key? key, required this.tagList, this.onTap})
      : super(key: key);

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  List<Map<String, dynamic>> checkedTagList = [];
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
              const SizedBox(height: 20),
              Consumer<ForumTagNotifier>(
                builder: (context, value, child) {
                  checkedTagList = value.selectedForumNames;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Wrap(
                        children: widget.tagList
                            .map(
                              (e) => InkWell(
                                onTap: () {
                                  var map = {"name": e.name, "id": e.id};

                                  if (!value.selectedTagId.contains(e.id)) {
                                    checkedTagList.add(map);
                                    value.setTags(map);
                                  } else {
                                    value.removeTags(map);
                                  }
                                },
                                child: SizedBox(
                                  height: 45,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(e.name ?? "",
                                            style: const TextStyle(
                                                color: MyColors.black)),
                                        const SizedBox(width: 15),
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: IgnorePointer(
                                            child: Checkbox(
                                                fillColor: MaterialStateProperty
                                                    .all<Color>(
                                                        MyColors.primaryColor),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                side: const BorderSide(
                                                    color: MyColors.border1),
                                                splashRadius: 5,
                                                onChanged: (_) {},
                                                value: value.selectedTagId
                                                    .contains(e.id)),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            )
                            .toList()),
                  );
                },
              ),
              const SizedBox(height: 10),
              CustomElevatedButton(
                  text: "Шүүх",
                  onPress: () {
                    widget.onTap!(checkedTagList);
                  }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
// CheckboxListTile(
//                               contentPadding: EdgeInsets.zero,
//                               activeColor: MyColors.primaryColor,
//                               checkColor: MyColors.primaryColor,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4)),
//                               side: const BorderSide(color: MyColors.border1),
//                               title: Text(
//                                 e.name ?? "",
//                                 style: const TextStyle(color: MyColors.black),
//                               ),
                      