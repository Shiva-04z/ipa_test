import 'package:apple_grower/features/aadhati/aadhati_controller.dart';
import 'package:get/get.dart';

class AadhatiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AadhatiController());
  }
}
