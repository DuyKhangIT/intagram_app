import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:instagram_app/models/get_all_photo_another_user/get_all_photo_another_user_request.dart';
import 'package:instagram_app/models/get_all_photo_another_user/get_all_photo_another_user_response.dart';

import 'package:instagram_app/models/list_posts_home/data_posts_response.dart';
import 'package:instagram_app/models/list_posts_home/list_posts_home_response.dart';

import '../../../api_http/handle_api.dart';
import '../../../models/another_user_profile/another_profile_response.dart';
import '../../../models/another_user_profile/another_user_profile_request.dart';
import '../../../models/user_profile/profile_response.dart';
import '../../../util/global.dart';
import '../another_profile_screen/another_profile_screen.dart';

class HomeController extends GetxController {
  bool isLike = false;
  final scrollController = ScrollController();
  double previousOffset = 0.0;
  File? avatar;
  bool isNewUpdate = false;
  String userId = "";
  bool isLoading = false;
  String phone = "";

  List<DataPostsResponse> dataPostsResponse = [];
  @override
  void onReady() {
    getListPosts();
    loadUserProfile();
    update();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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
      dataPostsResponse = listPostsHomeResponse.data!;
      Global.listPostInfo = dataPostsResponse;
      await Future.delayed(const Duration(seconds: 1), () {});
      isLoading = false;
      update();
    }
    return listPostsHomeResponse;
  }

  // /// refresh
  Future<void> refreshData() async {
    isNewUpdate = false;
    update();
    getListPosts();
  }

  /// pull to refresh
  Future<void> pullToRefreshData({bool isRefreshIndicator = true}) async {
    isNewUpdate = false;
    getListPosts();
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
    } catch (error) {
      debugPrint("Fail to user profile $error");
      rethrow;
    }
    if (body == null) return ProfileResponse.buildDefault();
    //get data from api here
    profileResponse = ProfileResponse.fromJson(body);
    if (profileResponse.status == true) {
      Global.userProfileResponse = profileResponse.userProfileResponse;
      print("load profile success");
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
      Global.anOtherUserProfileResponse = anOtherProfileResponse.anOtherUserProfileResponse;
      print("load profile success");
      update();
      if(Global.anOtherUserProfileResponse!=null){
        Get.to(() => const AnOtherProfileScreen());
      }
    }
    return anOtherProfileResponse;
  }
}
