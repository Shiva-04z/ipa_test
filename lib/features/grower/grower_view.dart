import 'package:apple_grower/features/forms/buyer_form_page.dart';
import 'package:apple_grower/features/forms/driver_form_page.dart';
import 'package:apple_grower/features/grower/grower_controller.dart';
import 'package:apple_grower/models/ladani_model.dart';
import 'package:apple_grower/navigation/routes_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apple_grower/core/globalsWidgets.dart' as glbw;
import 'package:intl/intl.dart';
import '../../core/globals.dart' as glb;
import '../../models/aadhati.dart';
import '../../models/hpmc_collection_center_model.dart';
import '../../models/pack_house_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/transport_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../models/freightForwarder.dart';
import '../forms/commission_agent_form_page.dart';
import '../forms/consignmentForm/consignment_form_page.dart';
import '../forms/orchard_form_page.dart';
import '../forms/packing_house_form_page.dart';
import 'grower_dialogs.dart';
import '../../models/orchard_model.dart';
import '../../models/consignment_model.dart';
import '../forms/transport_union_form_page.dart';
import 'dart:io';
import '../forms/hpmc_depot_form_page.dart';

class GrowerView extends GetView<GrowerController> {
  final RxString selectedSection = 'Orchards'.obs;

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
            SizedBox(height: 40),
            _buildSectionSelector(),
            SizedBox(height: 20),
            Obx(() {
              return Column(
                children: [
                  if (selectedSection.value == 'Orchards') ...[
                    _buildOrchardContainer(context),
                    _buildTable(),
                  ],
                  if (selectedSection.value == 'Consignments')
                    _buildConsignmentsContainer(context),
                  if (selectedSection.value == 'Commission Agents')
                    _buildCommissionAgentsContainer(context),
                  if (selectedSection.value == 'Freight Forwarders')
                    _buildFreightForwardersContainer(context),
                  if (selectedSection.value == 'Packing Houses')
                    _buildPackingHouseContainer(context),
                  if (selectedSection.value == 'Drivers')
                    _buildDriversContainer(context),
                  if (selectedSection.value == 'Transport Union')
                    _buildTransportUnionContainer(context),
                  if (selectedSection.value == 'HPMC')
                    _buildHpmcContainer(context),
                  if (selectedSection.value == 'Gallery')
                    _buildGalleryContainer(context),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionSelector() {
    final sections = [
      'Orchards',
      'Packing Houses',
      'Commission Agents',
      'Freight Forwarders',
      'Drivers',
      'Transport Union',
      'HPMC',
      'Consignments',
      'Gallery',
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: sections.map((section) {
            return Padding(
              padding: EdgeInsets.only(right: 8),
              child: _buildSectionChip(section),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSectionChip(String label) {
    return Obx(() => FilterChip(
          label: Text(
            glb.getTranslatedText(label),
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

  Widget _buildOrchardContainer(BuildContext context) {
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
                  itemCount: controller.orchards.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewOrchardCard(context);
                    return _buildOrchardCard(
                        context, controller.orchards[index - 1]);
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
            glb.getTranslatedText("My Orchards"),
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

  Widget _buildOrchardCard(BuildContext context, Orchard orchard) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    Color iconColor;
    switch (orchard.cropStage) {
      case CropStage.walnutSize:
        iconColor = Colors.blue;
        break;
      case CropStage.fruitDevelopment:
        iconColor = Colors.lightBlue;
        break;
      case CropStage.colourInitiation:
        iconColor = Colors.orange;
        break;
      case CropStage.fiftyPercentColour:
        iconColor = Colors.deepOrange;
        break;
      case CropStage.eightyPercentColour:
        iconColor = Colors.red;
        break;
      case CropStage.harvest:
        iconColor = Colors.green;
        break;

    }
    return InkWell(
      onTap: () => GrowerDialogs.showOrchardDetailsDialog(context, orchard),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(
                AssetImage("assets/images/orchard.png"),
                size: isSmallScreen ? 32 : 40,
                color: iconColor,
              ),
              Text(
                glb.getTranslatedText(orchard.name),
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
                  glb.getTranslatedText(
                      '${orchard.numberOfFruitingTrees} trees'),
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  glb.getTranslatedText(DateFormat(
                    'MMM dd, yyyy',
                  ).format(orchard.expectedHarvestDate)),
                  style: TextStyle(fontSize: 12, color: iconColor),
                ),
                SizedBox(height: 4),
                _buildHarvestStatusChip(orchard.cropStage),
              ],
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
              glb.getTranslatedText(label),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
          ),
          Expanded(child: Text(glb.getTranslatedText(value))),
        ],
      ),
    );
  }

  Widget _buildHarvestStatusChip(CropStage stage) {
    Color color;
    String text;
    switch (stage) {
      case CropStage.walnutSize:
        color = Colors.blue;
        text = 'Walnut Size';
        break;
      case CropStage.fruitDevelopment:
        color = Colors.lightBlue;
        text = 'Fruit Development';
        break;
      case CropStage.colourInitiation:
        color = Colors.orange;
        text = 'Colour Initiation';
        break;
      case CropStage.fiftyPercentColour:
        color = Colors.deepOrange;
        text = '50% Colour';
        break;
      case CropStage.eightyPercentColour:
        color = Colors.red;
        text = '80% Colour';
        break;
      case CropStage.harvest:
        color = Colors.green;
        text = 'Harvest';
        break;
        color = Colors.teal;
        text = 'Packing';
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(glb.getTranslatedText(text),
          style: TextStyle(color: color, fontSize: 10)),
    );
  }

  Widget _buildAddNewOrchardCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 800;
    return InkWell(
      onTap: () => Get.to(() => OrchardFormPage()),
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
              glb.getTranslatedText("ADD NEW"),
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

  Widget _buildTable() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Obx(() => _buildDataTable()),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Color(0xff548235)),
      child: Row(
        children: [
          _buildHeaderCell("My Orchards"),
          _buildHeaderCell("Date of\nHarvesting"),
          _buildHeaderCell("Fruiting\nTrees"),
          _buildHeaderCell("Expected\nBoxes"),
          _buildHeaderCell("Status"),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: Text(
          glb.getTranslatedText(text),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      color: Colors.white,
      child: Column(
        children: controller.orchards.map((orchard) {
          return Row(
            children: [
              _buildDataCell(orchard.name),
              _buildDataCell(
                DateFormat(
                  'MMM dd, yyyy',
                ).format(orchard.expectedHarvestDate),
              ),
              _buildDataCell(orchard.numberOfFruitingTrees.toString()),
              _buildDataCell(orchard.estimatedBoxes?.toString() ?? 'N/A'),
              _buildDataCell(_getHarvestStatusText(orchard.cropStage)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        alignment: Alignment.center,
        child: Text(
          glb.getTranslatedText(text),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  String _getHarvestStatusText(CropStage stage) {
    switch (stage) {
      case CropStage.walnutSize:
        return glb.getTranslatedText('Walnut Size');
      case CropStage.fruitDevelopment:
        return glb.getTranslatedText('Fruit Development');
      case CropStage.colourInitiation:
        return glb.getTranslatedText('Colour Initiation');
      case CropStage.fiftyPercentColour:
        return glb.getTranslatedText('50% Colour');
      case CropStage.eightyPercentColour:
        return glb.getTranslatedText('80% Colour');
      case CropStage.harvest:
        return glb.getTranslatedText('Harvest');

    }
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
                  itemCount: controller.consignments.length , // +1 for the Add New card
                  itemBuilder: (context, index) {
                    return _buildConsignmentCard(
                      controller.consignments[index],
                    ); // Placeholder
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
            glb.getTranslatedText("My Consignments"),
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
      onTap: () {
        glb.consignmentID.value = consignment.id!;
        if(consignment.currentStage=="Release for Bid"||consignment.currentStage=="Bidding Invite"||consignment.currentStage=="Bidding Start")
{
  print("hello ${consignment.currentStage}");
  Get.toNamed(RoutesConstant.growerSession);
} else
          Get.toNamed(RoutesConstant.consignmentForm);
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
                color: Colors.orangeAccent,
              ),
              SizedBox(height: 8),
              Text(
                glb.getTranslatedText(
                    '${consignment.searchId!}'),
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,


              ),
              if (!isSmallScreen) ...[
                Text(
                  glb.getTranslatedText('Status: ${consignment.currentStage}'),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommissionAgentsContainer(BuildContext context) {
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
                  itemCount: controller.commissionAgents.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewAgentCard(context);
                    return _buildAgentCard(
                      controller.commissionAgents[index - 1],
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
            glb.getTranslatedText("Commission Agents"),
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

  Widget _buildAgentCard(Aadhati agent) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: agent,
        title: 'Commission Agent Details',
        details: [
          _buildDetailRow('Name ', '${agent.name}'),
          _buildDetailRow('Phone', '${agent.contact}'),
          _buildDetailRow('APMC Mandi', '${agent.apmc}'),
          _buildDetailRow('Address', '${agent.address}'),
        ],
        onEdit: () {},
        // Empty callback since we don't want edit functionality
        onDelete: () => controller.removeCommissionAgent('${agent.id}'),
      ),
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
                glb.getTranslatedText('${agent.name}'),
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
                  glb.getTranslatedText('${agent.apmc}'),
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  glb.getTranslatedText('${agent.contact}'),
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewAgentCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 800;
    return InkWell(
      onTap: () => Get.to(() => CommissionAgentFormPage()),
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
              glb.getTranslatedText("ADD NEW"),
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

  Widget _buildFreightForwardersContainer(BuildContext context) {
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
                  itemCount: controller.freightForwarders.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return _buildAddNewFreightForwarderCard(context);
                    return _buildFreightForwarderCard(
                      controller.freightForwarders[index - 1],
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
            glb.getTranslatedText("Freight Forwarders"),
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

  Widget _buildFreightForwarderCard(FreightForwarder forwarder) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: forwarder,
        title: 'Freight Forwarder Details',
        details: [
          _buildDetailRow('Name', forwarder.name),
          _buildDetailRow('Contact', forwarder.contact),
          _buildDetailRow('License No', forwarder.licenseNo ?? 'N/A'),
          _buildDetailRow('Address', forwarder.address),
          _buildDetailRow(
              'Forwarding Since', '${forwarder.forwardingSinceYears} years'),
          _buildDetailRow(
              'Boxes Forwarded 2023', '${forwarder.appleBoxesForwarded2023}'),
          _buildDetailRow(
              'Boxes Forwarded 2024', '${forwarder.appleBoxesForwarded2024}'),
        ],
        onEdit: () {},
        onDelete: () => controller.removeFreightForwarder(forwarder.id!),
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
                color: Colors.purple,
              ),
              SizedBox(height: 8),
              Text(
                glb.getTranslatedText(forwarder.name),
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
                  glb.getTranslatedText(forwarder.contact),
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  glb.getTranslatedText(
                      'License: ${forwarder.licenseNo ?? 'N/A'}'),
                  style: TextStyle(fontSize: 12, color: Colors.purple),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewFreightForwarderCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 800;
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
              glb.getTranslatedText("ADD NEW"),
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
                  itemCount: controller.packingHouses.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return _buildAddNewPackingHouseCard(context);
                    return _buildPackingHouseCard(
                      controller.packingHouses[index - 1],
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
            glb.getTranslatedText("Packing Houses"),
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
        onEdit: () {},
        // Empty callback since we don't want edit functionality
        onDelete: () => controller.removePackingHouse(house.id!),
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
                glb.getTranslatedText(house.name ?? "Packhouse"),
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
                  glb.getTranslatedText("Type: ${house.trayType}"),
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  glb.getTranslatedText(house.address),
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
              glb.getTranslatedText("ADD NEW"),
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

  Widget _buildDriversContainer(BuildContext context) {
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
                  itemCount: controller.drivers.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewDriverCard(context);
                    return _buildDriverCard(controller.drivers[index - 1]);
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
            glb.getTranslatedText("Associated Drivers"),
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
          _buildDetailRow('Name', '${driver.name}'),
          _buildDetailRow('Contact', '${driver.contact}'),
          _buildDetailRow('License', '${driver.drivingLicenseNo}'),
          _buildDetailRow('Vehicle', '${driver.vehicleRegistrationNo}'),
          _buildDetailRow('Tyres', '${driver.noOfTyres}'),
        ],
        onEdit: () {},
        onDelete: () => controller.removeDriver('${driver.id}'),
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
                glb.getTranslatedText('${driver.name}'),
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
                  glb.getTranslatedText('${driver.contact}'),
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  glb.getTranslatedText('${driver.drivingLicenseNo}'),
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
              glb.getTranslatedText("ADD NEW"),
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

  Widget _buildSummarySection() {
    bool isSmallScreen = MediaQuery.of(Get.context!).size.width > 950;
    bool isMediumScreen = MediaQuery.of(Get.context!).size.width > 750;
    bool isextraSmallScreen = MediaQuery.of(Get.context!).size.width > 396;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() => GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: isSmallScreen
                ? 7
                : isMediumScreen
                    ? 4
                    : 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: [
              _buildSummaryCard(
                'Orchards',
                controller.orchards.length.toString(),
                Colors.green,
                Icons.landscape,
              ),
              _buildSummaryCard(
                'Consignments',
                controller.consignments.length.toString(),
                Colors.orange,
                Icons.assignment,
              ),
              _buildSummaryCard(
                'Commission Agents',
                controller.commissionAgents.length.toString(),
                Colors.blue,
                Icons.people,
              ),
              _buildSummaryCard(
                'Freight Forwarders',
                controller.freightForwarders.length.toString(),
                Colors.purple,
                Icons.local_shipping,
              ),
              _buildSummaryCard(
                'Packing Houses',
                controller.packingHouses.length.toString(),
                Colors.red,
                Icons.warehouse,
              ),
              _buildSummaryCard(
                'Drivers',
                controller.drivers.length.toString(),
                Colors.teal,
                Icons.drive_eta,
              ),
              _buildSummaryCard(
                'Transport Union',
                controller.transportUnions.length.toString(),
                Colors.indigo,
                Icons.local_shipping,
              ),
            ],
          )),
    );
  }

  Widget _buildSummaryCard(
      String title, String count, Color color, IconData icon) {
    bool isSmallScreen = MediaQuery.of(Get.context!).size.width > 840;
    bool isMobileScreen= MediaQuery.of(Get.context!).size.width > 400;
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
                size: isMobileScreen?24:20,
              ),
              SizedBox(height: 8),
              Text(
                glb.getTranslatedText(count),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 24 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                glb.getTranslatedText(title),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobileScreen?24:16,
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
            height: MediaQuery.of(context).size.height -
                200, // Adjust height based on available space
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
            glb.getTranslatedText("Gallery"),
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
            image: kIsWeb
                ? NetworkImage(imageUrl) as ImageProvider
                : FileImage(File(imageUrl)) as ImageProvider,
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
                        glb.getTranslatedText('Failed to load image'),
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
                glb.getTranslatedText("UPLOAD NEW"),
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
                  itemCount: controller.transportUnions.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return _buildAddNewTransportUnionCard(context);
                    return _buildTransportUnionCard(
                        controller.transportUnions[index - 1]);
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
            glb.getTranslatedText("Transport Union"),
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
          _buildDetailRow('Name', '${union.name}'),
          _buildDetailRow('Contact', '${union.contact}'),
          _buildDetailRow(
              'Registeration No.', '${union.transportUnionRegistrationNo}'),
          _buildDetailRow('Address', '${union.address}'),
        ],
        onEdit: () {},
        onDelete: () => controller.removeTransportUnion('${union.id}'),
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
              SizedBox(height: 8),
              Text(
                glb.getTranslatedText('${union.name}'),
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
                  glb.getTranslatedText('${union.contact}'),
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  glb.getTranslatedText(
                      '${union.transportUnionRegistrationNo}'),
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
              glb.getTranslatedText("ADD NEW"),
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

  Widget _buildHpmcContainer(BuildContext context) {
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
                  itemCount: controller.hpmcDepots.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewHpmcCard(context);
                    return _buildHpmcCard(controller.hpmcDepots[index - 1]);
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
            glb.getTranslatedText("HPMC Depots"),
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

  Widget _buildHpmcCard(HpmcCollectionCenter depot) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: depot,
        title: 'HPMC Depot Details',
        details: [
          _buildDetailRow('Contact Name', depot.HPMCname!),
          _buildDetailRow('Operator', depot.operatorName!),
          _buildDetailRow('Phone', depot.cellNo!),
          _buildDetailRow('Location', depot.location!),
          _buildDetailRow('License No', depot.licenseNo!),
          _buildDetailRow('Operating Since', depot.operatingSince!),
          _buildDetailRow('Boxes 2023', '${depot.boxesTransported2023}'),
          _buildDetailRow('Boxes 2024', '${depot.boxesTransported2024}'),
          _buildDetailRow('Target 2025', '${depot.target2025}'),
        ],
        onEdit: () {},
        onDelete: () => controller.removeHpmc(depot.id!),
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
                color: Color(0xff548235),
              ),
              SizedBox(height: 8),
              Text(
                glb.getTranslatedText('${depot.operatorName}'),
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
                  glb.getTranslatedText('${depot.HPMCname}'),
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  glb.getTranslatedText('${depot.location}'),
                  style: TextStyle(fontSize: 12, color: Color(0xff548235)),
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

  Widget _buildAddNewHpmcCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 800;
    return InkWell(
      onTap: () => Get.to(() => HpmcDepotFormPage()),
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
              glb.getTranslatedText("ADD NEW"),
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
