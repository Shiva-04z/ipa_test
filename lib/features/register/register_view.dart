import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 24),
                _buildStepIndicator(),
                SizedBox(height: 24),
                _buildFormContent(),
                SizedBox(height: 24),
                _buildNavigationButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.person_add,
            size: 48,
            color: Colors.green,
          ),
          SizedBox(height: 8),
          Text(
            'Create Account',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 8),
          Obx(() => Text(
                'Register as ${controller.selectedRole.value}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Obx(() => Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                controller.getStepTitle(controller.currentStep.value),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: List.generate(
                  controller.getTotalSteps(),
                  (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index <= controller.currentStep.value
                            ? Colors.green
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildFormContent() {
    return Obx(() {
      switch (controller.currentStep.value) {
        case 0:
          return _buildBasicInfoStep();
        case 1:
          return _buildContactInfoStep();
        case 2:
          return _buildGrowerDetailsStep();
        default:
          return Container();
      }
    });
  }

  Widget _buildBasicInfoStep() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTextField(
            controller: controller.nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            icon: Icons.person,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: controller.villageController,
            label: 'Village',
            hint: 'Enter your village name',
            icon: Icons.location_on,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: controller.aadharController,
            label: 'Aadhar Number',
            hint: 'Enter 12-digit Aadhar number',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            maxLength: 12,
          ),
          SizedBox(height: 16),
          _buildRoleSelection(),
        ],
      ),
    );
  }

  Widget _buildContactInfoStep() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTextField(
            controller: controller.phoneController,
            label: 'Phone Number',
            hint: 'Enter 10-digit phone number',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            maxLength: 10,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: controller.addressController,
            label: 'Address',
            hint: 'Enter your complete address',
            icon: Icons.home,
            maxLines: 3,
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: controller.pinCodeController,
            label: 'PIN Code',
            hint: 'Enter 6-digit PIN code',
            icon: Icons.location_city,
            keyboardType: TextInputType.number,
            maxLength: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildGrowerDetailsStep() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.agriculture,
            size: 48,
            color: Colors.green,
          ),
          SizedBox(height: 16),
          Text(
            'Grower Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'You will be able to add orchards and manage your apple production after registration.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'You can add orchards, manage consignments, and track your apple production from your dashboard.',
                    style: TextStyle(color: Colors.green.shade700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLength,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.green),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Role',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade50,
          ),
          child: DropdownButtonFormField<String>(
            value: controller.selectedRole.value,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.work, color: Colors.green),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: controller.availableRoles.map((role) {
              return DropdownMenuItem<String>(
                value: role,
                child: Text(role),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectRole(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Obx(() => Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              if (controller.errorMessage.value.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  if (controller.currentStep.value > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.previousStep,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.green),
                        ),
                        child: Text(
                          'Previous',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                  if (controller.currentStep.value > 0) SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              controller.currentStep.value ==
                                      controller.getTotalSteps() - 1
                                  ? 'Register'
                                  : 'Next',
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
