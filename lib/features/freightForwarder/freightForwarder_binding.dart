import 'package:apple_grower/features/freightForwarder/freightForwarder_controller.dart';
import 'package:get/get.dart';

class FreightForwarderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FreightForwarderController());
  }
}
