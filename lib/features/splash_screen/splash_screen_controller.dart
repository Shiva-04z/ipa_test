import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../navigation/routes_constant.dart';
import '../../core/globals.dart' as glb;

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
    // _checkLoginStatusAndNavigate();

  }

  @override
  void onReady()
  {
    Get.toNamed(RoutesConstant.forward);
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

  // Check if user is already logged in and navigate accordingly
  Future<void> _checkLoginStatusAndNavigate() async {
    try {
      // Wait for animations to complete
      await Future.delayed(const Duration(seconds: 3));
      
      // Load stored user data (both ID and role)
      await glb.loadUserData();
      
      // Check if user ID exists and is not empty
      if (glb.id.value.isNotEmpty && glb.id.value != "") {
        // User is logged in, navigate to appropriate role page
        _navigateToRolePage();
      } else {
        // User is not logged in, go to sign-up page
        Get.offNamed(RoutesConstant.signUp);
      }
    } catch (e) {
      // If there's any error, go to sign-up page
      print("Error checking login status: $e");
      Get.offNamed(RoutesConstant.signUp);
    }
  }

  // Navigate to the appropriate role page based on stored role
  void _navigateToRolePage() {
    switch (glb.roleType.value) {
      case "Grower":
        Get.offNamed(RoutesConstant.grower);
        break;
      case "PackHouse":
        Get.offNamed(RoutesConstant.packHouse);
        break;
      case "Aadhati":
        Get.offNamed(RoutesConstant.aadhati);
        break;
      case "Ladani/Buyers":
        Get.offNamed(RoutesConstant.ladaniBuyers);
        break;
      case "Freight Forwarder":
        Get.offNamed(RoutesConstant.freightForwarder);
        break;
      case "Driver":
        Get.offNamed(RoutesConstant.driver);
        break;
      case "Transport Union":
        Get.offNamed(RoutesConstant.transportUnion);
        break;
      case "APMC Office":
        Get.offNamed(RoutesConstant.apmcOffice);
        break;
      case "HP Police":
        Get.offNamed(RoutesConstant.hpPolice);
        break;
      case "HPMC DEPOT":
        Get.offNamed(RoutesConstant.hpAgriBoard);
        break;
      default:
        Get.offNamed(RoutesConstant.grower); // Default fallback
    }
  }

  // Legacy method - keeping for backward compatibility
  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(RoutesConstant.signUp);
    });
  }
}