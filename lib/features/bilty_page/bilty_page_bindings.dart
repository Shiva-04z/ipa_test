import 'package:apple_grower/features/bilty_page/bilty_page_controller.dart';
import 'package:get/get.dart';

class BiltyPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BiltyPageController());
  }
}
