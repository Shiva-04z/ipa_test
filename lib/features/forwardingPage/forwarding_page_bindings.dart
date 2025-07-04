import 'package:apple_grower/features/forwardingPage/forwarding_page_controller.dart';
import 'package:get/get.dart';

class ForwardPageBindings extends Bindings
{
  @override
  void dependencies() {
    Get.lazyPut(()=>ForwardPageController());
  }

}