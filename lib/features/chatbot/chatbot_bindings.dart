import 'package:get/get.dart';

import 'chatbot_controller.dart';


class ChatBotBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => ChatBotController());
    // Add binding for 3D model page
    // Get.lazyPut(()=>Agent3DController());
  }
}
