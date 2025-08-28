import 'package:apple_grower/features/splash_screen/splash_screen_controller.dart';
import 'package:get/get.dart';

import 'load_screen_controller.dart';



class LoadScreenBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() =>LoadScreenController());
  }
}
