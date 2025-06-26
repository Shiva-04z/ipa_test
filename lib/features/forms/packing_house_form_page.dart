import 'package:apple_grower/features/driver/driver_controller.dart';
import 'package:apple_grower/features/hpAgriBoard/hpAgriBoard_controller.dart';
import 'package:apple_grower/models/pack_house_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/globals.dart' as glb;
import '../../core/global_role_loader.dart' as gld;
import '../aadhati/aadhati_controller.dart';
import '../grower/grower_controller.dart';

class PackingHouseFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final gradingMachineController = TextEditingController();
  final sortingMachineController = TextEditingController();
  final numberOfCratesController = TextEditingController();
  final boxesPacked2023Controller = TextEditingController();
  final boxesPacked2024Controller = TextEditingController();
  final estimatedBoxes2025Controller = TextEditingController();
  final searchController = TextEditingController();
  final selectedTrayType = TrayType.bothSide.obs;
  final isLoading = false.obs;
  final isSearching = true.obs;
  final searchResults = <PackHouse>[].obs;
  final availablePackHouses = <PackHouse>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    gradingMachineController.dispose();
    sortingMachineController.dispose();
    numberOfCratesController.dispose();
    boxesPacked2023Controller.dispose();
    boxesPacked2024Controller.dispose();
    estimatedBoxes2025Controller.dispose();
    searchController.dispose();
    super.onClose();
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
          nameController.text = contact.displayName;
          if (contact.phones.isNotEmpty) {
            String phoneNumber =
                contact.phones.first.number.replaceAll(RegExp(r'[^\d]'), '');
            if (phoneNumber.length > 10) {
              phoneNumber = phoneNumber.substring(phoneNumber.length - 10);
            }
            phoneController.text = phoneNumber;
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

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final response =
          await http.get(Uri.parse(glb.url + '/api/packhouse/nearby10'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        availablePackHouses.value = data
            .map((e) => PackHouse(
                  id: e['_id']?.toString() ?? '',
                  name: e['name'] ?? '',
                  phoneNumber: e['phoneNumber'] ?? '',
                  address: e['address'] ?? '',
                  gradingMachine: e['gradingMachine'] ?? '',
                  sortingMachine: e['sortingMachine'] ?? '',
                  numberOfCrates: e['numberOfCrates'] ?? 0,
                  boxesPacked2023: e['boxesPacked2023'] ?? 0,
                  boxesPacked2024: e['boxesPacked2024'] ?? 0,
                  estimatedBoxes2025: e['estimatedBoxes2025'] ?? 0,
                  trayType: TrayType.bothSide, // Adjust if API provides this
                ))
            .toList()
            .cast<PackHouse>();
        searchResults.value = availablePackHouses;
      } else {
        Get.snackbar(
            'Error', 'Failed to load packing houses: \\${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load packing houses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onSearchChanged(String query) async {
    if (query.isEmpty) {
      searchResults.value = availablePackHouses;
      return;
    }
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(glb.url +
          '/api/packhouse/${Uri.encodeComponent(query)}/searchbyName'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        searchResults.value = data
            .map((e) => PackHouse(
                  id: e['_id']?.toString() ?? '',
                  name: e['name'] ?? '',
                  phoneNumber: e['phoneNumber'] ?? '',
                  address: e['address'] ?? '',
                  gradingMachine: e['gradingMachine'] ?? '',
                  sortingMachine: e['sortingMachine'] ?? '',
                  numberOfCrates: e['numberOfCrates'] ?? 0,
                  boxesPacked2023: e['boxesPacked2023'] ?? 0,
                  boxesPacked2024: e['boxesPacked2024'] ?? 0,
                  estimatedBoxes2025: e['estimatedBoxes2025'] ?? 0,
                  trayType: TrayType.bothSide, // Adjust if API provides this
                ))
            .toList()
            .cast<PackHouse>();
      } else {
        Get.snackbar('Error',
            'Failed to search packing houses: \\${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to search packing houses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectPackingHouse(PackHouse house) {
    // Check if packing house already exists
    final exists = (glb.roleType.value == "Grower")
        ? Get.find<GrowerController>()
            .packingHouses
            .any((existingDriver) => existingDriver.id == house.id)
        : (glb.roleType.value == "Aadhti")
            ? Get.find<AadhatiController>()
                .associatedPackHouses
                .any((existingDriver) => existingDriver.id == house.id)
            : (glb.roleType.value == "HPMC DEPOT")
                ? Get.find<HPAgriBoardController>()
                    .associatedPackHouses
                    .any((existingDriver) => existingDriver.id == house.id)
                : Get.find<DriverController>()
                    .associatedPackhouses
                    .any((existingDriver) => existingDriver.id == house.id);

    if (exists) {
      Get.snackbar(
        'Packing House Already Added',
        'This packing house is already in your list',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    (glb.roleType.value == "Grower")
        ? Get.find<GrowerController>().addPackingHouse(house)
        : (glb.roleType.value == "Aadhti")
            ? Get.find<AadhatiController>().addAssociatedPackhouses(house)
            : (glb.roleType.value == "HPMC DEPOT")
                ? Get.find<HPAgriBoardController>()
                    .addAssociatedPackHouse(house)
                : Get.find<DriverController>().addAssociatedPackhouse(house);

    Get.back();
  }

  void submitForm() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final house = PackHouse(
        name: nameController.text,
        phoneNumber: phoneController.text,
        address: addressController.text,
        gradingMachine: '',
        sortingMachine: '',
        numberOfCrates: 0,
        boxesPacked2023: 0,
        boxesPacked2024: 0,
        estimatedBoxes2025: 0,
      );

      (glb.roleType.value == "Grower")
          ? Get.find<GrowerController>().addPackingHouse(house)
          : (glb.roleType.value == "Aadhti")
              ? Get.find<AadhatiController>().addAssociatedPackhouses(house)
              : (glb.roleType.value == "HPMC DEPOT")
                  ? Get.find<HPAgriBoardController>()
                      .addAssociatedPackHouse(house)
                  : Get.find<DriverController>().addAssociatedPackhouse(house);

      Get.back();
      Get.snackbar(
        'Success',
        'Packing house added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff548235),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error adding packing house: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class PackingHouseFormPage extends StatelessWidget {
  PackingHouseFormPage({super.key});

  final controller = Get.put(PackingHouseFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Packing House'),
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
                    : _buildNewPackingHouseForm()),
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
                Expanded(
                  child: Text(
                    'Select or Create Packing House',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width > 400 ? 20 : 14,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      color: const Color(0xff548235),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() => TextButton.icon(
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
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => controller.isSearching.value
                ? TextField(
                    controller: controller.searchController,
                    decoration: _getInputDecoration(
                      'Search packing houses...',
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
                'No packing houses found',
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
              final house = controller.searchResults[index];
              final exists = (glb.roleType.value == "Grower")
                  ? Get.find<GrowerController>()
                      .packingHouses
                      .any((existingDriver) => existingDriver.id == house.id)
                  : (glb.roleType.value == "Aadhti")
                      ? Get.find<AadhatiController>().associatedPackHouses.any(
                          (existingDriver) => existingDriver.id == house.id)
                      : (glb.roleType.value == "HPMC DEPOT")
                          ? Get.find<HPAgriBoardController>()
                              .associatedPackHouses
                              .any((existingDriver) =>
                                  existingDriver.id == house.id)
                          : Get.find<DriverController>()
                              .associatedPackhouses
                              .any((existingDriver) =>
                                  existingDriver.id == house.id);

              return Stack(
                children: [
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: exists
                          ? null
                          : () => controller.selectPackingHouse(house),
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
                                  Icon(
                                    Icons.business,
                                    color: const Color(0xff548235),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          house.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Tray Type: ${house.trayType?.toString().split('.').last ?? 'Not specified'}',
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
                                'Phone: ${house.phoneNumber}',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.location_on,
                                'Address: ${house.address}',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.inventory,
                                'Crates: ${house.numberOfCrates}',
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

  Widget _buildNewPackingHouseForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      'Packing House Name',
                      prefixIcon: Icons.business,
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter packing house name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.phoneController,
                          decoration: _getInputDecoration(
                            'Phone Number',
                            prefixIcon: Icons.phone,
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter phone number'
                              : null,
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
                    controller: controller.addressController,
                    decoration: _getInputDecoration(
                      'Address',
                      prefixIcon: Icons.location_on,
                    ),
                    maxLines: 2,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter address' : null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSubmitButton(),
        ],
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
          'Add Packing House',
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
