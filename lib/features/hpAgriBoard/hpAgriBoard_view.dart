import 'package:apple_grower/features/forms/packing_house_form_page.dart';
import 'package:apple_grower/features/hpAgriBoard/hpAgriBoard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/globalsWidgets.dart' as glbw;
import '../../models/grower_model.dart';
import '../../models/consignment_model.dart';
import '../../models/pack_house_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/transport_model.dart';
import '../forms/driver_form_page.dart';
import '../grower/grower_dialogs.dart';
import '../forms/grower_form_page.dart';
import '../packHouse/consignment_form2_page.dart';


import '../forms/transport_union_form_page.dart';

class HPAgriBoardView extends GetView<HPAgriBoardController> {
  final RxString selectedSection = 'My HPMC Depot Info'.obs;
  final RxDouble screenWidth = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    // Initialize screen width
    screenWidth.value = MediaQuery.of(context).size.width;

    // Listen to screen size changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenWidth.value = MediaQuery.of(context).size.width;
    });

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
                case 'My HPMC Depot Info':
                  return _buildDepotInfoContainer(context);
                case 'Associated Growers':
                  return _buildAssociatedGrowersContainer(context);
                case 'Associated Pack Houses':
                  return _buildAssociatedPackHousesContainer(context);
                case 'Associated Drivers':
                  return _buildAssociatedDriversContainer(context);
                case 'Associated Transport Unions':
                  return _buildAssociatedTransportUnionsContainer(context);
                case 'My Consignments':
                  return _buildConsignmentsContainer(context);
                case 'Gallery':
                  return _buildGalleryContainer(context);
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
            _buildSectionChip('My HPMC Depot Info'),
            SizedBox(width: 8),
            _buildSectionChip('Associated Growers'),
            SizedBox(width: 8),
            _buildSectionChip('Associated Pack Houses'),
            SizedBox(width: 8),
            _buildSectionChip('Associated Drivers'),
            SizedBox(width: 8),
            _buildSectionChip('Associated Transport Unions'),
            SizedBox(width: 8),
            _buildSectionChip('My Consignments'),
            SizedBox(width: 8),
            _buildSectionChip('Gallery'),
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

  Widget _buildSummarySection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        // Calculate grid columns based on screen size
        int crossAxisCount = screenWidth.value > 1110
            ? 6
            : screenWidth.value > 650
                ? 4
                : 3;

        return GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildSummaryCard(
              'Associated Growers',
              controller.associatedGrowers.length.toString(),
              Colors.green,
              Icons.people,
            ),
            _buildSummaryCard(
              'Pack Houses',
              controller.associatedPackHouses.length.toString(),
              Colors.orange,
              Icons.warehouse,
            ),
            _buildSummaryCard(
              'Drivers',
              controller.associatedDrivers.length.toString(),
              Colors.blue,
              Icons.drive_eta,
            ),
            _buildSummaryCard(
              'Transport Unions',
              controller.associatedTransportUnions.length.toString(),
              Colors.purple,
              Icons.local_shipping,
            ),
            _buildSummaryCard(
              'Active Consignments',
              controller.consignments
                  .where(
                      (c) => c.status == 'Pending' || c.status == 'In Transit')
                  .length
                  .toString(),
              Colors.red,
              Icons.assignment,
            ),
            _buildSummaryCard(
              'Completed Consignments',
              controller.consignments
                  .where(
                      (c) => c.status == 'Delivered' || c.status == 'Completed')
                  .length
                  .toString(),
              Colors.teal,
              Icons.check_circle,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryCard(
      String title, String count, Color color, IconData icon) {
    return Obx(() {
      final isLargeScreen = screenWidth.value > 900;
      final isMediumScreen = screenWidth.value > 650;

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
            padding: EdgeInsets.all(isLargeScreen
                ? 16.0
                : isMediumScreen
                    ? 12.0
                    : 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: isLargeScreen
                      ? 32
                      : isMediumScreen
                          ? 28
                          : 24,
                ),
                SizedBox(
                    height: isLargeScreen
                        ? 12
                        : isMediumScreen
                            ? 8
                            : 4),
                Text(
                  count,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isLargeScreen
                        ? 24
                        : isMediumScreen
                            ? 20
                            : 16,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                    height: isLargeScreen
                        ? 8
                        : isMediumScreen
                            ? 6
                            : 4),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isLargeScreen
                        ? 14
                        : isMediumScreen
                            ? 12
                            : 10,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDepotInfoContainer(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                        'Contact Name',
                        controller.sampleCollectionCenter.value.HPMCname ??
                            'N/A'),
                    _buildInfoRow(
                        'Operator Name',
                        controller.sampleCollectionCenter.value.operatorName ??
                            'N/A'),
                    _buildInfoRow(
                        'Cell No.',
                        controller.sampleCollectionCenter.value.cellNo ??
                            'N/A'),
                    _buildInfoRow(
                        'Aadhar No.',
                        controller.sampleCollectionCenter.value.aadharNo ??
                            'N/A'),
                    _buildInfoRow(
                        'License No.',
                        controller.sampleCollectionCenter.value.licenseNo ??
                            'N/A'),
                    _buildInfoRow('Operating Since',
                        '${controller.sampleCollectionCenter.value.operatingSince ?? 'N/A'}'),
                    _buildInfoRow(
                        'Location',
                        controller.sampleCollectionCenter.value.location ??
                            'N/A'),
                    _buildInfoRow('Boxes Transported 2023',
                        '${controller.sampleCollectionCenter.value.boxesTransported2023 ?? 0}'),
                    _buildInfoRow('Boxes Transported 2024',
                        '${controller.sampleCollectionCenter.value.boxesTransported2024 ?? 0}'),
                    _buildInfoRow('Target 2025',
                        '${controller.sampleCollectionCenter.value.target2025 ?? 0}'),
                  ],
                )),
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
            "My HPMC Depot Info",
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
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
          _buildDetailRow('Address', grower.address!),
          _buildDetailRow('Orchards', grower.orchards.length.toString()),
        ],
        onEdit: () {},
        onDelete: () => controller.removeAssociatedGrower(grower.id!),
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
                  grower.address!,
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
                'Consignment ${consignment.id?.substring(0, 4)}...',
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

  Widget _buildGalleryContainer(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;

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
          child: Container(
            height: MediaQuery.of(context).size.height - 200,
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SingleChildScrollView(
                child: Obx(
                  () => GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isLargeScreen ? 3 : 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: isLargeScreen ? 1.0 : 1.5,
                    ),
                    itemCount: controller.galleryImages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) return _buildAddNewImageCard(context);
                      return _buildImageCard(
                          controller.galleryImages[index - 1]);
                    },
                  ),
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
            "Gallery",
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

  Widget _buildImageCard(String imageUrl) {
    return InkWell(
      onTap: () => GrowerDialogs.showImageDetailsDialog(
        Get.context!,
        imageUrl,
        onDelete: () => controller.removeGalleryImage(imageUrl),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image(
            image: NetworkImage(imageUrl) as ImageProvider,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Failed to load image',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewImageCard(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 800;
    return InkWell(
      onTap: () => controller.pickAndUploadImage(),
      child: Card(
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
                Colors.grey[200]!,
                Colors.grey[300]!,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate,
                size: isLargeScreen ? 48 : 64,
                color: Colors.red,
              ),
              SizedBox(height: 12),
              Text(
                "UPLOAD NEW",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isLargeScreen ? 16 : 20,
                  color: Colors.red,
                ),
              ),
            ],
          ),
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

  Widget _buildAssociatedPackHousesContainer(BuildContext context) {
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
                  itemCount: controller.associatedPackHouses.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewPackHouseCard(context);
                    return _buildPackHouseCard(
                        controller.associatedPackHouses[index - 1]);
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
            "Associated Pack Houses",
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

  Widget _buildPackHouseCard(PackHouse packHouse) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: packHouse,
        title: 'Pack House Details',
        details: [
          _buildDetailRow('Name', packHouse.name),
          _buildDetailRow('Phone', packHouse.phoneNumber),
          _buildDetailRow('Address', packHouse.address),
          _buildDetailRow('Grading Machine', packHouse.gradingMachine),
          _buildDetailRow('Sorting Machine', packHouse.sortingMachine),
          _buildDetailRow(
              'Number of Crates', packHouse.numberOfCrates.toString()),
        ],
        onEdit: () {},
        onDelete: () => controller.removeAssociatedPackHouse(packHouse.id!),
      ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warehouse,
                size: isSmallScreen ? 32 : 40,
                color: Colors.orange,
              ),
              Text(
                packHouse.name,
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
                  packHouse.phoneNumber,
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  packHouse.address,
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

  Widget _buildAddNewPackHouseCard(BuildContext context) {
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
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: driver,
        title: 'Driver Details',
        details: [
          _buildDetailRow('Name', driver.name!),
          _buildDetailRow('Phone', driver.contact!),
          _buildDetailRow('License', driver.drivingLicenseNo!),
          _buildDetailRow('Vehicle',
              '${driver.noOfTyres} - ${driver.vehicleRegistrationNo}'),
        ],
        onEdit: () {},
        onDelete: () => controller.removeAssociatedDriver(driver.id!),
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
                driver.name!,
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
                  driver.contact!,
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
    final isSmallScreen = MediaQuery.of(context).size.width <= 800;
    return InkWell(
      onTap: () => Get.to(() => DriverFormPageView()),
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

  Widget _buildAssociatedTransportUnionsContainer(BuildContext context) {
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
            "Associated Transport Unions",
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
          _buildDetailRow('Name', union.name),
          _buildDetailRow('Contact', union.contact),
          _buildDetailRow(
              'Registration', union.transportUnionRegistrationNo ?? 'N/A'),
          _buildDetailRow('Address', union.address),
          _buildDetailRow('Vehicles', '${union.noOfVehiclesRegistered ?? 0}'),
        ],
        onEdit: () {},
        onDelete: () =>
            controller.removeAssociatedTransportUnion(union.id ?? ''),
      ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_shipping,
                size: isSmallScreen ? 32 : 40,
                color: Colors.indigo,
              ),
              Text(
                union.name,
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
                  union.contact,
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  union.transportUnionRegistrationNo ?? 'N/A',
                  style: TextStyle(fontSize: 12, color: Colors.indigo),
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
      onTap: () => Get.to(() => TransportUnionFormPage()),
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
