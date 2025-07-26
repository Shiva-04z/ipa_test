import 'package:apple_grower/features/hpAgriBoard/hpAgriBoard_controller.dart';
import 'package:get/get.dart';

class HPAgriBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HPAgriBoardController());
  }
}
