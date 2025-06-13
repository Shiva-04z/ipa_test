import 'package:apple_grower/features/driver/driver_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/globalsWidgets.dart' as glbw;

import '../../models/consignment_model.dart';
import '../../models/grower_model.dart';
import '../../models/pack_house_model.dart';
import '../../models/transport_model.dart';
import '../forms/corporate_company_form_page.dart';
import '../forms/grower_form_page.dart';
import '../forms/packing_house_form_page.dart';
import '../forms/transport_union_form_page.dart';
import '../grower/grower_dialogs.dart';
import 'driver_form_page.dart';
import '../packHouse/consignment_form2_page.dart'; // For adding new consignments

class DriverView extends GetView<DriverController> {
  final RxString selectedSection = 'My Info'.obs;

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
            _buildSummarySection(),
            SizedBox(height: 20),
            _buildSectionChips(),
            Obx(() {
              switch (selectedSection.value) {
                case 'My Info':
                  return _buildDriverInfoContainer(context);
                case 'My Requests':
                  return _buildMyJobsContainer(context);
                case 'Associated Transport Union':
                  return _buildTransportUnionContainer(context);
                case 'Associated Growers':
                  return _buildAssociatedGrowersContainer(context);
                case 'Associated Packhouses':
                  return _buildPackingHouseContainer(context);
                case 'Associated Buyers':
                  return _buildAssociatedBuyersContainer(context);
                default:
                  return SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionChips() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSectionChip('My Info'),
            SizedBox(width: 8),
            _buildSectionChip('My Requests'),
            SizedBox(width: 8),
            _buildSectionChip('Associated Transport Union'),
            SizedBox(width: 8),
            _buildSectionChip('Associated Growers'),
            SizedBox(width: 8),
            _buildSectionChip('Associated Packhouses'),
            SizedBox(width: 8),
            _buildSectionChip('Associated Buyers'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionChip(String label) {
    return Obx(() => FilterChip(
          label: Text(
            label,
            style: TextStyle(
              color: selectedSection.value == label
                  ? Colors.white
                  : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          selected: selectedSection.value == label,
          onSelected: (bool selected) {
            if (selected) {
              selectedSection.value = label;
            }
          },
          backgroundColor: Colors.grey[200],
          selectedColor: Color(0xff548235),
          checkmarkColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ));
  }

  Widget _buildDriverInfoContainer(BuildContext context) {
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
            height: MediaQuery.of(context).size.width > 800 ? 325 : 200,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Obx(
                () => GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 800 ? 5 : 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: controller.details.value.toMap().length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewDriverCard(context);
                    final key = controller.details.value
                        .toMap()
                        .keys
                        .toList()[index - 1];
                    final value = controller.details.value
                        .toMap()
                        .values
                        .toList()[index - 1];
                    return _buildDriverCard(key, value.toString());
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

  Widget _buildDriverCard(String name, String detail) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: controller.details.value,
        title: 'Driver Details',
        details: [
          _buildDetailRow('Name', controller.details.value.name ?? ''),
          _buildDetailRow('Contact', controller.details.value.contact ?? ''),
          _buildDetailRow(
              'License No', controller.details.value.drivingLicenseNo ?? ''),
          _buildDetailRow('Vehicle No',
              controller.details.value.vehicleRegistrationNo ?? ''),
          _buildDetailRow('Number of Tyres',
              controller.details.value.noOfTyres?.toString() ?? ''),
        ],
        onEdit: () => Get.to(() => DriverFormPage()),
        onDelete: () {},
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

  Widget _buildAddNewDriverCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 800;
    return InkWell(
      onTap: () => Get.to(() => DriverFormPage()),
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

  Widget _buildTransportUnionContainer(BuildContext context) {
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
            height: MediaQuery.of(context).size.width > 800 ? 325 : 200,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Obx(
                () => GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 800 ? 5 : 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: controller.associatedTransportUnions.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return _buildAddNewTransportUnionCard(context);
                    return _buildTransportUnionCard(
                        controller.associatedTransportUnions[index - 1]);
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
            "Associated Transport Union",
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

  Widget _buildTransportUnionCard(Transport union) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: union,
        title: 'Transport Union Details',
        details: [
          _buildDetailRow('Name', '${union.nameOfTheTransportUnion}'),
          _buildDetailRow('Contact', union.contact),
          _buildDetailRow('Address', union.address),
        ],
        onEdit: () {},
        onDelete: () =>
            controller.removeAssociatedTransportUnion('${union.id}'),
      ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.business,
                size: isSmallScreen ? 32 : 40,
                color: Colors.green,
              ),
              SizedBox(height: 8),
              Text(
                '${union.name}',
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
                  '${union.contact}',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  '${union.address}',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewTransportUnionCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 800;
    return InkWell(
      onTap: () {
        Get.to(() => TransportUnionFormPage());
      },
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

  Widget _buildMyJobsContainer(BuildContext context) {
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
            height: MediaQuery.of(context).size.width > 800 ? 325 : 200,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Obx(
                () => GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 800 ? 5 : 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: controller.myJobs.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewConsignmentCard(context);
                    return _buildConsignmentCard(controller.myJobs[index - 1]);
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
            "My Requests",
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
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
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
    final isSmallScreen = MediaQuery.of(context).size.width <= 800;
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

  Widget _buildSummarySection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() => GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount:
                MediaQuery.of(Get.context!).size.width > 850 ? 6 : 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildSummaryCard(
                'Associated Transport Unions',
                controller.associatedTransportUnions.length.toString(),
                Colors.blue,
                Icons.business,
              ),
              _buildSummaryCard(
                'Active Requests',
                controller.myJobs
                    .where((job) => job.status == 'In Transit')
                    .length
                    .toString(),
                Colors.green,
                Icons.local_shipping,
              ),
              _buildSummaryCard(
                'Completed Requests',
                controller.myJobs
                    .where((job) => job.status == 'Delivered')
                    .length
                    .toString(),
                Colors.purple,
                Icons.check_circle,
              ),
              _buildSummaryCard(
                'Associated Growers',
                controller.associatedGrowers.length.toString(),
                Colors.orange,
                Icons.agriculture,
              ),
              _buildSummaryCard(
                'Associated Packhouses',
                controller.associatedPackhouses.length.toString(),
                Colors.teal,
                Icons.warehouse,
              ),
              _buildSummaryCard(
                'Associated Buyers',
                controller.associatedBuyers.length.toString(),
                Colors.indigo,
                Icons.store,
              ),
            ],
          )),
    );
  }

  Widget _buildSummaryCard(
      String title, String count, Color color, IconData icon) {
    bool isSmallScreen = MediaQuery.of(Get.context!).size.width > 800;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.7),
              color,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: isSmallScreen ? 28: 20,
              ),
              SizedBox(height: 8),
              Text(
                count,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 20 : 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
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
            height: MediaQuery.of(context).size.width > 800 ? 325 : 200,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Obx(
                () => GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 800 ? 5 : 4,
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
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
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
    final isSmallScreen = MediaQuery.of(context).size.width <= 800;
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

  Widget _buildPackingHouseContainer(BuildContext context) {
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
            height: MediaQuery.of(context).size.width > 800 ? 325 : 200,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Obx(
                    () => GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                    MediaQuery.of(context).size.width > 800 ? 5 : 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: controller.associatedPackhouses.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return _buildAddNewPackingHouseCard(context);
                    return _buildPackingHouseCard(
                      controller.associatedPackhouses[index - 1],
                    );
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
            "Packing Houses",
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

  Widget _buildPackingHouseCard(PackHouse house) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: house,
        title: 'Packing House Details',
        details: [
          _buildDetailRow('Name', house.name),
          _buildDetailRow('Type', '${house.trayType}'),
          _buildDetailRow('Phone', house.phoneNumber),
          _buildDetailRow('Address', house.address),
        ],
        onEdit: () {}, // Empty callback since we don't want edit functionality
        onDelete: () => controller.removeAssociatedPackhouse(house.id),
      ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/images/packhouse.png"),
                height: isSmallScreen ? 32 : 40,
              ),
              Text(
                house.name ?? "Packhouse",
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
                  "Type: ${house.trayType}",
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  house.address,
                  style: TextStyle(fontSize: 12, color: Colors.orange),
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

  Widget _buildAddNewPackingHouseCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 800;
    return InkWell(
      onTap: () => Get.to(() => PackingHouseFormPage()),
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
            height: MediaQuery.of(context).size.width > 800 ? 325 : 200,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Obx(
                () => GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 800 ? 5 : 4,
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
            "Associated Buyers",
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

  Widget _buildBuyerCard(dynamic buyer) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: buyer,
        title: 'Buyer Details',
        details: [
          _buildDetailRow('Name', buyer.name ?? ''),
          _buildDetailRow('Contact', buyer.contact ?? ''),
          _buildDetailRow('Address', buyer.address ?? ''),
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
              Icon(
                Icons.store,
                size: isSmallScreen ? 32 : 40,
                color: Colors.purple,
              ),
              SizedBox(height: 8),
              Text(
                buyer.name ?? '',
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
                  buyer.contact ?? '',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  buyer.address ?? '',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewBuyerCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 800;
    return InkWell(
      onTap: () {
       Get.to(()=>CorporateCompanyFormPage());
      },
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
