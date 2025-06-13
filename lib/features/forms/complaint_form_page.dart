import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/globals.dart' as glb;
import '../../models/apmc_model.dart';
import '../../models/complaint_model.dart';

import 'apmc_selection_form_page.dart';

class ComplaintFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final complaintAgainstNameController = TextEditingController();
  final complaintAgainstContactController = TextEditingController();
  final complaintDescriptionController = TextEditingController();
  final isLoading = false.obs;
  final selectedApmc = Rxn<Apmc>();
  final selectedRole = Rxn<String>();

  final roles = [
    'Grower',
    'Pack House',
    'Aadhati',
    'Freight Forwarder',
    'Driver',
    'Ladani/Buyers',
    'HPMC Collection Center',
  ];

  @override
  void onClose() {
    complaintAgainstNameController.dispose();
    complaintAgainstContactController.dispose();
    complaintDescriptionController.dispose();
    super.onClose();
  }

  Future<void> selectApmc() async {
    final result = await Get.to(() => ApmcSelectionFormPage());
    if (result != null) {
      selectedApmc.value = result as Apmc;
    }
  }

  void submitComplaint() {
    if (!formKey.currentState!.validate()) return;
    if (selectedApmc.value == null) {
      Get.snackbar(
        'Error',
        'Please select an APMC office',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (selectedRole.value == null) {
      Get.snackbar(
        'Error',
        'Please select a role',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final newComplaint = Complaint(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        complainantName: glb.personName.value,
        complainantRole: glb.roleType.value,
        complainantContact: glb.personPhone.value,
        complaintAgainstName: complaintAgainstNameController.text,
        complaintAgainstRole: selectedRole.value,
        complaintAgainstContact: complaintAgainstContactController.text,
        apmcName: selectedApmc.value?.name,
        apmcContact: selectedApmc.value?.officePhoneNo,
        complaintDescription: complaintDescriptionController.text,
        complaintDate: DateTime.now(),
        status: 'Pending',
      );

      // TODO: Add complaint to database
      glb.myComplaint.add(newComplaint);

      Get.back();
      Get.snackbar(
        'Success',
        'Complaint submitted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error submitting complaint: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class ComplaintFormPage extends StatelessWidget {
  ComplaintFormPage({super.key});

  final controller = Get.put(ComplaintFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Complaint'),
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
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildApmcSelection(),
                  const SizedBox(height: 24),
                  _buildComplaintAgainstSection(),
                  const SizedBox(height: 24),
                  _buildComplaintDescription(),
                  const SizedBox(height: 24),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApmcSelection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select APMC Office',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => InkWell(
                  onTap: controller.selectApmc,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            controller.selectedApmc.value?.name ??
                                'Select APMC Office',
                            style: TextStyle(
                              color: controller.selectedApmc.value == null
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintAgainstSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Complaint Against',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedRole.value,
                  decoration: InputDecoration(
                    labelText: 'Select Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: controller.roles
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: (value) => controller.selectedRole.value = value,
                  validator: (value) =>
                      value == null ? 'Please select a role' : null,
                )),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.complaintAgainstNameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.complaintAgainstContactController,
              decoration: InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter contact number' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintDescription() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Complaint Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.complaintDescriptionController,
              decoration: InputDecoration(
                labelText: 'Describe your complaint (max 250 words)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              maxLength: 250,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter complaint description';
                }
                if (value!.split(' ').length > 250) {
                  return 'Description should not exceed 250 words';
                }
                return null;
              },
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
        onPressed: controller.submitComplaint,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff548235),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Submit Complaint',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
