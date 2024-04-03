import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/extensions/string_extensions.dart';
import 'package:goodali/pages/audio/components/audio_controls.dart';
import 'package:goodali/pages/audio/provider/audio_provider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/shared/components/custom_button.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/constants.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:goodali/utils/utils.dart';
import 'package:provider/provider.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({
    super.key,
    this.data,
    this.isSaved = false,
    this.isBought = false,
  });

  static String routeName = "/audio_page";
  final ProductResponseData? data;
  final bool isSaved;
  final bool isBought;

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  late AudioProvider audioProvider;
  PageController? controller;
  @override
  void initState() {
    audioProvider = Provider.of<AudioProvider>(context, listen: false);
    controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
    super.initState();
  }

  _init() async {
    await audioProvider.setAudioPlayer(context, widget.data,
        save: widget.isSaved);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, provider, _) {
        final podcast = widget.data;
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: PageView(
            controller: controller,
            physics: NeverScrollableScrollPhysics(),
            children: [
              SafeArea(
                bottom: false,
                child: Container(
                  padding: EdgeInsets.only(bottom: 30, top: 60),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          VSpacer(),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 80),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 10,
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl:
                                    podcast?.banner?.toUrl() ?? placeholder,
                                fit: BoxFit.cover,
                                height: 190,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16),
                            child: Column(
                              children: [
                                Text(
                                  removeHtmlTags(podcast?.body ?? ""),
                                  style: GoodaliTextStyles.bodyText(context),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                VSpacer.sm(),
                                Text(
                                  widget.isBought
                                      ? podcast?.lectureTitle ?? ""
                                      : podcast?.title ?? "",
                                  textAlign: TextAlign.center,
                                  style: GoodaliTextStyles.titleText(context,
                                      fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            onPressed: () {
                              controller?.nextPage(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.ease);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Image.asset(
                                      "assets/icons/ic_info.png",
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                  VSpacer(
                                    size: 2,
                                  ),
                                  Text(
                                    "Тайлбар",
                                    style: GoodaliTextStyles.bodyText(context),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      StreamBuilder<SeekBarData>(
                        stream: provider.streamController?.stream,
                        builder: (context, snapshot) {
                          final positionData = snapshot.data;
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CustomProgressBar(
                                  progress: positionData?.position,
                                  total: positionData?.duration,
                                  buffered: positionData?.bufferedPosition,
                                  onSeek: (value) {
                                    audioProvider.audioPlayer?.seek(value);
                                  },
                                ),
                              ),
                              VSpacer(size: 20),
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
              ),
              SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomButton(
                          onPressed: () {
                            controller?.previousPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.ease);
                          },
                          child: Image.asset(
                            "assets/icons/ic_arrow_left.png",
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                    VSpacer(),
                    Text(
                      "Тайлбар",
                      style: GoodaliTextStyles.titleText(context, fontSize: 24),
                    ),
                    VSpacer(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: HtmlWidget(
                          podcast?.body ?? "",
                          textStyle: GoodaliTextStyles.bodyText(
                            context,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
