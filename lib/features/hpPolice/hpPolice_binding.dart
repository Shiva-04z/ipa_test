import 'package:apple_grower/features/hpPolice/hpPolice_controller.dart';
import 'package:get/get.dart';

class HPPoliceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HPPoliceController());
  }
}
