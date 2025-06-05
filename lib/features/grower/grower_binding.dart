import 'package:apple_grower/features/grower/grower_controller.dart';
import 'package:get/get.dart';

class GrowerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GrowerController());
  }
}
