import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_app/models/delete_post/delete_post_request.dart';
import 'package:instagram_app/models/get_all_photo_another_user/get_all_photo_another_user_request.dart';
import 'package:instagram_app/models/get_all_photo_another_user/get_all_photo_another_user_response.dart';
import 'package:instagram_app/models/like_post/like_post_request.dart';
import 'package:instagram_app/models/like_post/like_post_response.dart';

import 'package:instagram_app/models/list_posts_home/list_posts_home_response.dart';
import 'package:instagram_app/models/list_story/list_story_response.dart';

import '../../../api_http/handle_api.dart';
import '../../../models/another_user_profile/another_profile_response.dart';
import '../../../models/another_user_profile/another_user_profile_request.dart';
import '../../../models/delete_post/delete_post_response.dart';
import '../../../models/list_comments_post/list_comments_post_request.dart';
import '../../../models/list_comments_post/list_comments_post_response.dart';
import '../../../models/user_profile/profile_response.dart';
import '../../../util/global.dart';
import '../another_profile_screen/another_profile_screen.dart';
import 'comments_screen/comments_view.dart';
import 'infor_account_screen/infro_account_view.dart';

class HomeController extends GetxController {
  File? avatar;
  bool isNewUpdate = false;
  String userId = "";
  bool isLoading = false;
  String phone = "";
  bool isLike = false;
  bool hideLike = false;
  bool hideCmt = false;
  String userIdForLoadListAnotherProfile = "";
  String postIdForLikePost = "";
  String postIdForDeletePost = "";

  @override
  void onReady() {
    getListPosts();
    getListStories();
    loadUserProfile();
    update();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void loadListPhotoAnotherUser() {
    GetAllPhotoAnotherUserRequest anotherUserRequest =
        GetAllPhotoAnotherUserRequest(userIdForLoadListAnotherProfile);
    getListPhotoAnOtherUser(anotherUserRequest);
    update();
  }

  void loadAnotherProfile() {
    AnotherUserProfileRequest anotherProfileRequest =
        AnotherUserProfileRequest(userIdForLoadListAnotherProfile);
    loadAnotherUserProfile(anotherProfileRequest);
    update();
    if (Global.anOtherUserProfileResponse != null) {
      Get.to(() => const AnOtherProfileScreen());
    }
  }

  void loadAnotherProfileForInfoAnotherUser() {
    AnotherUserProfileRequest anotherProfileRequest =
        AnotherUserProfileRequest(userIdForLoadListAnotherProfile);
    loadAnotherUserProfile(anotherProfileRequest);
    update();
    if (Global.anOtherUserProfileResponse != null) {
      Get.to(() => InForAccountScreen(isMyAccount: false));
    }
  }

  void handleLikePost() {
    LikePostRequest likePostRequest = LikePostRequest(postIdForLikePost);
    likePost(likePostRequest);
    update();
  }

  void handleDeletePost() {
    DeletePostRequest deletePostRequest =
        DeletePostRequest(postIdForDeletePost);
    deletePost(deletePostRequest);
    update();
  }

  /// call api list post
  Future<ListPostsHomeResponse> getListPosts() async {
    isLoading = true;
    update();
    ListPostsHomeResponse listPostsHomeResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse("http://14.225.204.248:8080/api/photo/homepage-posts"),
          RequestType.post,
          headers: null,
          body: null);
    } catch (error) {
      debugPrint("Fail to get list posts $error");
      rethrow;
    }
    if (body == null) return ListPostsHomeResponse.buildDefault();
    //get data from api here
    listPostsHomeResponse = ListPostsHomeResponse.fromJson(body);
    if (listPostsHomeResponse.status == true) {
      debugPrint("------------- GET LIST POST SUCCESSFULLY--------------");
      Global.listPostInfo = listPostsHomeResponse.data!;
      await Future.delayed(const Duration(seconds: 1), () {});
      isLoading = false;
      update();
    }
    return listPostsHomeResponse;
  }

  /// call api list post when liked
  Future<ListPostsHomeResponse> getListPostsWhenLiked() async {
    ListPostsHomeResponse listPostsHomeResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse("http://14.225.204.248:8080/api/photo/homepage-posts"),
          RequestType.post,
          headers: null,
          body: null);
    } catch (error) {
      debugPrint("Fail to get list posts $error");
      rethrow;
    }
    if (body == null) return ListPostsHomeResponse.buildDefault();
    //get data from api here
    listPostsHomeResponse = ListPostsHomeResponse.fromJson(body);
    if (listPostsHomeResponse.status == true) {
      //dataPostsResponse = listPostsHomeResponse.data!;
      Global.listPostInfo = listPostsHomeResponse.data!;
      update();
    }
    return listPostsHomeResponse;
  }

  // /// refresh
  Future<void> refreshData() async {
    isNewUpdate = false;
    update();
    getListPosts();
    getListStories();
  }

  /// pull to refresh
  Future<void> pullToRefreshData({bool isRefreshIndicator = true}) async {
    isNewUpdate = false;
    getListPosts();
    getListStories();
    update();
    return Future.delayed(const Duration(seconds: 1));
  }

  /// load user profile
  Future<ProfileResponse> loadUserProfile() async {
    ProfileResponse profileResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse("http://14.225.204.248:8080/api/user/profile"),
          RequestType.post,
          headers: null,
          body: null);
      debugPrint("------------- RESTFULL API USER PROFILE -------------");
    } catch (error) {
      debugPrint("Fail to user profile $error");
      rethrow;
    }
    if (body == null) return ProfileResponse.buildDefault();
    //get data from api here
    profileResponse = ProfileResponse.fromJson(body);
    if (profileResponse.status == true) {
      Global.userProfileResponse = profileResponse.userProfileResponse;
      debugPrint("------------- LOAD USER PROFILE SUCCESSFULLY -------------");
      update();
    }
    return profileResponse;
  }

  /// call api list photo another user
  Future<GetAllPhotoAnOtherUserResponse> getListPhotoAnOtherUser(
      GetAllPhotoAnotherUserRequest getAllPhotoAnotherUserRequest) async {
    GetAllPhotoAnOtherUserResponse getAllPhotoAnOtherUserResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse(
              "http://14.225.204.248:8080/api/photo/get-list-photos-another-user"),
          RequestType.post,
          headers: null,
          body: const JsonEncoder()
              .convert(getAllPhotoAnotherUserRequest.toBodyRequest()));
    } catch (error) {
      debugPrint("Fail to get list photos another user $error");
      rethrow;
    }
    if (body == null) return GetAllPhotoAnOtherUserResponse.buildDefault();
    //get data from api here
    getAllPhotoAnOtherUserResponse =
        GetAllPhotoAnOtherUserResponse.fromJson(body);
    if (getAllPhotoAnOtherUserResponse.status == true) {
      debugPrint(
          "------------- GET LIST PHOTOS ANOTHER USER SUCCESSFULLY -------------");
      Global.listPhotoAnOtherUser =
          getAllPhotoAnOtherUserResponse.listPhotosUser!;
    }
    return getAllPhotoAnOtherUserResponse;
  }

  /// load another user profile
  Future<AnOtherProfileResponse> loadAnotherUserProfile(
      AnotherUserProfileRequest anotherUserProfileRequest) async {
    AnOtherProfileResponse anOtherProfileResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse("http://14.225.204.248:8080/api/user/another-profile"),
          RequestType.post,
          headers: null,
          body: const JsonEncoder()
              .convert(anotherUserProfileRequest.toBodyRequest()));
    } catch (error) {
      debugPrint("Fail to user profile $error");
      rethrow;
    }
    if (body == null) return AnOtherProfileResponse.buildDefault();
    //get data from api here
    anOtherProfileResponse = AnOtherProfileResponse.fromJson(body);
    if (anOtherProfileResponse.status == true) {
      Global.anOtherUserProfileResponse =
          anOtherProfileResponse.anOtherUserProfileResponse;
      debugPrint(
          "-------------  LOAD ANOTHER USER PROFILE SUCCESSFULLY -------------");
      update();
    } else {
      debugPrint("Lỗi api");
    }
    return anOtherProfileResponse;
  }

  /// handle like post api
  Future<LikePostResponse> likePost(LikePostRequest likePostRequest) async {
    LikePostResponse likePostResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse("http://14.225.204.248:8080/api/photo/like"),
          RequestType.post,
          headers: null,
          body: const JsonEncoder().convert(likePostRequest.toBodyRequest()));
    } catch (error) {
      debugPrint("Fail to user profile $error");
      rethrow;
    }
    if (body == null) return LikePostResponse.buildDefault();
    //get data from api here
    likePostResponse = LikePostResponse.fromJson(body);
    if (likePostResponse.status == true) {
      getListPostsWhenLiked();
      debugPrint("----------LIKE POST SUCCESSFULLY----------");
      update();
    }
    return likePostResponse;
  }

  /// call api list comment post
  Future<ListCommentsPostResponse> getListCommentsPost(
      ListCommentsPostRequest request) async {
    ListCommentsPostResponse listCommentsPostResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse(
              "http://14.225.204.248:8080/api/photo/list-comment-of-post"),
          RequestType.post,
          headers: null,
          body: const JsonEncoder().convert(request.toBodyRequest()));
    } catch (error) {
      debugPrint("Fail to get list cmt $error");
      rethrow;
    }
    if (body == null) return ListCommentsPostResponse.buildDefault();
    //get data from api here
    listCommentsPostResponse = ListCommentsPostResponse.fromJson(body);
    if (listCommentsPostResponse.status == true) {
      debugPrint(
          "------------- GET LIST COMMENT POST SUCCESSFULLY -------------");
      Global.dataListCmt = listCommentsPostResponse.data;
      update();
      Get.to(() => const CommentScreen());
    }
    return listCommentsPostResponse;
  }

  /// handle delete post api
  Future<DeletePostResponse> deletePost(
      DeletePostRequest deletePostRequest) async {
    DeletePostResponse deletePostsResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse("http://14.225.204.248:8080/api/photo/delete-post"),
          RequestType.post,
          headers: null,
          body: const JsonEncoder().convert(deletePostRequest.toBodyRequest()));
    } catch (error) {
      debugPrint("Fail to delete post $error");
      rethrow;
    }
    if (body == null) return DeletePostResponse.buildDefault();
    //get data from api here
    deletePostsResponse = DeletePostResponse.fromJson(body);
    if (deletePostsResponse.status == true) {
      Navigator.pop(Get.context!);
      getListPosts();
      debugPrint("------------- DELETE POST SUCCESSFULLY -------------");
      update();
    }
    return deletePostsResponse;
  }

  /// call api list story
  Future<ListStoryResponse> getListStories() async {
    isLoading = true;
    update();
    ListStoryResponse listStoryResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse("http://14.225.204.248:8080/api/story/get-list-stories"),
          RequestType.post,
          headers: null,
          body: null);
    } catch (error) {
      debugPrint("Fail to get list stories $error");
      rethrow;
    }
    if (body == null) return ListStoryResponse.buildDefault();
    //get data from api here
    listStoryResponse = ListStoryResponse.fromJson(body);
    if (listStoryResponse.status == true) {
      debugPrint("------------- GET LIST STORIES SUCCESSFULLY -------------");
      Global.listStoriesData = listStoryResponse.data!;
      await Future.delayed(const Duration(seconds: 1), () {});
      isLoading = false;
      update();
    }
    return listStoryResponse;
  }
}
