import 'package:apple_grower/features/aadhati/aadhati_controller.dart';
import 'package:apple_grower/features/packHouse/packHouse_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/globals.dart' as glb;
import '../../models/employee_model.dart';
import '../../core/globalsWidgets.dart' as glbw;

class EmployeeFormPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _designationController = TextEditingController();

  Future<void> _pickContact() async {
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
          _nameController.text = contact.displayName;
          if (contact.phones.isNotEmpty) {
            // Get the first phone number and remove any non-digit characters
            String phoneNumber =
                contact.phones.first.number.replaceAll(RegExp(r'[^\d]'), '');
            // Ensure it's 10 digits
            if (phoneNumber.length > 10) {
              phoneNumber = phoneNumber.substring(phoneNumber.length - 10);
            }
            _phoneController.text = phoneNumber;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Add New Staff Member',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff548235),
                  ),
                ),
                SizedBox(height: 24),
                _buildBasicDetailsSection(),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff548235),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicDetailsSection() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            if (glb.roleType.value =="HP Police") TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Designation',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the Designation';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the phone number';
                      }
                      if (value.length != 10) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: _pickContact,
                  icon: Icon(Icons.contacts),
                  color: Color(0xff548235),
                  tooltip: kIsWeb
                      ? 'Use mobile app to pick contacts'
                      : 'Pick from contacts',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final employee = Employee(
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        designation: _designationController.text
      );

      (glb.roleType.value == "PackHouse")
          ? Get.find<PackHouseController>().addAssociatedPacker(employee)
          : Get.find<AadhatiController>().addStaff(employee);

      Get.back();
    }
  }
}
