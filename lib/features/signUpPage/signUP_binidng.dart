import 'package:apple_grower/features/signUpPage/signUp_controller.dart';
import 'package:get/get.dart';

class SignUpBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>SignUpController());
  }

}