import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../core/global_role_loader.dart' as gld;
import '../../models/orchard_model.dart';

class OrchardFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final treesController = TextEditingController();
  final areaController = TextEditingController();
  final delayReasonController = TextEditingController();
  final boxesController = TextEditingController();

  final expectedHarvestDate = Rxn<DateTime>();
  final harvestStatus = HarvestStatus.planned.obs;
  final isLoading = false.obs;
  final boundaryPoints = <GPSPoint>[].obs;
  final boundaryImagePath = RxnString();
  final mapController = Rxn<GoogleMapController>();
  final markers = <Marker>{}.obs;
  final polygons = <Polygon>{}.obs;
  final currentPosition = Rxn<Position>();
  final imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  @override
  void onClose() {
    nameController.dispose();
    locationController.dispose();
    treesController.dispose();
    areaController.dispose();
    delayReasonController.dispose();
    boxesController.dispose();
    mapController.value?.dispose();
    super.onClose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      if (kIsWeb) {
        await _handleWebLocation();
      } else if (Platform.isIOS) {
        await _handleIOSLocation();
      } else {
        await _handleAndroidLocation();
      }
    } catch (e) {
      print('Error getting location: $e');
      _setDefaultLocation();
    }
  }

  Future<void> _handleWebLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Services Disabled',
        'Please enable location services in your browser settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      _setDefaultLocation();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Location Permission Denied',
          'Please allow location access in your browser settings.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        _setDefaultLocation();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Location Permission Denied',
        'Location permissions are permanently denied. Please enable them in your browser settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      _setDefaultLocation();
      return;
    }

    await _getCurrentPosition();
  }

  Future<void> _handleIOSLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Services Disabled',
        'Please enable location services in your iOS settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      _setDefaultLocation();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Location Permission Denied',
          'Please allow location access in your iOS settings.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        _setDefaultLocation();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Location Permission Denied',
        'Location permissions are permanently denied. Please enable them in your iOS settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      _setDefaultLocation();
      return;
    }

    await _getCurrentPosition();
  }

  Future<void> _handleAndroidLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Services Disabled',
        'Please enable location services in your Android settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      _setDefaultLocation();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Location Permission Denied',
          'Please allow location access in your Android settings.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        _setDefaultLocation();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Location Permission Denied',
        'Location permissions are permanently denied. Please enable them in your Android settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      _setDefaultLocation();
      return;
    }

    await _getCurrentPosition();
  }

  Future<void> _getCurrentPosition() async {
    try {
      currentPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      if (currentPosition.value != null) {
        await _updateLocationFromCoordinates(
          currentPosition.value!.latitude,
          currentPosition.value!.longitude,
        );
      }
    } catch (e) {
      print('Error getting current position: $e');
      _setDefaultLocation();
    }
  }

  Future<void> _updateLocationFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        lat,
        lng,
        localeIdentifier: 'en_IN',
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = '';

        // Add name if available
        if (place.name?.isNotEmpty ?? false) {
          address += '${place.name}, ';
        }

        // Add village/locality
        if (place.locality?.isNotEmpty ?? false) {
          address += '${place.locality}, ';
        } else if (place.subLocality?.isNotEmpty ?? false) {
          address += '${place.subLocality}, ';
        }

        // Add administrative area (district)
        if (place.administrativeArea?.isNotEmpty ?? false) {
          address += '${place.administrativeArea}, ';
        }

        // Add postal code
        if (place.postalCode?.isNotEmpty ?? false) {
          address += place.postalCode!;
        }

        // If no address components were found, use coordinates
        if (address.isEmpty) {
          address =
              'Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}';
        }

        // Remove trailing comma and space if present
        address = address.trim();
        if (address.endsWith(',')) {
          address = address.substring(0, address.length - 1);
        }

        locationController.text = address;

        // Show a snackbar with the full address details
        Get.snackbar(
          'Location Details',
          'Name: ${place.name ?? 'N/A'}\n'
              'Village/Locality: ${place.locality ?? place.subLocality ?? 'N/A'}\n'
              'District: ${place.administrativeArea ?? 'N/A'}\n'
              'Pincode: ${place.postalCode ?? 'N/A'}',
          backgroundColor: const Color(0xff548235).withOpacity(0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        _setFallbackLocation(lat, lng);
      }
    } catch (e) {
      print('Error in geocoding: $e');
      _setFallbackLocation(lat, lng);
    }
  }

  void _setFallbackLocation(double lat, double lng) {
    locationController.text =
        'Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}';
    Get.snackbar(
      'Location Error',
      'Could not get detailed address. Using coordinates instead.',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _setDefaultLocation() {
    currentPosition.value = Position(
      latitude: 31.1048,
      longitude: 77.1734,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );

    // Try to get address for default location with retry
    _updateLocationFromCoordinates(31.1048, 77.1734);
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      if (image != null) {
        if (kIsWeb) {
          boundaryImagePath.value = image.path;
        } else {
          final File imageFile = File(image.path);
          if (await imageFile.exists()) {
            boundaryImagePath.value = image.path;
          } else {
            Get.snackbar(
              'Error',
              'Failed to access the selected image.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void addBoundaryPoint(LatLng point) {
    boundaryPoints.add(GPSPoint(
      latitude: point.latitude,
      longitude: point.longitude,
    ));

    markers.add(Marker(
      markerId: MarkerId('point_${boundaryPoints.length}'),
      position: point,
    ));

    if (boundaryPoints.length >= 3) {
      polygons.clear();
      polygons.add(Polygon(
        polygonId: const PolygonId('orchard_boundary'),
        points:
            boundaryPoints.map((p) => LatLng(p.latitude, p.longitude)).toList(),
        strokeWidth: 2,
        strokeColor: const Color(0xff548235),
        fillColor: const Color(0xff548235).withOpacity(0.2),
      ));
    }
  }

  void clearBoundary() {
    boundaryPoints.clear();
    markers.clear();
    polygons.clear();
  }

  void submitForm() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final newOrchard = Orchard(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        boundaryPoints: boundaryPoints,
        boundaryImagePath: boundaryImagePath.value ?? '',
        location: locationController.text,
        numberOfFruitingTrees: int.parse(treesController.text),
        expectedHarvestDate: expectedHarvestDate.value!,
        area: double.parse(areaController.text),
        harvestStatus: harvestStatus.value,
        harvestDelayReason: harvestStatus.value == HarvestStatus.delayed
            ? delayReasonController.text
            : null,
        estimatedBoxes: boxesController.text.isNotEmpty
            ? int.parse(boxesController.text)
            : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updatedOrchards = [
        ...gld.globalGrower.value.orchards,
        newOrchard
      ];
      gld.globalGrower.value = gld.globalGrower.value.copyWith(
        orchards: updatedOrchards,
        updatedAt: DateTime.now(),
      );

      Get.back();
      Get.snackbar(
        'Success',
        'Orchard added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff548235),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error adding orchard: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showLocationPicker() {
    Get.dialog(
      Dialog(
        child: Container(
          width: Get.width * 0.9,
          height: Get.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Location',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff548235),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Obx(() {
                    if (currentPosition.value == null) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xff548235)),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Loading map...',
                              style: TextStyle(color: Color(0xff548235)),
                            ),
                          ],
                        ),
                      );
                    }

                    return Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              currentPosition.value!.latitude,
                              currentPosition.value!.longitude,
                            ),
                            zoom: 14,
                          ),
                          onMapCreated: (GoogleMapController c) {
                            mapController.value = c;
                          },
                          markers: markers,
                          onTap: (LatLng position) {
                            markers.clear();
                            markers.add(
                              Marker(
                                markerId: const MarkerId('selected_location'),
                                position: position,
                                infoWindow: const InfoWindow(
                                    title: 'Selected Location'),
                              ),
                            );
                            _updateLocationFromCoordinates(
                              position.latitude,
                              position.longitude,
                            );
                          },
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          zoomControlsEnabled: true,
                          mapToolbarEnabled: true,
                          compassEnabled: true,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: FloatingActionButton(
                            heroTag: 'center_location',
                            onPressed: () {
                              if (mapController.value != null &&
                                  currentPosition.value != null) {
                                mapController.value!.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                    LatLng(
                                      currentPosition.value!.latitude,
                                      currentPosition.value!.longitude,
                                    ),
                                    14,
                                  ),
                                );
                              }
                            },
                            backgroundColor: const Color(0xff548235),
                            child: const Icon(Icons.my_location,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (markers.isNotEmpty) {
                        Get.back();
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please select a location on the map',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff548235),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Confirm Location'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrchardFormPage extends StatelessWidget {
  OrchardFormPage({super.key});

  final controller = Get.put(OrchardFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Orchard'),
        backgroundColor: const Color(0xff548235),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Obx(() => controller.isLoading.value
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                )
              : const SizedBox()),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xff548235).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicDetails(),
                  const SizedBox(height: 24),
                  _buildBoundarySection(),
                  const SizedBox(height: 24),
                  _buildHarvestDetails(),
                  const SizedBox(height: 24),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.nameController,
              decoration: _getInputDecoration(
                'Orchard Name',
                prefixIcon: Icons.landscape,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter orchard name' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.locationController,
                    decoration: _getInputDecoration(
                      'Location',
                      prefixIcon: Icons.location_on,
                    ),
                    readOnly: true,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please select location'
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => controller._showLocationPicker(),
                  icon: const Icon(Icons.map),
                  label: const Text('Select on Map'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff548235),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.treesController,
              decoration: _getInputDecoration(
                'Number of Fruiting Trees',
                prefixIcon: Icons.park,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true)
                  return 'Please enter number of trees';
                if (int.tryParse(value!) == null)
                  return 'Please enter a valid number';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.areaController,
              decoration: _getInputDecoration(
                'Area (in hectares)',
                prefixIcon: Icons.area_chart,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter area';
                if (double.tryParse(value!) == null)
                  return 'Please enter a valid number';
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Expected Harvest Date'),
              subtitle: Obx(() => Text(
                    controller.expectedHarvestDate.value != null
                        ? DateFormat('MMM dd, yyyy')
                            .format(controller.expectedHarvestDate.value!)
                        : 'Select date',
                  )),
              leading:
                  const Icon(Icons.calendar_today, color: Color(0xff548235)),
              onTap: () async {
                final date = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xff548235),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  controller.expectedHarvestDate.value = date;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoundarySection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Orchard Boundary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff548235),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '(Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Obx(() {
                  if (controller.currentPosition.value == null) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xff548235)),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading map...',
                            style: TextStyle(color: Color(0xff548235)),
                          ),
                        ],
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            controller.currentPosition.value!.latitude,
                            controller.currentPosition.value!.longitude,
                          ),
                          zoom: 14,
                        ),
                        onMapCreated: (GoogleMapController c) {
                          controller.mapController.value = c;
                          // Add a marker at current location
                          controller.markers.add(
                            Marker(
                              markerId: const MarkerId('current_location'),
                              position: LatLng(
                                controller.currentPosition.value!.latitude,
                                controller.currentPosition.value!.longitude,
                              ),
                              infoWindow:
                                  const InfoWindow(title: 'Current Location'),
                            ),
                          );
                        },
                        markers: controller.markers,
                        polygons: controller.polygons,
                        onTap: controller.addBoundaryPoint,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        mapToolbarEnabled: true,
                        compassEnabled: true,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: FloatingActionButton(
                          heroTag: 'center_location',
                          onPressed: () {
                            if (controller.mapController.value != null &&
                                controller.currentPosition.value != null) {
                              controller.mapController.value!.animateCamera(
                                CameraUpdate.newLatLngZoom(
                                  LatLng(
                                    controller.currentPosition.value!.latitude,
                                    controller.currentPosition.value!.longitude,
                                  ),
                                  14,
                                ),
                              );
                            }
                          },
                          backgroundColor: const Color(0xff548235),
                          child: const Icon(Icons.my_location,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() =>
                    Text('${controller.boundaryPoints.length} points marked')),
                TextButton.icon(
                  onPressed: controller.clearBoundary,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xff548235),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: controller.pickImage,
              icon: const Icon(Icons.image),
              label: Obx(() => Text(
                    controller.boundaryImagePath.value == null
                        ? 'Add Boundary Image'
                        : 'Change Boundary Image',
                  )),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff548235),
                foregroundColor: Colors.white,
              ),
            ),
            if (controller.boundaryImagePath.value != null) ...[
              const SizedBox(height: 8),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: kIsWeb
                      ? Image.network(
                          controller.boundaryImagePath.value!,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(controller.boundaryImagePath.value!),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHarvestDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Harvest Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => RadioListTile<HarvestStatus>(
                  title: const Text('Planned'),
                  value: HarvestStatus.planned,
                  groupValue: controller.harvestStatus.value,
                  onChanged: (value) {
                    controller.harvestStatus.value = value!;
                    controller.delayReasonController.clear();
                  },
                  activeColor: const Color(0xff548235),
                )),
            Obx(() => RadioListTile<HarvestStatus>(
                  title: const Text('Completed'),
                  value: HarvestStatus.completed,
                  groupValue: controller.harvestStatus.value,
                  onChanged: (value) {
                    controller.harvestStatus.value = value!;
                    controller.delayReasonController.clear();
                  },
                  activeColor: const Color(0xff548235),
                )),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.boxesController,
              decoration: _getInputDecoration(
                'Estimated Number of Boxes (Optional)',
                prefixIcon: Icons.inventory,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isNotEmpty ?? false) {
                  if (int.tryParse(value!) == null) {
                    return 'Please enter a valid number';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff548235),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Add Orchard',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration(String label, {IconData? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xff548235)),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
