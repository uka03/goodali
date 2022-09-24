import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/album_item.dart';
import 'package:provider/provider.dart';

class AlbumLecture extends StatefulWidget {
  const AlbumLecture({Key? key}) : super(key: key);

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
      body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                // snap: true,

                elevation: 0,
                iconTheme: const IconThemeData(color: MyColors.black),
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                    preferredSize:
                        const Size(double.infinity, kToolbarHeight - 10),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20),
                      alignment: Alignment.topLeft,
                      child: const Text("Цомог",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: MyColors.black)),
                    )),
              )
            ];
          },
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Consumer<Auth>(
              builder: (context, value, state) {
                return FutureBuilder(
                    future: value.isAuth ? getalbumListLogged() : getProducts(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        List<Products> albumList = snapshot.data;
                        return albumLecture(context, albumList);
                      } else {
                        return const Center(
                            child: CircularProgressIndicator(
                                color: MyColors.primaryColor));
                      }
                    });
              },
            ),
          )),
    );
  }

  Widget albumLecture(BuildContext context, List<Products> albumList) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: albumList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            mainAxisExtent: 230,
            crossAxisSpacing: 20),
        itemBuilder: (BuildContext context, int index) => Center(
              child: AlbumItem(albumData: albumList[index]),
            ));
  }

  Future<List<Products>> getProducts() {
    return Connection.getProducts(context, "0");
  }

  Future<List<Products>> getalbumListLogged() {
    return Connection.getalbumListLogged(context);
  }
}
