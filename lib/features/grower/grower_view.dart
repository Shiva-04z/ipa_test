import 'package:apple_grower/features/grower/grower_controller.dart';

import 'package:apple_grower/navigation/routes_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apple_grower/core/globalsWidgets.dart' as glbw;
import 'package:intl/intl.dart';
import 'grower_dialogs.dart';

import '../../models/commission_agent_model.dart';
import '../../models/corporate_company_model.dart';
import '../../models/orchard_model.dart';
import '../../models/packing_house_status_model.dart';
import '../../models/consignment_model.dart';
import 'consignment_form_page.dart';

class GrowerView extends GetView<GrowerController> {
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
            _buildOrchardContainer(context),
            _buildTable(),
            _buildConsignmentsContainer(context),
            _buildCommissionAgentsContainer(context),
            _buildCorporateCompaniesContainer(context),
            _buildPackingHouseContainer(context),
          ],
        ),
      ),
    );
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
                  itemCount: controller.orchards.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewOrchardCard(context);
                    return _buildOrchardCard(controller.orchards[index - 1]);
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
            "My Orchards",
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

  Widget _buildOrchardCard(Orchard orchard) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap:
          () => GrowerDialogs.showItemDetailsDialog(
            context: Get.context!,
            item: orchard,
            title: 'Orchard Details',
            details: [
              _buildDetailRow('Name', orchard.name),
              _buildDetailRow('Location', orchard.location),
              _buildDetailRow(
                'Trees',
                orchard.numberOfFruitingTrees.toString(),
              ),
              _buildDetailRow(
                'Expected Boxes',
                orchard.estimatedBoxes?.toString() ?? 'N/A',
              ),
              _buildDetailRow(
                'Harvest Date',
                DateFormat('MMM dd, yyyy').format(orchard.expectedHarvestDate),
              ),
              _buildDetailRow(
                'Status',
                _getHarvestStatusText(orchard.harvestStatus),
              ),
            ],
            onEdit:
                () =>
                    GrowerDialogs.showEditOrchardDialog(Get.context!, orchard),
            onDelete: () => controller.removeOrchard(orchard.id),
          ),
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
                color: Colors.green,
              ),
              Text(
                orchard.name,
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
                  '${orchard.numberOfFruitingTrees} trees',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  DateFormat(
                    'MMM dd, yyyy',
                  ).format(orchard.expectedHarvestDate),
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
                SizedBox(height: 4),
                _buildHarvestStatusChip(orchard.harvestStatus),
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

  Widget _buildHarvestStatusChip(HarvestStatus status) {
    Color color;
    String text;
    switch (status) {
      case HarvestStatus.planned:
        color = Colors.blue;
        text = 'Planned';
        break;
      case HarvestStatus.inProgress:
        color = Colors.orange;
        text = 'In Progress';
        break;
      case HarvestStatus.completed:
        color = Colors.green;
        text = 'Completed';
        break;
      case HarvestStatus.delayed:
        color = Colors.red;
        text = 'Delayed';
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 10)),
    );
  }

  Widget _buildAddNewOrchardCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return InkWell(
      onTap: () => GrowerDialogs.showAddOrchardDialog(context),
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
          text,
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
        children:
            controller.orchards.map((orchard) {
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
                  _buildDataCell(_getHarvestStatusText(orchard.harvestStatus)),
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
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  String _getHarvestStatusText(HarvestStatus status) {
    switch (status) {
      case HarvestStatus.planned:
        return 'Planned';
      case HarvestStatus.inProgress:
        return 'In Progress';
      case HarvestStatus.completed:
        return 'Completed';
      case HarvestStatus.delayed:
        return 'Delayed';
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
                  itemCount:
                      controller.consignments.length +
                      1, // +1 for the Add New card
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewConsignmentCard(context);
                    // TODO: Build Consignment Card UI
                    return _buildConsignmentCard(
                      controller.consignments[index - 1],
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
            "My Consignments",
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

  Widget _buildAddNewConsignmentCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return InkWell(
      onTap:
          () => Get.to(() => ConsignmentFormPage()), // Navigate to the new page
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: SizedBox.expand(
          // Wrap content in SizedBox.expand
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
      ),
    );
  }

  Widget _buildConsignmentCard(Consignment consignment) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    // TODO: Implement actual Consignment Card UI based on model fields
    return InkWell(
      onTap:
          () => GrowerDialogs.showItemDetailsDialog(
            context: Get.context!,
            item: consignment,
            title: 'Consignment Details',
            details: [
              _buildDetailRow('Quality', consignment.quality),
              _buildDetailRow('Category', consignment.category),
              _buildDetailRow('Boxes', consignment.numberOfBoxes.toString()),
              _buildDetailRow(
                'Pieces/Box',
                consignment.numberOfPiecesInBox.toString(),
              ),
              _buildDetailRow('Pickup', consignment.pickupOption),
              if (consignment.shippingFrom != null)
                _buildDetailRow('From', consignment.shippingFrom!),
              if (consignment.shippingTo != null)
                _buildDetailRow('To', consignment.shippingTo!),
              _buildDetailRow('Adhani', consignment.adhaniOption),
              _buildDetailRow('Ladhani', consignment.ladhaniOption),
              if (consignment.hasOwnCrates != null)
                _buildDetailRow(
                  'Own Crates',
                  consignment.hasOwnCrates.toString(),
                ),
              _buildDetailRow('Status', consignment.status),
              if (consignment.driverName != null)
                _buildDetailRow(
                  'Driver',
                  '${consignment.driverName} (${consignment.driverContact})',
                ),
              if (consignment.adhaniName != null)
                _buildDetailRow(
                  'Adhani',
                  '${consignment.adhaniName} (${consignment.adhaniContact})',
                ),
              if (consignment.ladhaniName != null)
                _buildDetailRow(
                  'Ladhani',
                  '${consignment.ladhaniName} (${consignment.ladhaniContact})',
                ),
            ],
            onEdit: () {}, // No edit functionality for consignments currently
            onDelete: () => controller.removeConsignment(consignment.id),
          ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder Icon
              Icon(
                Icons.assignment,
                size: isSmallScreen ? 32 : 40,
                color: Colors.orangeAccent,
              ),
              SizedBox(height: 8),
              Text(
                'Consignment ${consignment.id.substring(0, 4)}...', // Displaying a truncated ID as a placeholder name
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
            "Commission Agents",
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

  Widget _buildAgentCard(CommissionAgent agent) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap:
          () => GrowerDialogs.showItemDetailsDialog(
            context: Get.context!,
            item: agent,
            title: 'Commission Agent Details',
            details: [
              _buildDetailRow('Name', agent.name),
              _buildDetailRow('Phone', agent.phoneNumber),
              _buildDetailRow('APMC Mandi', agent.apmcMandi),
              _buildDetailRow('Address', agent.address),
            ],
            onEdit:
                () {}, // Empty callback since we don't want edit functionality
            onDelete: () => controller.removeCommissionAgent(agent.id),
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
                agent.name,
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
                Text(agent.apmcMandi, style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  agent.phoneNumber,
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
    final isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return InkWell(
      onTap: () => GrowerDialogs.showAddCommissionAgentDialog(context),
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

  Widget _buildCorporateCompaniesContainer(BuildContext context) {
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
                  itemCount: controller.corporateCompanies.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewCompanyCard(context);
                    return _buildCompanyCard(
                      controller.corporateCompanies[index - 1],
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
            "Corporate Companies",
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

  Widget _buildCompanyCard(CorporateCompany company) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap:
          () => GrowerDialogs.showItemDetailsDialog(
            context: Get.context!,
            item: company,
            title: 'Corporate Company Details',
            details: [
              _buildDetailRow('Name', company.name),
              _buildDetailRow('Phone', company.phoneNumber),
              _buildDetailRow('Type', company.companyType),
              _buildDetailRow('Address', company.address),
            ],
            onEdit:
                () {}, // Empty callback since we don't want edit functionality
            onDelete: () => controller.removeCorporateCompany(company.id),
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
                company.name,
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
                Text(company.companyType, style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  company.phoneNumber,
                  style: TextStyle(fontSize: 12, color: Colors.purple),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewCompanyCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return InkWell(
      onTap: () => GrowerDialogs.showAddCorporateCompanyDialog(context),
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

  Widget _buildPackingHouseCard(PackingHouse house) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 600;
    return InkWell(
      onTap:
          () => GrowerDialogs.showItemDetailsDialog(
            context: Get.context!,
            item: house,
            title: 'Packing House Details',
            details: [
              _buildDetailRow('Name', house.packingHouseName ?? 'N/A'),
              _buildDetailRow('Type', house.type.toString().split('.').last),
              _buildDetailRow('Phone', house.packingHousePhone ?? 'N/A'),
              _buildDetailRow('Address', house.packingHouseAddress ?? 'N/A'),
            ],
            onEdit:
                () {}, // Empty callback since we don't want edit functionality
            onDelete: () => controller.removePackingHouse(house.id),
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
                house.packingHouseName ?? "Packhouse",
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
                  "Type: ${house.type.toString().split('.').last}",
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  house.packingHouseAddress ?? "",
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
    final isSmallScreen = MediaQuery.of(context).size.width <= 600;
    return InkWell(
      onTap: () => GrowerDialogs.showPackingHouseDialog(context),
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
