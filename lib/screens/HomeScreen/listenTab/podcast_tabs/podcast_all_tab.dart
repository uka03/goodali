import 'package:flutter/material.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/podcast_item.dart';

typedef OnTap = Function(Products audioObject);

class PodcastAll extends StatefulWidget {
  final List<Products> podcastList;
  final OnTap onTap;

  const PodcastAll({Key? key, required this.onTap, required this.podcastList})
      : super(key: key);

  @override
  State<PodcastAll> createState() => _PodcastAllState();
}

class _PodcastAllState extends State<PodcastAll> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      RefreshIndicator(
        color: MyColors.primaryColor,
        onRefresh: _refresh,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 13, bottom: 15),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PodcastItem(
                  onTap: (product) => widget.onTap(product),
                  index: index,
                  podcastList: widget.podcastList,
                  podcastItem: widget.podcastList[index],
                ));
          },
          itemCount: widget.podcastList.length,
          separatorBuilder: (BuildContext context, int index) => const Divider(
            endIndent: 18,
            indent: 18,
          ),
        ),
      ),
    ]);
  }

  Future<List<Products>> getPodcastList() {
    return Connection.getPodcastList(context);
  }

  Future<void> _refresh() async {
    setState(() {});
  }
}
