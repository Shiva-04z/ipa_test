import 'package:apple_grower/features/driver/driver_controller.dart';
import 'package:apple_grower/models/pack_house_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void onInit() {
    super.onInit();
    searchResults.value = glb.availablePackHouses;
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

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      searchResults.value = glb.availablePackHouses;
    } else {
      searchResults.value = glb.availablePackHouses.where((house) {
        final name = house.name.toLowerCase();
        final address = house.address.toLowerCase();
        final searchLower = query.toLowerCase();

        return name.contains(searchLower) || address.contains(searchLower);
      }).toList();
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
        ? Get.find<GrowerController>()
        .addPackingHouse(house)
        : (glb.roleType.value == "Aadhti")
        ? Get.find<AadhatiController>()
        .addAssociatedPackhouses(house)
        : Get.find<DriverController>()
        .addAssociatedPackhouse(house);

    Get.back();

  }

  void submitForm() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final house = PackHouse(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        phoneNumber: phoneController.text,
        address: addressController.text,
        gradingMachine: gradingMachineController.text,
        sortingMachine: sortingMachineController.text,
        numberOfCrates: int.parse(numberOfCratesController.text),
        boxesPacked2023: int.parse(boxesPacked2023Controller.text),
        boxesPacked2024: int.parse(boxesPacked2024Controller.text),
        estimatedBoxes2025: int.parse(estimatedBoxes2025Controller.text),
        trayType: selectedTrayType.value,
      );

      (glb.roleType.value == "Grower")
          ? Get.find<GrowerController>()
          .addPackingHouse(house)
          : (glb.roleType.value == "Aadhti")
          ? Get.find<AadhatiController>()
          .addAssociatedPackhouses(house)
          : Get.find<DriverController>()
          .addAssociatedPackhouse(house);

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
                Text(
                  'Select or Create Packing House',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 400 ? 20 : 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff548235),
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
                  ? Get.find<AadhatiController>()
                  .associatedPackHouses
                  .any((existingDriver) => existingDriver.id == house.id)
                  : Get.find<DriverController>()
                  .associatedPackhouses
                  .any((existingDriver) => existingDriver.id == house.id);

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
          _buildTrayTypeSelector(),
          const SizedBox(height: 24),
          _buildBasicDetails(),
          const SizedBox(height: 24),
          _buildMachineDetails(),
          const SizedBox(height: 24),
          _buildCapacityDetails(),
          const SizedBox(height: 24),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildTrayTypeSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tray Type',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => SegmentedButton<TrayType>(
                segments: [
                  ButtonSegment(
                    value: TrayType.singleSide,
                    label: const Text('Single Side'),
                    icon: const Icon(Icons.view_agenda),
                  ),
                  ButtonSegment(
                    value: TrayType.bothSide,
                    label: const Text('Both Side'),
                    icon: const Icon(Icons.view_agenda_outlined),
                  ),
                ],
                selected: {controller.selectedTrayType.value},
                onSelectionChanged: (Set<TrayType> newSelection) {
                  controller.selectedTrayType.value = newSelection.first;
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.selected)) {
                      return const Color(0xff548235);
                    }
                    return Colors.grey.shade200;
                  }),
                ),
              ),
            ),
          ],
        ),
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
                'Packing House Name',
                prefixIcon: Icons.business,
              ),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter packing house name'
                  : null,
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

  Widget _buildMachineDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Machine Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.gradingMachineController,
              decoration: _getInputDecoration(
                'Grading Machine',
                prefixIcon: Icons.precision_manufacturing,
              ),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter grading machine details'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.sortingMachineController,
              decoration: _getInputDecoration(
                'Sorting Machine',
                prefixIcon: Icons.precision_manufacturing,
              ),
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter sorting machine details'
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapacityDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Capacity Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.numberOfCratesController,
              decoration: _getInputDecoration(
                'Number of Crates',
                prefixIcon: Icons.inventory,
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter number of crates'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.boxesPacked2023Controller,
              decoration: _getInputDecoration(
                'Boxes Packed in 2023',
                prefixIcon: Icons.calendar_today,
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter boxes packed in 2023'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.boxesPacked2024Controller,
              decoration: _getInputDecoration(
                'Boxes Packed in 2024',
                prefixIcon: Icons.calendar_today,
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter boxes packed in 2024'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.estimatedBoxes2025Controller,
              decoration: _getInputDecoration(
                'Estimated Boxes for 2025',
                prefixIcon: Icons.calendar_today,
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true
                  ? 'Please enter estimated boxes for 2025'
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
