import 'package:apple_grower/features/freightForwarder/freightForwarder_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/globalsWidgets.dart' as glbw;
import '../../models/grower_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/aadhati.dart';
import '../../models/consignment_model.dart';
import '../../models/freightForwarder.dart';
import '../grower/grower_dialogs.dart';
import '../packHouse/consignment_form2_page.dart';
import '../packHouse/driver_form_page.dart';
import '../packHouse/grower_form_page.dart';
import '../aadhati/aadhati_form_page.dart';
import 'freightForwarder_form_page.dart';

class FreightForwarderView extends GetView<FreightForwarderController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: glbw.buildAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            glbw.buildInfo(),
            SizedBox(height: 20),
            _buildFreightForwarderInfoContainer(context),
            _buildConsignmentsContainer(context),
            _buildAssociatedGrowersContainer(context),
            _buildAssociatedAadhatisContainer(context),
            _buildAssociatedDriversContainer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFreightForwarderInfoContainer(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black26, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.width > 600 ? 325 : 200,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Obx(
                () => GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 5 : 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: controller.details.value.toMap().length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return _buildAddNewFreightForwarderCard(context);
                    final key = controller.details.value
                        .toMap()
                        .keys
                        .toList()[index - 1];
                    final value = controller.details.value
                        .toMap()
                        .values
                        .toList()[index - 1];
                    return _buildFreightForwarderCard(key, value.toString());
                  },
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Color(0xff548235),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(maxWidth: 225),
          child: Text(
            "My Info",
            style: TextStyle(
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFreightForwarderCard(String name, String detail) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: controller.details.value,
        title: 'Freight Forwarder Details',
        details: [
          _buildDetailRow('Name', controller.details.value.name),
          _buildDetailRow('Contact', controller.details.value.contact),
          _buildDetailRow('Address', controller.details.value.address),
          _buildDetailRow('License No', controller.details.value.licenseNo!),
          _buildDetailRow(
              'Forwarding Since',
              controller.details.value.forwardingSinceYears.toString() +
                  ' years'),
          _buildDetailRow('Issuing Authority',
              controller.details.value.licensesIssuingAuthority!),
          _buildDetailRow('Location on Google',
              controller.details.value.locationOnGoogle ?? 'N/A'),
          _buildDetailRow('Apple Boxes 2023',
              controller.details.value.appleBoxesForwarded2023.toString()),
          _buildDetailRow('Apple Boxes 2024',
              controller.details.value.appleBoxesForwarded2024.toString()),
          _buildDetailRow(
              'Est. Target 2025',
              controller.details.value.estimatedForwardingTarget2025
                  .toString()),
          _buildDetailRow('Aadhati Trade License',
              controller.details.value.tradeLicenseOfAadhatiAttached ?? 'N/A'),
        ],
        onEdit: () => Get.to(() => FreightForwarderFormPage()),
        onDelete: () {},
      ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/images/company.png"),
                height: isSmallScreen ? 32 : 40,
              ),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isSmallScreen) ...[
                SizedBox(height: 4),
                Text(
                  detail,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewFreightForwarderCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return InkWell(
      onTap: () => Get.to(() => FreightForwarderFormPage()),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit,
              size: isSmallScreen ? 32 : 40,
              color: Colors.blue,
            ),
            SizedBox(height: 8),
            Text(
              "Edit",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsignmentsContainer(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black26, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.width > 600 ? 325 : 200,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Obx(
                () => GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 5 : 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: controller.consignments.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewConsignmentCard(context);
                    return _buildConsignmentCard(
                        controller.consignments[index - 1]);
                  },
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Color(0xff548235),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(maxWidth: 225),
          child: Text(
            "Consignments",
            style: TextStyle(
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConsignmentCard(Consignment consignment) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap: () => GrowerDialogs.showConsignmentDetailsDialog(
        Get.context!,
        consignment,
      ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment,
                size: isSmallScreen ? 32 : 40,
                color: Colors.orangeAccent,
              ),
              SizedBox(height: 8),
              Text(
                'Consignment ${consignment.id.substring(0, 4)}...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isSmallScreen) ...[
                SizedBox(height: 4),
                Text(
                  '${consignment.numberOfBoxes} Boxes',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  consignment.quality,
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
                SizedBox(height: 4),
                Text(
                  'Status: ${consignment.status}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewConsignmentCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return InkWell(
      onTap: () => Get.to(() => ConsignmentForm2Page()),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle,
              size: isSmallScreen ? 32 : 40,
              color: Colors.red,
            ),
            SizedBox(height: 8),
            Text(
              "ADD NEW",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssociatedGrowersContainer(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black26, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.width > 600 ? 325 : 200,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Obx(
                () => GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 5 : 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: controller.associatedGrowers.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewGrowerCard(context);
                    return _buildGrowerCard(
                        controller.associatedGrowers[index - 1]);
                  },
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Color(0xff548235),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(maxWidth: 225),
          child: Text(
            "Associated Growers",
            style: TextStyle(
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrowerCard(Grower grower) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: grower,
        title: 'Grower Details',
        details: [
          _buildDetailRow('Name', '${grower.name}'),
          _buildDetailRow('Contact', '${grower.phoneNumber}'),
          _buildDetailRow('Address', '${grower.address}'),
        ],
        onEdit: () {},
        onDelete: () => controller.removeAssociatedGrower('${grower.id}'),
      ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: isSmallScreen ? 32 : 40,
                color: Colors.blue,
              ),
              SizedBox(height: 8),
              Text(
                '${grower.name}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isSmallScreen) ...[
                SizedBox(height: 4),
                Text(
                  '${grower.phoneNumber}',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  '${grower.address}',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewGrowerCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return InkWell(
      onTap: () => Get.to(() => GrowerFormPage()),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle,
              size: isSmallScreen ? 32 : 40,
              color: Colors.red,
            ),
            SizedBox(height: 8),
            Text(
              "ADD NEW",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssociatedAadhatisContainer(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black26, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.width > 600 ? 325 : 200,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Obx(
                () => GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 5 : 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: controller.associatedAadhatis.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewAadhatiCard(context);
                    return _buildAadhatiCard(
                        controller.associatedAadhatis[index - 1]);
                  },
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Color(0xff548235),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(maxWidth: 225),
          child: Text(
            "Associated Aadhatis",
            style: TextStyle(
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAadhatiCard(Aadhati aadhati) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: aadhati,
        title: 'Aadhati Details',
        details: [
          _buildDetailRow('Name', '${aadhati.name}'),
          _buildDetailRow('Contact', '${aadhati.contact}'),
          _buildDetailRow('Firm', '${aadhati.nameOfTradingFirm}'),
          _buildDetailRow('Type', '${aadhati.firmType}'),
        ],
        onEdit: () {},
        onDelete: () => controller.removeAssociatedAadhati('${aadhati.id}'),
      ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: isSmallScreen ? 32 : 40,
                color: Colors.blue,
              ),
              SizedBox(height: 8),
              Text(
                '${aadhati.name}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isSmallScreen) ...[
                SizedBox(height: 4),
                Text(
                  '${aadhati.contact}',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  '${aadhati.nameOfTradingFirm}',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
                SizedBox(height: 4),
                Text(
                  '${aadhati.firmType}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewAadhatiCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return InkWell(
      onTap: () => Get.to(() => AadhatiFormPage()),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle,
              size: isSmallScreen ? 32 : 40,
              color: Colors.red,
            ),
            SizedBox(height: 8),
            Text(
              "ADD NEW",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssociatedDriversContainer(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black26, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.width > 600 ? 325 : 200,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Obx(
                () => GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 5 : 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: controller.associatedDrivers.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewDriverCard(context);
                    return _buildDriverCard(
                        controller.associatedDrivers[index - 1]);
                  },
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Color(0xff548235),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(maxWidth: 225),
          child: Text(
            "Associated Drivers",
            style: TextStyle(
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverCard(DrivingProfile driver) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: driver,
        title: 'Driver Details',
        details: [
          _buildDetailRow('Name', '${driver.name}'),
          _buildDetailRow('Contact', '${driver.contact}'),
          _buildDetailRow('License', '${driver.drivingLicenseNo}'),
          _buildDetailRow('Vehicle', '${driver.vehicleRegistrationNo}'),
          _buildDetailRow('Tyres', '${driver.noOfTyres}'),
        ],
        onEdit: () {},
        onDelete: () => controller.removeAssociatedDriver('${driver.id}'),
      ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.drive_eta,
                size: isSmallScreen ? 32 : 40,
                color: Colors.blue,
              ),
              SizedBox(height: 8),
              Text(
                '${driver.name}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isSmallScreen) ...[
                SizedBox(height: 4),
                Text(
                  '${driver.contact}',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  '${driver.drivingLicenseNo}',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
                SizedBox(height: 4),
                Text(
                  'Vehicle: ${driver.vehicleRegistrationNo}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewDriverCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return InkWell(
      onTap: () => Get.to(() => DriverFormPage()),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle,
              size: isSmallScreen ? 32 : 40,
              color: Colors.red,
            ),
            SizedBox(height: 8),
            Text(
              "ADD NEW",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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
