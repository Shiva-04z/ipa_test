import 'package:apple_grower/features/driver/driver_controller.dart';
import 'package:get/get.dart';

class DriverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DriverController());
  }
}
