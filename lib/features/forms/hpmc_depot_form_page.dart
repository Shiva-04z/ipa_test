import 'package:apple_grower/features/grower/grower_controller.dart';
import 'package:apple_grower/features/hpAgriBoard/hpAgriBoard_controller.dart';
import 'package:apple_grower/features/packHouse/packHouse_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/global_role_loader.dart' as gld;
import '../../core/globals.dart' as glb;
import '../../models/hpmc_collection_center_model.dart';

class HpmcDepotFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final contactNameController = TextEditingController();
  final operatorNameController = TextEditingController();
  final cellNoController = TextEditingController();
  final adharNoController = TextEditingController();
  final licenseNoController = TextEditingController();
  final operatingSinceController = TextEditingController();
  final locationController = TextEditingController();
  final boxes2023Controller = TextEditingController();
  final boxes2024Controller = TextEditingController();
  final target2025Controller = TextEditingController();
  final searchController = TextEditingController();
  final isLoading = false.obs;
  final isSearching = true.obs;
  final searchResults = <HpmcCollectionCenter>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchResults.value = glb.availableHpmcDepots;
  }

  @override
  void onClose() {
    contactNameController.dispose();
    operatorNameController.dispose();
    cellNoController.dispose();
    adharNoController.dispose();
    licenseNoController.dispose();
    operatingSinceController.dispose();
    locationController.dispose();
    boxes2023Controller.dispose();
    boxes2024Controller.dispose();
    target2025Controller.dispose();
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      searchResults.value = glb.availableHpmcDepots;
    } else {
      searchResults.value = glb.availableHpmcDepots.where((depot) {
        final contactName = depot.contactName.toLowerCase();
        final operatorName = depot.operatorName.toLowerCase();
        final location = depot.location.toLowerCase();
        final searchLower = query.toLowerCase();

        return contactName.contains(searchLower) ||
            operatorName.contains(searchLower) ||
            location.contains(searchLower);
      }).toList();
    }
  }

  Future<void> pickContact() async {
    if (kIsWeb) {
      Get.snackbar(
        'Not Available',
        'Contact picker is not available on web due to security restrictions. Please use the mobile app.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
      return;
    }

    try {
      final status = await Permission.contacts.request();
      if (status.isGranted) {
        final contact = await FlutterContacts.openExternalPick();
        if (contact != null) {
          contactNameController.text = contact.displayName;
          if (contact.phones.isNotEmpty) {
            String phoneNumber =
                contact.phones.first.number.replaceAll(RegExp(r'[^\d]'), '');
            if (phoneNumber.length > 10) {
              phoneNumber = phoneNumber.substring(phoneNumber.length - 10);
            }
            cellNoController.text = phoneNumber;
          }
        }
      } else {
        Get.snackbar(
          'Permission Denied',
          'Please grant contacts permission to use this feature',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick contact: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void selectDepot(HpmcCollectionCenter depot) {
    final exists = (glb.roleType.value == "Grower")
        ? Get.find<GrowerController>().hpmcDepots.any(
              (existingDepot) => existingDepot.id == depot.id,
            )
        : Get.find<PackHouseController>().hpmcDepots.any(
              (existingDepot) => existingDepot.id == depot.id,
            );

    if (exists) {
      Get.snackbar(
        'Depot Already Added',
        'This HPMC depot is already in your list',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    (glb.roleType.value == "Grower")
        ? Get.find<GrowerController>().addHpmc(depot)
        : Get.find<PackHouseController>().addHpmc(depot);

    Get.back();
  }

  void submitForm() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final depot = HpmcCollectionCenter(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        contactName: contactNameController.text,
        operatorName: operatorNameController.text,
        cellNo: cellNoController.text,
        adharNo: adharNoController.text,
        licenseNo: licenseNoController.text,
        operatingSince: operatingSinceController.text,
        location: locationController.text,
        boxesTransported2023: int.tryParse(boxes2023Controller.text) ?? 0,
        boxesTransported2024: int.tryParse(boxes2024Controller.text) ?? 0,
        target2025: double.tryParse(target2025Controller.text) ?? 0.0,
      );

      (glb.roleType.value == "Grower")
          ? Get.find<GrowerController>().addHpmc(depot)
          : Get.find<PackHouseController>().addHpmc(depot);

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error adding HPMC depot: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class HpmcDepotFormPage extends StatelessWidget {
  HpmcDepotFormPage({super.key});

  final controller = Get.put(HpmcDepotFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add HPMC Depot'),
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
                    : _buildNewDepotForm()),
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
                  'Select or Create Depot',
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
                      'Search depots...',
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
                'No depots found',
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
              final depot = controller.searchResults[index];
              final exists = (glb.roleType.value == "Grower")
                  ? Get.find<GrowerController>().hpmcDepots.any(
                        (existingDepot) => existingDepot.id == depot.id,
                      )
                  : Get.find<PackHouseController>().hpmcDepots.any(
                        (existingDepot) => existingDepot.id == depot.id,
                      );
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
                          exists ? null : () => controller.selectDepot(depot),
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
                                    Icons.business,
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
                                          depot.contactName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Operator: ${depot.operatorName}',
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
                                'Phone: ${depot.cellNo}',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.location_on,
                                'Location: ${depot.location}',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.assignment,
                                'License: ${depot.licenseNo}',
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

  Widget _buildNewDepotForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBasicDetails(),
          const SizedBox(height: 24),
          _buildBusinessDetails(),
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
              controller: controller.contactNameController,
              decoration: _getInputDecoration(
                'Contact Name',
                prefixIcon: Icons.person,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter contact name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.operatorNameController,
              decoration: _getInputDecoration(
                'Operator Name',
                prefixIcon: Icons.person_outline,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter operator name' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.cellNoController,
                    decoration: _getInputDecoration(
                      'Phone Number',
                      prefixIcon: Icons.phone,
                    ),
                    keyboardType: TextInputType.phone,
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
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: controller.pickContact,
                  icon: const Icon(Icons.contacts),
                  color: const Color(0xff548235),
                  tooltip: kIsWeb
                      ? 'Use mobile app to pick contacts'
                      : 'Pick from contacts',
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.adharNoController,
              decoration: _getInputDecoration(
                'Aadhar Number',
                prefixIcon: Icons.badge,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter Aadhar number' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.licenseNoController,
              decoration: _getInputDecoration(
                'License Number',
                prefixIcon: Icons.assignment,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter license number' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.operatingSinceController,
              decoration: _getInputDecoration(
                'Operating Since',
                prefixIcon: Icons.calendar_today,
              ),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter operating since'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.locationController,
              decoration: _getInputDecoration(
                'Location',
                prefixIcon: Icons.location_on,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter location' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Business Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.boxes2023Controller,
              decoration: _getInputDecoration(
                'Boxes Transported in 2023',
                prefixIcon: Icons.inventory,
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter boxes transported in 2023'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.boxes2024Controller,
              decoration: _getInputDecoration(
                'Boxes Transported in 2024',
                prefixIcon: Icons.inventory,
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter boxes transported in 2024'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.target2025Controller,
              decoration: _getInputDecoration(
                'Target for 2025',
                prefixIcon: Icons.trending_up,
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter target for 2025'
                  : null,
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
          'Add HPMC Depot',
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
