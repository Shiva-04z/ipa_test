import 'package:apple_grower/features/aadhati/aadhati_controller.dart';
import 'package:apple_grower/features/forms/driver_form_page.dart';
import 'package:apple_grower/models/freightForwarder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/globalsWidgets.dart' as glbw;
import '../../models/grower_model.dart';
import '../../models/ladani_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/consignment_model.dart';
import '../../models/transport_model.dart';
import '../../models/employee_model.dart';
import 'aadhati_edit_info_form_page.dart';
import '../forms/buyer_form_page.dart';
import '../forms/corporate_company_form_page.dart';
import '../forms/grower_form_page.dart';
import '../grower/grower_dialogs.dart';
import '../packHouse/consignment_form2_page.dart';
import '../forms/transport_union_form_page.dart';
import '../forms/employee_form_page.dart';

class AadhatiView extends GetView<AadhatiController> {
  final RxString selectedSection = 'My Commission Agent Info'.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: glbw.buildAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            glbw.buildInfo(),
            const SizedBox(height: 20),
            _buildSummarySection(),
            const SizedBox(height: 20),
            _buildSectionChips(),
            Obx(() {
              switch (selectedSection.value) {
                case 'My Commission Agent Info':
                  return _buildAadhatiInfoContainer(context);
                case 'Associated Growers':
                  return _buildAssociatedGrowersContainer(context);
                case 'Associated Freight Forwarder':
                  return _buildAssociatedBuyersContainer(context);
                case 'Associated Buyers/Ladanis':
                  return _buildAssociatedLadanisContainer(context);
                case 'Associated Transport Unions':
                  return _buildAssociatedTransportUnionsContainer(context);
                case 'My Staff':
                  return _buildStaffContainer(context);
                case 'Associated Drivers':
                  return _buildAssociatedDriversContainer(context);
                case 'Consignments':
                  return _buildConsignmentsContainer(context);
                case 'Gallery':
                  return _buildGalleryContainer(context);
                default:
                  return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSectionChip('My Commission Agent Info'),
            const SizedBox(width: 8),
            _buildSectionChip('Associated Growers'),
            const SizedBox(width: 8),
            _buildSectionChip('Associated Freight Forwarder'),
            const SizedBox(width: 8),
            _buildSectionChip('Associated Buyers/Ladanis'),
            const SizedBox(width: 8),
            _buildSectionChip('Associated Transport Unions'),
            const SizedBox(width: 8),
            _buildSectionChip('My Staff'),
            const SizedBox(width: 8),
            _buildSectionChip('Associated Drivers'),
            const SizedBox(width: 8),
            _buildSectionChip('Consignments'),
            const SizedBox(width: 8),
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
          selectedColor: const Color(0xff548235),
          checkmarkColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ));
  }

  Widget _buildAadhatiInfoContainer(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 1,
          color: Colors.white,
          shape: const RoundedRectangleBorder(
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 800 ? 5 : 4,
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
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xff548235),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: const BoxConstraints(maxWidth: 225),
          child: const Text(
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
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage("assets/images/agent.png"),
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
               ...[
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewAadhatiCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 800;
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
            const SizedBox(height: 8),
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
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 1,
          color: Colors.white,
          shape: const RoundedRectangleBorder(
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xff548235),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: const BoxConstraints(maxWidth: 225),
          child: const Text(
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
                image: const AssetImage("assets/images/grower.png"),
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
                const SizedBox(height: 4),
                Text(
                  '${grower.orchards.length} Orchards',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  grower.address!,
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
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
            const SizedBox(height: 8),
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
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 1,
          color: Colors.white,
          shape: const RoundedRectangleBorder(
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xff548235),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: const BoxConstraints(maxWidth: 225),
          child: const Text(
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
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
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
        onDelete: () => controller.removeAssociatedBuyer(buyer.id!),
      ),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage("assets/images/buyer.png"),
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
                const SizedBox(height: 4),
                Text(
                  buyer.contact,
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
                const SizedBox(height: 4),
                Text(
                  buyer.address,
                  style: const TextStyle(fontSize: 12),
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
            const SizedBox(height: 8),
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
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 1,
          color: Colors.white,
          shape: const RoundedRectangleBorder(
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 800 ? 5 : 4,
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
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xff548235),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: const BoxConstraints(maxWidth: 225),
          child: const Text(
            "Associated Buyers/Ladanis",
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
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: ladani,
        title: 'Buyer/Ladanis Details',
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
                image: const AssetImage("assets/images/company.png"),
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
                const SizedBox(height: 4),
                Text('${ladani.firmType}', style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  '${ladani.contact}',
                  style: const TextStyle(fontSize: 12, color: Colors.purple),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewLadaniCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 800;
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
            const SizedBox(height: 8),
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
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 1,
          color: Colors.white,
          shape: const RoundedRectangleBorder(
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xff548235),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: const BoxConstraints(maxWidth: 225),
          child: const Text(
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
                image: const AssetImage("assets/images/driver.png"),
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
                const SizedBox(height: 4),
                Text(
                  '${driver.noOfTyres}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '${driver.contact}',
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
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
            const SizedBox(height: 8),
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
              style: const TextStyle(
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
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 1,
          color: Colors.white,
          shape: const RoundedRectangleBorder(
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xff548235),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: const BoxConstraints(maxWidth: 225),
          child: const Text(
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
              const SizedBox(height: 8),
              Text(
                '${consignment.searchId!}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isSmallScreen) ...[
                const SizedBox(height: 4),

                const SizedBox(height: 4),
                Text(
                  'Status: ${consignment.currentStage}',
                  style: const TextStyle(fontSize: 12),
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
            const SizedBox(height: 8),
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

  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() => GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount:
                MediaQuery.of(Get.context!).size.width > 800 ? 5 : 3,
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
                'Freight Forwarders',
                controller.associatedBuyers.length.toString(),
                Colors.orange,
                Icons.local_shipping,
              ),
              _buildSummaryCard(
                'Associated Ladanis',
                controller.associatedLadanis.length.toString(),
                Colors.purple,
                Icons.business,
              ),
              _buildSummaryCard(
                'Associated Drivers',
                controller.associatedDrivers.length.toString(),
                Colors.blue,
                Icons.drive_eta,
              ),
              _buildSummaryCard(
                'Consignments',
                controller.consignments.length.toString(),
                Colors.red,
                Icons.assignment,
              ),
            ],
          )),
    );
  }

  Widget _buildSummaryCard(
      String title, String count, Color color, IconData icon) {
    bool isSmallScreen = MediaQuery.of(Get.context!).size.width > 840;
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
              const SizedBox(height: 8),
              Text(
                count,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 24 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
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

  Widget _buildGalleryContainer(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;

    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 1,
          color: Colors.white,
          shape: const RoundedRectangleBorder(
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
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xff548235),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: const BoxConstraints(maxWidth: 225),
          child: const Text(
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
            image:NetworkImage(imageUrl) as ImageProvider,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Center(
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
              const SizedBox(height: 12),
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

  Widget _buildAssociatedTransportUnionsContainer(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 1,
          color: Colors.white,
          shape: const RoundedRectangleBorder(
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xff548235),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: const BoxConstraints(maxWidth: 225),
          child: const Text(
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
                const SizedBox(height: 4),
                Text(
                  union.contact,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  union.transportUnionRegistrationNo ?? 'N/A',
                  style: const TextStyle(fontSize: 12, color: Colors.indigo),
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
            const SizedBox(height: 8),
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

  Widget _buildStaffContainer(BuildContext context) {
    final List<String> requiredRoles = [
      'Assistant Aadhati',
      'MUNSHI',
      'Auction Recorder',
      'Loader'
    ];

    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 1,
          color: Colors.white,
          shape: const RoundedRectangleBorder(
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 800 ? 5 : 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: requiredRoles.length,
                  itemBuilder: (context, index) {
                    final role = requiredRoles[index];
                    return Obx(() {
                      final employee = controller.staff[role];
                      return employee != null
                          ? _buildStaffCard(role, employee)
                          : _buildEmptyStaffCard(context, role);
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xff548235),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: const BoxConstraints(maxWidth: 225),
          child: const Text(
            "My Staff",
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

  Widget _buildEmptyStaffCard(BuildContext context, String role) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 800;
    return InkWell(
      onTap: () {
        controller.key.value = role;
        Get.to(() => EmployeeFormPage());
      },
      child: Card(
        elevation: 0,
        color: Colors.grey[100],
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add,
                size: isSmallScreen ? 32 : 40,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                role,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 12 : 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isSmallScreen) ...[
                const SizedBox(height: 4),
                Text(
                  'Click to add',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaffCard(String role, Employee employee) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () => GrowerDialogs.showItemDetailsDialog(
        context: Get.context!,
        item: employee,
        title: 'Staff Details',
        details: [
          _buildDetailRow('Name', employee.name),
          _buildDetailRow('Role', role),
          _buildDetailRow('Phone', employee.phoneNumber ?? 'N/A'),
          _buildDetailRow('Address', employee.address ?? 'N/A'),
          _buildDetailRow('Joining Date', employee.joiningDate ?? 'N/A'),
          _buildDetailRow('Salary', employee.salary ?? 'N/A'),
        ],
        onEdit: () {},
        onDelete: () => controller.removeStaff(role),
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
                color: Colors.teal,
              ),
              Text(
                employee.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isSmallScreen) ...[
                const SizedBox(height: 4),
                Text(
                  role,
                  style: const TextStyle(fontSize: 12, color: Colors.teal),
                ),
                const SizedBox(height: 4),
                Text(
                  employee.phoneNumber ?? 'N/A',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
