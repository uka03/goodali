import 'package:flutter/material.dart';
import 'package:goodali/Providers/local_database.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/podcast_item.dart';
import 'package:hive_flutter/adapters.dart';

typedef OnTap = Function(Products audioObject);

class NotListenedPodcast extends StatefulWidget {
  final HiveDataStore dataStore;

  const NotListenedPodcast({
    Key? key,
    required this.dataStore,
  }) : super(key: key);

  @override
  State<NotListenedPodcast> createState() => _NotListenedPodcastState();
}

class _NotListenedPodcastState extends State<NotListenedPodcast>
    with AutomaticKeepAliveClientMixin<NotListenedPodcast> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder(
      valueListenable: HiveDataStore.box.listenable(),
      builder: (context, Box box, widget) {
        if (box.length > 0) {
          List<Products> data = [];
          for (int a = 0; a < box.length; a++) {
            Products item = box.getAt(a);
            if (item.position == 0) data.add(item);
          }
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: PodcastItem(
                  index: index,
                  podcastItem: data[index],
                  podcastList: data,
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
