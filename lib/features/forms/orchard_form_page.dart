import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/gestures.dart';

import '../../core/global_role_loader.dart' as gld;
import '../../models/orchard_model.dart';
import '../grower/grower_controller.dart';

class OrchardFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final treesController = TextEditingController();
  final areaController = TextEditingController();
  final delayReasonController = TextEditingController();
  final boxesController = TextEditingController();
  final boundarySearchController = TextEditingController();

  final expectedHarvestDate = Rxn<DateTime>();
  final cropStage = CropStage.walnutSize.obs;
  final isLoading = false.obs;
  final boundaryPoints = <GPSPoint>[].obs;
  final boundaryImagePath = Rxn<String>();
  final mapController = MapController();
  final markers = <Marker>[].obs;
  final polygons = <Polygon>[].obs;
  final currentPosition = Rxn<Position>();
  final imagePicker = ImagePicker();
  final GlobalKey mapKey = GlobalKey();
  final isSatelliteMode = false.obs;
  final isBoundarySearching = false.obs;
  final isDrawingBoundary = false.obs;
  final isFreehandDrawing = false.obs;
  final selectedMarkerIndex = RxnInt();
  final drawnPath = <Offset>[].obs;
  final boundarySearchSuggestions = <Map<String, dynamic>>[].obs;
  final boundarySearchText = ''.obs;
  LatLng? firstDrawnPoint;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
    ever(boundaryPoints, (_) => _updateBoundaryMarkersAndPolygon());

    // Debounce the search controller
    debounce(boundarySearchText,
        (_) => searchAndGoToBoundaryLocation(isSuggestion: true),
        time: Duration(milliseconds: 400));
  }

  @override
  void onClose() {
    nameController.dispose();
    locationController.dispose();
    treesController.dispose();
    areaController.dispose();
    delayReasonController.dispose();
    boxesController.dispose();
    boundarySearchController.dispose();
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
      debugPrint('Error getting location: $e');
      _setDefaultLocation();
    }
  }

  Widget savedImage() {
    return Center(
      child: Container(
          height: MediaQuery.of(Get.context!).size.height / 2,
          width: MediaQuery.of(Get.context!).size.width - 100,
          child: Image.network("${boundaryImagePath.value}")),
    );
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
      debugPrint('Error getting current position: $e');
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
      } else {
        _setFallbackLocation(lat, lng);
      }
    } catch (e) {
      debugPrint('Error in geocoding: $e');
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

    // Set default location text
    locationController.text = 'Lat: 31.1048, Lng: 77.1734';

    // Try to get address for default location
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
      debugPrint('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> captureMapScreenshot() async {
    try {
      final RenderRepaintBoundary boundary =
          mapKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();
        final String tempPath = '${DateTime.now().millisecondsSinceEpoch}.png';

        if (kIsWeb) {
          boundaryImagePath.value = tempPath;
        } else {
          final File file = File(tempPath);
          await file.writeAsBytes(pngBytes);
          boundaryImagePath.value = file.path;
        }
      }
    } catch (e) {
      debugPrint('Error capturing map screenshot: $e');
      Get.snackbar(
        'Error',
        'Failed to capture map screenshot',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void toggleDrawingBoundary() {
    isDrawingBoundary.value = !isDrawingBoundary.value;
    selectedMarkerIndex.value = null;
  }

  void addOrMoveBoundaryPoint(LatLng point) {
    if (selectedMarkerIndex.value != null) {
      // Move existing marker
      boundaryPoints[selectedMarkerIndex.value!] =
          GPSPoint(latitude: point.latitude, longitude: point.longitude);
      selectedMarkerIndex.value = null;
    } else {
      // Add new marker
      boundaryPoints
          .add(GPSPoint(latitude: point.latitude, longitude: point.longitude));
    }
    _updateBoundaryMarkersAndPolygon();
  }

  void selectMarker(int index) {
    selectedMarkerIndex.value = index;
  }

  void removeLastBoundaryPoint() {
    if (boundaryPoints.isNotEmpty) {
      boundaryPoints.removeLast();
      _updateBoundaryMarkersAndPolygon();
    }
  }

  void _updateBoundaryMarkersAndPolygon() {
    markers.clear();
    for (int i = 0; i < boundaryPoints.length; i++) {
      final p = boundaryPoints[i];
      markers.add(Marker(
        point: LatLng(p.latitude, p.longitude),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => selectMarker(i),
          child: Icon(
            Icons.location_on,
            color: selectedMarkerIndex.value == i ? Colors.blue : Colors.red,
            size: 40,
          ),
        ),
      ));
    }
    polygons.clear();
    if (boundaryPoints.length >= 3) {
      polygons.add(Polygon(
        points:
            boundaryPoints.map((p) => LatLng(p.latitude, p.longitude)).toList(),
        color: Colors.red.withOpacity(0.2),
        borderColor: Colors.red,
        borderStrokeWidth: 2,
      ));
    }
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
        cropStage: cropStage.value,
        harvestDelayReason: null,
        estimatedBoxes: boxesController.text.isNotEmpty
            ? int.parse(boxesController.text)
            : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      Get.back();
      Get.find<GrowerController>().addOrchard(newOrchard);
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

  void showLocationPicker() {
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
                        FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            initialCenter: LatLng(
                              currentPosition.value!.latitude,
                              currentPosition.value!.longitude,
                            ),
                            initialZoom: 14,
                            minZoom: 5.0,
                            maxZoom: 18.0,
                            onTap: (tapPosition, point) {
                              markers.clear();
                              markers.add(Marker(
                                point: point,
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.location_on,
                                  color: Color(0xff548235),
                                  size: 40,
                                ),
                              ));
                              _updateLocationFromCoordinates(
                                point.latitude,
                                point.longitude,
                              );
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: isSatelliteMode.value
                                  ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                                  : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.apple_grower',
                            ),
                            MarkerLayer(
                              markers: [
                                if (currentPosition.value != null)
                                  Marker(
                                    point: LatLng(
                                      currentPosition.value!.latitude,
                                      currentPosition.value!.longitude,
                                    ),
                                    width: 40,
                                    height: 40,
                                    child: const Icon(
                                      Icons.my_location,
                                      color: Colors.blue,
                                      size: 40,
                                    ),
                                  ),
                                ...markers.map((marker) {
                                  return Marker(
                                    point: marker.point,
                                    width: marker.width,
                                    height: marker.height,
                                    child: GestureDetector(
                                      onTap: marker.child is GestureDetector
                                          ? (marker.child as GestureDetector)
                                              .onTap
                                          : null,
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                            PolygonLayer(polygons: polygons),
                          ],
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Column(
                            children: [
                              FloatingActionButton(
                                heroTag: 'viewMode',
                                onPressed: () {
                                  isSatelliteMode.value =
                                      !isSatelliteMode.value;
                                  Get.snackbar(
                                    'Map View Changed',
                                    isSatelliteMode.value
                                        ? 'Satellite View'
                                        : 'Standard View',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                                backgroundColor: const Color(0xff548235),
                                child: Icon(
                                  isSatelliteMode.value
                                      ? Icons.map
                                      : Icons.satellite,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              FloatingActionButton(
                                heroTag: 'center_location',
                                onPressed: () {
                                  if (currentPosition.value != null) {
                                    mapController.move(
                                      LatLng(
                                        currentPosition.value!.latitude,
                                        currentPosition.value!.longitude,
                                      ),
                                      14,
                                    );
                                  }
                                },
                                backgroundColor: const Color(0xff548235),
                                child: const Icon(Icons.my_location,
                                    color: Colors.white),
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
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    final currentZoom =
                                        mapController.camera.zoom;
                                    final newZoom =
                                        (currentZoom + 1).clamp(5.0, 18.0);
                                    if (newZoom != currentZoom) {
                                      mapController.move(
                                        mapController.camera.center,
                                        newZoom,
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    final currentZoom =
                                        mapController.camera.zoom;
                                    final newZoom =
                                        (currentZoom - 1).clamp(5.0, 18.0);
                                    if (newZoom != currentZoom) {
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

  Future<void> searchAndGoToBoundaryLocation({bool isSuggestion = false}) async {
    final query = boundarySearchController.text.trim();
    print('Searching for: $query');
    if (query.isEmpty) {
      if (isSuggestion) boundarySearchSuggestions.clear();
      return;
    }
    isBoundarySearching.value = true;
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=5');
      final response = await http.get(url, headers: {
        'User-Agent': 'YourAppName/1.0 (your@email.com)',
      });
      if (response.statusCode == 200) {
        final List results = json.decode(response.body);
        print('OSM Results: $results');
        if (isSuggestion) {
          // Filter: only suggestions containing all query words
          final queryWords = query.toLowerCase().split(' ');
          final filtered = results.where((r) {
            final name = (r['display_name'] ?? '').toLowerCase();
            return queryWords.every((word) => name.contains(word));
          }).toList();
          print('Filtered Suggestions: $filtered');
          boundarySearchSuggestions.assignAll(filtered.cast<Map<String, dynamic>>());
        } else {
          boundarySearchSuggestions.clear();
          if (results.isNotEmpty) {
            final lat = double.tryParse(results[0]['lat'] ?? '');
            final lon = double.tryParse(results[0]['lon'] ?? '');
            if (lat != null && lon != null) {
              mapController.move(LatLng(lat, lon), 16);
              Get.snackbar('Location Found', 'Moved to $query',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white);
            } else {
              Get.snackbar('Error', 'Invalid coordinates from OSM',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white);
            }
          } else {
            Get.snackbar('Not Found', 'No location found for "$query"',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange,
                colorText: Colors.white);
          }
        }
      } else {
        if (isSuggestion) {
          boundarySearchSuggestions.clear();
        } else {
          Get.snackbar('Error', 'Failed to fetch location from OSM',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      }
    } catch (e) {
      if (isSuggestion) {
        boundarySearchSuggestions.clear();
      } else {
        Get.snackbar('Error', 'Failed to find location: $e',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } finally {
      isBoundarySearching.value = false;
    }
  }

  void selectBoundarySuggestion(Map<String, dynamic> suggestion) {
    final lat = double.tryParse(suggestion['lat'] ?? '');
    final lon = double.tryParse(suggestion['lon'] ?? '');
    if (lat != null && lon != null) {
      mapController.move(LatLng(lat, lon), 16);
    }
    boundarySearchController.text = suggestion['display_name'] ?? '';
    boundarySearchSuggestions.clear();
  }

  void clearBoundary() {
    boundaryPoints.clear();
    _updateBoundaryMarkersAndPolygon();
  }

  void startFreehandDrawing() {
    isFreehandDrawing.value = true;
  }

  void stopFreehandDrawing() {
    isFreehandDrawing.value = false;
  }

  void clearDrawnPath() {
    drawnPath.clear();
    firstDrawnPoint = null;
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
                  _buildBoundarySection(context),
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
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please select location'
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => controller.showLocationPicker(),
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
                if (value?.isEmpty ?? true) {
                  return 'Please enter number of trees';
                }
                if (int.tryParse(value!) == null) {
                  return 'Please enter a valid number';
                }
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
                if (double.tryParse(value!) == null) {
                  return 'Please enter a valid number';
                }
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

  Widget _buildBoundarySection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth > 500;

                      // Wide screen: everything in a row
                     return isWide ? Row(
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
                          const Spacer(),
                          Obx(() => ElevatedButton.icon(
                                onPressed: controller.toggleDrawingBoundary,
                                icon: Icon(controller.isDrawingBoundary.value
                                    ? Icons.edit_off
                                    : Icons.edit),
                                label: Text(controller.isDrawingBoundary.value
                                    ? 'Stop Drawing'
                                    : 'Draw Boundary'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: controller.isDrawingBoundary.value
                                      ? Colors.red
                                      : const Color(0xff548235),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                              )),
                          const SizedBox(width: 8),
                          Obx(() => IconButton(
                                icon: const Icon(Icons.undo),
                                tooltip: 'Remove Last Point',
                                onPressed: controller.boundaryPoints.isNotEmpty
                                    ? controller.removeLastBoundaryPoint
                                    : null,
                              )),
                          Obx(() => IconButton(
                                icon: const Icon(Icons.clear),
                                tooltip: 'Clear All',
                                onPressed: controller.boundaryPoints.isNotEmpty
                                    ? controller.clearBoundary
                                    : null,
                              )),
                        ],
                      ) :  Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Orchard Boundary',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff548235),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '(Optional)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Obx(() => ElevatedButton.icon(
                                onPressed: controller.toggleDrawingBoundary,
                                icon: Icon(controller.isDrawingBoundary.value
                                    ? Icons.edit_off
                                    : Icons.edit),
                                label: Text(controller.isDrawingBoundary.value
                                    ? 'Stop Drawing'
                                    : 'Draw Boundary'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: controller.isDrawingBoundary.value
                                      ? Colors.red
                                      : const Color(0xff548235),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                              )),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Obx(() => IconButton(
                                    icon: const Icon(Icons.undo),
                                    tooltip: 'Remove Last Point',
                                    onPressed: controller.boundaryPoints.isNotEmpty
                                        ? controller.removeLastBoundaryPoint
                                        : null,
                                  )),
                                  Obx(() => IconButton(
                                    icon: const Icon(Icons.clear),
                                    tooltip: 'Clear All',
                                    onPressed: controller.boundaryPoints.isNotEmpty
                                        ? controller.clearBoundary
                                        : null,
                                  )),
                                ],
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.end,
                          )
                        ],
                      );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                          children: [
                            Expanded(
                                child: TextField(
                                  controller: controller.boundarySearchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search location... (e.g. Shimla, HP)',
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  onChanged: (val) => controller.boundarySearchText.value = val,
                                  onSubmitted: (_) => controller.searchAndGoToBoundaryLocation(),
                                )),
                            const SizedBox(width: 8),
                            Obx(() => controller.isBoundarySearching.value
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : IconButton(
                              icon: const Icon(Icons.arrow_forward,
                                  color: Color(0xff548235)),
                              onPressed: controller.searchAndGoToBoundaryLocation,
                            )),
                          ],
                        ),
                const SizedBox(height: 16),
                Container(
                  height: 500,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Obx(() {
                      if (controller.boundaryImagePath.value != null) {
                        return kIsWeb
                            ? Image.network(
                                controller.boundaryImagePath.value!,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(controller.boundaryImagePath.value!),
                                fit: BoxFit.cover,
                              );
                      }

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

                      return Obx(() {
                        if (controller.isDrawingBoundary.value) {
                          return Listener(
                            onPointerDown: (event) {
                              if (controller.isDrawingBoundary.value) {
                                controller.startFreehandDrawing();
                                controller.drawnPath.clear();
                                controller.drawnPath.add(event.localPosition);
                                // Store first point's map location
                                final mapLatLng = _localToLatLng(
                                    context, event.localPosition, controller);
                                if (mapLatLng != null)
                                  controller.firstDrawnPoint = mapLatLng;
                              }
                            },
                            onPointerMove: (event) {
                              if (controller.isDrawingBoundary.value &&
                                  controller.isFreehandDrawing.value) {
                                controller.drawnPath.add(event.localPosition);
                              }
                            },
                            onPointerUp: (event) {
                              if (controller.isDrawingBoundary.value) {
                                controller.stopFreehandDrawing();
                              }
                            },
                            child: Stack(
                              children: [
                                FlutterMap(
                                  key: controller.mapKey,
                                  mapController: controller.mapController,
                                  options: MapOptions(
                                    initialCenter: LatLng(
                                      controller.currentPosition.value!.latitude,
                                      controller.currentPosition.value!.longitude,
                                    ),
                                    initialZoom: 14,
                                    minZoom: 5.0,
                                    maxZoom: 18.0,
                                    interactionOptions: InteractionOptions(
                                      flags: controller.isDrawingBoundary.value
                                          ? InteractiveFlag.none
                                          : (InteractiveFlag.all &
                                              ~InteractiveFlag.rotate),
                                    ),
                                    onMapReady: () {
                                      if (controller.currentPosition.value !=
                                          null) {
                                        controller.mapController.move(
                                          LatLng(
                                            controller
                                                .currentPosition.value!.latitude,
                                            controller
                                                .currentPosition.value!.longitude,
                                          ),
                                          14,
                                        );
                                      }
                                    },
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate: controller.isSatelliteMode.value
                                          ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                                          : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName:
                                          'com.example.apple_grower',
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        if (controller.currentPosition.value !=
                                            null)
                                          Marker(
                                            point: LatLng(
                                              controller
                                                  .currentPosition.value!.latitude,
                                              controller
                                                  .currentPosition.value!.longitude,
                                            ),
                                            width: 40,
                                            height: 40,
                                            child: const Icon(
                                              Icons.my_location,
                                              color: Colors.blue,
                                              size: 40,
                                            ),
                                          ),
                                        ...controller.markers.map((marker) {
                                          return Marker(
                                            point: marker.point,
                                            width: marker.width,
                                            height: marker.height,
                                            child: GestureDetector(
                                              onTap: marker.child is GestureDetector
                                                  ? (marker.child
                                                          as GestureDetector)
                                                      .onTap
                                                  : null,
                                              child: Icon(
                                                Icons.location_on,
                                                color: Colors.red,
                                                size: 40,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                    PolygonLayer(
                                      polygons: controller.polygons,
                                    ),
                                  ],
                                ),
                                CustomPaint(
                                  painter: _FreehandPainter(
                                      controller.drawnPath.toList()),
                                  size: Size.infinite,
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Column(
                                    children: [
                                      FloatingActionButton(
                                        heroTag: 'boundary_viewMode',
                                        onPressed: () {
                                          controller.isSatelliteMode.value =
                                              !controller.isSatelliteMode.value;
                                          Get.snackbar(
                                            'Map View Changed',
                                            controller.isSatelliteMode.value
                                                ? 'Satellite View'
                                                : 'Standard View',
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        },
                                        backgroundColor: const Color(0xff548235),
                                        child: Icon(
                                          controller.isSatelliteMode.value
                                              ? Icons.map
                                              : Icons.satellite,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      FloatingActionButton(
                                        heroTag: 'boundary_center_location',
                                        onPressed: () {
                                          if (controller.currentPosition.value !=
                                              null) {
                                            controller.mapController.move(
                                              LatLng(
                                                controller.currentPosition.value!
                                                    .latitude,
                                                controller.currentPosition.value!
                                                    .longitude,
                                              ),
                                              14,
                                            );
                                          }
                                        },
                                        backgroundColor: const Color(0xff548235),
                                        child: const Icon(Icons.my_location,
                                            color: Colors.white),
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
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            final currentZoom = controller
                                                .mapController.camera.zoom;
                                            final newZoom =
                                                (currentZoom + 1).clamp(5.0, 18.0);
                                            if (newZoom != currentZoom) {
                                              controller.mapController.move(
                                                controller
                                                    .mapController.camera.center,
                                                newZoom,
                                              );
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            final currentZoom = controller
                                                .mapController.camera.zoom;
                                            final newZoom =
                                                (currentZoom - 1).clamp(5.0, 18.0);
                                            if (newZoom != currentZoom) {
                                              controller.mapController.move(
                                                controller
                                                    .mapController.camera.center,
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
                            ),
                          );
                        } else {
                          return Stack(
                            children: [
                              FlutterMap(
                                key: controller.mapKey,
                                mapController: controller.mapController,
                                options: MapOptions(
                                  initialCenter: LatLng(
                                    controller.currentPosition.value!.latitude,
                                    controller.currentPosition.value!.longitude,
                                  ),
                                  initialZoom: 14,
                                  minZoom: 5.0,
                                  maxZoom: 18.0,
                                  onMapReady: () {
                                    if (controller.currentPosition.value != null) {
                                      controller.mapController.move(
                                        LatLng(
                                          controller
                                              .currentPosition.value!.latitude,
                                          controller
                                              .currentPosition.value!.longitude,
                                        ),
                                        14,
                                      );
                                    }
                                  },
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: controller.isSatelliteMode.value
                                        ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                                        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName:
                                        'com.example.apple_grower',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      if (controller.currentPosition.value != null)
                                        Marker(
                                          point: LatLng(
                                            controller
                                                .currentPosition.value!.latitude,
                                            controller
                                                .currentPosition.value!.longitude,
                                          ),
                                          width: 40,
                                          height: 40,
                                          child: const Icon(
                                            Icons.my_location,
                                            color: Colors.blue,
                                            size: 40,
                                          ),
                                        ),
                                      ...controller.markers.map((marker) {
                                        return Marker(
                                          point: marker.point,
                                          width: marker.width,
                                          height: marker.height,
                                          child: GestureDetector(
                                            onTap: marker.child is GestureDetector
                                                ? (marker.child as GestureDetector)
                                                    .onTap
                                                : null,
                                            child: Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                              size: 40,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                  PolygonLayer(
                                    polygons: controller.polygons,
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Column(
                                  children: [
                                    FloatingActionButton(
                                      heroTag: 'boundary_viewMode',
                                      onPressed: () {
                                        controller.isSatelliteMode.value =
                                            !controller.isSatelliteMode.value;
                                        Get.snackbar(
                                          'Map View Changed',
                                          controller.isSatelliteMode.value
                                              ? 'Satellite View'
                                              : 'Standard View',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      },
                                      backgroundColor: const Color(0xff548235),
                                      child: Icon(
                                        controller.isSatelliteMode.value
                                            ? Icons.map
                                            : Icons.satellite,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    FloatingActionButton(
                                      heroTag: 'boundary_center_location',
                                      onPressed: () {
                                        if (controller.currentPosition.value !=
                                            null) {
                                          controller.mapController.move(
                                            LatLng(
                                              controller
                                                  .currentPosition.value!.latitude,
                                              controller
                                                  .currentPosition.value!.longitude,
                                            ),
                                            14,
                                          );
                                        }
                                      },
                                      backgroundColor: const Color(0xff548235),
                                      child: const Icon(Icons.my_location,
                                          color: Colors.white),
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
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          final currentZoom =
                                              controller.mapController.camera.zoom;
                                          final newZoom =
                                              (currentZoom + 1).clamp(5.0, 18.0);
                                          if (newZoom != currentZoom) {
                                            controller.mapController.move(
                                              controller
                                                  .mapController.camera.center,
                                              newZoom,
                                            );
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          final currentZoom =
                                              controller.mapController.camera.zoom;
                                          final newZoom =
                                              (currentZoom - 1).clamp(5.0, 18.0);
                                          if (newZoom != currentZoom) {
                                            controller.mapController.move(
                                              controller
                                                  .mapController.camera.center,
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
                        }
                      });
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
                      onPressed: () {
                        controller.clearBoundary();
                        controller.boundaryImagePath.value = null;
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xff548235),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upload Boundary Image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff548235),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Upload a screenshot or image of your orchard boundary',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child:
                                Obx(() => controller.boundaryImagePath.value != null
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.image,
                                            color: const Color(0xff548235),
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              controller.boundaryImagePath.value!,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const Text(
                                        'No image selected',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      )),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: controller.pickImage,
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Upload Image'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff548235),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Obx(() {
              if (controller.boundarySearchSuggestions.isEmpty) return SizedBox();
              return Positioned(
                left: 0,
                right: 0,
                top: 100, // Height of the search bar
                child: SizedBox(
                  width: double.infinity, // Makes the dropdown as wide as the search bar
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 200), // max height for dropdown
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.boundarySearchSuggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = controller.boundarySearchSuggestions[index];
                          return ListTile(
                            title: Text(suggestion['display_name'] ?? ''),
                            onTap: () => controller.selectBoundarySuggestion(suggestion),
                          );
                        },
                      ),
                    ),
                  )
                ),
              );
            }),
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
              'Crop Stage',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<CropStage>(
                  value: controller.cropStage.value,
                  decoration: _getInputDecoration(
                    'Select Crop Stage',
                    prefixIcon: Icons.grass,
                  ),
                  items: CropStage.values.map((stage) {
                    return DropdownMenuItem<CropStage>(
                      value: stage,
                      child: Text(
                        stage
                            .toString()
                            .split('.')
                            .last
                            .replaceAll(RegExp(r'(?=[A-Z])'), ' ')
                            .trim(),
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) => controller.cropStage.value = value!,
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

  LatLng? _localToLatLng(
      BuildContext context, Offset local, OrchardFormController controller) {
    final mapKey = controller.mapKey;
    final mapBox = mapKey.currentContext?.findRenderObject() as RenderBox?;
    if (mapBox == null) return null;
    final mapSize = mapBox.size;
    final x = local.dx / mapSize.width;
    final y = local.dy / mapSize.height;
    final bounds = controller.mapController.camera.visibleBounds;
    final lat = bounds.north + (bounds.south - bounds.north) * y;
    final lng = bounds.west + (bounds.east - bounds.west) * x;
    return LatLng(lat, lng);
  }
}

class _FreehandPainter extends CustomPainter {
  final List<Offset> points;

  _FreehandPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    final path = ui.Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FreehandPainter oldDelegate) =>
      oldDelegate.points != points;
}
