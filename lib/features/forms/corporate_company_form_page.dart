import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/globals.dart' as glb;
import '../../models/ladani_model.dart';
import '../aadhati/aadhati_controller.dart';
import '../ampcOffice/ampcOffice_controller.dart';
import '../driver/driver_controller.dart';
import '../freightForwarder/freightForwarder_controller.dart';
import '../grower/grower_controller.dart';
import '../hpAgriBoard/hpAgriBoard_controller.dart';
import '../packHouse/packHouse_controller.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class CorporateCompanyFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final tradingFirmController = TextEditingController();
  final tradingYearsController = TextEditingController();
  final firmTypeController = TextEditingController();
  final licenseNoController = TextEditingController();
  final purchaseLocationController = TextEditingController();
  final apmcController = TextEditingController();
  final googleLocationController = TextEditingController();
  final boxes2023Controller = TextEditingController();
  final boxes2024Controller = TextEditingController();
  final target2025Controller = TextEditingController();
  final perBoxExpensesController = TextEditingController();
  final searchController = TextEditingController();
  final isLoading = false.obs;
  final isSearching = true.obs;
  final searchResults = <Ladani>[].obs;
  final availableCompanies = <Ladani>[].obs;
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
          await http.get(Uri.parse(glb.url + '/api/ladanis/nearby10'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        availableCompanies.value =
            data.map((e) => Ladani.fromJson(e)).toList().cast<Ladani>();
        searchResults.value = availableCompanies;
      } else {
        Get.snackbar(
            'Error', 'Failed to load companies: \\${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load companies: $e');
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
        duration: Duration(seconds: 5),
      );
      return;
    }
    try {
      final status = await Permission.contacts.request();
      if (status.isGranted) {
        final contact = await FlutterContacts.openExternalPick();
        if (contact != null) {
          print('Picked contact: ' + contact.toString());
          print('Contact phones: ' + contact.phones.toString());
          nameController.text = contact.displayName;
          if (contact.phones.isNotEmpty) {
            String phoneNumber =
                contact.phones.first.number.replaceAll(RegExp(r'[^\d]'), '');
            if (phoneNumber.length > 10) {
              phoneNumber = phoneNumber.substring(phoneNumber.length - 10);
            }
            phoneController.text = phoneNumber;
          } else {
            print('No phone numbers found for this contact.');
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
      searchResults.value = availableCompanies;
      return;
    }
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(glb.url +
            '/api/ladanis/' +
            Uri.encodeComponent(query) +
            '/searchbyName'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        searchResults.value =
            data.map((e) => Ladani.fromJson(e)).toList().cast<Ladani>();
      } else {
        Get.snackbar(
            'Error', 'Failed to search Ladani: \\${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to search Ladani: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    tradingFirmController.dispose();
    tradingYearsController.dispose();
    firmTypeController.dispose();
    licenseNoController.dispose();
    purchaseLocationController.dispose();
    apmcController.dispose();
    googleLocationController.dispose();
    boxes2023Controller.dispose();
    boxes2024Controller.dispose();
    target2025Controller.dispose();
    perBoxExpensesController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void selectCompany(Ladani company) {
    // Check if company already exists
    final exists = (glb.roleType.value == "Grower")
        ? Get.find<GrowerController>()
            .corporateCompanies
            .any((existingDriver) => existingDriver.id == company.id)
        : (glb.roleType.value == "PackHouse")
            ? Get.find<PackHouseController>()
                .associatedLadanis
                .any((existingDriver) => existingDriver.id == company.id)
            : (glb.roleType.value == "Aadhati")
                ? Get.find<AadhatiController>()
                    .associatedLadanis
                    .any((existingDriver) => existingDriver.id == company.id)
                : (glb.roleType.value == "Freight Forwarder")
                    ? Get.find<FreightForwarderController>()
                        .associatedLadanis
                        .any(
                            (existingDriver) => existingDriver.id == company.id)
                    : (glb.roleType.value == "Driver")
                        ? Get.find<DriverController>().associatedBuyers.any(
                            (existingDriver) => existingDriver.id == company.id)
                        : Get.find<ApmcOfficeController>().flag.value
                            ? Get.find<ApmcOfficeController>()
                                .approvedLadanis
                                .any((existingDriver) =>
                                    existingDriver.id == company.id)
                            : Get.find<ApmcOfficeController>()
                                .blacklistedLadanis
                                .any((existingDriver) =>
                                    existingDriver.id == company.id);

    if (exists) {
      Get.snackbar(
        'Company Already Added',
        'This company is already in your list',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    (glb.roleType.value == "PackHouse")
        ? Get.find<PackHouseController>().addAssociatedLadani(company)
        : (glb.roleType.value == "Aadhati")
            ? Get.find<AadhatiController>().addAssociatedLadani(company)
            : (glb.roleType.value == "Grower")
                ? Get.find<GrowerController>().addCorporateCompany(company)
                : (glb.roleType.value == "Freight Forwarder")
                    ? Get.find<FreightForwarderController>()
                        .addAssociatedLadani(company)
                    : (glb.roleType.value == "Driver")
                        ? Get.find<DriverController>()
                            .addAssociatedBuyer(company)
                        : Get.find<ApmcOfficeController>().addLadani(company);
    Get.back();
  }

  void submitForm() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final newCompany = Ladani(
        name: nameController.text,
        contact: phoneController.text,
        address: addressController.text,
        nameOfTradingFirm: tradingFirmController.text,
      );

      (glb.roleType.value == "PackHouse")
          ? Get.find<PackHouseController>().addAssociatedLadani(newCompany)
          : (glb.roleType.value == "Aadhati")
              ? Get.find<AadhatiController>().addAssociatedLadani(newCompany)
              : (glb.roleType.value == "Grower")
                  ? Get.find<GrowerController>().addCorporateCompany(newCompany)
                  : (glb.roleType.value == "Freight Forwarder")
                      ? Get.find<FreightForwarderController>()
                          .addAssociatedLadani(newCompany)
                      : (glb.roleType.value == "Driver")
                          ? Get.find<DriverController>()
                              .addAssociatedBuyer(newCompany)
                          : Get.find<ApmcOfficeController>()
                              .addLadani(newCompany);

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error adding Ladani: $e',
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

class CorporateCompanyFormPage extends StatelessWidget {
  CorporateCompanyFormPage({super.key});

  final controller = Get.put(CorporateCompanyFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Ladani/Buyer'),
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
                    : _buildNewCompanyForm()),
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
                    'Select or Create Ladani/Buyers',
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width > 400 ? 20 : 14,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      color: Color(0xff548235),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() => TextButton.icon(
                        onPressed: () => controller.isSearching.value =
                            !controller.isSearching.value,
                        icon: Icon(
                          controller.isSearching.value
                              ? Icons.add
                              : Icons.search,
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
                      'Search Ladanis...',
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
                'No Ladani found',
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
              final company = controller.searchResults[index];
              final exists = (glb.roleType.value == "Grower")
                  ? Get.find<GrowerController>()
                      .corporateCompanies
                      .any((existingDriver) => existingDriver.id == company.id)
                  : (glb.roleType.value == "PackHouse")
                      ? Get.find<PackHouseController>().associatedLadanis.any(
                          (existingDriver) => existingDriver.id == company.id)
                      : (glb.roleType.value == "Aadhati")
                          ? Get.find<AadhatiController>().associatedLadanis.any(
                              (existingDriver) =>
                                  existingDriver.id == company.id)
                          : (glb.roleType.value == "Freight Forwarder")
                              ? Get.find<FreightForwarderController>()
                                  .associatedLadanis
                                  .any((existingDriver) =>
                                      existingDriver.id == company.id)
                              : (glb.roleType.value == "Driver")
                                  ? Get.find<DriverController>()
                                      .associatedBuyers
                                      .any((existingDriver) =>
                                          existingDriver.id == company.id)
                                  : Get.find<ApmcOfficeController>().flag.value
                                      ? Get.find<ApmcOfficeController>()
                                          .approvedLadanis
                                          .any((existingDriver) =>
                                              existingDriver.id == company.id)
                                      : Get.find<ApmcOfficeController>()
                                          .blacklistedLadanis
                                          .any((existingDriver) =>
                                              existingDriver.id == company.id);
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
                          : () => controller.selectCompany(company),
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
                                          company.name ?? 'N/A',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Trading Firm: ${company.nameOfTradingFirm ?? 'N/A'}',
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
                                Icons.category,
                                'Type: ${company.firmType ?? 'N/A'}',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.phone,
                                'Phone: ${company.contact ?? 'N/A'}',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.location_on,
                                'Address: ${company.address ?? 'N/A'}',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.store,
                                'APMC: ${company.licensesIssuingAPMC ?? 'N/A'}',
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

  Widget _buildNewCompanyForm() {
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
                      'Company Name',
                      prefixIcon: Icons.business,
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter company name'
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
                    controller: controller.tradingFirmController,
                    decoration: _getInputDecoration(
                      'Name of Firm',
                      prefixIcon: Icons.business_center,
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter name of firm'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.addressController,
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
          'Add Corporate Company',
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
