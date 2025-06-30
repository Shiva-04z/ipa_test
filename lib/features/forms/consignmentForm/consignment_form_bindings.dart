import 'package:apple_grower/features/forms/consignmentForm/consignment_form_controller.dart';
import 'package:get/get.dart';

class ConsignmentBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>ConsignmentFormController());
  }
}
