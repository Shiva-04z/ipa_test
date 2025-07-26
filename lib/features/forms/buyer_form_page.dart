import 'package:apple_grower/features/grower/grower_controller.dart';
import 'package:apple_grower/features/packHouse/packHouse_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/globalsWidgets.dart' as glbw;
import '../../core/globals.dart' as glb;
import '../../models/freightForwarder.dart';
import '../aadhati/aadhati_controller.dart';
import '../ladaniBuyers/ladaniBuyers_controller.dart';
import '../transportUnion/transportUnion_controller.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class BuyerFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final searchController = TextEditingController();
  final isLoading = false.obs;
  final isSearching = true.obs;
  final searchResults = <FreightForwarder>[].obs;
  final availableBuyers = <FreightForwarder>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('${glb.url}/api/freightforwarders/nearby10'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        availableBuyers.value = data.map((e) => FreightForwarder(
          id: e['_id']?.toString(),
          name: e['name'] ?? '',
          contact: e['contact'] ?? '',
          address: e['address'] ?? '',
          licenseNo: e['licenseNo'],
          forwardingSinceYears: e['forwadingExperience'],
          licensesIssuingAuthority: e['issuingAuthority'],
          appleBoxesForwarded2023: e['appleBoxesT1'],
          appleBoxesForwarded2024: e['appleBoxesT2'],
          estimatedForwardingTarget2025: e['appleBoxesT0'],
          createdAt: DateTime.tryParse(e['createdAt'] ?? '') ?? DateTime.now(),
          updatedAt: DateTime.tryParse(e['updatedAt'] ?? '') ?? DateTime.now(),

          // Optional: handle references or galleries if populated
          associatedAadhatis: [], // map if API includes
          associatedGrowers: [],
          associatedPickupProviders: [],
          associatedTruckServiceProviders: [],
          locationOnGoogle: null, // set if API has it
          tradeLicenseOfAadhatiAttached: null,
        )).toList().cast<FreightForwarder>();
        searchResults.value = availableBuyers;
      } else {
        Get.snackbar(
          'Error',
          'Failed to load FreightForwardes: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load FreightForwardes: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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
          String phoneNumber = contact.phones.first.number.replaceAll(RegExp(r'[^0-9]'), '');
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
      searchResults.value = availableBuyers;
      return;
    }
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${glb.url}/api/freightforwarders/${Uri.encodeComponent(query)}/searchbyName'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        searchResults.value = data.map((e) => FreightForwarder(
          id: e['_id']?.toString(),
          name: e['name'] ?? '',
          contact: e['contact'] ?? '',
          address: e['address'] ?? '',
          licenseNo: e['licenseNo'],
          forwardingSinceYears: e['forwadingExperience'],
          licensesIssuingAuthority: e['issuingAuthority'],
          appleBoxesForwarded2023: e['appleBoxesT1'],
          appleBoxesForwarded2024: e['appleBoxesT2'],
          estimatedForwardingTarget2025: e['appleBoxesT0'],
          createdAt: DateTime.tryParse(e['createdAt'] ?? '') ?? DateTime.now(),
          updatedAt: DateTime.tryParse(e['updatedAt'] ?? '') ?? DateTime.now(),

          // Optional: handle references or galleries if populated
          associatedAadhatis: [], // map if API includes
          associatedGrowers: [],
          associatedPickupProviders: [],
          associatedTruckServiceProviders: [],
          locationOnGoogle: null, // set if API has it
          tradeLicenseOfAadhatiAttached: null,
        )).toList().cast<FreightForwarder>();
      } else {
        Get.snackbar(
          'Error',
          'Failed to search FreightForwardes: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to search FreightForwardes: $e',
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

  void selectBuyer(FreightForwarder buyer) {
    final exists = _checkBuyerExists(buyer);
    if (exists) {
      Get.snackbar(
        'Freight Forwarders Already Added',
        'This Freight Forwarders is already in your list',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    _addBuyerBasedOnRole(buyer);
    Get.back();
  }

  bool _checkBuyerExists(FreightForwarder buyer) {
    switch (glb.roleType.value) {
      case "Aadhati":
        return Get.find<AadhatiController>().associatedBuyers.any((b) => b.id == buyer.id);
      case "Ladani/Buyers":
        return Get.find<LadaniBuyersController>().associatedBuyers.any((b) => b.id == buyer.id);
      case "Transport Union":
        return Get.find<TransportUnionController>().associatedFreightForwarders.any((b) => b.id == buyer.id);
      case "Grower":
        return Get.find<GrowerController>().freightForwarders.any((b) => b.id == buyer.id);
      default:
        return Get.find<PackHouseController>().associatedFreightForwarders.any((b) => b.id == buyer.id);
    }
  }

  void _addBuyerBasedOnRole(FreightForwarder buyer) {
    switch (glb.roleType.value) {
      case "Aadhati":
        Get.find<AadhatiController>().addAssociatedBuyer(buyer);
        break;
      case "Ladani/Buyers":
        Get.find<LadaniBuyersController>().addAssociatedBuyers(buyer);
        break;
      case "Transport Union":
        Get.find<TransportUnionController>().addAssociatedBuyers(buyer);
        break;
      case "Grower":
        Get.find<GrowerController>().addFreightForwarder(buyer);
        break;
      default:
        Get.find<PackHouseController>().addAssociatedFreightForwarder(buyer);
    }
  }

  void submitForm() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final now = DateTime.now();
      final buyer = FreightForwarder(
        name: nameController.text,
        contact: phoneController.text,
        address: addressController.text,
        createdAt: now,
        updatedAt: now,
      );

      _addBuyerBasedOnRole(buyer);
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error adding Freight Forwarders: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class BuyerFormPage extends StatelessWidget {
  BuyerFormPage({super.key});

  final controller = Get.put(BuyerFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Freight Forwarders'),
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
                    : _buildNewBuyerForm()),
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
                Expanded(
                  child: Text(
                    'Select or Create Freight Forwarders',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width > 400 ? 20 : 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff548235),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() => TextButton.icon(
                    onPressed: () => controller.isSearching.toggle(),
                    icon: Icon(
                      controller.isSearching.value ? Icons.add : Icons.search,
                      color: const Color(0xff548235),
                    ),
                    label: Text(
                      controller.isSearching.value ? 'Create New' : 'Search Existing',
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
                'Search FreightForwardes...',
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
              'No FreightForwardes found',
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
          final buyer = controller.searchResults[index];
          final exists = controller._checkBuyerExists(buyer);

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
                  onTap: exists ? null : () => controller.selectBuyer(buyer),
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
                                      buyer.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Phone: ${buyer.contact}',
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
                            'Address: ${buyer.address}',
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

  Widget _buildNewBuyerForm() {
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
                'Name',
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
          'Add Freight Forwarders',
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