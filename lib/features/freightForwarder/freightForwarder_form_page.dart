import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/globalsWidgets.dart' as glbw;
import 'freightForwarder_controller.dart';
import '../../models/freightForwarder.dart';

class FreightForwarderFormPage extends GetView<FreightForwarderController> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _licenseNoController = TextEditingController();
  final _forwardingSinceYearsController = TextEditingController();
  final _licensesIssuingAuthorityController = TextEditingController();
  final _locationOnGoogleController = TextEditingController();
  final _appleBoxesForwarded2023Controller = TextEditingController();
  final _appleBoxesForwarded2024Controller = TextEditingController();
  final _estimatedForwardingTarget2025Controller = TextEditingController();
  final _tradeLicenseOfAadhatiAttachedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initialize text controllers with existing values from the FreightForwarder object
    _nameController.text = controller.details.value.name;
    _contactController.text = controller.details.value.contact;
    _addressController.text = controller.details.value.address;
    _licenseNoController.text = controller.details.value.licenseNo!;
    _forwardingSinceYearsController.text =
        controller.details.value.forwardingSinceYears.toString();
    _licensesIssuingAuthorityController.text =
        controller.details.value.licensesIssuingAuthority!;
    _locationOnGoogleController.text =
        controller.details.value.locationOnGoogle ?? '';
    _appleBoxesForwarded2023Controller.text =
        controller.details.value.appleBoxesForwarded2023.toString();
    _appleBoxesForwarded2024Controller.text =
        controller.details.value.appleBoxesForwarded2024.toString();
    _estimatedForwardingTarget2025Controller.text =
        controller.details.value.estimatedForwardingTarget2025.toString();
    _tradeLicenseOfAadhatiAttachedController.text =
        controller.details.value.tradeLicenseOfAadhatiAttached ?? '';

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
                  'Edit Freight Forwarder Details',
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
                    labelText: 'Name of Freight Forwarder Agency',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter agency name';
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
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Registered Address',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _licenseNoController,
                  decoration: InputDecoration(
                    labelText: 'License No.',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter license number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _forwardingSinceYearsController,
                  decoration: InputDecoration(
                    labelText: 'Forwarding Since — Years select',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter years of forwarding';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _licensesIssuingAuthorityController,
                  decoration: InputDecoration(
                    labelText: 'Licenses Issuing Authority',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter issuing authority';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _locationOnGoogleController,
                  decoration: InputDecoration(
                    labelText: 'Location on Google (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _appleBoxesForwarded2023Controller,
                  decoration: InputDecoration(
                    labelText: 'Apple boxes forwarded in 2023',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter forwarded boxes for 2023';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _appleBoxesForwarded2024Controller,
                  decoration: InputDecoration(
                    labelText: 'Apple boxes forwarded in 2024',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter forwarded boxes for 2024';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _estimatedForwardingTarget2025Controller,
                  decoration: InputDecoration(
                    labelText: 'Estimated Forwarding Target in 2025',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter estimated target for 2025';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _tradeLicenseOfAadhatiAttachedController,
                  decoration: InputDecoration(
                    labelText: 'Trade License of Aadhati attached (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final now = DateTime.now();
                      final updatedFreightForwarder = FreightForwarder(
                        id: controller.details.value.id,
                        name: _nameController.text,
                        contact: _contactController.text,
                        address: _addressController.text,
                        licenseNo: _licenseNoController.text,
                        forwardingSinceYears:
                            int.parse(_forwardingSinceYearsController.text),
                        licensesIssuingAuthority:
                            _licensesIssuingAuthorityController.text,
                        locationOnGoogle:
                            _locationOnGoogleController.text.isEmpty
                                ? null
                                : _locationOnGoogleController.text,
                        appleBoxesForwarded2023:
                            int.parse(_appleBoxesForwarded2023Controller.text),
                        appleBoxesForwarded2024:
                            int.parse(_appleBoxesForwarded2024Controller.text),
                        estimatedForwardingTarget2025: int.parse(
                            _estimatedForwardingTarget2025Controller.text),
                        tradeLicenseOfAadhatiAttached:
                            _tradeLicenseOfAadhatiAttachedController
                                    .text.isEmpty
                                ? null
                                : _tradeLicenseOfAadhatiAttachedController.text,
                        associatedAadhatis:
                            controller.details.value.associatedAadhatis,
                        associatedGrowers:
                            controller.details.value.associatedGrowers,
                        associatedPickupProviders:
                            controller.details.value.associatedPickupProviders,
                        associatedTruckServiceProviders: controller
                            .details.value.associatedTruckServiceProviders,
                        createdAt: controller.details.value.createdAt,
                        updatedAt: now,
                      );
                      controller.details.value = updatedFreightForwarder;
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
