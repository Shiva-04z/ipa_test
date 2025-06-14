import 'package:apple_grower/features/freightForwarder/freightForwarder_controller.dart';
import 'package:apple_grower/features/hpAgriBoard/hpAgriBoard_controller.dart';
import 'package:apple_grower/features/packHouse/packHouse_controller.dart';
import 'package:apple_grower/models/driving_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/globalsWidgets.dart' as glbw;
import '../../core/globals.dart' as glb;
// Use a prefix for the model import
import '../../models/transport_model.dart';
import '../driver/driver_controller.dart';
import '../grower/grower_controller.dart';
import '../ladaniBuyers/ladaniBuyers_controller.dart';

class TransportUnionFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final searchController = TextEditingController();
  final isLoading = false.obs;
  final isSearching = true.obs;
  final searchResults = <Transport>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchResults.value = glb.availableTransports;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      searchResults.value = glb.availableTransports;
    } else {
      searchResults.value = (glb.availableTransports).where((union) {
        final name = union.nameOfTheTransportUnion?.toLowerCase();
        final contact = union.contact.toLowerCase();
        final address = union.address.toLowerCase();
        final searchLower = query.toLowerCase();
        return name!.contains(searchLower) ||
            contact.contains(searchLower) ||
            address.contains(searchLower);
      }).toList();
    }
  }

  void selectUnion(Transport union) {
    final exists = (glb.roleType.value == "Grower")
        ? Get.find<GrowerController>()
            .transportUnions
            .any((existingDriver) => existingDriver.id == union.id)
        : (glb.roleType.value == "Driver")
            ? Get.find<DriverController>()
                .associatedTransportUnions
                .any((existingDriver) => existingDriver.id == union.id)
            : (glb.roleType.value == "PackHouse")
                ? Get.find<PackHouseController>()
                    .associatedTransportUnions
                    .any((existingDriver) => existingDriver.id == union.id)
                : (glb.roleType.value == "HPMC DEPOT")
                    ? Get.find<HPAgriBoardController>()
                        .associatedTransportUnions
                        .any((existingDriver) => existingDriver.id == union.id)
                    : (glb.roleType.value == "Freight Forwarder")
        ? Get.find<FreightForwarderController>()
        .associatedTransportUnions
        .any((existingDriver) => existingDriver.id == union.id): Get.find<LadaniBuyersController>()
                        .associatedTransportUnions
                        .any((existingDriver) => existingDriver.id == union.id);

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

    (glb.roleType.value == "Grower")
        ? Get.find<GrowerController>().addTransportUnion(union)
        : (glb.roleType.value == "Driver")
            ? Get.find<DriverController>().addTransportUnion(union)
            : (glb.roleType.value == "PackHouse")
                ? Get.find<PackHouseController>()
                    .addAssociatedTransportUnion(union)
                : (glb.roleType.value == "HPMC DEPOT")
        ? Get.find<HPAgriBoardController>()
        .addAssociatedTransportUnion(union)
        :  (glb.roleType.value == "Freight Forwarder")
        ? Get.find<FreightForwarderController>()
        .addAssociatedTransportUnion(union): Get.find<LadaniBuyersController>()
                    .addAssociatedTransportUnion(union);
    Get.back();
  }

  void submitForm() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final union = Transport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        contact: phoneController.text,
        address: addressController.text,
      );

      (glb.roleType.value == "Grower")
          ? Get.find<GrowerController>().addTransportUnion(union)
          : (glb.roleType.value == "Driver")
              ? Get.find<DriverController>().addTransportUnion(union)
              : (glb.roleType.value == "PackHouse")
                  ? Get.find<PackHouseController>()
                      .addAssociatedTransportUnion(union)
                  :(glb.roleType.value == "HPMC DEPOT")
          ? Get.find<HPAgriBoardController>()
          .addAssociatedTransportUnion(union): (glb.roleType.value == "Freight Forwarder")
          ? Get.find<FreightForwarderController>()
          .addAssociatedTransportUnion(union): Get.find<LadaniBuyersController>()
                      .addAssociatedTransportUnion(union);
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error adding transport union: \$e',
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
    return Obx(() => controller.searchResults.isEmpty
        ? const Center(
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
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.searchResults.length,
            itemBuilder: (context, index) {
              final union = controller.searchResults[index];
              final exists = (glb.roleType.value == "Grower")
                  ? Get.find<GrowerController>()
                      .transportUnions
                      .any((existingDriver) => existingDriver.id == union.id)
                  : (glb.roleType.value == "Driver")
                      ? Get.find<DriverController>()
                          .associatedTransportUnions
                          .any(
                              (existingDriver) => existingDriver.id == union.id)
                      : (glb.roleType.value == "PackHouse")
                          ? Get.find<PackHouseController>()
                              .associatedTransportUnions
                              .any((existingDriver) =>
                                  existingDriver.id == union.id)
                          :(glb.roleType.value == "HPMC DEPOT")
                  ? Get.find<HPAgriBoardController>()
                  .associatedTransportUnions
                  .any((existingDriver) => existingDriver.id == union.id)
                  : (glb.roleType.value == "Freight Forwarder")
                  ? Get.find<FreightForwarderController>()
                  .associatedTransportUnions
                  .any((existingDriver) => existingDriver.id == union.id):  Get.find<LadaniBuyersController>()
                              .associatedTransportUnions
                              .any((existingDriver) =>
                                  existingDriver.id == union.id);

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
                          exists ? null : () => controller.selectUnion(union),
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
            TextFormField(
              controller: controller.phoneController,
              decoration: _getInputDecoration(
                'Contact Number',
                prefixIcon: Icons.phone,
              ),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter contact number';
                }
                if (value!.length != 10) {
                  return 'Contact number must be 10 digits';
                }
                return null;
              },
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
