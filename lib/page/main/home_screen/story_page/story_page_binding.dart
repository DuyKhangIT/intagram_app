import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:instagram_app/page/main/home_screen/story_page/story_page_controller.dart';


class StoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StoryController());
  }
}
