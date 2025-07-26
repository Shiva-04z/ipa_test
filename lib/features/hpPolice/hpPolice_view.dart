import 'package:apple_grower/features/hpPolice/hpPolice_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apple_grower/core/globalsWidgets.dart' as glbw;
import 'package:apple_grower/models/hp_police_model.dart';
import 'package:apple_grower/models/driving_profile_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../forms/police_officer_form_page.dart';
import '../forms/driver_form_page.dart';

class HpPoliceView extends GetView<HpPoliceController> {
  final RxString selectedSection = 'Traffic Control'.obs;
  final RxBool isTrackingMode = false.obs;
  final RxBool isSatelliteMode = false.obs;
  final Rx<DrivingProfile?> selectedVehicle = Rx<DrivingProfile?>(null);
  final mapController = MapController();

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
                case 'Traffic Management':
                  return _buildTrafficControlSection(context);
                case 'Vehicles':
                  return _buildVehiclesSection(context);
                case 'Staff':
                  return _buildPersonnelSection(context);
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
    final sections = [
      'Traffic Management',
      'Vehicles',
      'Staff',
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
      child: Obx(() => GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount:
                MediaQuery.of(Get.context!).size.width > 800 ? 4 : 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: [
              _buildSummaryCard(
                'Active Personnel',
                controller.policePersonnel
                    .where((p) => p.isActive)
                    .length
                    .toString(),
                Colors.blue,
                Icons.person,
              ),
              _buildSummaryCard(
                'Tracked Vehicles',
                controller.vehicles.length.toString(),
                Colors.green,
                Icons.directions_car,
              ),
              _buildSummaryCard(
                'Restricted Areas',
                controller.restrictedAreas
                    .where((a) => a.isActive)
                    .length
                    .toString(),
                Colors.red,
                Icons.warning,
              ),
              _buildSummaryCard(
                'Total Vehicles',
                controller.vehicles.length.toString(),
                Colors.orange,
                Icons.local_shipping,
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
              SizedBox(height: 8),
              Text(
                count,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 24 : 14,
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

  Widget _buildTrafficControlSection(BuildContext context) {
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
            height: MediaQuery.of(context).size.width > 800 ? 500 : 350,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: _buildMap(),
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
            "Traffic Management",
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

  Widget _buildMap() {
    return Obx(() {
      print('Building map with ${controller.vehicles.length} vehicles');
      return Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: controller.currentLocation.value,
              zoom: controller.currentZoom.value,
              minZoom: 5.0,
              maxZoom: 18.0,
              onPositionChanged: (position, hasGesture) {
                if (!hasGesture) {
                  controller.updateMapPosition(
                    position.center!,
                    position.zoom!,
                  );
                }
              },
              onTap: (_, point) {
                if (isTrackingMode.value) {
                  _showAddRestrictedAreaDialog(point);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: isSatelliteMode.value
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  // My Location Marker
                  Marker(
                    point: controller.currentLocation.value,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue.withOpacity(0.8),
                      child: Icon(
                        Icons.my_location,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  // Police Personnel Markers
                  ...controller.policePersonnel.map((personnel) {
                    return Marker(
                      point: personnel.location,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.blue.withOpacity(0.8),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    );
                  }).toList(),
                  // Vehicle Markers
                  ...controller.vehicles
                      .where((vehicle) => vehicle.currentLocation != null)
                      .map((vehicle) {
                    return Marker(
                      point: vehicle.currentLocation!,
                      child: GestureDetector(
                        onTap: () => _showVehicleDetailsDialog(vehicle),
                        child: Icon(
                          Icons.fire_truck_sharp,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    );
                  }).toList(),
                  // Restricted Area Markers
                  ...controller.restrictedAreas.map((area) {
                    return Marker(
                      point: area.coordinates.first,
                      child: GestureDetector(
                        onTap: () => _showRestrictedAreaDetailsDialog(area),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor:
                              _getAreaColor(area.type).withOpacity(0.8),
                          child: Icon(
                            _getAreaIcon(area.type),
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
              PolygonLayer(
                polygons: controller.restrictedAreas.map((area) {
                  return Polygon(
                    points: area.coordinates,
                    color: _getAreaColor(area.type).withOpacity(0.3),
                    borderColor: _getAreaColor(area.type),
                    borderStrokeWidth: 2,
                  );
                }).toList(),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'viewMode',
                  onPressed: () {
                    isSatelliteMode.value = !isSatelliteMode.value;
                    Get.snackbar(
                      'Map View Changed',
                      isSatelliteMode.value
                          ? 'Satellite View'
                          : 'Standard View',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: Icon(
                    isSatelliteMode.value ? Icons.map : Icons.satellite,
                  ),
                ),
                SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'markArea',
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: Text('Mark Restricted Area'),
                        content: Text(
                            'Do you want to mark a restricted area on the map?'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                              isTrackingMode.value = true;
                              Get.snackbar(
                                'Marking Mode Active',
                                'Tap on map to mark restricted area',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            child: Text('Start Marking'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Icon(Icons.add_location),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: Card(
              elevation: 4,
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      final currentZoom = controller.currentZoom.value;
                      final newZoom = (currentZoom + 1).clamp(5.0, 18.0);
                      if (newZoom != currentZoom) {
                        controller.currentZoom.value = newZoom;
                        mapController.move(
                          mapController.camera.center,
                          newZoom,
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      final currentZoom = controller.currentZoom.value;
                      final newZoom = (currentZoom - 1).clamp(5.0, 18.0);
                      if (newZoom != currentZoom) {
                        controller.currentZoom.value = newZoom;
                        mapController.move(
                          mapController.camera.center,
                          newZoom,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildVehiclesSection(BuildContext context) {
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
                  itemCount: controller.vehicles.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewDriverCard(context);
                    final vehicle = controller.vehicles[index - 1];
                    return _buildDriverCard(vehicle);
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
            "Vehicles",
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

  Widget _buildPersonnelSection(BuildContext context) {
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
                  itemCount: controller.policePersonnel.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewPersonnelCard(context);
                    return _buildPersonnelCard(
                        controller.policePersonnel[index - 1]);
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
            "Personnel",
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

  Widget _buildPersonnelCard(HpPolice personnel) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () => _showPersonnelDetailsDialog(personnel),
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
                personnel.name,
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
                  personnel.rank,
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  personnel.dutyLocation,
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
                SizedBox(height: 4),
                Text(
                  'Belt No: ${personnel.beltNo}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewPersonnelCard(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 800;
    return InkWell(
      onTap: () => Get.to(() => PoliceOfficerFormPage()),
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

  void _showPersonnelDetailsDialog(HpPolice personnel) {
    Get.dialog(
      AlertDialog(
        title: Text('Police Officer Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Name', personnel.name),
              _buildDetailRow('Rank', personnel.rank),
              _buildDetailRow('Belt Number', personnel.beltNo),
              _buildDetailRow('Aadhar ID', personnel.adharId),
              _buildDetailRow('Phone', personnel.cellNo),
              _buildDetailRow('Reporting Officer', personnel.reportingOfficer),
              _buildDetailRow('Duty Location', personnel.dutyLocation),
              _buildDetailRow(
                  'Status', personnel.isActive ? 'Active' : 'Inactive'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () => controller.callDriver(personnel.cellNo),
          ),
        ],
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

  void _showAddRestrictedAreaDialog(LatLng point) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String selectedType = 'restricted';

    Get.dialog(
      AlertDialog(
        title: Text('Add Restricted Area'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Area Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                    value: 'restricted', child: Text('Restricted Area')),
                DropdownMenuItem(value: 'diversion', child: Text('Diversion')),
                DropdownMenuItem(
                    value: 'landslide', child: Text('Landslide Zone')),
              ],
              onChanged: (value) {
                if (value != null) selectedType = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              isTrackingMode.value = false;
              Get.back();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please enter an area name',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              controller.addRestrictedArea(
                selectedType,
                [point],
                descriptionController.text,
              );
              isTrackingMode.value = false;
              Get.back();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showRestrictedAreaDetailsDialog(RestrictedArea area) {
    Get.dialog(
      AlertDialog(
        title: Text('Restricted Area Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Name', area.name),
            _buildDetailRow('Type', area.type.toUpperCase()),
            _buildDetailRow('Description', area.description),
            _buildDetailRow('Start Time', area.startTime.toString()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () {
              controller.restrictedAreas.remove(area);
              Get.back();
              Get.snackbar(
                'Success',
                'Restricted area removed',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showVehicleDetailsDialog(DrivingProfile vehicle) {
    Get.dialog(
      AlertDialog(
        title: Text('Vehicle Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Driver Name', vehicle.name ?? 'N/A'),
              _buildDetailRow('Contact', vehicle.contact ?? 'N/A'),
              _buildDetailRow('License No', vehicle.drivingLicenseNo ?? 'N/A'),
              _buildDetailRow(
                  'Vehicle Reg. No', vehicle.vehicleRegistrationNo ?? 'N/A'),
              _buildDetailRow('Chassis No', vehicle.chassiNoOfVehicle ?? 'N/A'),
              _buildDetailRow('Payload Capacity',
                  vehicle.payloadCapacityApprovedByRto ?? 'N/A'),
              _buildDetailRow(
                  'Gross Weight', vehicle.grossVehicleWeight ?? 'N/A'),
              _buildDetailRow(
                  'No. of Tyres', vehicle.noOfTyres?.toString() ?? 'N/A'),
              _buildDetailRow(
                  'Permit', vehicle.permitOfVehicleDriving ?? 'N/A'),
              _buildDetailRow(
                  'Location',
                  vehicle.currentLocation != null
                      ? '${vehicle.currentLocation!.latitude.toStringAsFixed(6)}, ${vehicle.currentLocation!.longitude.toStringAsFixed(6)}'
                      : 'Not Available'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () => controller.callDriver(vehicle.contact ?? ''),
          ),
        ],
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

  Widget _buildDriverCard(DrivingProfile vehicle) {
    final isSmallScreen = MediaQuery.of(Get.context!).size.width <= 800;
    return InkWell(
      onTap: () => _showDriverDetailsDialog(vehicle),
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
                vehicle.name ?? 'N/A',
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
                  vehicle.contact ?? 'N/A',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  vehicle.vehicleRegistrationNo ?? 'N/A',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDriverDetailsDialog(DrivingProfile vehicle) {
    Get.dialog(
      AlertDialog(
        title: Text('Driver Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Driver Name', vehicle.name ?? 'N/A'),
              _buildDetailRow('Contact', vehicle.contact ?? 'N/A'),
              _buildDetailRow('License No', vehicle.drivingLicenseNo ?? 'N/A'),
              _buildDetailRow(
                  'Vehicle Reg. No', vehicle.vehicleRegistrationNo ?? 'N/A'),
              _buildDetailRow('Chassis No', vehicle.chassiNoOfVehicle ?? 'N/A'),
              _buildDetailRow('Payload Capacity',
                  vehicle.payloadCapacityApprovedByRto ?? 'N/A'),
              _buildDetailRow(
                  'Gross Weight', vehicle.grossVehicleWeight ?? 'N/A'),
              _buildDetailRow(
                  'No. of Tyres', vehicle.noOfTyres?.toString() ?? 'N/A'),
              _buildDetailRow(
                  'Permit', vehicle.permitOfVehicleDriving ?? 'N/A'),
              _buildDetailRow(
                  'Location',
                  vehicle.currentLocation != null
                      ? '${vehicle.currentLocation!.latitude.toStringAsFixed(6)}, ${vehicle.currentLocation!.longitude.toStringAsFixed(6)}'
                      : 'Not Available'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () => controller.callDriver(vehicle.contact ?? ''),
          ),
        ],
      ),
    );
  }

  Color _getAreaColor(String type) {
    switch (type) {
      case 'restricted':
        return Colors.red;
      case 'diversion':
        return Colors.orange;
      case 'landslide':
        return Colors.brown;
      default:
        return Colors.red;
    }
  }

  IconData _getAreaIcon(String type) {
    switch (type) {
      case 'restricted':
        return Icons.warning;
      case 'diversion':
        return Icons.directions;
      case 'landslide':
        return Icons.terrain;
      default:
        return Icons.warning;
    }
  }
}
