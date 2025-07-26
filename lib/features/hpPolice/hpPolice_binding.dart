import 'package:get/get.dart';
import 'hpPolice_controller.dart';

class HpPoliceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HpPoliceController>(
      () => HpPoliceController(),
    );
  }
}
