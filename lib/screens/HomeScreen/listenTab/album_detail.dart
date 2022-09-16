import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Utils/urls.dart';
import 'package:goodali/Widgets/image_view.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/custom_readmore_text.dart';
import 'package:goodali/Widgets/simple_appbar.dart';
import 'package:goodali/models/products_model.dart';
import 'package:goodali/screens/ListItems/album_detail_item.dart';
import 'package:goodali/screens/payment/cart_screen.dart';
import 'package:provider/provider.dart';

class AlbumDetail extends StatefulWidget {
  final Products products;

  const AlbumDetail({Key? key, required this.products}) : super(key: key);

  @override
  State<AlbumDetail> createState() => _AlbumDetailState();
}

class _AlbumDetailState extends State<AlbumDetail> {
  late final Future future = getAlbumLectures();
  late final Future futureLogged = getLectureListLogged();

  ScrollController? _controller;
  double imageSize = 0;
  double initialSize = 180;
  double containerHeight = 270;
  double containerInitialHeight = 270;
  double imageOpacity = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    imageSize = initialSize;

    _controller = ScrollController()
      ..addListener(() {
        imageSize = initialSize - _controller!.offset;
        if (imageSize < 0) {
          imageSize = 0;
        }

        containerHeight = containerInitialHeight - _controller!.offset;
        if (containerHeight < 0) {
          containerHeight = 0;
        }
        imageOpacity = imageSize / initialSize;

        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
        appBar: const SimpleAppBar(),
        body: Consumer<Auth>(
          builder: (context, value, child) {
            return FutureBuilder(
              future: value.isAuth ? futureLogged : future,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  List<Products> lectureList = snapshot.data;
                  return Stack(children: [
                    Container(
                        height: containerHeight,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Container(
                            //     height: imageSize,
                            //     width: imageSize,
                            //     color: Colors.indigo[200]),
                            Opacity(
                              opacity: imageOpacity.clamp(0, 1),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: ImageView(
                                    imgPath: widget.products.banner ?? "",
                                    width: imageSize,
                                    height: imageSize),
                              ),
                            ),
                            const SizedBox(height: 80)
                          ],
                        )),
                    SingleChildScrollView(
                      controller: _controller,
                      physics: const BouncingScrollPhysics(),
                      child: Column(children: [
                        SizedBox(height: initialSize + 32),
                        Text(
                          widget.products.title ?? "",
                          style: const TextStyle(
                              fontSize: 20,
                              color: MyColors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: CustomReadMoreText(
                              text: widget.products.body ?? "",
                              textAlign: TextAlign.center,
                            )),
                        const SizedBox(height: 20),
                        const Divider(endIndent: 20, indent: 20),
                        lecture(context, lectureList),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CustomElevatedButton(
                              text: "Худалдаж авах",
                              onPress: () {
                                cart.addItemsIndex(widget.products.productId!);
                                if (!cart.sameItemCheck) {
                                  cart.addProducts(widget.products);
                                  cart.addTotalPrice(
                                      widget.products.price?.toDouble() ?? 0.0);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CartScreen()));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CartScreen()));
                                }
                              }),
                        ),
                        const SizedBox(height: 50),
                      ]),
                    ),
                  ]);
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: MyColors.primaryColor));
                }
              },
            );
          },
        ));
  }

  Widget lecture(BuildContext context, List<Products> product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 15),
            itemBuilder: (BuildContext context, int index) {
              return AlbumDetailItem(
                  products: product[index],
                  isBought: false,
                  albumName: widget.products.title!,
                  productsList: product);
            },
            itemCount: product.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              endIndent: 18,
              indent: 18,
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Products>> getAlbumLectures() async {
    return await Connection.getAlbumLectures(
        context, widget.products.id.toString());
  }

  Future<List<Products>> getLectureListLogged() async {
    return await Connection.getLectureListLogged(
        context, widget.products.id.toString());
  }
}
