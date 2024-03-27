import 'package:flutter/material.dart';
import 'package:goodali/connection/dio_client.dart';
import 'package:goodali/connection/models/base_response.dart';
import 'package:goodali/connection/models/post_response.dart';
import 'package:goodali/connection/models/tag_response.dart';

class CommunityProvider extends ChangeNotifier {
  final _dioClient = DioClient();

  List<TagResponseData?> tags = [];
  List<TagResponseData?> selectedTags = [];

  Future<List<PostResponseData?>> getNaturePosts() async {
    final response = await _dioClient.getPost(id: 0);
    if (response.data?.isNotEmpty == true) {
      return response.data ?? [];
    }
    return [];
  }

  Future<List<PostResponseData?>> getSecretPosts() async {
    final response = await _dioClient.getPost(id: 1);
    if (response.data?.isNotEmpty == true) {
      return response.data ?? [];
    }
    return [];
  }

  Future<List<PostResponseData?>> getMyPosts() async {
    final response = await _dioClient.getPost(id: 2);
    if (response.data?.isNotEmpty == true) {
      return response.data ?? [];
    }
    return [];
  }

  Future<bool> postLike({required int id}) async {
    final response = await _dioClient.postLike(id: id);
    return response;
  }

  Future<bool> postDisLike({required int id}) async {
    final response = await _dioClient.postDislike(id: id);
    return response;
  }

  Future<void> getTags() async {
    final response = await _dioClient.getTags();
    if (response.data?.isNotEmpty == true) {
      tags = response.data ?? [];
    }
    notifyListeners();
  }

  void setTags(List<TagResponseData?> tags) {
    selectedTags = tags;
    notifyListeners();
  }

  void removeTag(TagResponseData? tag) {
    selectedTags.remove(tag);
    notifyListeners();
  }

  List<PostResponseData?> filteredPost(List<PostResponseData?> posts) {
    if (selectedTags.isEmpty == true) {
      return posts;
    }
    List<PostResponseData?> filteredPost = [];
    for (var post in posts) {
      if (post?.tags?.isNotEmpty == true) {
        for (var tag in post!.tags!) {
          for (var selectedTag in selectedTags) {
            if (tag?.id == selectedTag?.id) {
              filteredPost.add(post);
            }
          }
        }
      }
    }
    return filteredPost;
  }

  Future<BaseResponse> createPost({
    required String title,
    required String body,
    required int? postType,
    required List<int?> tags,
  }) async {
    final response = await _dioClient.createPost(
      title: title,
      body: body,
      postType: postType,
      tags: tags,
    );
    return response;
  }

  Future<bool> postReply({required String? body, required int? postId}) async {
    final response = await _dioClient.postReply(body: body, postId: postId);
    if (response?.status == 1) {
      return true;
    }
    return false;
  }
}
