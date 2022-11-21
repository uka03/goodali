import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goodali/Providers/local_database.dart';
import 'package:goodali/Utils/styles.dart';
import 'package:goodali/controller/connection_controller.dart';
import 'package:goodali/models/search_model.dart';
import 'package:goodali/screens/HomeScreen/courseTab/course_detail.dart';
import 'package:goodali/screens/HomeScreen/feelTab/mood_detail.dart';
import 'package:goodali/screens/HomeScreen/listenTab/album.dart';
import 'package:goodali/screens/HomeScreen/listenTab/podcast_screen.dart';
import 'package:goodali/screens/HomeScreen/readTab/article_screen.dart';
import 'package:goodali/screens/blank.dart';

typedef OnSearchChanged = Future<List<String>> Function(String);

class SearchScreen extends SearchDelegate<String> {
  final OnSearchChanged? onSearchChanged;

  List<String> _oldFilters = const [];
  @override
  String get searchFieldLabel => 'Нэрээр хайх';
  final HiveDataStore dataStore = HiveDataStore();

  SearchScreen({String? searchFieldLabel, required this.onSearchChanged})
      : super(searchFieldLabel: searchFieldLabel);

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
          close(context, query);
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MoodDetail(
                                      moodListId:
                                          searchResult[index].id.toString())));
                          break;
                        case 'podcast':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Podcast(
                                        id: searchResult[index].id,
                                        dataStore: dataStore,
                                      )));
                          break;

                        default:
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const Blank()));
                          break;
                      }
                    },
                    title: Text(
                      searchResult[index].title!,
                      maxLines: 2,
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
    return FutureBuilder<List<String>>(
      future: onSearchChanged != null ? onSearchChanged!(query) : null,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) _oldFilters = snapshot.data;
        return ListView.builder(
          itemCount: _oldFilters.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.restore),
              title: Text(_oldFilters[index]),
              onTap: () {
                query = _oldFilters[index];

                showResults(context);
              },
            );
          },
        );
      },
    );
  }

  Future<List<SearchModel>> searchText(BuildContext context, {String? query}) {
    return Connection.getSearchText(context, query: query);
  }
}
