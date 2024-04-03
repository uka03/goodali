import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/pages/home/components/lecture_card.dart';
import 'package:goodali/pages/home/provider/home_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key, this.id});
  final int? id;
  static String routeName = "/album";

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  late HomeProvider homeProvider;
  List<ProductResponseData?> lectures = [];
  @override
  void initState() {
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      lectures = await homeProvider.getlecture(id: widget.id);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        return GeneralScaffold(
          backgroundColor: GoodaliColors.primaryBGColor,
          appBar: AppbarWithBackButton(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Цомог",
                  style: GoodaliTextStyles.titleText(context, fontSize: 32),
                ),
                VSpacer(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      lectures = await homeProvider.getlecture(id: widget.id);
                      setState(() {});
                    },
                    child: GridView.builder(
                      itemCount: widget.id == null
                          ? provider.lectures?.length ?? 0
                          : lectures.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: kIsWeb ? 1.3 : 0.75,
                        crossAxisCount: kIsWeb ? 4 : 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        ProductResponseData? lecture;
                        if (widget.id != null) {
                          lecture = lectures[index];
                        } else {
                          lecture = provider.lectures?[index];
                        }
                        return Center(
                          child: LectureCard(
                            lecture: lecture,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                VSpacer.xl(),
              ],
            ),
          ),
        );
      },
    );
  }
}
