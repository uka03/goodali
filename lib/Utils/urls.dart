import 'package:goodali/Utils/constans.dart';

class Urls {
  static String host = isStaging
      ? "https://staging.goodali.mn/api"
      : 'https://staging.goodali.mn/api';

  static final signin = "$host/signin";
  static final signup = "$host/signup";
  static final getProducts = "$host/products/";
  // static final getAlbumProducts = "$host/products/0";
  // static final getAlbumLecture = "$host/products/1";
  static final getTrainingDetail = "$host/training_detail";
  static final getMoodList = "$host/get_mood_list";
  static final getMoodMain = "$host/get_mood_main";
  static final getMoodItem = "$host/get_mood_item";
  static final orderRequest = "$host/order";
  static final passwordChange = "$host/password_change";
  static final getArticle = "$host/post_list";
  static final editUserData = "$host/edit_user_data";
  static final lectureList = "$host/lecture_list";
}
