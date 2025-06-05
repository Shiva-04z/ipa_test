import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'grower_controller.dart';
import '../../models/commission_agent_model.dart';
import '../../models/corporate_company_model.dart';
import '../../models/orchard_model.dart';
import '../../models/packing_house_status_model.dart';
import '../../models/consignment_model.dart';

class GrowerDialogs {
  static final _dialogTheme = ThemeData(
    primaryColor: Color(0xff548235),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green,
      primary: Colors.green,
      secondary: Colors.orange,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff548235),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(0xff548235),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xff548235), width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
    ),
  );

  static void showItemDetailsDialog({
    required BuildContext context,
    required dynamic item,
    required String title,
    required List<Widget> details,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...details,
              if (onDelete != null) ...[
                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                  label: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  static Future<void> showAddCommissionAgentDialog(BuildContext context) async {
    final controller = Get.find<GrowerController>();
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final apmcController = TextEditingController();
    final addressController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => Theme(
        data: _dialogTheme,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Add Commission Agent',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: apmcController,
                    decoration: InputDecoration(
                      labelText: 'APMC Mandi',
                      prefixIcon: Icon(Icons.store),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final agent = CommissionAgent(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    phoneNumber: phoneController.text,
                    apmcMandi: apmcController.text,
                    address: addressController.text,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  controller.addCommissionAgent(agent);
                  Navigator.pop(context);
                  Get.snackbar(
                    'Success',
                    'Commission agent added successfully',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
              },
              child: Text('Save', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> showAddCorporateCompanyDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final RxBool isSearching = true.obs;
    final RxList<CorporateCompany> searchResults = <CorporateCompany>[].obs;

    return Get.dialog(
      AlertDialog(
        title: Text('Add Corporate Company'),
        content: Container(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => isSearching.value
                    ? Column(
                        children: [
                          TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search company...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              // TODO: Implement company search logic
                              // This should search your database or API
                              searchResults.value =
                                  []; // Replace with actual search results
                            },
                          ),
                          SizedBox(height: 16),
                          if (searchResults.isNotEmpty)
                            Container(
                              height: 200,
                              child: ListView.builder(
                                itemCount: searchResults.length,
                                itemBuilder: (context, index) {
                                  final company = searchResults[index];
                                  return ListTile(
                                    title: Text(company.name),
                                    subtitle: Text(company.companyType),
                                    onTap: () {
                                      // TODO: Implement company selection logic
                                      Get.back();
                                    },
                                  );
                                },
                              ),
                            ),
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => isSearching.value = false,
                            icon: Icon(Icons.add),
                            label: Text('Create New Company'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff548235),
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 45),
                            ),
                          ),
                        ],
                      )
                    : _buildCompanyForm(
                        context,
                        () => isSearching.value = true,
                      ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
        ],
      ),
    );
  }

  static Widget _buildCompanyForm(BuildContext context, VoidCallback onBack) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final companyTypeController = TextEditingController();

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back),
            label: Text('Back to Search'),
            style: TextButton.styleFrom(foregroundColor: Color(0xff548235)),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Company Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter company name' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter phone number' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: companyTypeController,
            decoration: InputDecoration(
              labelText: 'Company Type',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter company type' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: addressController,
            decoration: InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: 2,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter address' : null,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                // TODO: Implement company creation logic
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff548235),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 45),
            ),
            child: Text('Add Company'),
          ),
        ],
      ),
    );
  }

  static Future<void> showPackingHouseDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final RxBool isSearching = true.obs;
    final RxList<PackingHouse> searchResults = <PackingHouse>[].obs;

    return Get.dialog(
      AlertDialog(
        title: Text('Add Packing House'),
        content: Container(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => isSearching.value
                    ? Column(
                        children: [
                          TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search packing house...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              // TODO: Implement packing house search logic
                              // This should search your database or API
                              searchResults.value =
                                  []; // Replace with actual search results
                            },
                          ),
                          SizedBox(height: 16),
                          if (searchResults.isNotEmpty)
                            Container(
                              height: 200,
                              child: ListView.builder(
                                itemCount: searchResults.length,
                                itemBuilder: (context, index) {
                                  final house = searchResults[index];
                                  return ListTile(
                                    title: Text(
                                      house.packingHouseName ?? 'Unnamed',
                                    ),
                                    subtitle: Text(
                                      house.type.toString().split('.').last,
                                    ),
                                    onTap: () {
                                      // TODO: Implement packing house selection logic
                                      Get.back();
                                    },
                                  );
                                },
                              ),
                            ),
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => isSearching.value = false,
                            icon: Icon(Icons.add),
                            label: Text('Create New Packing House'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff548235),
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 45),
                            ),
                          ),
                        ],
                      )
                    : _buildPackingHouseForm(
                        context,
                        () => isSearching.value = true,
                      ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
        ],
      ),
    );
  }

  static Widget _buildPackingHouseForm(
    BuildContext context,
    VoidCallback onBack,
  ) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final Rx<PackingHouseType> selectedType = PackingHouseType.own.obs;

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back),
            label: Text('Back to Search'),
            style: TextButton.styleFrom(foregroundColor: Color(0xff548235)),
          ),
          SizedBox(height: 16),
          Obx(
            () => SegmentedButton<PackingHouseType>(
              segments: [
                ButtonSegment(
                  value: PackingHouseType.own,
                  label: Text('Own'),
                  icon: Icon(Icons.business),
                ),
                ButtonSegment(
                  value: PackingHouseType.thirdParty,
                  label: Text('Third Party'),
                  icon: Icon(Icons.business_outlined),
                ),
              ],
              selected: {selectedType.value},
              onSelectionChanged: (Set<PackingHouseType> newSelection) {
                selectedType.value = newSelection.first;
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((
                  Set<MaterialState> states,
                ) {
                  if (states.contains(MaterialState.selected)) {
                    return Color(0xff548235);
                  }
                  return Colors.grey.shade200;
                }),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Packing House Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) => value?.isEmpty ?? true
                ? 'Please enter packing house name'
                : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter phone number' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: addressController,
            decoration: InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: 2,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter address' : null,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                // TODO: Implement packing house creation logic
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff548235),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 45),
            ),
            child: Text('Add Packing House'),
          ),
        ],
      ),
    );
  }

  static Future<void> showEditOrchardDialog(
    BuildContext context,
    Orchard orchard,
  ) async {
    final controller = Get.find<GrowerController>();
    final formKey = GlobalKey<FormState>();
    final treesController = TextEditingController(
      text: orchard.numberOfFruitingTrees.toString(),
    );
    final boxesController = TextEditingController(
      text: orchard.estimatedBoxes?.toString() ?? '',
    );
    final harvestDate = orchard.expectedHarvestDate.obs;
    final harvestStatus = orchard.harvestStatus.obs;

    return showDialog(
      context: context,
      builder: (context) => Theme(
        data: _dialogTheme,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Edit Orchard',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: treesController,
                    decoration: InputDecoration(
                      labelText: 'Number of Trees',
                      prefixIcon: Icon(Icons.park),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  Obx(
                    () => DropdownButtonFormField<HarvestStatus>(
                      value: harvestStatus.value,
                      decoration: InputDecoration(
                        labelText: 'Harvest Status',
                        prefixIcon: Icon(Icons.calendar_view_day),
                      ),
                      items: HarvestStatus.values.map((status) {
                        return DropdownMenuItem<HarvestStatus>(
                          value: status,
                          child: Text(
                            status.toString().split('.').last,
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => harvestStatus.value = value!,
                    ),
                  ),
                  SizedBox(height: 16),
                  Obx(
                    () => InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: harvestDate.value,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                          builder: (context, child) => Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(0xff548235),
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (date != null) harvestDate.value = date;
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Harvest Date',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat(
                                'MMM dd, yyyy',
                              ).format(harvestDate.value),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: boxesController,
                    decoration: InputDecoration(
                      labelText: 'Expected Boxes',
                      prefixIcon: Icon(Icons.shopping_cart),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final updatedOrchard = orchard.copyWith(
                    numberOfFruitingTrees: int.parse(treesController.text),
                    expectedHarvestDate: harvestDate.value,
                    harvestStatus: harvestStatus.value,
                    estimatedBoxes: int.parse(boxesController.text),
                    updatedAt: DateTime.now(),
                  );
                  controller.updateOrchard(updatedOrchard);
                  Navigator.pop(context);
                  Get.snackbar(
                    'Success',
                    'Orchard updated successfully',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
              },
              child: Text('Save', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _showMapLocationPicker(
    BuildContext context,
    TextEditingController locationController,
  ) async {
    // TODO: Implement map location picker
    // This should show a map where users can select a location
    // For now, we'll just use the current location
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = placemarks.isNotEmpty
          ? '${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.postalCode}'
          : 'Unknown Location';

      locationController.text = address;
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: ${e.toString()}');
    }
  }

  // Update the location field in all forms to include a map button
  static InputDecoration _getLocationDecoration(
    String label,
    VoidCallback onMapTap,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(Icons.location_on),
      suffixIcon: IconButton(icon: Icon(Icons.map), onPressed: onMapTap),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  static Future<void> showConsignmentDetailsDialog(
    BuildContext context,
    Consignment consignment,
  ) {
    return showDialog(
      context: context,
      builder: (context) => Theme(
        data: _dialogTheme,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Consignment Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Quality', consignment.quality),
                        _buildDetailRow('Category', consignment.category),
                        _buildDetailRow(
                          'Boxes',
                          consignment.numberOfBoxes.toString(),
                        ),
                        _buildDetailRow(
                          'Pieces/Box',
                          consignment.numberOfPiecesInBox.toString(),
                        ),
                        _buildDetailRow('Pickup', consignment.pickupOption),
                        if (consignment.shippingFrom != null)
                          _buildDetailRow(
                            'From',
                            consignment.shippingFrom!,
                          ),
                        if (consignment.shippingTo != null)
                          _buildDetailRow('To', consignment.shippingTo!),
                        if (consignment.packingHouse != null)
                          _buildDetailRow(
                            'Packhouse',
                            consignment.packingHouse!.packingHouseName ?? 'N/A',
                          ),
                        if (consignment.hasOwnCrates != null)
                          _buildDetailRow(
                            'Own Crates',
                            consignment.hasOwnCrates.toString(),
                          ),
                        _buildDetailRow('Status', consignment.status),
                        if (consignment.driverName != null)
                          _buildDetailRow(
                            'Driver',
                            '${consignment.driverName} (${consignment.driverContact})',
                          ),
                        if (consignment.commissionAgent != null)
                          _buildDetailRow(
                            'Adhani',
                            '${consignment.commissionAgent!.name} (${consignment.commissionAgent!.phoneNumber})',
                          ),
                        if (consignment.corporateCompany != null)
                          _buildDetailRow(
                            'Ladhani',
                            '${consignment.corporateCompany!.name} (${consignment.corporateCompany!.phoneNumber})',
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.find<GrowerController>().removeConsignment(
                          consignment.id,
                        );
                      },
                      icon: Icon(Icons.delete, size: 18),
                      label: Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
