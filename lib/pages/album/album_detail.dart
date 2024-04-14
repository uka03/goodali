import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/Utils/globals.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/pages/cart/cart_page.dart';
import 'package:goodali/pages/cart/provider/cart_provider.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/pages/podcast/components/podcast_item.dart';
import 'package:goodali/shared/components/action_item.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_read_more.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/primary_button.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

class AlbumDetail extends StatefulWidget {
  const AlbumDetail({super.key});
  static String routeName = "/album_detail";

  @override
  State<AlbumDetail> createState() => _AlbumDetailState();
}

class _AlbumDetailState extends State<AlbumDetail> {
  late HomeProvider homeProvider;
  late CartProvider cartProvider;
  late AuthProvider authProvider;
  ProductResponseData? lecture;
  int boughtItemsLenght = 0;
  @override
  void initState() {
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authProvider.getMe();
      _fecthData();
    });
    super.initState();
  }

  _fecthData() async {
    showLoader();
    lecture = ModalRoute.of(context)?.settings.arguments as ProductResponseData?;
    lecture?.albumId = lecture?.productId;
    await homeProvider.getLectureList(lecture);

    setState(() {
      boughtItemsLenght = getBoughtItems();
    });
    dismissLoader();
  }

  onAddToCart() {
    cartProvider.addProduct(lecture);
    Navigator.pushNamed(
      context,
      CartPage.routeName,
    );
  }

  int getBoughtItems() {
    return homeProvider.albumLectures?.where((element) => element?.isBought == true).length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      backgroundColor: GoodaliColors.primaryBGColor,
      bottomBar: lecture?.isBought == true || (lecture?.audioCount ?? 0) <= boughtItemsLenght
          ? SizedBox()
          : authProvider.token.isEmpty == true || authProvider.me?.email?.toLowerCase() == "surgalt9@gmail.com"
              ? SizedBox()
              : Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                  child: PrimaryButton(
                    height: 50,
                    text: "Худалдаж авах",
                    textFontSize: 16,
                    onPressed: () {
                      onAddToCart();
                    },
                  ),
                ),
      appBar: AppbarWithBackButton(
        actions: [
          authProvider.token.isEmpty == true || authProvider.me?.email?.toLowerCase() == "surgalt9@gmail.com"
              ? SizedBox()
              : Consumer<CartProvider>(builder: (context, cartProviderConsumer, _) {
                  return ActionItem(
                    iconPath: 'assets/icons/ic_cart.png',
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartPage.routeName);
                    },
                    isDot: cartProviderConsumer.products.isNotEmpty,
                    count: cartProviderConsumer.products.length,
                  );
                }),
          HSpacer()
        ],
      ),
      child: SafeArea(
        child: Consumer<HomeProvider>(builder: (context, provider, _) {
          return SingleChildScrollView(
            child: Container(
              margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 155) : null,
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: lecture?.banner.toUrl() ?? placeholder,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  VSpacer(size: 30),
                  Text(
                    lecture?.title ?? "",
                    style: GoodaliTextStyles.titleText(
                      context,
                      fontSize: 20,
                    ),
                  ),
                  VSpacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomReadMore(
                      text: removeHtmlTags(lecture?.body ?? ""),
                    ),
                  ),
                  VSpacer(),
                  Divider(height: 0),
                  !kIsWeb
                      ? ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: provider.albumLectures?.length ?? 0,
                          separatorBuilder: (context, index) => Divider(),
                          itemBuilder: (context, index) {
                            final podcast = provider.albumLectures?[index];
                            if (lecture?.isBought == true) {
                              podcast?.isBought = true;
                            }
                            print(podcast?.isBought);
                            return podcast != null ? PodcastItem(podcast: podcast) : SizedBox();
                          },
                        )
                      : GridView.builder(
                          padding: EdgeInsets.all(16),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: provider.albumLectures?.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 2,
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            final podcast = provider.albumLectures?[index];
                            return podcast != null
                                ? PodcastItem(
                                    podcast: podcast,
                                    isSaved: true,
                                  )
                                : SizedBox();
                          },
                        ),
                  VSpacer(size: lecture?.isBought == false ? 100 : 50),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
