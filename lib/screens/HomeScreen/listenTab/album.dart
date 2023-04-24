import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/HomeScreen/header_widget.dart';
import 'package:goodali/screens/ListItems/album_item.dart';
import 'package:provider/provider.dart';

class AlbumLecture extends StatefulWidget {
  final int? id;
  final int? productType;
  final int? productID;
  const AlbumLecture({Key? key, this.id, this.productType, this.productID}) : super(key: key);

  @override
  State<AlbumLecture> createState() => _AlbumLectureState();
}

class _AlbumLectureState extends State<AlbumLecture> {
  @override
  void initState() {
    super.initState();
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
              title: 'Нүүр / Цомог',
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              // physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: kIsWeb ? 255 : 20),
                    alignment: Alignment.topLeft,
                    child: const Text("Цомог", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: MyColors.black)),
                  ),
                  const SizedBox(height: 20),
                  Consumer<Auth>(
                    builder: (context, value, state) {
                      return FutureBuilder(
                          future: value.isAuth ? getalbumListLogged() : getProducts(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                              List<Products> albumList = snapshot.data;
                              List<Products> searchResult = [];
                              List<Products> banner = [];
                              if (widget.id != null) {
                                for (var item in albumList) {
                                  if (widget.id == item.id) {
                                    searchResult.add(item);
                                  }
                                  if (widget.productID == item.productId) {
                                    banner.add(item);
                                  }
                                }
                              }
                              return albumLecture(
                                  context,
                                  widget.productID != null
                                      ? banner
                                      : widget.id != null
                                          ? searchResult
                                          : albumList);
                            } else {
                              return const Center(child: CircularProgressIndicator(color: MyColors.primaryColor));
                            }
                          });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget albumLecture(BuildContext context, List<Products> albumList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 255 : 20),
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: albumList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              // childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.3),
              childAspectRatio: kIsWeb ? 0.5 : 1 / 1.6,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              crossAxisCount: kIsWeb ? 6 : 2),
          itemBuilder: (BuildContext context, int index) => AlbumItem(albumData: albumList[index])),
    );
  }

  Future<List<Products>> getProducts() {
    return Connection.getProducts(context, "0");
  }

  Future<List<Products>> getalbumListLogged() {
    return Connection.getalbumListLogged(context);
  }
}
