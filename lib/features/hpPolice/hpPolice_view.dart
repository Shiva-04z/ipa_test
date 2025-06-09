import 'package:apple_grower/features/hpPolice/hpPolice_controller.dart';
import 'package:apple_grower/features/packHouse/consignment_form2_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/consignment_model.dart';

import '../../core/globalsWidgets.dart' as glbw;

class HPPoliceView extends GetView<HPPoliceController> {
  final RxString selectedSection = 'Police Station Info'.obs;

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
                case 'Police Station Info':
                  return _buildPoliceStationInfoContainer();
                case 'Check Posts':
                  return _buildPostsContainer();
                case 'Consignments':
                  return _buildConsignmentsContainer();
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
            _buildSectionChip('Police Station Info'),
            SizedBox(width: 8),
            _buildSectionChip('Check Posts'),
            SizedBox(width: 8),
            _buildSectionChip('Consignments'),
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

  Widget _buildPoliceStationInfoContainer() {
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                _buildInfoRow('Station Name', controller.stationName.value),
                _buildInfoRow('Address', controller.stationAddress.value),
                _buildInfoRow('Contact', controller.stationContact.value),
                _buildInfoRow('Email', controller.stationEmail.value),
                _buildInfoRow('Station Code', controller.stationCode.value),
              ],
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
            "Police Station Info",
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

  Widget _buildPostsContainer() {
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
            height: MediaQuery.of(Get.context!).size.width > 800 ? 325 : 200,
            width: MediaQuery.of(Get.context!).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Obx(
                () => GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(Get.context!).size.width > 800 ? 5 : 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: controller.posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewPostCard();
                    return _buildPostCard(controller.posts[index - 1]);
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
            "Check Posts",
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

  Widget _buildConsignmentsContainer() {
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
            height: MediaQuery.of(Get.context!).size.width > 800 ? 325 : 200,
            width: MediaQuery.of(Get.context!).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Obx(
                () => GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(Get.context!).size.width > 800 ? 5 : 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: controller.consignments.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewConsignmentCard();
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

  Widget _buildInfoRow(String label, String value) {
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

  Widget _buildPostCard(Map<String, dynamic> post) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () {
        // TODO: Show post details dialog
      },
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: isSmallScreen ? 32 : 40,
                color: Colors.blue,
              ),
              Text(
                post['title'],
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
                Text(post['location'], style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  post['officerInCharge'],
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
                SizedBox(height: 4),
                _buildPostStatusChip(post['status']),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsignmentCard(Consignment consignment) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () {
        // TODO: Show consignment details dialog
      },
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
                color: Colors.orange,
              ),
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
                Text('${consignment.numberOfBoxes} Boxes',
                    style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  consignment.quality,
                  style: TextStyle(fontSize: 12, color: Colors.orange),
                ),
                SizedBox(height: 4),
                _buildConsignmentStatusChip(consignment.status),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewPostCard() {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () => _showAddPostDialog(),
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

  Widget _buildAddNewConsignmentCard() {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () => {Get.to(() => ConsignmentForm2Page())},
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

  void _showAddPostDialog() {
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    final officerController = TextEditingController();
    final contactController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Add New Check Post'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Post Title'),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: officerController,
                decoration: InputDecoration(labelText: 'Officer In Charge'),
              ),
              TextField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Contact'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  locationController.text.isNotEmpty &&
                  officerController.text.isNotEmpty &&
                  contactController.text.isNotEmpty) {
                controller.addPost({
                  'id': 'POST${DateTime.now().millisecondsSinceEpoch}',
                  'title': titleController.text,
                  'location': locationController.text,
                  'officerInCharge': officerController.text,
                  'contact': contactController.text,
                  'status': 'Active',
                  'createdAt': DateTime.now(),
                });
                Get.back();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddConsignmentDialog() {
    final qualityController = TextEditingController();
    final categoryController = TextEditingController();
    final boxesController = TextEditingController();
    final fromController = TextEditingController();
    final toController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Add New Consignment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: qualityController,
                decoration: InputDecoration(labelText: 'Quality'),
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: boxesController,
                decoration: InputDecoration(labelText: 'Number of Boxes'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: fromController,
                decoration: InputDecoration(labelText: 'Shipping From'),
              ),
              TextField(
                controller: toController,
                decoration: InputDecoration(labelText: 'Shipping To'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (qualityController.text.isNotEmpty &&
                  categoryController.text.isNotEmpty &&
                  boxesController.text.isNotEmpty &&
                  fromController.text.isNotEmpty &&
                  toController.text.isNotEmpty) {
                controller.addConsignment(
                  Consignment(
                    id: 'CONS${DateTime.now().millisecondsSinceEpoch}',
                    quality: qualityController.text,
                    category: categoryController.text,
                    numberOfBoxes: int.parse(boxesController.text),
                    numberOfPiecesInBox: 20, // Default value
                    pickupOption: 'Own',
                    shippingFrom: fromController.text,
                    shippingTo: toController.text,
                    commissionAgent: null,
                    corporateCompany: null,
                    packingHouse: null,
                    hasOwnCrates: true,
                    status: 'In Transit',
                    driver: null,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                );
                Get.back();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildPostStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.green;
        break;
      case 'inactive':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 10)),
    );
  }

  Widget _buildConsignmentStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'in transit':
        color = Colors.orange;
        break;
      case 'delivered':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 10)),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() => GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount:
                MediaQuery.of(Get.context!).size.width > 800 ? 3 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildSummaryCard(
                'Active Check Posts',
                controller.posts
                    .where((post) => post['status'] == 'Active')
                    .length
                    .toString(),
                Colors.blue,
                Icons.location_on,
              ),
              _buildSummaryCard(
                'In Transit Consignments',
                controller.consignments
                    .where((c) => c.status == 'In Transit')
                    .length
                    .toString(),
                Colors.orange,
                Icons.local_shipping,
              ),
              _buildSummaryCard(
                'Delivered Consignments',
                controller.consignments
                    .where((c) => c.status == 'Delivered')
                    .length
                    .toString(),
                Colors.green,
                Icons.check_circle,
              ),
            ],
          )),
    );
  }

  Widget _buildSummaryCard(
      String title, String count, Color color, IconData icon) {
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
                size: 28,
              ),
              SizedBox(height: 8),
              Text(
                count,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
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
}
