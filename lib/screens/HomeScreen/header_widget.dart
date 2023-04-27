import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodali/Providers/auth_provider.dart';
import 'package:goodali/Providers/cart_provider.dart';
import 'package:goodali/Providers/local_database.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/Widgets/custom_elevated_button.dart';
import 'package:goodali/Widgets/search_bar.dart';
import 'package:goodali/screens/Auth/login_web.dart';
import 'package:goodali/screens/Auth/reset_password.dart';
import 'package:goodali/screens/ForumScreen/forum_screen.dart';
import 'package:goodali/screens/HomeScreen/courseTab/course_tab_web.dart';
import 'package:goodali/screens/HomeScreen/feelTab/feel_tab_web.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_screen.dart';
import 'package:goodali/screens/HomeScreen/listenTab/video_list.dart';
import 'package:goodali/screens/HomeScreen/readTab/article_screen.dart';
import 'package:goodali/screens/ProfileScreen/edit_profile.dart';
import 'package:goodali/screens/ProfileScreen/faQ.dart';
import 'package:goodali/screens/ProfileScreen/profile_screen.dart';
import 'package:goodali/screens/payment/cart_screen.dart';
import 'package:goodali/screens/payment/web_cart_screen.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatelessWidget {
  final bool? isHome;
  final String? title;
  final String? subtitle;
  const HeaderWidget({Key? key, this.title, this.subtitle, this.isHome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 255),
              child: InkWell(
                  onTap: () {
                    if (isHome == false) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                  child: Image.asset("assets/images/title_logo.png", width: 113, height: 32)),
            ),
            Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 60), child: const SearchBar())),
            Builder(
              builder: (BuildContext innerContext) {
                return InkWell(
                  onTap: () {
                    final RenderBox rowRenderBox = innerContext.findRenderObject() as RenderBox;
                    final rowSize = rowRenderBox.size;
                    final rowPosition = rowRenderBox.localToGlobal(Offset.zero);
                    showMenu<String>(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        rowPosition.dx,
                        rowPosition.dy + rowSize.height,
                        MediaQuery.of(context).size.width - rowPosition.dx - rowSize.width - (rowSize.width / 1.25),
                        rowPosition.dy,
                      ),
                      items: [
                        'Цомог',
                        'Подкаст',
                        'Видео',
                        'Бичвэр',
                        'Мүүд',
                        'Онлайн сургалт',
                      ].map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(choice),
                          ),
                        );
                      }).toList(),
                    ).then((String? value) {
                      if (value != null) {
                        if (value == 'Цомог') {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const AlbumLecture()));
                        } else if (value == 'Подкаст') {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => Podcast(dataStore: HiveDataStore())));
                        } else if (value == 'Видео') {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoList(isHomeScreen: true)));
                        } else if (value == 'Бичвэр') {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ArticleScreen()));
                        } else if (value == 'Мүүд') {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const FeelTabbarWeb()));
                        } else if (value == 'Онлайн сургалт') {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseTabbarWeb()));
                        }
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Сэтгэл",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Color(0xff778089),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            )),
                        SizedBox(height: 24, width: 24, child: SvgPicture.asset("assets/images/chevron_down.svg", color: const Color(0xff778089))),
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, right: 60),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ForumScreen()));
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Сэтгэлийн гэр",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0xff778089),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      )),
                ),
              ),
            ),
            Consumer<Auth>(builder: (BuildContext context, value, Widget? child) {
              if (value.isAuth == true) {
                return Row(
                  children: [
                    const WebCartPopupButton(),
                    const SizedBox(width: 30),
                    Builder(
                      builder: (BuildContext innerContext) {
                        return InkWell(
                          onTap: () {
                            final RenderBox rowRenderBox = innerContext.findRenderObject() as RenderBox;
                            final rowSize = rowRenderBox.size;
                            final rowPosition = rowRenderBox.localToGlobal(Offset.zero);
                            showMenu<String>(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                rowPosition.dx,
                                rowPosition.dy + rowSize.height,
                                MediaQuery.of(context).size.width - rowPosition.dx - rowSize.width - (rowSize.width / 1.25),
                                rowPosition.dy,
                              ),
                              items: [
                                'Би',
                                'Миний мэдээлэл',
                                'Пин код солих',
                                'Нийтлэг асуулт хариулт',
                                'Гарах',
                              ].map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(choice),
                                  ),
                                );
                              }).toList(),
                            ).then((String? value) {
                              if (value != null) {
                                if (value == 'Би') {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                                } else if (value == 'Миний мэдээлэл') {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfile()));
                                } else if (value == 'Пин код солих') {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPassword()));
                                } else if (value == 'Нийтлэг асуулт хариулт') {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FrequentlyQuestions()));
                                } else if (value == 'Гарах') {
                                  showLogOutDialog(context);
                                }
                              }
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFBF9F8),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                'assets/images/web_icon_profile.svg',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 30),
                  ],
                );
              } else {
                return Container(
                  margin: const EdgeInsets.only(right: 155),
                  width: 86,
                  height: 36,
                  child: CustomElevatedButton(
                      onPress: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const WebLoginScreen()));
                      },
                      text: "Нэвтрэх"),
                );
              }
            }),
          ],
        ),
        if (title?.isNotEmpty ?? false)
          Container(
            padding: const EdgeInsets.only(left: 255, bottom: 60),
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Color(0xff84807D)),
                children: [
                  TextSpan(
                    text: 'Нүүр',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        if (subtitle?.isNotEmpty ?? false) {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                  ),
                  const TextSpan(text: ' / '),
                  TextSpan(
                    text: title,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        if (subtitle?.isNotEmpty ?? false) {
                          if (isHome == true) {
                            switch (title) {
                              case 'Онлайн сургалт':
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseTabbarWeb()));
                                break;
                              case 'Цомог':
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const AlbumLecture()));
                                break;
                              case 'Видео':
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoList()));
                                break;
                              case 'Бичвэр':
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const ArticleScreen()));
                                break;
                              default:
                                Navigator.pop(context);
                            }
                          } else {
                            Navigator.pop(context);
                          }
                        }
                      },
                  ),
                  if (subtitle?.isNotEmpty ?? false)
                    TextSpan(
                      children: [
                        const TextSpan(text: ' / '),
                        TextSpan(text: subtitle),
                      ],
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  showLogOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Та гарахдаа итгэлтэй байна уу?", textAlign: TextAlign.center, style: TextStyle(color: MyColors.black, fontSize: 18)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "ҮГҮЙ",
                    style: TextStyle(color: MyColors.primaryColor),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Provider.of<Auth>(context, listen: false).logOut(context);
                    Provider.of<CartProvider>(context, listen: false).removeAllProducts();
                  },
                  child: const Text(
                    "ТИЙМ",
                    style: TextStyle(color: MyColors.primaryColor),
                  )),
            ],
          );
        });
  }
}
