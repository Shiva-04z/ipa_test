import 'package:get/get.dart';

import '../../models/bilty_model.dart';

class BiltyPageController extends GetxController{
  Rx<Bilty?> bilty = Rx<Bilty?>(null);
  RxBool biltyValue = false.obs;
}