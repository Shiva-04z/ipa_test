import 'package:apple_grower/features/ampcOffice/ampcOffice_controller.dart';
import 'package:get/get.dart';

class ApmcOfficeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApmcOfficeController());
  }
}
