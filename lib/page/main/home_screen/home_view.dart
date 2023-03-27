import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_app/assets/assets.dart';
import 'package:instagram_app/models/story_data.dart';
import 'package:instagram_app/page/main/home_screen/story_page/story_page_view.dart';
import 'package:instagram_app/widget/avatar_circle.dart';

import '../../../assets/icons_assets.dart';
import '../../../config/theme_service.dart';
import '../../onboarding/login/login_view.dart';
import 'home_controller.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

const moonIcon = CupertinoIcons.moon_stars;

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    return GetBuilder<HomeController>(
        builder: (controller) => SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(
                    'SeShare',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Theme.of(context).textTheme.headline6?.color,
                        fontSize: 22,
                        fontStyle: FontStyle.italic),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        ThemeService().changeTheme();
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 10),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            BlendMode.srcIn,
                          ),
                          child: const Icon(
                            moonIcon,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // homeController.auth.signOut();
                        // ConfigSharedPreferences().setStringValue(
                        //     SharedData.USER_ID.toString(), "");
                        Get.to(() => Login());
                      },
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(IconsAssets.icShare),
                      ),
                    )
                  ],
                  elevation: 0,
                ),
                body: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 110,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                        ),
                        color: Colors.transparent,
                      ),
                      child: Expanded(child: listViewStory(homeController)),
                    ),
                    Expanded(child: listViewPost())
                  ],
                ),
              ),
            ));
  }

  /// list view story
  Widget listViewStory(HomeController homeController) {
    homeController = Get.put(HomeController());
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10, //Call API
          itemBuilder: (context, index) {
            return contentListViewStory();
          }),
    );
  }

  /// list view story
  Widget listViewPost() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 4, //Call API
        itemBuilder: (context, index) {
          return contentListViewPost();
        });
  }

  /// content list view story
  Widget contentListViewStory() {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarCircle(
              onTap: () {
                Get.to(() => const StoryPage());
              },
              image: ImageAssets.imgTet),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text("Duy Khang",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: 12, fontFamily: 'Nunito Sans')),
          ),
        ],
      ),
    );
  }

  /// content list view post
  Widget contentListViewPost() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// avatar + username + location
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///avatar
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          ImageAssets.imgTet,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    /// user name and location
                    SizedBox(
                      width: 230,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Duy Khang",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'Nunito Sans')),
                          Text("Tp.Hồ Chí Minh",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'Nunito Sans')),
                        ],
                      ),
                    ),
                  ],
                ),

                /// dot
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(IconsAssets.icDot),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Image.asset(ImageAssets.imgTet),

          /// icon like + cmt + share + save
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /// ic like
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(IconsAssets.icLike),
                      ),

                      /// ic cmt
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(IconsAssets.icComment),
                      ),

                      /// ic share
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(IconsAssets.icShare),
                      ),
                    ],
                  ),
                ),

                /// ic save
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(IconsAssets.icSave),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      ImageAssets.imgTet,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                /// member like
                RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline6?.color,
                          fontFamily: 'NunitoSans'),
                      children: const [
                        TextSpan(text: "Có ", style: TextStyle(fontSize: 13)),
                        TextSpan(
                            text: "Trà My ",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w700)),
                        TextSpan(text: "và ", style: TextStyle(fontSize: 14)),
                        TextSpan(
                            text: "44,666 ",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w700)),
                        TextSpan(
                            text: "người khác", style: TextStyle(fontSize: 13))
                      ]),
                ),
              ],
            ),
          ),

          /// descriptions of post
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 18),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline6?.color,
                      fontFamily: 'NunitoSans'),
                  children: const [
                    TextSpan(
                        text: "Duy Khang ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: "Hôm nay thật là vui!!",
                        style: TextStyle(fontSize: 14)),
                  ]),
            ),
          ),

          /// comment
          GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 5, left: 18),
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline6?.color,
                        fontFamily: 'NunitoSans'),
                    children: const [
                      TextSpan(
                          text: "Xem tất cả ", style: TextStyle(fontSize: 14)),
                      TextSpan(
                          text: "20",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: " bình luận", style: TextStyle(fontSize: 14)),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
