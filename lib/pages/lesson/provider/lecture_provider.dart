import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/models/base_response.dart';
import 'package:goodali/connection/models/course_response.dart';
import 'package:goodali/connection/models/membership_response.dart';
import 'package:goodali/connection/models/product_response.dart';
import 'package:goodali/utils/globals.dart';

class LessonProvider extends ChangeNotifier {
  final _dioClient = DioClient();
  List<ProductResponseData?> lessons = List.empty(growable: true);
  List<MemberShipResponse> courses = List.empty(growable: true);
  List<CourseItemResponse> courseItems = List.empty(growable: true);
  List<LessonResponse> coursesLessons = List.empty(growable: true);
  List<TaskResponse> coursesTasks = List.empty(growable: true);

  getLessons() async {
    showLoader();
    final response = await _dioClient.getProduct("2");
    if (response.isNotEmpty == true) {
      lessons = response;
    }
    dismissLoader();
    notifyListeners();
  }

  getCourses({int? id}) async {
    showLoader();
    final response = await _dioClient.getCourses(id: id);
    if (response.isNotEmpty == true) {
      courses = response;
    }
    dismissLoader();
    notifyListeners();
  }

  getCourseItems({int? id}) async {
    courseItems = [];
    showLoader();
    final response = await _dioClient.getCourseItems(id: id);
    if (response.isNotEmpty == true) {
      courseItems = response;
    }
    dismissLoader();
    notifyListeners();
  }

  getCoursesLessons({int? id}) async {
    coursesLessons = [];
    showLoader();
    final response = await _dioClient.getCoursesLessons(id: id);
    if (response.isNotEmpty == true) {
      coursesLessons = response;
    }
    dismissLoader();
    notifyListeners();
  }

  Future<void> getTasks(int? id) async {
    showLoader();
    final response = await _dioClient.getCoursesTasks(id: id);
    if (response.isNotEmpty == true) {
      coursesTasks = response;
    }
    dismissLoader();
    notifyListeners();
  }

  Future<BaseResponse> setAnswer({int? id, required String answer}) async {
    final response = await _dioClient.setAnswer(id: id, answer: answer);

    return response;
  }
}
