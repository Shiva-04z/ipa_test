import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/globalsWidgets.dart' as glbw;
import 'driver_controller.dart';
import '../../models/driving_profile_model.dart';

class DriverFormPage extends GetView<DriverController> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _licenseNoController = TextEditingController();
  final _vehicleRegistrationNoController = TextEditingController();
  final _noOfTyresController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initialize text controllers with existing values from the DrivingProfile object
    _nameController.text = controller.details.value.name ?? '';
    _contactController.text = controller.details.value.contact ?? '';
    _licenseNoController.text = controller.details.value.drivingLicenseNo ?? '';
    _vehicleRegistrationNoController.text =
        controller.details.value.vehicleRegistrationNo ?? '';
    _noOfTyresController.text =
        controller.details.value.noOfTyres?.toString() ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: glbw.buildAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Edit Driver Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff548235),
                  ),
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter contact number';
                    }
                    if (value.length != 10) {
                      return 'Contact number must be 10 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _licenseNoController,
                  decoration: InputDecoration(
                    labelText: 'Driving License Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter driving license number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _vehicleRegistrationNoController,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Registration Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter vehicle registration number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _noOfTyresController,
                  decoration: InputDecoration(
                    labelText: 'Number of Tyres',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of tyres';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final now = DateTime.now();
                      final updatedDriver = DrivingProfile(
                        id: controller.details.value.id ?? '',
                        name: _nameController.text,
                        contact: _contactController.text,
                        drivingLicenseNo: _licenseNoController.text,
                        vehicleRegistrationNo:
                            _vehicleRegistrationNoController.text,
                        noOfTyres: int.tryParse(_noOfTyresController.text) ?? 0,
                      );
                      controller.details.value = updatedDriver;
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff548235),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
