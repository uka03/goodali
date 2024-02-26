import 'package:flutter/material.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.easeIn;
  Widget rightButton = const Icon(IconlyLight.arrow_right, color: Colors.white);
  double _current = 0;
  final List<String> imgPath = [
    "assets/images/intro1.png",
    "assets/images/intro2.png",
    "assets/images/intro3.png"
  ];

  final List<String> titles = ["Гоодаль", "Аудио лекц", "Онлайн сургалт"];

  final List<String> descriptions = [
    "Ертөнцийн түгээмэл асуудлуудыг багцалсан лекцийн цомгууд сэтгэл зүрхний тань үнэт зөвлөх болно.",
    "Шилдэг контентуудтай онцлох бүтээл, сүүлийн үеийн цоо шинэ мэдээллүүд таны замд гэрэлт цамхаг болно.",
    "Ертөнцийн түгээмэл асуудлуудыг багцалсан лекцийн цомгууд сэтгэл зүрхний тань үнэт зөвлөх болно."
  ];

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        _current = _pageController.page!;
      });
      if (_current == 2.0) {
        rightButton = const Text("Эхлэх",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold));
      } else {
        rightButton = const Icon(IconlyLight.arrow_right, color: Colors.white);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(alignment: Alignment.topCenter, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
              controller: _pageController,
              itemCount: imgPath.length,
              itemBuilder: ((context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(imgPath[index],
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2 + 50,
                        fit: BoxFit.cover),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Text(titles[index],
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Text(descriptions[index],
                          style: const TextStyle(
                            height: 1.7,
                            fontSize: 16,
                          )),
                    ),
                  ],
                );
              })),
        ),
        // Positioned(
        //   left: 30,
        //   top: MediaQuery.of(context).size.height / 2 + 125,
        //   child: const
        // ),
        // Positioned(
        //   left: 30,
        //   top: MediaQuery.of(context).size.height / 2 + 190,
        //   child: const SizedBox(
        //     width: 320,
        //     child:
        //   ),
        // ),
        _current != 0
            ? Positioned(
                bottom: 32,
                left: 32,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: RawMaterialButton(
                    onPressed: () {
                      _pageController.previousPage(
                          curve: _kCurve, duration: _kDuration);
                    },
                    child:
                        const Icon(IconlyLight.arrow_left, color: Colors.white),
                  ),
                ))
            : Container(),

        Positioned(
            bottom: 32,
            right: 32,
            child: Container(
              height: 50,
              width: _current == 2.0 ? 80 : 50,
              decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(12)),
              child: RawMaterialButton(
                onPressed: () async {
                  _pageController.nextPage(
                      curve: _kCurve, duration: _kDuration);
                  if (_current == 2.0) {
                    Provider.of<Auth>(context, listen: false)
                        .removeIntroScreen(context);
                  }
                },
                child: rightButton,
              ),
            )),
        Positioned(
          bottom: 40,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: imgPath.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _pageController.nextPage(
                    curve: _kCurve, duration: _kDuration),
                child: Container(
                  width: _current.toInt() == entry.key ? 8.0 : 6,
                  height: _current.toInt() == entry.key ? 8.0 : 6,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 6.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.primaryColor.withOpacity(
                          _current.toInt() == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        )
      ]),
    ));
  }
}
