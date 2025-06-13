import 'package:apple_grower/features/ampcOffice/ampcOffice_controller.dart';
import 'package:apple_grower/features/hpAgriBoard/hpAgriBoard_controller.dart';
import 'package:apple_grower/models/aadhati.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  var exists;

  @override
  void onInit() {
    super.onInit();
    searchResults.value = glb.availableAadhatis;
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

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      searchResults.value = glb.availableAadhatis;
    } else {
      searchResults.value = glb.availableAadhatis.where((agent) {
        final name = agent.name!.toLowerCase();
        final apmc = agent.apmc!.toLowerCase();
        final address = agent.address!.toLowerCase();
        final searchLower = query.toLowerCase();

        return name.contains(searchLower) ||
            apmc.contains(searchLower) ||
            address.contains(searchLower);
      }).toList();
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
                                ? Get.find<ApmcOfficeController>().approvedAadhatis.any((existingDriver) =>
                                    existingDriver.id == agent.id)
                                : Get.find<ApmcOfficeController>()
                                    .blacklistedAadhatis
                                    .any((existingDriver) =>
                                        existingDriver.id == agent.id): Get.find<TransportUnionController>().associatedAadhatis.any(
            (existingDriver) => existingDriver.id == agent.id);

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
                        ? Get.find<TransportUnionController>().addAssociatedAadhatis(agent)
                        :  Get.find<ApmcOfficeController>().addAdhati(agent);


    Get.back();
  }

  void submitForm() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final agent = Aadhati(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        contact: phoneController.text,
        apmc: apmcController.text,
        address: addressController.text,
        nameOfTradingFirm: tradingFirmController.text,
        tradingSinceYears: int.tryParse(tradingYearsController.text),
        firmType: firmTypeController.text,
        licenseNo: licenseNoController.text,
        salesPurchaseLocationName: salesLocationController.text,
        locationOnGoogle: googleLocationController.text,
        appleBoxesPurchased2023: int.tryParse(boxes2023Controller.text),
        appleBoxesPurchased2024: int.tryParse(boxes2024Controller.text),
        estimatedTarget2025: double.tryParse(target2025Controller.text),
        needTradeFinance: needTradeFinance.value,
        noOfAppleGrowersServed: int.tryParse(growersServedController.text),
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
          ? Get.find<TransportUnionController>().addAssociatedAadhatis(agent)
          :  Get.find<ApmcOfficeController>().addAdhati(agent);

      Get.back();
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
    return Obx(() => controller.searchResults.isEmpty
        ? const Center(
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
          )
        : ListView.builder(
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
                      ? Get.find<GrowerController>().commissionAgents.any(
                          (existingDriver) => existingDriver.id == agent.id)
                      : (glb.roleType.value == "Ladani/Buyers")
                          ? Get.find<LadaniBuyersController>()
                              .associatedAadhatis
                              .any((existingDriver) =>
                                  existingDriver.id == agent.id)
                          : (glb.roleType.value == "Freight Forwarder")
                              ? Get.find<FreightForwarderController>()
                                  .associatedAadhatis
                                  .any((existingDriver) =>
                                      existingDriver.id == agent.id)
                              : (glb.roleType.value == "Transport Union")
                                  ? Get.find<TransportUnionController>()
                                      .associatedAadhatis
                                      .any((existingDriver) =>
                                          existingDriver.id == agent.id)
                                  : (glb.roleType.value == "APMC Office")
                                      ? Get.find<ApmcOfficeController>()
                                              .flag
                                              .value
                                          ? Get.find<ApmcOfficeController>()
                                              .approvedAadhatis
                                              .any((existingDriver) =>
                                                  existingDriver.id == agent.id)
                                          : Get.find<ApmcOfficeController>()
                                              .blacklistedAadhatis
                                              .any((existingDriver) => existingDriver.id == agent.id)
                                      : Get.find<TransportUnionController>().associatedAadhatis.any(
                      (existingDriver) => existingDriver.id == agent.id);
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
                          exists ? null : () => controller.selectAgent(agent),
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
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.business,
                                'Firm Type: ${agent.firmType ?? 'N/A'}',
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

  Widget _buildNewAgentForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBasicDetails(),
          const SizedBox(height: 24),
          _buildTradingDetails(),
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
              controller: controller.nameController,
              decoration: _getInputDecoration(
                'Commission Agent Name',
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
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter phone number' : null,
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
    );
  }

  Widget _buildTradingDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trading Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.tradingFirmController,
              decoration: _getInputDecoration(
                'Trading Firm Name',
                prefixIcon: Icons.business,
              ),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter trading firm name'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.tradingYearsController,
              decoration: _getInputDecoration(
                'Years in Trading',
                prefixIcon: Icons.calendar_today,
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter years in trading'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.firmTypeController,
              decoration: _getInputDecoration(
                'Firm Type (Prop./Partnership/HUF/PL/LLP/OPC)',
                prefixIcon: Icons.business_center,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter firm type' : null,
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
              controller: controller.salesLocationController,
              decoration: _getInputDecoration(
                'Sales/Purchase Location',
                prefixIcon: Icons.location_city,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter sales location' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.googleLocationController,
              decoration: _getInputDecoration(
                'Google Location',
                prefixIcon: Icons.map,
              ),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter Google location'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.boxes2023Controller,
              decoration: _getInputDecoration(
                'Apple Boxes Purchased in 2023',
                prefixIcon: Icons.inventory,
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter boxes purchased in 2023'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.boxes2024Controller,
              decoration: _getInputDecoration(
                'Apple Boxes Purchased in 2024',
                prefixIcon: Icons.inventory,
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter boxes purchased in 2024'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.target2025Controller,
              decoration: _getInputDecoration(
                'Estimated Target for 2025',
                prefixIcon: Icons.trending_up,
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter estimated target for 2025'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.growersServedController,
              decoration: _getInputDecoration(
                'Number of Apple Growers Served',
                prefixIcon: Icons.people,
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter number of growers served'
                  : null,
            ),
            const SizedBox(height: 16),
            Obx(() => SwitchListTile(
                  title: const Text('Need Trade Finance'),
                  value: controller.needTradeFinance.value,
                  onChanged: (value) =>
                      controller.needTradeFinance.value = value,
                  activeColor: const Color(0xff548235),
                )),
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
          'Add Commission Agent',
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
