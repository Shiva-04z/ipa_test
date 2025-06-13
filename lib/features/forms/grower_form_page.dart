import 'package:apple_grower/features/aadhati/aadhati_controller.dart';
import 'package:apple_grower/models/aadhati.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/grower_model.dart';
import '../../core/globals.dart' as glb;
import '../driver/driver_controller.dart';
import '../freightForwarder/freightForwarder_controller.dart';
import '../grower/grower_controller.dart';
import '../ladaniBuyers/ladaniBuyers_controller.dart';
import '../packHouse/packHouse_controller.dart';
import '../transportUnion/transportUnion_controller.dart';

class GrowerFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final aadharController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final pinCodeController = TextEditingController();
  final searchController = TextEditingController();
  final isLoading = false.obs;
  final isSearching = true.obs;
  final searchResults = <Grower>[].obs;
  var exists;
  @override
  void onInit() {
    super.onInit();
    searchResults.value = glb.availableGrowers;
  }

  @override
  void onClose() {
    nameController.dispose();
    aadharController.dispose();
    phoneController.dispose();
    addressController.dispose();
    pinCodeController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      searchResults.value = glb.availableGrowers;
    } else {
      searchResults.value = glb.availableGrowers.where((grower) {
        final name = grower.name.toLowerCase();
        final phone = grower.phoneNumber.toLowerCase();
        final address = grower.address.toLowerCase();
        final searchLower = query.toLowerCase();

        return name.contains(searchLower) ||
            phone.contains(searchLower) ||
            address.contains(searchLower);
      }).toList();
    }
  }

  void selectGrower(Grower grower) {
    final exists = (glb.roleType.value == "PackHouse")
        ? Get.find<PackHouseController>()
            .associatedGrowers
            .any((existingDriver) => existingDriver.id == grower.id)
        : (glb.roleType.value == "Aadhati")
            ? Get.find<AadhatiController>()
                .associatedGrowers
                .any((existingDriver) => existingDriver.id == grower.id)
            : (glb.roleType.value == "Freight Forwarder")
                ? Get.find<FreightForwarderController>()
                    .associatedGrowers
                    .any((existingDriver) => existingDriver.id == grower.id)
                : (glb.roleType.value == "Driver")
                    ? Get.find<DriverController>()
                        .associatedGrowers
                        .any((existingDriver) => existingDriver.id == grower.id)
                    : Get.find<TransportUnionController>()
                        .associatedGrowers
                        .any(
                            (existingDriver) => existingDriver.id == grower.id);

    if (exists) {
      Get.snackbar(
        'Grower Already Added',
        'This grower is already in your list',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    (glb.roleType.value == "PackHouse")
        ? Get.find<PackHouseController>().addAssociatedGrower(grower)
        : (glb.roleType.value == "Aadhati")
            ? Get.find<AadhatiController>().addAssociatedGrower(grower)
            : (glb.roleType.value == "Freight Forwarder")
                ? Get.find<FreightForwarderController>()
                    .addAssociatedGrower(grower)
                : (glb.roleType.value == "Driver")
                    ? Get.find<DriverController>().addAssociatedGrower(grower)
                    : Get.find<TransportUnionController>()
                        .addAssociatedGrower(grower);
    Get.back();
  }

  void submitForm() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final grower = Grower(
        id: 'G${DateTime.now().millisecondsSinceEpoch}',
        name: nameController.text,
        aadharNumber: aadharController.text,
        phoneNumber: phoneController.text,
        address: addressController.text,
        pinCode: pinCodeController.text,
        packingHouses: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      (glb.roleType.value == "PackHouse")
          ? Get.find<PackHouseController>().addAssociatedGrower(grower)
          : (glb.roleType.value == "Aadhati")
              ? Get.find<AadhatiController>().addAssociatedGrower(grower)
              : (glb.roleType.value == "Freight Forwarder")
                  ? Get.find<FreightForwarderController>()
                      .addAssociatedGrower(grower)
                  : (glb.roleType.value == "Driver")
                      ? Get.find<DriverController>().addAssociatedGrower(grower)
                      : Get.find<TransportUnionController>()
                          .addAssociatedGrower(grower);

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error adding grower: $e',
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

class GrowerFormPage extends StatelessWidget {
  GrowerFormPage({super.key});

  final controller = Get.put(GrowerFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Grower'),
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
                    : _buildNewGrowerForm()),
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
                  'Select or Create Grower',
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
                      'Search growers...',
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
                'No growers found',
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
              final grower = controller.searchResults[index];
              final exists = (glb.roleType.value == "PackHouse")
                  ? Get.find<PackHouseController>()
                      .associatedGrowers
                      .any((existingDriver) => existingDriver.id == grower.id)
                  : (glb.roleType.value == "Aadhati")
                      ? Get.find<AadhatiController>().associatedGrowers.any(
                          (existingDriver) => existingDriver.id == grower.id)
                      : (glb.roleType.value == "Freight Forwarder")
                          ? Get.find<FreightForwarderController>()
                              .associatedGrowers
                              .any((existingDriver) =>
                                  existingDriver.id == grower.id)
                          :  (glb.roleType.value == "Driver")
                  ? Get.find<DriverController>()
                  .associatedGrowers
                  .any((existingDriver) => existingDriver.id == grower.id)
                  : Get.find<TransportUnionController>()
                              .associatedGrowers
                              .any((existingDriver) =>
                                  existingDriver.id == grower.id);

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
                          exists ? null : () => controller.selectGrower(grower),
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
                                          grower.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Aadhar: ${grower.aadharNumber}',
                                          style: TextStyle(
                                            fontSize: 12,
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
                                Icons.phone,
                                'Phone: ${grower.phoneNumber}',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.location_on,
                                'Address: ${grower.address}',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.pin_drop,
                                'PIN Code: ${grower.pinCode}',
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

  Widget _buildNewGrowerForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBasicDetails(),
          const SizedBox(height: 24),
          _buildAddressDetails(),
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
              controller: controller.aadharController,
              decoration: _getInputDecoration(
                'Aadhar Number',
                prefixIcon: Icons.badge,
              ),
              keyboardType: TextInputType.number,
              maxLength: 12,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter Aadhar number';
                }
                if (value!.length != 12) {
                  return 'Aadhar number must be 12 digits';
                }
                return null;
              },
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

  Widget _buildAddressDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Address Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.addressController,
              decoration: _getInputDecoration(
                'Address',
                prefixIcon: Icons.location_on,
              ),
              maxLines: 3,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter address' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.pinCodeController,
              decoration: _getInputDecoration(
                'PIN Code',
                prefixIcon: Icons.pin_drop,
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter PIN code';
                }
                if (value!.length != 6) {
                  return 'PIN code must be 6 digits';
                }
                return null;
              },
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
          'Add Grower',
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
