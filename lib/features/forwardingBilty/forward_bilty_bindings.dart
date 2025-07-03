import 'package:apple_grower/features/forwardingBilty/forward_bilty_controller.dart';
import 'package:get/get.dart';

class ForwardBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>ForwardBiltyController());
  }
}
