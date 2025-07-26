import 'package:apple_grower/features/profile_page/profile_page_controller.dart';
import 'package:get/get.dart';

class ProfilePageBindigs extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>ProfilePageController());
  }

}