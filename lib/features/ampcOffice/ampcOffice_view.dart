import 'package:apple_grower/features/ampcOffice/ampcOffice_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/globalsWidgets.dart' as glbw;

class AmpcOfficeView extends GetView<AmpcOfficeController> {
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
            _buildAmpcOfficeInfoContainer(),
            _buildApprovedAadhatisContainer(),
            _buildBlacklistedAadhatisContainer(),
            _buildApprovedLadanisContainer(),
            _buildBlacklistedLadanisContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmpcOfficeInfoContainer() {
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
                _buildInfoRow('Office Name', controller.officeName.value),
                _buildInfoRow('Address', controller.officeAddress.value),
                _buildInfoRow('Contact', controller.officeContact.value),
                _buildInfoRow('Email', controller.officeEmail.value),
                _buildInfoRow('License No', controller.officeLicenseNo.value),
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
            "AMPC Office Info",
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

  Widget _buildApprovedAadhatisContainer() {
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
                  itemCount: controller.approvedAadhatis.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewAadhatiCard(true);
                    return _buildAadhatiCard(
                        controller.approvedAadhatis[index - 1], true);
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
            "Approved Aadhatis",
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

  Widget _buildBlacklistedAadhatisContainer() {
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
                  itemCount: controller.blacklistedAadhatis.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewAadhatiCard(false);
                    return _buildAadhatiCard(
                        controller.blacklistedAadhatis[index - 1], false);
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
            color: Colors.red[800],
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(maxWidth: 225),
          child: Text(
            "Blacklisted Aadhatis",
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

  Widget _buildApprovedLadanisContainer() {
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
                  itemCount: controller.approvedLadanis.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewLadaniCard(true);
                    return _buildLadaniCard(
                        controller.approvedLadanis[index - 1], true);
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
            "Approved Ladanis",
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

  Widget _buildBlacklistedLadanisContainer() {
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
                  itemCount: controller.blacklistedLadanis.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewLadaniCard(false);
                    return _buildLadaniCard(
                        controller.blacklistedLadanis[index - 1], false);
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
            color: Colors.red[800],
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(maxWidth: 225),
          child: Text(
            "Blacklisted Ladanis",
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

  Widget _buildAadhatiCard(dynamic aadhati, bool isApproved) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap: () {
        // TODO: Show details dialog
      },
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
                Text('${aadhati.licenseNo}', style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  '${aadhati.contact}',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLadaniCard(dynamic ladani, bool isApproved) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap: () {
        // TODO: Show details dialog
      },
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
                '${ladani.name}',
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
                Text('${ladani.licenseNo}', style: TextStyle(fontSize: 12)),
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

  Widget _buildAddNewAadhatiCard(bool isApproved) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap: () {
        // TODO: Navigate to add new aadhati form
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

  Widget _buildAddNewLadaniCard(bool isApproved) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap: () {
        // TODO: Navigate to add new ladani form
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
