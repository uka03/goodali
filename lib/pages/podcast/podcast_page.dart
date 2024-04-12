import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/pages/podcast/components/podcast_item.dart';
import 'package:goodali/pages/podcast/provider/podcast_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_appbar.dart';
import 'package:goodali/shared/components/empty_state.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class PodcastPage extends StatefulWidget {
  const PodcastPage({super.key});

  static String routeName = "/podcast_page";

  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  late PodcastProvider podcastProvider;
  @override
  void initState() {
    podcastProvider = Provider.of<PodcastProvider>(context, listen: false);
    podcastProvider.getPodcasts();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PodcastProvider>(builder: (context, provider, _) {
      return DefaultTabController(
        length: 2,
        child: GeneralScaffold(
          appBar: kIsWeb ? CustomWebAppbar() : AppbarWithBackButton() as PreferredSizeWidget,
          child: SafeArea(
            child: Container(
              margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 155) : null,
              child: Column(
                children: [
                  TabBar(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 4,
                    labelPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                    onTap: (value) {},
                    indicatorColor: GoodaliColors.primaryColor,
                    labelColor: GoodaliColors.primaryColor,
                    labelStyle: GoodaliTextStyles.titleText(
                      context,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(text: "Бүгд"),
                      Tab(text: "Сонссон"),
                    ],
                  ),
                  Expanded(
                      child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      buildPodcast(provider.podcasts),
                      buildPodcast(provider.listen, emptyStateText: "Сонссон"),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildPodcast(List<ProductResponseData?> podcasts, {String? emptyStateText}) {
    return podcasts.isNotEmpty
        ? RefreshIndicator(
            onRefresh: () => podcastProvider.getPodcasts(),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: podcasts.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final podcast = podcasts[index];
                return PodcastItem(
                  podcast: podcast,
                  isSaved: true,
                );
              },
            ),
          )
        : EmptyState(
            title: "${emptyStateText ?? ""} Подкаст байхгүй байна.",
          );
  }
}
