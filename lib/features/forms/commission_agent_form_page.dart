import 'package:apple_grower/features/ampcOffice/ampcOffice_controller.dart';
import 'package:apple_grower/models/aadhati.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/global_role_loader.dart' as gld;
import '../../core/globals.dart' as glb;
import '../freightForwarder/freightForwarder_controller.dart';
import '../grower/grower_controller.dart';
import '../ladaniBuyers/ladaniBuyers_controller.dart';
import '../packHouse/packHouse_controller.dart';
import '../transportUnion/transportUnion_controller.dart';

class CommissionAgentFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final apmcController = TextEditingController();
  final addressController = TextEditingController();
  final tradingFirmController = TextEditingController();
  final tradingYearsController = TextEditingController();
  final firmTypeController = TextEditingController();
  final licenseNoController = TextEditingController();
  final salesLocationController = TextEditingController();
  final googleLocationController = TextEditingController();
  final boxes2023Controller = TextEditingController();
  final boxes2024Controller = TextEditingController();
  final target2025Controller = TextEditingController();
  final growersServedController = TextEditingController();
  final needTradeFinance = false.obs;
  final searchController = TextEditingController();
  final isLoading = false.obs;
  final isSearching = true.obs;
  final searchResults = <Aadhati>[].obs;
  RxList<Aadhati> availableAadhatis = <Aadhati>[].obs;
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
          await http.get(Uri.parse(glb.url + '/api/agents/nearby10'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        availableAadhatis.value = data
            .map((e) => Aadhati(
                  id: e['_id']?.toString(),
                  name: e['name'],
                  contact: e['contact'],
                  apmc: e['apmc_ID'],
                  address: e['address'],
                  nameOfTradingFirm: e['nameOfTradingFirm'],
                  tradingSinceYears: e['tradingSinceYears'],
                  firmType: e['firmType'],
                  licenseNo: e['licenseNo'],
                  salesPurchaseLocationName: e['salesPurchaseLocationName'],
                  locationOnGoogle: e['locationOnGoogle'],
                  appleBoxesPurchased2023: e['appleBoxesPurchased2023'],
                  appleBoxesPurchased2024: e['appleBoxesPurchased2024'],
                  estimatedTarget2025: (e['estimatedTarget2025'] is int)
                      ? (e['estimatedTarget2025'] as int).toDouble()
                      : e['estimatedTarget2025'],
                  needTradeFinance: e['needTradeFinance'],
                  noOfAppleGrowersServed: e['noOfAppleGrowersServed'],
                ))
            .toList()
            .cast<Aadhati>();
        searchResults.value = availableAadhatis;
        print(availableAadhatis.last.name);
        print(availableAadhatis.last.address);
      } else {
        Get.snackbar('Error', 'Failed to load agents: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load agents: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    apmcController.dispose();
    addressController.dispose();
    tradingFirmController.dispose();
    tradingYearsController.dispose();
    firmTypeController.dispose();
    licenseNoController.dispose();
    salesLocationController.dispose();
    googleLocationController.dispose();
    boxes2023Controller.dispose();
    boxes2024Controller.dispose();
    target2025Controller.dispose();
    growersServedController.dispose();
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
      searchResults.value = availableAadhatis;
      return;
    }
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
          glb.url + '/api/agents/${Uri.encodeComponent(query)}/searchbyName'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        searchResults.value = data
            .map((e) => Aadhati(
                  id: e['_id']?.toString(),
                  name: e['name'],
                  contact: e['contact'],
                  apmc: e['apmc'],
                  address: e['address'],
                  nameOfTradingFirm: e['nameOfTradingFirm'],
                  tradingSinceYears: e['tradingSinceYears'],
                  firmType: e['firmType'],
                  licenseNo: e['licenseNo'],
                  salesPurchaseLocationName: e['salesPurchaseLocationName'],
                  locationOnGoogle: e['locationOnGoogle'],
                  appleBoxesPurchased2023: e['appleBoxesPurchased2023'],
                  appleBoxesPurchased2024: e['appleBoxesPurchased2024'],
                  estimatedTarget2025: (e['estimatedTarget2025'] is int)
                      ? (e['estimatedTarget2025'] as int).toDouble()
                      : e['estimatedTarget2025'],
                  needTradeFinance: e['needTradeFinance'],
                  noOfAppleGrowersServed: e['noOfAppleGrowersServed'],
                ))
            .toList()
            .cast<Aadhati>();
      } else {
        Get.snackbar(
            'Error', 'Failed to search agents: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to search agents: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectAgent(Aadhati agent) {
    // Check if agent already exists
    final exists = (glb.roleType.value == "PackHouse")
        ? Get.find<PackHouseController>()
            .associatedAadhatis
            .any((existingDriver) => existingDriver.id == agent.id)
        : (glb.roleType.value == "Grower")
            ? Get.find<GrowerController>()
                .commissionAgents
                .any((existingDriver) => existingDriver.id == agent.id)
            : (glb.roleType.value == "Ladani/Buyers")
                ? Get.find<LadaniBuyersController>()
                    .associatedAadhatis
                    .any((existingDriver) => existingDriver.id == agent.id)
                : (glb.roleType.value == "Freight Forwarder")
                    ? Get.find<FreightForwarderController>()
                        .associatedAadhatis
                        .any((existingDriver) => existingDriver.id == agent.id)
                    : (glb.roleType.value == "Transport Union")
                        ? Get.find<TransportUnionController>().associatedAadhatis.any(
                            (existingDriver) => existingDriver.id == agent.id)
                        : (glb.roleType.value == "APMC Office")
                            ? Get.find<ApmcOfficeController>().flag.value
                                ? Get.find<ApmcOfficeController>()
                                    .approvedAadhatis
                                    .any((existingDriver) =>
                                        existingDriver.id == agent.id)
                                : Get.find<ApmcOfficeController>()
                                    .blacklistedAadhatis
                                    .any((existingDriver) =>
                                        existingDriver.id == agent.id)
                            : Get.find<TransportUnionController>()
                                .associatedAadhatis
                                .any((existingDriver) =>
                                    existingDriver.id == agent.id);

    if (exists) {
      Get.snackbar(
        'Agent Already Added',
        'This commission agent is already in your list',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    (glb.roleType.value == "PackHouse")
        ? Get.find<PackHouseController>().addAssociatedAadhati(agent)
        : (glb.roleType.value == "Grower")
            ? Get.find<GrowerController>().addCommissionAgent(agent)
            : (glb.roleType.value == "Ladani/Buyers")
                ? Get.find<LadaniBuyersController>()
                    .addAssociatedAadhatis(agent)
                : (glb.roleType.value == "Freight Forwarder")
                    ? Get.find<FreightForwarderController>()
                        .addAssociatedAadhatis(agent)
                    : (glb.roleType.value == "Transport Union")
                        ? Get.find<TransportUnionController>()
                            .addAssociatedAadhatis(agent)
                        : Get.find<ApmcOfficeController>().addAdhati(agent);

    Get.back();
  }

  void submitForm() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final agent = Aadhati(
        name: nameController.text,
        contact: phoneController.text,
        apmc: apmcController.text,
      );
      (glb.roleType.value == "PackHouse")
          ? Get.find<PackHouseController>().addAssociatedAadhati(agent)
          : (glb.roleType.value == "Grower")
              ? Get.find<GrowerController>().addCommissionAgent(agent)
              : (glb.roleType.value == "Ladani/Buyers")
                  ? Get.find<LadaniBuyersController>()
                      .addAssociatedAadhatis(agent)
                  : (glb.roleType.value == "Freight Forwarder")
                      ? Get.find<FreightForwarderController>()
                          .addAssociatedAadhatis(agent)
                      : (glb.roleType.value == "Transport Union")
                          ? Get.find<TransportUnionController>()
                              .addAssociatedAadhatis(agent)
                          : Get.find<ApmcOfficeController>().addAdhati(agent);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error adding commission agent: $e',
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

class CommissionAgentFormPage extends StatelessWidget {
  CommissionAgentFormPage({super.key});

  final controller = Get.put(CommissionAgentFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Commission Agent'),
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
                    : _buildNewAgentForm()),
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
                  'Select or Create Agent',
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
                      'Search agents...',
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
              'No agents found',
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
          final agent = controller.searchResults[index];
          final exists = (glb.roleType.value == "PackHouse")
              ? Get.find<PackHouseController>()
                  .associatedAadhatis
                  .any((existingDriver) => existingDriver.id == agent.id)
              : (glb.roleType.value == "Grower")
                  ? Get.find<GrowerController>()
                      .commissionAgents
                      .any((existingDriver) => existingDriver.id == agent.id)
                  : (glb.roleType.value == "Ladani/Buyers")
                      ? Get.find<LadaniBuyersController>()
                          .associatedAadhatis
                          .any(
                              (existingDriver) => existingDriver.id == agent.id)
                      : (glb.roleType.value == "Freight Forwarder")
                          ? Get.find<FreightForwarderController>().associatedAadhatis.any(
                              (existingDriver) => existingDriver.id == agent.id)
                          : (glb.roleType.value == "Transport Union")
                              ? Get.find<TransportUnionController>()
                                  .associatedAadhatis
                                  .any((existingDriver) =>
                                      existingDriver.id == agent.id)
                              : (glb.roleType.value == "APMC Office")
                                  ? Get.find<ApmcOfficeController>().flag.value
                                      ? Get.find<ApmcOfficeController>()
                                          .approvedAadhatis
                                          .any((existingDriver) =>
                                              existingDriver.id == agent.id)
                                      : Get.find<ApmcOfficeController>()
                                          .blacklistedAadhatis
                                          .any((existingDriver) =>
                                              existingDriver.id == agent.id)
                                  : Get.find<TransportUnionController>()
                                      .associatedAadhatis
                                      .any((existingDriver) => existingDriver.id == agent.id);
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
                  onTap: exists ? null : () => controller.selectAgent(agent),
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
                                      agent.name ?? 'N/A',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Trading Firm: ${agent.nameOfTradingFirm ?? 'N/A'}',
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
                            Icons.store,
                            'APMC: ${agent.apmc ?? 'N/A'}',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.phone,
                            'Phone: ${agent.contact ?? 'N/A'}',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.location_on,
                            'Address: ${agent.address ?? 'N/A'}',
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

  Widget _buildNewAgentForm() {
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
                'Commission Agent Name',
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
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.apmcController,
              decoration: _getInputDecoration(
                'APMC Mandi',
                prefixIcon: Icons.store,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter APMC Mandi' : null,
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
          'Create Commission Agent',
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
