import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:goodali/connection/models/faq_response.dart';
import 'package:goodali/pages/auth/provider/auth_provider.dart';
import 'package:goodali/shared/components/appbar_with_back.dart';
import 'package:goodali/shared/components/general_scaffold.dart';
import 'package:goodali/utils/colors.dart';
import 'package:goodali/utils/globals.dart';
import 'package:goodali/utils/spacer.dart';
import 'package:goodali/utils/text_styles.dart';
import 'package:provider/provider.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  static String routeName = "/faq_page";

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  late final AuthProvider authProvider;
  List<FaqResponseData?> faqs = [];

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      showLoader();

      final response = await authProvider.getFaq();
      setState(() {
        faqs = response;
      });
      dismissLoader();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      appBar: AppbarWithBackButton(title: "Нийтлэг асуулт хариулт"),
      child: SafeArea(
        child: Container(
          margin: kIsWeb ? EdgeInsets.symmetric(horizontal: 155) : null,
          child: ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: faqs.length,
            separatorBuilder: (context, index) => VSpacer(size: 0),
            itemBuilder: (context, index) {
              final faq = faqs[index];
              return Theme(
                data: ThemeData().copyWith(
                  dividerColor: Colors.transparent,
                  unselectedWidgetColor: GoodaliColors.primaryColor,
                ),
                child: ExpansionTile(
                  iconColor: GoodaliColors.primaryColor,
                  collapsedIconColor: GoodaliColors.primaryColor,
                  textColor: GoodaliColors.blackColor,
                  expandedAlignment: Alignment.topLeft,
                  collapsedTextColor: GoodaliColors.blackColor,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  title: Text(
                    faq?.question ?? "",
                    style: GoodaliTextStyles.bodyText(context, fontSize: 16, textColor: GoodaliColors.blackColor),
                  ),
                  children: [
                    HtmlWidget(faq?.answer ?? "")
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
