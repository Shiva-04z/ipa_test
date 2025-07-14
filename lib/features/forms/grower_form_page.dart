import 'package:apple_grower/features/aadhati/aadhati_controller.dart';
import 'package:apple_grower/features/hpAgriBoard/hpAgriBoard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/grower_model.dart';
import '../../core/globals.dart' as glb;
import '../driver/driver_controller.dart';
import '../freightForwarder/freightForwarder_controller.dart';
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
  RxList<Grower> availableGrowers = <Grower>[].obs;
  var exists;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final response =
          await http.get(Uri.parse(glb.url + '/api/growers/nearby10'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        availableGrowers.value = data
            .map((e) => Grower(
                  id: e['_id']?.toString(),
                  name: e['name'],
                  aadharNumber: e['aadharNumber'],
                  phoneNumber: e['phoneNumber'],
                  address: e['address'],
                  pinCode: e['pinCode'],
                  orchards: [],
                  commissionAgents: [],
                  corporateCompanies: [],
                  consignments: [],
                  packingHouses: [],
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ))
            .toList()
            .cast<Grower>();
        searchResults.value = availableGrowers;
      } else {
        Get.snackbar('Error', 'Failed to load growers: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load growers: $e');
    } finally {
      isLoading.value = false;
    }
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
            // Get the first phone number and remove any non-digit characters
            String phoneNumber =
                contact.phones.first.number.replaceAll(RegExp(r'[^\d]'), '');
            // Ensure it's 10 digits
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

  Future<void> onSearchChanged(String query) async {
    if (query.isEmpty) {
      searchResults.value = availableGrowers;
      return;
    }
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
          glb.url + '/api/growers/${Uri.encodeComponent(query)}/searchbyName'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        searchResults.value = data
            .map((e) => Grower(
                  id: e['_id']?.toString(),
                  name: e['name'],
                  aadharNumber: e['aadharNumber'],
                  phoneNumber: e['phoneNumber'],
                  address: e['address'],
                  pinCode: e['pinCode'],
                  orchards: [],
                  commissionAgents: [],
                  corporateCompanies: [],
                  consignments: [],
                  packingHouses: [],
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ))
            .toList()
            .cast<Grower>();
      } else {
        Get.snackbar(
            'Error', 'Failed to search growers: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to search growers: $e');
    } finally {
      isLoading.value = false;
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
                    : (glb.roleType.value == "HPMC DEPOT")
                        ? Get.find<HPAgriBoardController>()
                            .associatedGrowers
                            .any((existingDriver) =>
                                existingDriver.id == grower.id)
                        : Get.find<TransportUnionController>()
                            .associatedGrowers
                            .any((existingDriver) =>
                                existingDriver.id == grower.id);

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
                    : (glb.roleType.value == "HPMC DEPOT")
                        ? Get.find<HPAgriBoardController>()
                            .addAssociatedGrower(grower)
                        : Get.find<TransportUnionController>()
                            .addAssociatedGrower(grower);
    Get.back();
  }

  void submitForm() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final grower = Grower(
        name: nameController.text, // Default empty value
        phoneNumber: phoneController.text,
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
                      : (glb.roleType.value == "HPMC DEPOT")
                          ? Get.find<HPAgriBoardController>()
                              .addAssociatedGrower(grower)
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
      color: Colors.white,
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
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          height: MediaQuery.of(Get.context!).size.height,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (controller.searchResults.isEmpty) {
        return const Center(
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
        );
      }
      return ListView.builder(
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
                  ? Get.find<AadhatiController>()
                      .associatedGrowers
                      .any((existingDriver) => existingDriver.id == grower.id)
                  : (glb.roleType.value == "Freight Forwarder")
                      ? Get.find<FreightForwarderController>()
                          .associatedGrowers
                          .any((existingDriver) =>
                              existingDriver.id == grower.id)
                      : (glb.roleType.value == "Driver")
                          ? Get.find<DriverController>().associatedGrowers.any(
                              (existingDriver) =>
                                  existingDriver.id == grower.id)
                          : (glb.roleType.value == "HPMC DEPOT")
                              ? Get.find<HPAgriBoardController>()
                                  .associatedGrowers
                                  .any((existingDriver) =>
                                      existingDriver.id == grower.id)
                              : Get.find<TransportUnionController>()
                                  .associatedGrowers
                                  .any((existingDriver) =>
                                      existingDriver.id == grower.id);

          return Stack(
            children: [
              Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: exists ? null : () => controller.selectGrower(grower),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      grower.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Aadhar: ${grower.aadharNumber ?? 'N/A'}',
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
                            'Address: ${grower.address ?? 'N/A'}',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.pin_drop,
                            'PIN Code: ${grower.pinCode ?? 'N/A'}',
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
      );
    });
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
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildBasicDetails() {
    return Card(
      color: Colors.white,
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
                'Grower Name',
                prefixIcon: Icons.person,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter name' : null,
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
