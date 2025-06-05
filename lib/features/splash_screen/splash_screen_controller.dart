import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../navigation/routes_constant.dart';

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Animation variables
  var logoOpacity = 0.02.obs;
  var textOpacity = 0.02.obs;
  late AnimationController _animationController;

  @override
  void onInit() {
    super.onInit();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _startAnimations();
    _navigateToHome();
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }

  // Call this when you need to show splash again
  void resetAndStartAnimations() {
    logoOpacity.value = 0.02;
    textOpacity.value = 0.02;
    _animationController.reset();
    _startAnimations();
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      logoOpacity.value = 1.0;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      textOpacity.value = 1.0;
    });
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(RoutesConstant.signUp); // Replace with your home route
    });
  }
}