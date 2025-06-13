import 'package:apple_grower/features/aadhati/aadhati_controller.dart';
import 'package:apple_grower/features/freightForwarder/freightForwarder_controller.dart';
import 'package:apple_grower/features/grower/grower_controller.dart';
import 'package:apple_grower/features/hpAgriBoard/hpAgriBoard_controller.dart';
import 'package:apple_grower/features/ladaniBuyers/ladaniBuyers_controller.dart';
import 'package:apple_grower/features/transportUnion/transportUnion_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/driving_profile_model.dart';
import '../../core/globals.dart' as glb;
import '../packHouse/packHouse_controller.dart';

class DriverFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final licenseController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final searchController = TextEditingController();
  final isLoading = false.obs;
  final isSearching = true.obs;
  final searchResults = <DrivingProfile>[].obs;
  var exists;
  @override
  void onInit() {
    super.onInit();
    searchResults.value = glb.availableDrivingProfiles;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    licenseController.dispose();
    vehicleTypeController.dispose();
    vehicleNumberController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      searchResults.value = glb.availableDrivingProfiles;
    } else {
      searchResults.value = glb.availableDrivingProfiles.where((driver) {
        final name = driver.name!.toLowerCase();
        final phone = driver.contact!.toLowerCase();
        final license = driver.drivingLicenseNo!.toLowerCase();
        final vehicle = driver.vehicleRegistrationNo!.toLowerCase();
        final searchLower = query.toLowerCase();

        return name.contains(searchLower) ||
            phone.contains(searchLower) ||
            license.contains(searchLower) ||
            vehicle.contains(searchLower);
      }).toList();
    }
  }

  void selectDriver(DrivingProfile driver) {
    exists = (glb.roleType.value == "PackHouse")
        ? Get.find<PackHouseController>()
            .associatedDrivers
            .any((existingDriver) => existingDriver.id == driver.id)
        : (glb.roleType.value == "Grower")
            ? Get.find<GrowerController>()
                .drivers
                .any((existingDriver) => existingDriver.id == driver.id)
            : (glb.roleType.value == "Aadhati")
                ? Get.find<AadhatiController>()
                    .associatedDrivers
                    .any((existingDriver) => existingDriver.id == driver.id)
                : (glb.roleType.value == "Ladani/Buyers")
                    ? Get.find<LadaniBuyersController>()
                        .associatedDrivers
                        .any((existingDriver) => existingDriver.id == driver.id)
                    : (glb.roleType.value == "Freight Forwarder")
                        ? Get.find<FreightForwarderController>()
                            .associatedDrivers
                            .any((existingDriver) =>
                                existingDriver.id == driver.id)
                        : (glb.roleType.value == "HPMC DEPOT")
                            ? Get.find<HPAgriBoardController>()
                                .associatedDrivers
                                .any((existingDriver) =>
                                    existingDriver.id == driver.id)
                            : Get.find<TransportUnionController>()
                                .associatedDrivers
                                .any((existingDriver) =>
                                    existingDriver.id == driver.id);

    if (exists) {
      Get.snackbar(
        'Driver Already Added',
        'This driver is already in your list',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    (glb.roleType.value == "PackHouse")
        ? Get.find<PackHouseController>().addAssociatedDriver(driver)
        : (glb.roleType.value == "Grower")
            ? Get.find<GrowerController>().addDriver(driver)
            : (glb.roleType.value == "Aadhati")
                ? Get.find<AadhatiController>().addAssociatedDriver(driver)
                : (glb.roleType.value == "Ladani/Buyers")
                    ? Get.find<LadaniBuyersController>()
                        .addAssociatedDrivers(driver)
                    : (glb.roleType.value == "Freight Forwarder")
                        ? Get.find<FreightForwarderController>()
                            .addAssociatedDrivers(driver)
                        : (glb.roleType.value == "HPMC DEPOT")
                            ? Get.find<HPAgriBoardController>()
                                .addAssociatedDriver(driver)
                            : Get.find<TransportUnionController>()
                                .addAssociatedDrivers(driver);
    Get.back();
  }

  void submitForm() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final driver = DrivingProfile(
        id: 'D${DateTime.now().millisecondsSinceEpoch}',
        name: nameController.text,
        contact: phoneController.text,
        drivingLicenseNo: licenseController.text,
        vehicleRegistrationNo: vehicleNumberController.text,
      );

      (glb.roleType.value == "PackHouse")
          ? Get.find<PackHouseController>().addAssociatedDriver(driver)
          : (glb.roleType.value == "Grower")
              ? Get.find<GrowerController>().addDriver(driver)
              : (glb.roleType.value == "Aadhati")
                  ? Get.find<AadhatiController>().addAssociatedDriver(driver)
                  : (glb.roleType.value == "Ladani/Buyers")
                      ? Get.find<LadaniBuyersController>()
                          .addAssociatedDrivers(driver)
                      : (glb.roleType.value == "Freight Forwarder")
                          ? Get.find<FreightForwarderController>()
                              .addAssociatedDrivers(driver)
                          : (glb.roleType.value == "HPMC DEPOT")
                              ? Get.find<HPAgriBoardController>()
                                  .addAssociatedDriver(driver)
                              : Get.find<TransportUnionController>()
                                  .addAssociatedDrivers(driver);

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error adding driver: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      Get.back();
      isLoading.value = false;
    }
  }
}

class DriverFormPageView extends StatelessWidget {
  DriverFormPageView({super.key});

  final controller = Get.put(DriverFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Driver'),
        backgroundColor: const Color(0xff548235),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Obx(() => controller.isLoading.value
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                )
              : const SizedBox()),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xff548235).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchSection(context),
                const SizedBox(height: 24),
                Obx(() => controller.isSearching.value
                    ? _buildSearchResults()
                    : _buildNewDriverForm()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select or Create Driver',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 400 ? 20 : 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff548235),
                  ),
                ),
                Obx(() => TextButton.icon(
                      onPressed: () => controller.isSearching.value =
                          !controller.isSearching.value,
                      icon: Icon(
                        controller.isSearching.value ? Icons.add : Icons.search,
                        color: const Color(0xff548235),
                      ),
                      label: Text(
                        controller.isSearching.value
                            ? 'Create New'
                            : 'Search Existing',
                        style: const TextStyle(color: Color(0xff548235)),
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => controller.isSearching.value
                ? TextField(
                    controller: controller.searchController,
                    decoration: _getInputDecoration(
                      'Search drivers...',
                      prefixIcon: Icons.search,
                    ),
                    onChanged: controller.onSearchChanged,
                  )
                : const SizedBox()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Obx(() => controller.searchResults.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No drivers found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.searchResults.length,
            itemBuilder: (context, index) {
              final driver = controller.searchResults[index];
              final exists = (glb.roleType.value == "PackHouse")
                  ? Get.find<PackHouseController>()
                      .associatedDrivers
                      .any((existingDriver) => existingDriver.id == driver.id)
                  : (glb.roleType.value == "Grower")
                      ? Get.find<GrowerController>().drivers.any(
                          (existingDriver) => existingDriver.id == driver.id)
                      : (glb.roleType.value == "Aadhati")
                          ? Get.find<AadhatiController>().associatedDrivers.any(
                              (existingDriver) =>
                                  existingDriver.id == driver.id)
                          : (glb.roleType.value == "Ladani/Buyers")
                              ? Get.find<LadaniBuyersController>()
                                  .associatedDrivers
                                  .any((existingDriver) =>
                                      existingDriver.id == driver.id)
                              : (glb.roleType.value == "Freight Forwarder")
                                  ? Get.find<FreightForwarderController>()
                                      .associatedDrivers
                                      .any((existingDriver) =>
                                          existingDriver.id == driver.id)
                                  : (glb.roleType.value == "HPMC DEPOT")
                                      ? Get.find<HPAgriBoardController>()
                                          .associatedDrivers
                                          .any((existingDriver) =>
                                              existingDriver.id == driver.id)
                                      : Get.find<TransportUnionController>()
                                          .associatedDrivers
                                          .any((existingDriver) =>
                                              existingDriver.id == driver.id);

              return Stack(
                children: [
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap:
                          exists ? null : () => controller.selectDriver(driver),
                      borderRadius: BorderRadius.circular(12),
                      child: Opacity(
                        opacity: exists ? 0.7 : 1.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Color(0xff548235),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${driver.name}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Phone: ${driver.contact}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                Icons.badge,
                                'License: ${driver.drivingLicenseNo}',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.directions_car,
                                'Vehicle: ${driver.vehicleRegistrationNo}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (exists)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Already Added',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ));
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewDriverForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBasicDetails(),
          const SizedBox(height: 24),
          _buildVehicleDetails(),
          const SizedBox(height: 24),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildBasicDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.nameController,
              decoration: _getInputDecoration(
                'Name',
                prefixIcon: Icons.person,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.phoneController,
              decoration: _getInputDecoration(
                'Phone Number',
                prefixIcon: Icons.phone,
              ),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter phone number';
                }
                if (value!.length != 10) {
                  return 'Phone number must be 10 digits';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vehicle Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.licenseController,
              decoration: _getInputDecoration(
                'Driving License Number',
                prefixIcon: Icons.badge,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter license number' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.vehicleNumberController,
              decoration: _getInputDecoration(
                'Vehicle Registration Number',
                prefixIcon: Icons.directions_car,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter vehicle number' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff548235),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Add Driver',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration(String label, {IconData? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xff548235)),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
