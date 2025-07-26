import 'package:get/get.dart';
import 'aadhati_session_controller.dart';

class AadhatiSesssionBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AadhatiSessionController());
  }
}
