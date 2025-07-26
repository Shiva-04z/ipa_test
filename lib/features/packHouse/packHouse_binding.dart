import 'package:apple_grower/features/packHouse/packHouse_controller.dart';
import 'package:get/get.dart';

class PackHouseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PackHouseController());
  }
}
