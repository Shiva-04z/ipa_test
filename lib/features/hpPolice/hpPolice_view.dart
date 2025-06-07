import 'package:apple_grower/features/hpPolice/hpPolice_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/consignment_model.dart';

import '../../core/globalsWidgets.dart' as glbw;

class HPPoliceView extends GetView<HPPoliceController> {
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
            _buildPoliceStationInfoContainer(),
            _buildPostsContainer(),
            _buildConsignmentsContainer(),
          ],
        ),
      ),
    );
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
            height: MediaQuery.of(Get.context!).size.width > 600 ? 325 : 200,
            width: MediaQuery.of(Get.context!).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Obx(
                () => GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(Get.context!).size.width > 600 ? 5 : 4,
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
            height: MediaQuery.of(Get.context!).size.width > 600 ? 325 : 200,
            width: MediaQuery.of(Get.context!).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Obx(
                () => GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(Get.context!).size.width > 600 ? 5 : 4,
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
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
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
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsignmentCard(Consignment consignment) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
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
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewPostCard() {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
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
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap: () => _showAddConsignmentDialog(),
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
}
