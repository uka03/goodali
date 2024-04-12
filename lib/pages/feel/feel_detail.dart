import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/audio/components/audio_controls.dart';
import 'package:goodali/pages/audio/provider/audio_provider.dart';
import 'package:goodali/pages/feel/provider/feel_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/custom_animation.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

class FeelDetail extends StatefulWidget {
  const FeelDetail({super.key, this.data, this.id});

  final ProductResponseData? data;
  final int? id;

  @override
  State<FeelDetail> createState() => _FeelDetailState();
}

class _FeelDetailState extends State<FeelDetail> {
  late FeelProvider feelProvider;
  late AudioProvider audioProvider;
  late ProductResponseData? data;
  final PageController controller = PageController();

  int pageNumber = 1;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    audioProvider = Provider.of<AudioProvider>(context, listen: false);
    feelProvider = Provider.of<FeelProvider>(context, listen: false);
    audioProvider.setPlayerState(context, GoodaliPlayerState.disposed);
    print(data?.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  _init() {
    feelProvider.getFeelDetail(widget.id ?? data?.id);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    feelProvider.feelDetails = [];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeelProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: GoodaliColors.primaryBGColor,
        appBar: AppbarWithBackButton(
          onleading: () {
            audioProvider.setPlayerState(context, GoodaliPlayerState.disposed);
          },
        ),
        body: SafeArea(
          child: Container(
            margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 155, vertical: 20) : null,
            child: Column(
              children: [
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                  tween: Tween<double>(
                    begin: 0,
                    end: pageNumber / (provider.feelDetails.isEmpty ? 1 : provider.feelDetails.length),
                  ),
                  builder: (context, value, _) => SizedBox(
                    height: 4,
                    child: LinearProgressIndicator(
                      value: value,
                      color: GoodaliColors.primaryColor,
                      backgroundColor: GoodaliColors.borderColor.withOpacity(0.8),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: controller,
                    itemCount: provider.feelDetails.length,
                    onPageChanged: (value) {
                      setState(() {
                        pageNumber = value + 1;
                      });
                    },
                    itemBuilder: (context, index) {
                      final detail = provider.feelDetails[index];
                      if (detail?.audio != "Audio failed to upload") {
                        audioProvider.setAudioPlayer(context, detail);
                      }
                      return Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            detail?.banner != "Image failed to upload"
                                ? Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromRGBO(0, 0, 0, 0.16),
                                            blurRadius: 32,
                                            spreadRadius: 0,
                                            offset: Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          progressIndicatorBuilder: (context, url, progress) {
                                            return customLoader();
                                          },
                                          imageUrl: detail?.banner.toUrl() ?? placeholder,
                                          width: 250,
                                          height: 250,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            VSpacer(size: 40),
                            detail?.audio == "Audio failed to upload"
                                ? HtmlWidget(detail?.body ?? "",
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                    ))
                                : Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(removeHtmlTags(detail?.body ?? "", placeholder: 'Та үүнийг хийгээд үз.'), style: GoodaliTextStyles.bodyText(context)),
                                            VSpacer(),
                                            Text(
                                              data?.title ?? "",
                                              style: GoodaliTextStyles.titleText(
                                                context,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                        StreamBuilder<SeekBarData>(
                                          stream: audioProvider.streamController?.stream,
                                          builder: (context, snapshot) {
                                            final positionData = snapshot.data;
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: CustomProgressBar(
                                                    progress: positionData?.position,
                                                    total: positionData?.duration,
                                                    buffered: positionData?.bufferedPosition,
                                                    onSeek: (value) {
                                                      audioProvider.audioPlayer?.seek(value);
                                                    },
                                                  ),
                                                ),
                                                VSpacer(size: 30),
                                                AudioControls(
                                                  audioProvider: audioProvider,
                                                  positionData: positionData,
                                                )
                                              ],
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      pageNumber != 1
                          ? CustomButton(
                              onPressed: () async {
                                await audioProvider.setPlayerState(context, GoodaliPlayerState.paused);
                                controller.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: GoodaliColors.primaryColor,
                                ),
                                child: Image.asset(
                                  "assets/icons/ic_arrow_left.png",
                                  width: 30,
                                  height: 30,
                                  color: GoodaliColors.whiteColor,
                                ),
                              ),
                            )
                          : SizedBox(),
                      CustomButton(
                        onPressed: () {
                          if (provider.feelDetails.length == pageNumber) {
                            audioProvider.setPlayerState(context, GoodaliPlayerState.disposed);
                            Navigator.pop(context);
                          } else {
                            controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: GoodaliColors.primaryColor,
                          ),
                          child: Text(
                            provider.feelDetails.length == pageNumber ? "Дуусгах" : "Дараах",
                            style: GoodaliTextStyles.titleText(
                              context,
                              textColor: GoodaliColors.whiteColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
