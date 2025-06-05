import 'package:apple_grower/features/ladaniBuyers/ladaniBuyers_controller.dart';
import 'package:get/get.dart';

class LadaniBuyersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LadaniBuyersController());
  }
}
