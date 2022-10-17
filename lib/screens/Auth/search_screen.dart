import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/search_model.dart';
import 'package:goodali/screens/HomeScreen/courseTab/course_detail.dart';
import 'package:goodali/screens/HomeScreen/feelTab/mood_detail.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_screen.dart';
import 'package:goodali/screens/HomeScreen/readTab/article_screen.dart';
import 'package:goodali/screens/blank.dart';

class SearchScreen extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Нэрээр хайх';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      applyElevationOverlayColor: true,
      textTheme: const TextTheme(
        headline6: TextStyle(fontSize: 16.0, color: MyColors.gray),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          color: MyColors.black,
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        color: MyColors.black,
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: searchText(context, query: query),
      builder:
          (BuildContext context, AsyncSnapshot<List<SearchModel>> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          List<SearchModel> searchResult = snapshot.data ?? [];
          if (searchResult.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset("assets/images/search_no_result.svg"),
                  const SizedBox(height: 10),
                  const Text(
                    "Уучлаарай, өөр үгээр хайна уу?",
                    style: TextStyle(color: MyColors.gray),
                  )
                ],
              ),
            );
          } else {
            return ListView.builder(
                itemCount: searchResult.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      switch (searchResult[index].module) {
                        case 'post':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ArticleScreen(
                                        id: searchResult[index].id,
                                      )));
                          break;
                        case 'training':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CourseDetail(
                                      id: searchResult[index].id)));
                          break;
                        case 'album':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AlbumLecture(
                                      id: searchResult[index].id)));
                          break;
                        case 'mood':
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (_) => MoodDetail(
                                      moodListId:
                                          searchResult[index].id.toString())));
                          break;
                        case 'podcast':
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      Podcast(id: searchResult[index].id)));
                          break;

                        default:
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(builder: (_) => const Blank()));
                          break;
                      }
                    },
                    title: Text(
                      searchResult[index].title!,
                      style: const TextStyle(color: MyColors.black),
                    ),
                    subtitle: Text(searchResult[index].module!),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        color: MyColors.gray, size: 20),
                  );
                });
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(color: MyColors.primaryColor),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: SvgPicture.asset("assets/images/no_search_history.svg"),
    );
  }

  Future<List<SearchModel>> searchText(BuildContext context, {String? query}) {
    return Connection.getSearchText(context, query: query);
  }
}
