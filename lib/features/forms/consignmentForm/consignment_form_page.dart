import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/globals.dart' as glb;
import '../../../models/driving_profile_model.dart';
import 'consignment_form_controller.dart';
import 'consignment_form_widgets.dart' as ConsignmentFormWidgets;

class ConsignmentFormPage extends StatelessWidget {
  final ConsignmentFormController controller =
      Get.put(ConsignmentFormController());

  Widget buildDriverDetailsCard(String selectedDriverOption) {
    if (selectedDriverOption == "Self") return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedDriverOption == 'My Drivers') ...[
          DropdownButtonFormField<DrivingProfile>(
            decoration: ConsignmentFormWidgets.getInputDecoration(
                'Select Driver',
                prefixIcon: Icons.person),
            value: controller.selectedDriver.value,
            items: glb.availableDrivingProfiles.map((DrivingProfile driver) {
              return DropdownMenuItem<DrivingProfile>(
                value: driver,
                child: Text(driver.name ?? 'Unknown Driver'),
              );
            }).toList(),
            onChanged: (DrivingProfile? newValue) {
              controller.selectedDriver.value = newValue;
            },
            validator: (value) =>
                value == null ? 'Please select a driver' : null,
          ),
        ] else if (selectedDriverOption == 'Request Support') ...[
          ElevatedButton.icon(
            onPressed: controller.isDriverSupportRequested.value
                ? null
                : controller.requestDriverSupport,
            icon: Icon(Icons.support_agent),
            label: Text('Request Driver Support'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff548235),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          if (controller.isDriverSupportRequested.value)
            Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Requesting driver support...'),
                ],
              ),
            )
          else if (controller.resolvedDriverDetails.value != null)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assigned Driver:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                      'Name: ${controller.resolvedDriverDetails.value!.name ?? 'Unknown Driver'}'),
                  Text(
                      'Contact: ${controller.resolvedDriverDetails.value!.contact ?? 'N/A'}'),
                  if (controller
                          .resolvedDriverDetails.value!.vehicleRegistrationNo !=
                      null)
                    Text(
                        'Vehicle: ${controller.resolvedDriverDetails.value!.vehicleRegistrationNo}'),
                ],
              ),
            ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Consignment'),
        backgroundColor: Color(0xff548235),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(Get.context!).size.height,
        width: MediaQuery.of(Get.context!).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff548235).withOpacity(0.1), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: Stepper(
                    type: StepperType.vertical,
                    currentStep: controller.currentStep,
                    onStepContinue: () => controller.onStepContinue(),
                    onStepCancel: () => controller.onStepCancel(),
                    onStepTapped: (step) => controller.onStepTapped(step),
                    steps: buildSteps(),
                    controlsBuilder: (
                      BuildContext context,
                      ControlsDetails controls,
                    ) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => controller.onStepContinue(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff548235),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  controller.currentStep == 5
                                      ? 'Submit'
                                      : 'Next',
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            if (controller.currentStep > 0)
                              Expanded(
                                child: TextButton(
                                  onPressed: () => controller.onStepCancel(),
                                  child: Text('Back'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey[700],
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Step> buildSteps() {
    return [
      Step(
        title: Text('Driver Selection'),
        content: Obx(
          () => Column(
            children: [
              ConsignmentFormWidgets.buildDriverSelectionCard(controller),
              SizedBox(height: 16),
              buildDriverDetailsCard(controller.selectedDriverOption.value),
            ],
          ),
        ),
        isActive: controller.currentStep >= 0,
        state:
            controller.currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Packhouse Selection'),
        content: Obx(
          () => Column(
            children: [
              ConsignmentFormWidgets.buildPackhouseSelectionCard(controller),
              SizedBox(height: 16),
              ConsignmentFormWidgets.buildPackhouseDetailsCard(controller),
            ],
          ),
        ),
        isActive: controller.currentStep >= 1,
        state:
            controller.currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Bilty Details'),
        content: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (MediaQuery.of(Get.context!).size.width > 600)
                  ? ConsignmentFormWidgets.buildBiltyStepDesktop(controller)
                  : ConsignmentFormWidgets.buildBiltyStepMobile(controller)
            ],
          ),
        ),
        isActive: controller.currentStep >= 2,
        state:
            controller.currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
    ];
  }
}
