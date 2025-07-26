import 'package:get/get.dart';
import 'grower_session_controller.dart';

class GrowerSessionBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GrowerSessionController>(() => GrowerSessionController());
  }
}
