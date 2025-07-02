import 'package:apple_grower/features/aadhati/aadhati_controller.dart';
import 'package:apple_grower/features/freightForwarder/freightForwarder_controller.dart';
import 'package:apple_grower/features/hpAgriBoard/hpAgriBoard_controller.dart';
import 'package:apple_grower/features/packHouse/packHouse_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/globalsWidgets.dart' as glbw;
import '../../core/globals.dart' as glb;
import '../../models/transport_model.dart';
import '../driver/driver_controller.dart';
import '../grower/grower_controller.dart';
import '../ladaniBuyers/ladaniBuyers_controller.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class TransportUnionFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final searchController = TextEditingController();
  final isLoading = false.obs;
  final isSearching = true.obs;
  final searchResults = <Transport>[].obs;
  final availableUnions = <Transport>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final response =
          await http.get(Uri.parse('${glb.url}/api/transportunion/nearby10'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        availableUnions.value = data.map((e) => Transport(
          id: e['_id']?.toString(), // MongoDB usually returns `_id`
          name: e['name'],
          contact: e['contact'],
          address: e['address'],
          noOfLightCommercialVehicles: e['LCVs'],
          noOfMediumCommercialVehicles: e['MCVs'],
          noOfHeavyCommercialVehicles: e['HCVs'],
          appleBoxesTransported2023: e['boxesTransportedT3'], // Update if wrong
          appleBoxesTransported2024: e['boxesTransportedT2'], // Update if wrong
          estimatedTarget2025: (e['estimatedTarget2025'] is int)
              ? (e['estimatedTarget2025'] as int).toDouble()
              : e['estimatedTarget2025'],
          statesDrivenThrough: (e['statesDrivenThrough'] as List<dynamic>?)
              ?.join(', '),
          appleGrowers: [], // or use actual parsing if data present
          aadhatis: [],
          buyers: [],
          associatedDrivers: [],
        )).toList().cast<Transport>();

        searchResults.value = availableUnions;
      } else {
        Get.snackbar(
          'Error',
          'Failed to load transport unions: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load transport unions: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
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
        duration: const Duration(seconds: 5),
      );
      return;
    }

    try {
      final status = await Permission.contacts.request();
      if (!status.isGranted) {
        if (status.isPermanentlyDenied) {
          await openAppSettings();
        }
        throw Exception('Contacts permission denied');
      }

      final contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        nameController.text = contact.displayName;
        if (contact.phones.isNotEmpty) {
          String phoneNumber =
              contact.phones.first.number.replaceAll(RegExp(r'[^0-9]'), '');
          if (phoneNumber.length > 10) {
            phoneNumber = phoneNumber.substring(phoneNumber.length - 10);
          }
          phoneController.text = phoneNumber;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> onSearchChanged(String query) async {
    if (query.isEmpty) {
      searchResults.value = availableUnions;
      return;
    }
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(
            '${glb.url}/api/transportunion/${Uri.encodeComponent(query)}/searchbyName'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        searchResults.value =
            data.map((e) => Transport(
              id: e['_id']?.toString(), // MongoDB usually returns `_id`
              name: e['name'],
              contact: e['contact'],
              address: e['address'],
              noOfLightCommercialVehicles: e['LCVs'],
              noOfMediumCommercialVehicles: e['MCVs'],
              noOfHeavyCommercialVehicles: e['HCVs'],
              appleBoxesTransported2023: e['boxesTransportedT3'], // Update if wrong
              appleBoxesTransported2024: e['boxesTransportedT2'], // Update if wrong
              estimatedTarget2025: (e['estimatedTarget2025'] is int)
                  ? (e['estimatedTarget2025'] as int).toDouble()
                  : e['estimatedTarget2025'],
              statesDrivenThrough: (e['statesDrivenThrough'] as List<dynamic>?)
                  ?.join(', '),
              appleGrowers: [], // or use actual parsing if data present
              aadhatis: [],
              buyers: [],
              associatedDrivers: [],
            )).toList().cast<Transport>();
      } else {
        Get.snackbar(
          'Error',
          'Failed to search unions: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to search unions: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectUnion(Transport union) {
    final exists = _checkUnionExists(union);
    if (exists) {
      Get.snackbar(
        'Union Already Added',
        'This transport union is already in your list',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    _addUnionBasedOnRole(union);
    Get.back();
  }

  bool _checkUnionExists(Transport union) {
    switch (glb.roleType.value) {
      case "Grower":
        return Get.find<GrowerController>()
            .transportUnions
            .any((u) => u.id == union.id);
      case "Driver":
        return Get.find<DriverController>()
            .associatedTransportUnions
            .any((u) => u.id == union.id);
      case "PackHouse":
        return Get.find<PackHouseController>()
            .associatedTransportUnions
            .any((u) => u.id == union.id);
      case "HPMC DEPOT":
        return Get.find<HPAgriBoardController>()
            .associatedTransportUnions
            .any((u) => u.id == union.id);
      case "Freight Forwarder":
        return Get.find<FreightForwarderController>()
            .associatedTransportUnions
            .any((u) => u.id == union.id);
      case "Aadhati":
        return Get.find<AadhatiController>() .associatedTransportUnions
            .any((u) => u.id == union.id);
      default:
        return Get.find<LadaniBuyersController>()
            .associatedTransportUnions
            .any((u) => u.id == union.id);
    }
  }

  void _addUnionBasedOnRole(Transport union) {
    switch (glb.roleType.value) {
      case "Grower":
        Get.find<GrowerController>().addTransportUnion(union);
        break;
      case "Driver":
        Get.find<DriverController>().addTransportUnion(union);
        break;
      case "PackHouse":
        Get.find<PackHouseController>().addAssociatedTransportUnion(union);
        break;
      case "HPMC DEPOT":
        Get.find<HPAgriBoardController>().addAssociatedTransportUnion(union);
        break;
      case "Freight Forwarder":
        Get.find<FreightForwarderController>()
            .addAssociatedTransportUnion(union);
        break;
      case "Aadhati":
    Get.find<AadhatiController>() .addAssociatedTransportUnion(union);
            break;
      default:
        Get.find<LadaniBuyersController>().addAssociatedTransportUnion(union);
    }
  }

  void submitForm() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final union = Transport(
        name: nameController.text,
        contact: phoneController.text,
        address: addressController.text,
      );

      _addUnionBasedOnRole(union);
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error adding transport union: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class TransportUnionFormPage extends StatelessWidget {
  TransportUnionFormPage({super.key});

  final controller = Get.put(TransportUnionFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transport Union'),
        backgroundColor: const Color(0xff548235),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Obx(() => controller.isLoading.value
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                    : _buildNewUnionForm()),
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
                  'Select or Create Union',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 400 ? 20 : 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff548235),
                  ),
                ),
                Obx(() => TextButton.icon(
                      onPressed: () => controller.isSearching.toggle(),
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
                      'Search unions...',
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
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (controller.searchResults.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'No unions found',
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
          final union = controller.searchResults[index];
          final exists = controller._checkUnionExists(union);

          return Stack(
            children: [
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: exists ? null : () => controller.selectUnion(union),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      union.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Contact: ${union.contact}',
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
                            Icons.location_on,
                            'Address: ${union.address}',
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

  Widget _buildNewUnionForm() {
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
                'Union Name',
                prefixIcon: Icons.business,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter union name' : null,
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
                'Address (Optional)',
                prefixIcon: Icons.location_on,
              ),
              maxLines: 2,
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
          'Add Union',
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
