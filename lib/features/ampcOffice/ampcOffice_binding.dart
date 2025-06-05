import 'package:apple_grower/features/ampcOffice/ampcOffice_controller.dart';
import 'package:get/get.dart';

class AmpcOfficeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AmpcOfficeController());
  }
}
