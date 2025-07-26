import 'package:get/get.dart';
import 'bidder_session_controller.dart';

class BidderSessionBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BidderSessionController>(() => BidderSessionController());
  }
}
