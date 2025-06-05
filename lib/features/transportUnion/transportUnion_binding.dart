import 'package:apple_grower/features/transportUnion/transportUnion_controller.dart';
import 'package:get/get.dart';

class TransportUnionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransportUnionController());
  }
}
