import 'package:apple_grower/features/aadhati/aadhati_controller.dart';
import 'package:apple_grower/models/freightForwarder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/globalsWidgets.dart' as glbw;
import '../../core/global_role_loader.dart' as gld;
import '../../models/aadhati.dart';
import '../../models/grower_model.dart';
import '../../models/ladani_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/consignment_model.dart';
import '../grower/grower_dialogs.dart';

import '../grower/corporate_company_form_page.dart';
import '../packHouse/driver_form_page.dart';
import '../packHouse/grower_form_page.dart';
import '../packHouse/consignment_form2_page.dart';
import 'aadhati_controller.dart';
import 'aadhati_form_page.dart';

import 'buyer_form_page.dart';

class AadhatiView extends GetView<AadhatiController> {
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
            _buildAadhatiInfoContainer(context),
            _buildAssociatedGrowersContainer(context),
            _buildAssociatedBuyersContainer(context),
            _buildAssociatedLadanisContainer(context),
            _buildAssociatedDriversContainer(context),
            _buildConsignmentsContainer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAadhatiInfoContainer(BuildContext context) {
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
                  itemCount: controller.details.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewAadhatiCard(context);
                    return _buildAadhatiCard(
                        controller.details.keys.toList()[index - 1],
                        controller.details.values.toList()[index - 1]);
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
            "My Commission Agent Info",
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

  Widget _buildAadhatiCard(String name, String detail) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/images/agent.png"),
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
          _buildDetailRow('Name', grower.name),
          _buildDetailRow('Phone', grower.phoneNumber),
          _buildDetailRow('Address', grower.address),
          _buildDetailRow('Orchards', grower.orchards.length.toString()),
        ],
        onEdit: () {},
        onDelete: () => controller.removeAssociatedGrower(grower.id),
      ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/images/grower.png"),
                height: isSmallScreen ? 32 : 40,
              ),
              Text(
                grower.name,
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
                  '${grower.orchards.length} Orchards',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  grower.address,
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

  Widget _buildAssociatedBuyersContainer(BuildContext context) {
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
                  itemCount: controller.associatedBuyers.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewBuyerCard(context);
                    return _buildBuyerCard(
                        controller.associatedBuyers[index - 1]);
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
            "Associated Freight Forwarder",
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

  Widget _buildBuyerCard(FreightForwarder buyer) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: buyer,
        title: 'Buyer Details',
        details: [
          _buildDetailRow('Name', buyer.name),
          _buildDetailRow('Phone', buyer.contact),
          _buildDetailRow('Address', buyer.address),
        ],
        onEdit: () {},
        onDelete: () => controller.removeAssociatedBuyer(buyer.id),
      ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/images/buyer.png"),
                height: isSmallScreen ? 32 : 40,
              ),
              Text(
                buyer.name,
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
                  buyer.contact,
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
                SizedBox(height: 4),
                Text(
                  buyer.address,
                  style: TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewBuyerCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return InkWell(
      onTap: () => Get.to(() => BuyerFormPage()),
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

  Widget _buildAssociatedLadanisContainer(BuildContext context) {
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
                  itemCount: controller.associatedLadanis.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewLadaniCard(context);
                    return _buildLadaniCard(
                        controller.associatedLadanis[index - 1]);
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
            "Associated Corporate Companies",
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

  Widget _buildLadaniCard(Ladani ladani) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: ladani,
        title: 'Corporate Company Details',
        details: [
          _buildDetailRow('Name', '${ladani.name}'),
          _buildDetailRow('Phone', '${ladani.contact}'),
          _buildDetailRow('Type', '${ladani.firmType}'),
          _buildDetailRow('Address', '${ladani.address}'),
        ],
        onEdit: () {},
        onDelete: () => controller.removeAssociatedLadani('${ladani.id}'),
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
                "${ladani.name}",
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
                Text('${ladani.firmType}', style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  '${ladani.contact}',
                  style: TextStyle(fontSize: 12, color: Colors.purple),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewLadaniCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return InkWell(
      onTap: () => Get.to(() => CorporateCompanyFormPage()),
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
          _buildDetailRow('Phone', '${driver.contact}'),
          _buildDetailRow('License', '${driver.drivingLicenseNo}'),
          _buildDetailRow('Vehicle',
              '${driver.noOfTyres} - ${driver.vehicleRegistrationNo}'),
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
              Image(
                image: AssetImage("assets/images/driver.png"),
                height: isSmallScreen ? 32 : 40,
              ),
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
                  '${driver.noOfTyres}',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  '${driver.contact}',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
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
}
