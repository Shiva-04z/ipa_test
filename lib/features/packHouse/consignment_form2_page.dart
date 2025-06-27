import 'package:apple_grower/features/driver/driver_controller.dart';
import 'package:apple_grower/features/hpAgriBoard/hpAgriBoard_controller.dart';
import 'package:apple_grower/features/hpPolice/hpPolice_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/consignment_model.dart';
import '../aadhati/aadhati_controller.dart';
import '../freightForwarder/freightForwarder_controller.dart';
import '../grower/grower_controller.dart';
import '../ladaniBuyers/ladaniBuyers_controller.dart';
import '../transportUnion/transportUnion_controller.dart';
import 'packHouse_controller.dart';
import '../../core/globals.dart' as glb;
import '../../core/global_role_loader.dart' as gld;

class ConsignmentForm2Controller extends GetxController {
  final searchController = TextEditingController();
  final isLoading = false.obs;
  final searchResults = <Consignment>[].obs;

  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {

  }

  void selectConsignment(Consignment consignment) {
    final exists = (glb.roleType.value == "PackHouse")
        ? Get.find<PackHouseController>()
            .consignments
            .any((existingDriver) => existingDriver.id == consignment.id)
        : (glb.roleType.value == "Grower")
            ? Get.find<GrowerController>()
                .consignments
                .any((existingDriver) => existingDriver.id == consignment.id)
            : (glb.roleType.value == "Aadhati")
                ? Get.find<AadhatiController>().consignments.any(
                    (existingDriver) => existingDriver.id == consignment.id)
                : (glb.roleType.value == "Ladani/Buyers")
                    ? Get.find<LadaniBuyersController>().consignments.any(
                        (existingDriver) => existingDriver.id == consignment.id)
                    : (glb.roleType.value == "Freight Forwarder")
                        ? Get.find<FreightForwarderController>()
                            .consignments
                            .any((existingDriver) =>
                                existingDriver.id == consignment.id)
                        : (glb.roleType.value == "Transport Union")
                            ? Get.find<TransportUnionController>()
                                .consignments
                                .any((existingDriver) =>
                                    existingDriver.id == consignment.id)
                            : (glb.roleType.value == "Driver")
                                ? Get.find<DriverController>().myJobs.any(
                                    (existingDriver) =>
                                        existingDriver.id == consignment.id)
                                : (glb.roleType.value == "HPMC DEPOT")
                                    ? Get.find<HPAgriBoardController>()
                                        .consignments
                                        .any((existingDriver) =>
                                            existingDriver.id == consignment.id)
                                    :Get.find<HPAgriBoardController>()
        .consignments
        .any((existingDriver) =>
    existingDriver.id == consignment.id);

    if (exists) {
      Get.snackbar(
        'Consignment Already Added',
        'This consignment is already in your list',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    (glb.roleType.value == "PackHouse")
        ? Get.find<PackHouseController>().addConsignment(consignment)
        : (glb.roleType.value == "Grower")
            ? Get.find<GrowerController>().addConsignment(consignment)
            : (glb.roleType.value == "Aadhati")
                ? Get.find<AadhatiController>().addConsignment(consignment)
                : (glb.roleType.value == "Ladani/Buyers")
                    ? Get.find<LadaniBuyersController>()
                        .addConsignments(consignment)
                    : (glb.roleType.value == "Freight Forwarder")
                        ? Get.find<FreightForwarderController>()
                            .addConsignments(consignment)
                        : (glb.roleType.value == "Transport Union")
                            ? Get.find<TransportUnionController>()
                                .addConsignments(consignment)
                            : (glb.roleType.value == "Driver")
                                ? Get.find<DriverController>()
                                    .addConsignment(consignment)
                                : (glb.roleType.value == "HPMC DEPOT")
                                    ? Get.find<HPAgriBoardController>()
                                        .addConsignment(consignment)
                                    : Get.find<HPAgriBoardController>()
        .addConsignment(consignment);
    Get.back();
  }

  void navigateToNewConsignmentForm() {
    Get.toNamed('/consignment-form');
  }
}

class ConsignmentForm2Page extends StatelessWidget {
  ConsignmentForm2Page({super.key});

  final controller = Get.put(ConsignmentForm2Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Consignment'),
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
                _buildSearchResults(),
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
                  'Select Consignment',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 400 ? 20 : 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff548235),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.searchController,
              decoration: _getInputDecoration(
                'Search consignments...',
                prefixIcon: Icons.search,
              ),
              onChanged: controller.onSearchChanged,
            ),
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
                'No consignments found',
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
              final consignment = controller.searchResults[index];
              final exists = (glb.roleType.value == "PackHouse")
                  ? Get.find<PackHouseController>().consignments.any(
                      (existingDriver) => existingDriver.id == consignment.id)
                  : (glb.roleType.value == "Grower")
                      ? Get.find<GrowerController>().consignments.any(
                          (existingDriver) =>
                              existingDriver.id == consignment.id)
                      : (glb.roleType.value == "Aadhati")
                          ? Get.find<AadhatiController>().consignments.any(
                              (existingDriver) =>
                                  existingDriver.id == consignment.id)
                          : (glb.roleType.value == "Ladani/Buyers")
                              ? Get.find<LadaniBuyersController>()
                                  .consignments
                                  .any((existingDriver) =>
                                      existingDriver.id == consignment.id)
                              : (glb.roleType.value == "Freight Forwarder")
                                  ? Get.find<FreightForwarderController>()
                                      .consignments
                                      .any((existingDriver) =>
                                          existingDriver.id == consignment.id)
                                  : (glb.roleType.value == "Transport Union")
                                      ? Get.find<TransportUnionController>()
                                          .consignments
                                          .any((existingDriver) =>
                                              existingDriver.id ==
                                              consignment.id)
                                      : (glb.roleType.value == "Driver")
                                          ? Get.find<DriverController>().myJobs.any(
                                              (existingDriver) => existingDriver.id == consignment.id)
                                          : (glb.roleType.value == "HPMC DEPOT")
                  ? Get.find<HPAgriBoardController>()
                  .consignments
                  .any((existingDriver) =>
              existingDriver.id == consignment.id)
                  :  Get.find<HPAgriBoardController>()
                  .consignments
                  .any((existingDriver) =>
              existingDriver.id == consignment.id);


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
                          : () => controller.selectConsignment(consignment),
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
                                    Icons.inventory,
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
                                          'Consignment ID: ${consignment.id}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Status: ${consignment.status}',
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
                                'Quality: ${consignment.quality}',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.label,
                                'Category: ${consignment.category}',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.inventory_2,
                                'Boxes: ${consignment.numberOfBoxes}',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.calendar_today,
                                'Created: ${consignment.createdAt.toString().split(' ')[0]}',
                              ),
                              if (consignment.commissionAgent != null) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.person,
                                  'Commission Agent: ${consignment.commissionAgent?.name ?? 'N/A'}',
                                ),
                              ],
                              if (consignment.corporateCompany != null) ...[
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.business,
                                  'Corporate Company: ${consignment.corporateCompany?.name ?? 'N/A'}',
                                ),
                              ],
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
