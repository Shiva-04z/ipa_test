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
          if (controller.selectedRole.value == "Grower") {
            return _buildGrowerDetailsStep();
          } else if (controller.selectedRole.value == "Aadhati") {
            return _buildAadhatiDetailsStep();
          } else if (controller.selectedRole.value == "PackHouse") {
            return _buildPackHouseDetailsStep();
          } else if (controller.selectedRole.value == "Transport Union") {
            return _buildTransportUnionDetailsStep();
          }
          return Container();
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
          Obx(() => controller.selectedRole.value == "Aadhati"
              ? _buildTextField(
                  controller: controller.apmc_IDController,
                  label: 'APMC ID',
                  hint: 'Enter your APMC ID',
                  icon: Icons.business,
                )
              : _buildTextField(
                  controller: controller.villageController,
                  label: 'Village',
                  hint: 'Enter your village name',
                  icon: Icons.location_on,
                )),
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
          Obx(() => controller.selectedRole.value != "Aadhati"
              ? _buildTextField(
                  controller: controller.pinCodeController,
                  label: 'PIN Code',
                  hint: 'Enter 6-digit PIN code',
                  icon: Icons.location_city,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                )
              : SizedBox.shrink()),
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

  Widget _buildAadhatiDetailsStep() {
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Icon(
              Icons.business,
              size: 48,
              color: Colors.green,
            ),
            SizedBox(height: 16),
            Text(
              'Aadhati Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 24),

            // Trading Firm Details
            _buildTextField(
              controller: controller.nameOfTradingFirmController,
              label: 'Trading Firm Name',
              hint: 'Enter your trading firm name',
              icon: Icons.business_center,
            ),
            SizedBox(height: 16),

            // Trading Experience
            _buildTextField(
              controller: controller.tradingExperienceController,
              label: 'Trading Experience (Years)',
              hint: 'Enter years of trading experience',
              icon: Icons.timeline,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),

            // Firm Type Dropdown
            _buildFirmTypeDropdown(),
            SizedBox(height: 16),

            // License Number
            _buildTextField(
              controller: controller.licenceNumberController,
              label: 'License Number',
              hint: 'Enter your license number',
              icon: Icons.verified_user,
            ),
            SizedBox(height: 24),

            // Apple Boxes Section
            Text(
              'Apple Boxes Purchased',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: controller.appleboxesT2Controller,
                    label:
                        'Apple Boxes ${(DateTime.now().subtract(Duration(days: 730)).year)}',
                    hint: '0',
                    icon: Icons.inventory,
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: controller.appleboxesT1Controller,
                    label:
                        'Appple Boxes ${(DateTime.now().subtract(Duration(days: 365)).year)}',
                    hint: '0',
                    icon: Icons.inventory,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            _buildTextField(
              controller: controller.appleboxesTController,
              label: 'Estimated Boxes this year',
              hint: '5000',
              icon: Icons.inventory,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),

            // Apple Growers Served
            _buildTextField(
              controller: controller.applegrowersServedController,
              label: 'Apple Growers Served',
              hint: 'Enter number of growers served',
              icon: Icons.people,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),

            // Trade Finance Option
            _buildTradeFinanceOption(),
            SizedBox(height: 24),

            // Info Box
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
                      'You can manage growers, buyers, drivers, and track consignments from your dashboard after registration.',
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackHouseDetailsStep() {
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Icon(Icons.factory, size: 48, color: Colors.green),
            SizedBox(height: 16),
            Text('PackHouse Information',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
            SizedBox(height: 24),
            _buildTextField(
              controller: controller.gradingMachineController,
              label: 'Grading Machine',
              hint: 'Enter grading machine',
              icon: Icons.precision_manufacturing,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.gradingMachineCapacityController,
              label: 'Grading Machine Capacity',
              hint: 'Enter grading machine capacity',
              icon: Icons.speed,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.sortingMachineController,
              label: 'Sorting Machine',
              hint: 'Enter sorting machine',
              icon: Icons.precision_manufacturing,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.sortingMachineCapacityController,
              label: 'Sorting Machine Capacity',
              hint: 'Enter sorting machine capacity',
              icon: Icons.speed,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.machineManufactureController,
              label: 'Machine Manufacture',
              hint: 'Enter machine manufacture',
              icon: Icons.build,
            ),
            SizedBox(height: 16),
            _buildTrayTypeDropdown(),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.perDayCapacityController,
              label: 'Per Day Capacity',
              hint: 'Enter per day capacity',
              icon: Icons.calendar_today,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.numberOfCratesController,
              label: 'Number of Crates',
              hint: 'Enter number of crates',
              icon: Icons.format_list_numbered,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.crateManufactureController,
              label: 'Crate Manufacture',
              hint: 'Enter crate manufacture',
              icon: Icons.build,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.boxesPackedT2Controller,
              label: 'Boxes Packed (T-2)',
              hint: 'Enter boxes packed two years ago',
              icon: Icons.inventory,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.boxesPackedT1Controller,
              label: 'Boxes Packed (T-1)',
              hint: 'Enter boxes packed last year',
              icon: Icons.inventory,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.boxesEstimatedTController,
              label: 'Estimated Boxes (This Year)',
              hint: 'Enter estimated boxes for this year',
              icon: Icons.inventory,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.geoLocationController,
              label: 'Geo Location',
              hint: 'Enter geo location',
              icon: Icons.location_on,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.numberOfGrowersServedController,
              label: 'Number of Growers Served',
              hint: 'Enter number of growers served',
              icon: Icons.people,
              keyboardType: TextInputType.number,
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
                      'You can manage growers, packers, drivers, and track consignments from your dashboard after registration.',
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportUnionDetailsStep() {
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Icon(Icons.local_shipping, size: 48, color: Colors.green),
            SizedBox(height: 16),
            Text('Transport Union Information',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
            SizedBox(height: 24),
            _buildTextField(
              controller: controller.nameOfTheTransportUnionController,
              label: 'Name of the Transport Union',
              hint: 'Enter name of the transport union',
              icon: Icons.business,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.transportUnionRegistrationNoController,
              label: 'Registration Number',
              hint: 'Enter registration number',
              icon: Icons.confirmation_number,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.noOfVehiclesRegisteredController,
              label: 'Number of Vehicles Registered',
              hint: 'Enter number of vehicles registered',
              icon: Icons.directions_car,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.transportUnionPresidentAdharIdController,
              label: 'President Aadhar ID',
              hint: 'Enter president aadhar ID',
              icon: Icons.person,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.transportUnionSecretaryAdharController,
              label: 'Secretary Aadhar ID',
              hint: 'Enter secretary aadhar ID',
              icon: Icons.person,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.noOfLightCommercialVehiclesController,
              label: 'No. of Light Commercial Vehicles',
              hint: 'Enter number',
              icon: Icons.local_shipping,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.noOfMediumCommercialVehiclesController,
              label: 'No. of Medium Commercial Vehicles',
              hint: 'Enter number',
              icon: Icons.local_shipping,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.noOfHeavyCommercialVehiclesController,
              label: 'No. of Heavy Commercial Vehicles',
              hint: 'Enter number',
              icon: Icons.local_shipping,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.appleBoxesTransported2023Controller,
              label: 'Apple Boxes Transported 2023',
              hint: 'Enter number',
              icon: Icons.inventory,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.appleBoxesTransported2024Controller,
              label: 'Apple Boxes Transported 2024',
              hint: 'Enter number',
              icon: Icons.inventory,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.estimatedTarget2025Controller,
              label: 'Estimated Target 2025',
              hint: 'Enter estimated target',
              icon: Icons.trending_up,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.statesDrivenThroughController,
              label: 'States Driven Through',
              hint: 'Enter states driven through',
              icon: Icons.map,
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
                      'You can manage vehicles, drivers, and track consignments from your dashboard after registration.',
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  Widget _buildTradeFinanceOption() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trade Finance',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Obx(() => CheckboxListTile(
              title: Text('Need Trade Finance'),
              subtitle: Text('Check if you need trade finance support'),
              value: controller.needTradeFinance.value,
              onChanged: (value) {
                controller.needTradeFinance.value = value ?? false;
              },
              activeColor: Colors.green,
              contentPadding: EdgeInsets.zero,
            )),
      ],
    );
  }

  Widget _buildFirmTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Firm Type',
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
            value: controller.firmTypeController.text.isEmpty
                ? null
                : controller.firmTypeController.text,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.business, color: Colors.green),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            hint: Text('Select firm type'),
            items: controller.firmTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.firmTypeController.text = value;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrayTypeDropdown() {
    final trayTypes = ['singleSide', 'bothSide'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tray Type',
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
            value: controller.trayTypeController.text.isEmpty
                ? null
                : controller.trayTypeController.text,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.category, color: Colors.green),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            hint: Text('Select tray type'),
            items: trayTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.trayTypeController.text = value;
              }
            },
          ),
        ),
      ],
    );
  }
}
