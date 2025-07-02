import 'package:get/get.dart';
import 'bilty_page_aadhti_controller.dart';

class BiltyPageAadhtiBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BiltyPageAadhtiController());
  }
}
