import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/globals.dart' as glb;
import '../../models/hp_police_model.dart';
import '../../models/driving_profile_model.dart';

class HpPoliceController extends GetxController {
  final RxList<HpPolice> policePersonnel = <HpPolice>[].obs;
  final RxList<RestrictedArea> restrictedAreas = <RestrictedArea>[].obs;
  final RxList<DrivingProfile> vehicles = <DrivingProfile>[].obs;
  final Rx<LatLng> currentLocation =
      const LatLng(31.1048, 77.1734).obs; // Shimla coordinates
  final RxDouble currentZoom = 13.0.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedSection = 'Traffic Management'.obs;

  // Form controllers
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    glb.roleType.value = "HP Police";
    glb.loadIDData();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void setSelectedSection(String section) {
    selectedSection.value = section;
  }

  void addVehicle(DrivingProfile driver) {
    vehicles.add(driver);
  }

  Future<void> addPolicePersonnel(officer) async {
    // TODO: Implement API call to save data
    policePersonnel.add(officer);
    Get.back();
  }

  Future<void> addRestrictedArea(
      String type, List<LatLng> coordinates, String description) async {
    try {
      final newArea = RestrictedArea(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: '${type.toUpperCase()} Area',
        type: type,
        coordinates: coordinates,
        description: description,
        startTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // TODO: Implement API call to save data
      restrictedAreas.add(newArea);
      Get.snackbar(
        'Success',
        'Restricted area added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add restricted area: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateVehicleStatus(String vehicleId, String status) async {
    try {
      final index = vehicles.indexWhere((v) => v.id == vehicleId);
      if (index != -1) {
        final vehicle = vehicles[index];
        final updatedVehicle = DrivingProfile(
          id: vehicle.id,
          name: vehicle.name,
          contact: vehicle.contact,
          currentLocation: vehicle.currentLocation,
          vehicleRegistrationNo: vehicle.vehicleRegistrationNo,
        );

        // TODO: Implement API call to update data
        vehicles[index] = updatedVehicle;
        Get.snackbar(
          'Success',
          'Vehicle status updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update vehicle status: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> callDriver(String phoneNumber) async {
    try {
      final url = 'tel:$phoneNumber';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to make call: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void updateMapPosition(LatLng position, double zoom) {
    currentLocation.value = position;
    currentZoom.value = zoom;
  }
}
