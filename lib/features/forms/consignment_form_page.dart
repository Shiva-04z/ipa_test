import 'package:apple_grower/models/aadhati.dart';
import 'package:apple_grower/models/driving_profile_model.dart';
import 'package:apple_grower/models/ladani_model.dart';
import 'package:apple_grower/models/pack_house_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';
import '../../core/globals.dart' as glb;
import '../../models/consignment_model.dart';
import '../../core/global_role_loader.dart' as gld;
import '../grower/grower_controller.dart';

class ConsignmentFormPage extends StatefulWidget {
  @override
  _ConsignmentFormPageState createState() => _ConsignmentFormPageState();
}

class _ConsignmentFormPageState extends State<ConsignmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final GrowerController controller = Get.find<GrowerController>();

  int _currentStep = 0;

  // Step 1: Driver Selection
  String? _selectedDriverOption; // 'Self', 'My Drivers', 'Request Support'
  DrivingProfile? _selectedDriver;
  bool _isDriverSupportRequested = false;
  DrivingProfile? _resolvedDriverDetails;

  // Step 2: Packhouse Selection
  String?
      _selectedPackhouseOption; // 'Self', 'My Packhouses', 'Request Support'
  PackHouse? _selectedPackhouse;
  bool _isPackhouseSupportRequested = false;
  PackHouse? _resolvedPackhouseDetails;

  // Step 3: Bilty Creation
  String? _selectedPackingType; // 'Gunny Bags' or 'Detailed Bilty'
  String? _selectedHpmcDepot;
  final TextEditingController _boxesController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // Government data for bilty details
  final List<Map<String, dynamic>> _biltyData = [
    {
      'quality': 'AAA',
      'category': 'Extra Large',
      'size': '>80mm',
      'avgWeight': '250g',
      'piecesInBox': 80,
    },
    {
      'quality': 'AAA',
      'category': 'Large',
      'size': '>75mm-<80mm',
      'avgWeight': '200g',
      'piecesInBox': 100,
    },
    {
      'quality': 'AAA',
      'category': 'Medium',
      'size': '>70mm-<75mm',
      'avgWeight': '160g',
      'piecesInBox': 125,
    },
    {
      'quality': 'AAA',
      'category': 'Small',
      'size': '>65mm-<70mm',
      'avgWeight': '133g',
      'piecesInBox': 150,
    },
    {
      'quality': 'AAA',
      'category': 'Extra Small',
      'size': '>60mm-<65mm',
      'avgWeight': '116g',
      'piecesInBox': 175,
    },
    {
      'quality': 'AAA',
      'category': 'E Extra Small',
      'size': '>55mm-<60mm',
      'avgWeight': '98g',
      'piecesInBox': 200,
    },
    {
      'quality': 'AAA',
      'category': '240 Count',
      'size': '>50mm-<55mm',
      'avgWeight': '75g',
      'piecesInBox': 240,
    },
    {
      'quality': 'AAA',
      'category': 'Pittu',
      'size': '>45mm-<50mm',
      'avgWeight': '70g',
      'piecesInBox': 270,
    },
    {
      'quality': 'AAA',
      'category': 'Seprator',
      'size': '>40mm-<45mm',
      'avgWeight': '65g',
      'piecesInBox': 300,
    },
    {
      'quality': 'GP',
      'category': 'Large',
      'size': '>75mm-<80mm',
      'avgWeight': '200g',
      'piecesInBox': 40,
    },
    {
      'quality': 'GP',
      'category': 'Medium',
      'size': '>70mm-<75mm',
      'avgWeight': '160g',
      'piecesInBox': 50,
    },
    {
      'quality': 'GP',
      'category': 'Small',
      'size': '>65mm-<70mm',
      'avgWeight': '133g',
      'piecesInBox': 60,
    },
    {
      'quality': 'GP',
      'category': 'Extra Small',
      'size': '>60mm-<65mm',
      'avgWeight': '116g',
      'piecesInBox': 70,
    },
    {
      'quality': 'AA',
      'category': 'Extra Large',
      'size': '>80mm',
      'avgWeight': '250g',
      'piecesInBox': 80,
    },
    {
      'quality': 'AA',
      'category': 'Large',
      'size': '>75mm-<80mm',
      'avgWeight': '200g',
      'piecesInBox': 100,
    },
    {
      'quality': 'AA',
      'category': 'Medium',
      'size': '>70mm-<75mm',
      'avgWeight': '160g',
      'piecesInBox': 125,
    },
    {
      'quality': 'AA',
      'category': 'Small',
      'size': '>65mm-<70mm',
      'avgWeight': '133g',
      'piecesInBox': 150,
    },
    {
      'quality': 'AA',
      'category': 'Extra Small',
      'size': '>60mm-<65mm',
      'avgWeight': '116g',
      'piecesInBox': 175,
    },
  ];

  String? _selectedQuality;
  String? _selectedCategory;
  final TextEditingController _boxCountController = TextEditingController();
  final List<Map<String, dynamic>> _biltyItems = [];

  // Add dummy bilty data structure
  final List<Map<String, dynamic>> _dummyBiltyItems = [
    {
      'quality': 'AAA',
      'category': 'Large',
      'size': '>75mm-<80mm',
      'avgWeight': '200g',
      'piecesInBox': 100,
      'weightPerBox': 20.0,
      'boxCount': 10,
      'totalWeight': 200.0,
      'totalPieces': 1000,
    }
  ];

  // Add new state variables for Aadhati pricing
  bool _isPerKgMode = true;
  final List<Map<String, dynamic>> _pricedBiltyItems = [];
  bool _isAadhatiSubmitted = false;
  // Track which field was last edited for each row
  final Map<int, String> _lastEditedField = {};

  @override
  void dispose() {
    _boxesController.dispose();
    _priceController.dispose();
    _boxCountController.dispose();
    super.dispose();
  }

  List<String> get _availableQualities =>
      _biltyData.map((e) => e['quality'] as String).toSet().toList();

  List<String> get _availableCategories {
    if (_selectedQuality == null) return [];
    return _biltyData
        .where((e) => e['quality'] == _selectedQuality)
        .map((e) => e['category'] as String)
        .toList();
  }

  Map<String, dynamic>? _getBiltyDetails({String? quality, String? category}) {
    if (quality == null || category == null) return null;
    final details = _biltyData.firstWhereOrNull(
      (e) => e['quality'] == quality && e['category'] == category,
    );
    if (details == null) return null;

    // Create a new map to avoid reference issues
    return {
      'quality': details['quality'],
      'category': details['category'],
      'size': details['size'],
      'avgWeight': details['avgWeight'],
      'piecesInBox': details['piecesInBox'],
    };
  }

  double _parseWeight(String weightStr) {
    return double.parse(weightStr.replaceAll('g', ''));
  }

  Future<void> _requestDriverSupport() async {
    _isDriverSupportRequested = true;
    await Future.delayed(Duration(seconds: 2));
    final randomDriver =
        (glb.availableDrivingProfiles.toList()..shuffle()).first;
    setState(() {
      _resolvedDriverDetails = randomDriver;
      _isDriverSupportRequested = false;
    });
    Get.snackbar(
      'Success',
      'Driver support requested successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> _requestPackhouseSupport() async {
    _isPackhouseSupportRequested = true;
    await Future.delayed(Duration(seconds: 2));
    final randomPackhouse = (glb.availablePackHouses.toList()..shuffle()).first;
    setState(() {
      _resolvedPackhouseDetails = randomPackhouse;
      _isPackhouseSupportRequested = false;
    });
    Get.snackbar(
      'Success',
      'Packhouse support requested successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  InputDecoration _getInputDecoration(String label, {IconData? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xff548235)),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildDriverSelectionCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Driver:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff548235),
          ),
        ),
        SizedBox(height: 16),
        ListTile(
          title: const Text('Self'),
          subtitle: Text('You will handle the driving yourself'),
          leading: Radio<String>(
            value: 'Self',
            groupValue: _selectedDriverOption,
            onChanged: (value) {
              setState(() {
                _selectedDriverOption = value;
                _selectedDriver = null;
                _resolvedDriverDetails = null;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('My Drivers'),
          subtitle: Text('Select from your saved drivers'),
          leading: Radio<String>(
            value: 'My Drivers',
            groupValue: _selectedDriverOption,
            onChanged: (value) {
              setState(() {
                _selectedDriverOption = value;
                _resolvedDriverDetails = null;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Request Support'),
          subtitle: Text('FAS will assign a driver before dispatch'),
          leading: Radio<String>(
            value: 'Request Support',
            groupValue: _selectedDriverOption,
            onChanged: (value) {
              setState(() {
                _selectedDriverOption = value;
                _selectedDriver = null;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDriverDetailsCard() {
    if (_selectedDriverOption == null) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedDriverOption == 'My Drivers') ...[
          DropdownButtonFormField<DrivingProfile>(
            decoration:
                _getInputDecoration('Select Driver', prefixIcon: Icons.person),
            value: _selectedDriver,
            items: glb.availableDrivingProfiles.map((DrivingProfile driver) {
              return DropdownMenuItem<DrivingProfile>(
                value: driver,
                child: Text(driver.name ?? 'Unknown Driver'),
              );
            }).toList(),
            onChanged: (DrivingProfile? newValue) {
              setState(() {
                _selectedDriver = newValue;
              });
            },
            validator: (value) =>
                value == null ? 'Please select a driver' : null,
          ),
        ] else if (_selectedDriverOption == 'Request Support') ...[
          ElevatedButton.icon(
            onPressed: _isDriverSupportRequested ? null : _requestDriverSupport,
            icon: Icon(Icons.support_agent),
            label: Text('Request Driver Support'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff548235),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          if (_isDriverSupportRequested)
            Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Requesting driver support...'),
                ],
              ),
            )
          else if (_resolvedDriverDetails != null)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assigned Driver:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                      'Name: ${_resolvedDriverDetails!.name ?? 'Unknown Driver'}'),
                  Text('Contact: ${_resolvedDriverDetails!.contact ?? 'N/A'}'),
                  if (_resolvedDriverDetails!.vehicleRegistrationNo != null)
                    Text(
                        'Vehicle: ${_resolvedDriverDetails!.vehicleRegistrationNo}'),
                ],
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildPackhouseSelectionCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Packhouse:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff548235),
          ),
        ),
        SizedBox(height: 16),
        ListTile(
          title: const Text('Self'),
          subtitle: Text('You will handle the packing yourself'),
          leading: Radio<String>(
            value: 'Self',
            groupValue: _selectedPackhouseOption,
            onChanged: (value) {
              setState(() {
                _selectedPackhouseOption = value;
                _selectedPackhouse = null;
                _resolvedPackhouseDetails = null;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('My Packhouses'),
          subtitle: Text('Select from your saved packhouses'),
          leading: Radio<String>(
            value: 'My Packhouses',
            groupValue: _selectedPackhouseOption,
            onChanged: (value) {
              setState(() {
                _selectedPackhouseOption = value;
                _resolvedPackhouseDetails = null;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Request Support'),
          subtitle: Text('FAS will assign a packhouse near your farm'),
          leading: Radio<String>(
            value: 'Request Support',
            groupValue: _selectedPackhouseOption,
            onChanged: (value) {
              setState(() {
                _selectedPackhouseOption = value;
                _selectedPackhouse = null;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPackhouseDetailsCard() {
    if (_selectedPackhouseOption == null) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedPackhouseOption == 'My Packhouses') ...[
          DropdownButtonFormField<PackHouse>(
            decoration: _getInputDecoration('Select Packhouse',
                prefixIcon: Icons.business),
            value: _selectedPackhouse,
            items: glb.availablePackHouses.map((PackHouse packhouse) {
              return DropdownMenuItem<PackHouse>(
                value: packhouse,
                child: Text(packhouse.name),
              );
            }).toList(),
            onChanged: (PackHouse? newValue) {
              setState(() {
                _selectedPackhouse = newValue;
              });
            },
            validator: (value) =>
                value == null ? 'Please select a packhouse' : null,
          ),
        ] else if (_selectedPackhouseOption == 'Request Support') ...[
          ElevatedButton.icon(
            onPressed:
                _isPackhouseSupportRequested ? null : _requestPackhouseSupport,
            icon: Icon(Icons.support_agent),
            label: Text('Request Packhouse Support'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff548235),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          if (_isPackhouseSupportRequested)
            Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Requesting packhouse support...'),
                ],
              ),
            )
          else if (_resolvedPackhouseDetails != null)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assigned Packhouse:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Name: ${_resolvedPackhouseDetails!.name}'),
                  Text('Contact: ${_resolvedPackhouseDetails!.phoneNumber}'),
                  if (_resolvedPackhouseDetails!.address != null)
                    Text('Address: ${_resolvedPackhouseDetails!.address}'),
                ],
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildPackingTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Packing Type:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff548235),
          ),
        ),
        SizedBox(height: 16),
        ListTile(
          title: const Text('Gunny Bags'),
          subtitle: Text('For HPMC depots'),
          leading: Radio<String>(
            value: 'Gunny Bags',
            groupValue: _selectedPackingType,
            onChanged: (value) {
              setState(() {
                _selectedPackingType = value;
                _selectedHpmcDepot = null;
                _boxesController.clear();
                _priceController.clear();
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Detailed Bilty'),
          subtitle: Text('Manual entry with quality details'),
          leading: Radio<String>(
            value: 'Detailed Bilty',
            groupValue: _selectedPackingType,
            onChanged: (value) {
              setState(() {
                _selectedPackingType = value;
                _selectedQuality = null;
                _selectedCategory = null;
                _boxCountController.clear();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGunnyBagsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gunny Bags Details:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff548235),
          ),
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: _getInputDecoration('Select HPMC Depot',
              prefixIcon: Icons.warehouse),
          value: _selectedHpmcDepot,
          items: ['Depot 1', 'Depot 2', 'Depot 3'].map((String depot) {
            return DropdownMenuItem<String>(
              value: depot,
              child: Text(depot),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedHpmcDepot = newValue;
            });
          },
          validator: (value) =>
              value == null ? 'Please select HPMC Depot' : null,
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _boxesController,
          decoration: _getInputDecoration('Number of Boxes',
              prefixIcon: Icons.inventory),
          keyboardType: TextInputType.number,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter number of boxes' : null,
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _priceController,
          decoration: _getInputDecoration('Price per Box (Optional)',
              prefixIcon: Icons.attach_money),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildDetailedBiltyForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Bilty Entry:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff548235),
          ),
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration:
              _getInputDecoration('Quality', prefixIcon: Icons.category),
          value: _selectedQuality,
          items: _availableQualities.map((String quality) {
            return DropdownMenuItem<String>(
              value: quality,
              child: Text(quality),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedQuality = newValue;
              _selectedCategory = null;
            });
          },
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: _getInputDecoration('Category', prefixIcon: Icons.list),
          value: _selectedCategory,
          items: _availableCategories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: _selectedQuality == null
              ? null
              : (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
        ),
        if (_selectedQuality != null && _selectedCategory != null) ...[
          SizedBox(height: 16),
          Builder(
            builder: (context) {
              final biltyDetails = _getBiltyDetails(
                quality: _selectedQuality,
                category: _selectedCategory,
              );
              if (biltyDetails == null) return SizedBox.shrink();

              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Box Details:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Size: ${biltyDetails['size']}'),
                    Text('Average Weight: ${biltyDetails['avgWeight']}'),
                    Text('Pieces per box: ${biltyDetails['piecesInBox']}'),
                  ],
                ),
              );
            },
          ),
        ],
        SizedBox(height: 16),
        TextFormField(
          controller: _boxCountController,
          decoration: _getInputDecoration('Number of Boxes',
              prefixIcon: Icons.inventory),
          keyboardType: TextInputType.number,
        ),
        if (_selectedQuality != null &&
            _selectedCategory != null &&
            _boxCountController.text.isNotEmpty) ...[
          SizedBox(height: 16),
          Builder(
            builder: (context) {
              final biltyDetails = _getBiltyDetails(
                quality: _selectedQuality,
                category: _selectedCategory,
              );
              if (biltyDetails == null) return SizedBox.shrink();

              final weightPerPiece = _parseWeight(biltyDetails['avgWeight']);
              final boxCount = int.parse(_boxCountController.text);
              final piecesInBox = biltyDetails['piecesInBox'] as int;
              final weightPerBox =
                  (weightPerPiece * piecesInBox) / 1000; // Convert to Kg
              final totalWeight = weightPerBox * boxCount;
              final totalPieces = piecesInBox * boxCount;

              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculated Details:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                        'Weight per box: ${weightPerBox.toStringAsFixed(2)} Kg'),
                    Text('Total weight: ${totalWeight.toStringAsFixed(2)} Kg'),
                    Text('Total pieces: $totalPieces'),
                  ],
                ),
              );
            },
          ),
        ],
        SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            if (_selectedQuality != null &&
                _selectedCategory != null &&
                _boxCountController.text.isNotEmpty) {
              final biltyDetails = _getBiltyDetails(
                quality: _selectedQuality,
                category: _selectedCategory,
              );
              if (biltyDetails == null) return;

              setState(() {
                final weightPerPiece = _parseWeight(biltyDetails['avgWeight']);
                final boxCount = int.parse(_boxCountController.text);
                final piecesInBox = biltyDetails['piecesInBox'] as int;
                final weightPerBox =
                    (weightPerPiece * piecesInBox) / 1000; // Convert to Kg
                final totalWeight = weightPerBox * boxCount;
                final totalPieces = piecesInBox * boxCount;

                _biltyItems.add({
                  'quality': _selectedQuality,
                  'category': _selectedCategory,
                  'size': biltyDetails['size'],
                  'avgWeight': biltyDetails['avgWeight'],
                  'piecesInBox': piecesInBox,
                  'weightPerPiece': weightPerPiece,
                  'weightPerBox': weightPerBox,
                  'boxCount': boxCount,
                  'totalWeight': totalWeight,
                  'totalPieces': totalPieces,
                });

                _selectedQuality = null;
                _selectedCategory = null;
                _boxCountController.clear();
              });
            }
          },
          icon: Icon(Icons.add),
          label: Text('Add to Bilty'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff548235),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDummyBiltyCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Data filled by selected packhouse',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Quality')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Size')),
              DataColumn(label: Text('Avg Weight')),
              DataColumn(label: Text('Pieces/Box')),
              DataColumn(label: Text('Weight/Box (Kg)')),
              DataColumn(label: Text('Boxes')),
              DataColumn(label: Text('Total Pieces')),
              DataColumn(label: Text('Total Weight (Kg)')),
            ],
            rows: _dummyBiltyItems.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(item['quality'] ?? '')),
                  DataCell(Text(item['category'] ?? '')),
                  DataCell(Text(item['size'] ?? '')),
                  DataCell(Text(item['avgWeight'] ?? '')),
                  DataCell(Text(item['piecesInBox']?.toString() ?? '')),
                  DataCell(
                      Text(item['weightPerBox']?.toStringAsFixed(2) ?? '')),
                  DataCell(Text(item['boxCount']?.toString() ?? '')),
                  DataCell(Text(item['totalPieces']?.toString() ?? '')),
                  DataCell(Text(item['totalWeight']?.toStringAsFixed(2) ?? '')),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewBiltySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Bilty',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff548235),
          ),
        ),
        SizedBox(height: 16),
        if (_selectedPackhouseOption != 'Self')
          _buildDummyBiltyCard()
        else
          _buildBiltyItemsTable(),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Items: ${_selectedPackhouseOption == 'Self' ? _biltyItems.length : _dummyBiltyItems.length}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (_selectedPackhouseOption == 'Self' &&
                _biltyItems.isNotEmpty) ...[
              Text(
                'Total Weight: ${_calculateTotalWeight().toStringAsFixed(2)} Kg',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Total Pieces: ${_calculateTotalPieces()}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ] else if (_selectedPackhouseOption != 'Self') ...[
              Text(
                'Total Weight: ${_dummyBiltyItems.first['totalWeight']?.toStringAsFixed(2)} Kg',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Total Pieces: ${_dummyBiltyItems.first['totalPieces']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }

  double _calculateTotalWeight() {
    return _biltyItems.fold(
      0.0,
      (sum, item) => sum + (item['totalWeight'] as double),
    );
  }

  int _calculateTotalPieces() {
    return _biltyItems.fold(
      0,
      (sum, item) => sum + (item['totalPieces'] as int),
    );
  }

  Widget _buildBiltyItemsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Quality')),
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Size')),
          DataColumn(label: Text('Avg Weight')),
          DataColumn(label: Text('Pieces/Box')),
          DataColumn(label: Text('Weight/Box (Kg)')),
          DataColumn(label: Text('Boxes')),
          DataColumn(label: Text('Total Pieces')),
          DataColumn(label: Text('Total Weight (Kg)')),
          if (_selectedPackhouseOption == 'Self')
            DataColumn(label: Text('Actions')),
        ],
        rows: _biltyItems.map((item) {
          return DataRow(
            cells: [
              DataCell(Text(item['quality'] ?? '')),
              DataCell(Text(item['category'] ?? '')),
              DataCell(Text(item['size'] ?? '')),
              DataCell(Text(item['avgWeight'] ?? '')),
              DataCell(Text(item['piecesInBox']?.toString() ?? '')),
              DataCell(Text(item['weightPerBox']?.toStringAsFixed(2) ?? '')),
              DataCell(Text(item['boxCount']?.toString() ?? '')),
              DataCell(Text(item['totalPieces']?.toString() ?? '')),
              DataCell(Text(item['totalWeight']?.toStringAsFixed(2) ?? '')),
              if (_selectedPackhouseOption == 'Self')
                DataCell(Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // TODO: Implement edit functionality
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _biltyItems.remove(item);
                        });
                      },
                    ),
                  ],
                )),
            ],
          );
        }).toList(),
      ),
    );
  }

  // Add new methods for price calculations
  void _updatePrices(
      Map<String, dynamic> item, int index, String field, String value) {
    final double? newValue = double.tryParse(value);
    if (newValue == null) return;

    setState(() {
      _lastEditedField[index] = field;

      if (field == 'pricePerKg') {
        item['pricePerKg'] = newValue;
        // Calculate price per box
        final totalWeight = item['totalWeight'] as double;
        final boxCount = item['boxCount'] as int;
        if (totalWeight > 0 && boxCount > 0) {
          item['pricePerBox'] = (totalWeight * newValue) / boxCount;
        }
      } else if (field == 'pricePerBox') {
        item['pricePerBox'] = newValue;
        // Calculate price per kg
        final totalWeight = item['totalWeight'] as double;
        final boxCount = item['boxCount'] as int;
        if (totalWeight > 0 && boxCount > 0) {
          item['pricePerKg'] = (boxCount * newValue) / totalWeight;
        }
      }
    });
  }

  double _calculateRowTotal(Map<String, dynamic> item, int index) {
    final lastEdited = _lastEditedField[index];
    if (lastEdited == 'pricePerKg') {
      return item['totalWeight'] * (item['pricePerKg'] as double? ?? 0.0);
    } else {
      return item['boxCount'] * (item['pricePerBox'] as double? ?? 0.0);
    }
  }

  double _calculateGrandTotal() {
    return _pricedBiltyItems.asMap().entries.fold(
          0.0,
          (sum, entry) => sum + _calculateRowTotal(entry.value, entry.key),
        );
  }

  bool _areAllPricesFilled() {
    return _pricedBiltyItems.every(
        (item) => item['pricePerKg'] != null && item['pricePerBox'] != null);
  }

  // Add new state variables for pricing summary
  String _getPricingTypeForRow(Map<String, dynamic> item, int index) {
    final lastEdited = _lastEditedField[index];
    return lastEdited == 'pricePerKg' ? 'Per Kg' : 'Per Box';
  }

  String _getOverallPricingType() {
    if (_pricedBiltyItems.isEmpty) return 'Not Set';
    final firstType = _getPricingTypeForRow(_pricedBiltyItems[0], 0);
    final allSameType = _pricedBiltyItems.asMap().entries.every(
          (entry) => _getPricingTypeForRow(entry.value, entry.key) == firstType,
        );
    return allSameType ? firstType : 'Mixed';
  }

  Map<String, dynamic> _calculateSummary() {
    int totalBoxes = 0;
    double totalWeight = 0.0;
    double grandTotal = 0.0;

    for (var entry in _pricedBiltyItems.asMap().entries) {
      final item = entry.value;
      final index = entry.key;
      totalBoxes += item['boxCount'] as int;
      totalWeight += item['totalWeight'] as double;
      grandTotal += _calculateRowTotal(item, index);
    }

    return {
      'totalBoxes': totalBoxes,
      'totalWeight': totalWeight,
      'grandTotal': grandTotal,
      'pricingType': _getOverallPricingType(),
    };
  }

  Widget _buildPricingSummary() {
    final summary = _calculateSummary();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Final Bilty Summary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff548235),
          ),
        ),
        SizedBox(height: 16),
        // Summary Cards
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Boxes',
                summary['totalBoxes'].toString(),
                Icons.inventory,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                'Total Weight',
                '${summary['totalWeight'].toStringAsFixed(2)} Kg',
                Icons.scale,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Grand Total',
                '₹ ${summary['grandTotal'].toStringAsFixed(2)}',
                Icons.attach_money,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                'Pricing Type',
                summary['pricingType'],
                Icons.price_change,
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        // Bilty Table
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Quality')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Size (mm)')),
              DataColumn(label: Text('Boxes')),
              DataColumn(label: Text('Avg Weight/Piece (g)')),
              DataColumn(label: Text('Total Pieces')),
              DataColumn(label: Text('Total Weight (Kg)')),
              DataColumn(label: Text('Price/Kg (₹)')),
              DataColumn(label: Text('Price/Box (₹)')),
              DataColumn(label: Text('Row Total (₹)')),
            ],
            rows: _pricedBiltyItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return DataRow(
                cells: [
                  DataCell(Text(item['quality'] ?? '')),
                  DataCell(Text(item['category'] ?? '')),
                  DataCell(Text(item['size']?.toString() ?? '')),
                  DataCell(Text(item['boxCount']?.toString() ?? '')),
                  DataCell(Text(item['avgWeight']?.toString() ?? '')),
                  DataCell(Text(item['totalPieces']?.toString() ?? '')),
                  DataCell(Text(item['totalWeight']?.toStringAsFixed(2) ?? '')),
                  DataCell(Text(item['pricePerKg']?.toStringAsFixed(2) ?? '')),
                  DataCell(Text(item['pricePerBox']?.toStringAsFixed(2) ?? '')),
                  DataCell(Text(
                    _calculateRowTotal(item, index).toStringAsFixed(2),
                  )),
                ],
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 32),
        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement save for later functionality
                Get.snackbar(
                  'Saved',
                  'Consignment saved for later',
                  backgroundColor: Colors.blue,
                  colorText: Colors.white,
                );
              },
              icon: Icon(Icons.save),
              label: Text('Keep for Later'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement release for bid functionality
                Get.snackbar(
                  'Released',
                  'Consignment released for bidding',
                  backgroundColor: Color(0xff548235),
                  colorText: Colors.white,
                );
              },
              icon: Icon(Icons.gavel),
              label: Text('Release for Bid'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff548235),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Color(0xff548235)),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff548235),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAadhatiPricingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aadhati Pricing',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff548235),
          ),
        ),
        SizedBox(height: 16),
        if (!_isAadhatiSubmitted) ...[
          // Bilty Table with Pricing
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Quality')),
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Boxes')),
                DataColumn(label: Text('Total Weight (Kg)')),
                DataColumn(label: Text('Price/Kg (₹)')),
                DataColumn(label: Text('Price/Box (₹)')),
                DataColumn(label: Text('Row Total (₹)')),
              ],
              rows: _pricedBiltyItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return DataRow(
                  cells: [
                    DataCell(Text(item['quality'] ?? '')),
                    DataCell(Text(item['category'] ?? '')),
                    DataCell(Text(item['boxCount']?.toString() ?? '')),
                    DataCell(
                        Text(item['totalWeight']?.toStringAsFixed(2) ?? '')),
                    DataCell(
                      TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: item['pricePerKg']?.toString() ?? '',
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                        onChanged: (value) => _updatePrices(
                          item,
                          index,
                          'pricePerKg',
                          value,
                        ),
                      ),
                    ),
                    DataCell(
                      TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: item['pricePerBox']?.toString() ?? '',
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                        onChanged: (value) => _updatePrices(
                          item,
                          index,
                          'pricePerBox',
                          value,
                        ),
                      ),
                    ),
                    DataCell(Text(
                      _calculateRowTotal(item, index).toStringAsFixed(2),
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16),
          // Grand Total
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Grand Total:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '₹ ${_calculateGrandTotal().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff548235),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          // Submit Button
          Center(
            child: ElevatedButton.icon(
              onPressed: _pricedBiltyItems.isNotEmpty
                  ? () {
                      setState(() {
                        _isAadhatiSubmitted = true;
                      });
                      Get.snackbar(
                        'Success',
                        'Pricing submitted successfully',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    }
                  : null,
              icon: Icon(Icons.check),
              label: Text('Submit Pricing'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff548235),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ] else ...[
          _buildPricingSummary(),
        ],
      ],
    );
  }

  bool _isStepValid(int step) {
    switch (step) {
      case 0: // Driver Selection
        if (_selectedDriverOption == null) return false;
        if (_selectedDriverOption == 'My Drivers' && _selectedDriver == null)
          return false;
        if (_selectedDriverOption == 'Request Support' &&
            _resolvedDriverDetails == null) return false;
        return true;
      case 1: // Packhouse Selection
        if (_selectedPackhouseOption == null) return false;
        if (_selectedPackhouseOption == 'My Packhouses' &&
            _selectedPackhouse == null) return false;
        if (_selectedPackhouseOption == 'Request Support' &&
            _resolvedPackhouseDetails == null) return false;
        return true;
      case 2: // Bilty Creation
        if (_selectedPackhouseOption == 'Self') {
          if (_selectedPackingType == null) return false;
          return true;
        }
        return true; // For non-self packhouse, always valid
      case 3: // Review Bilty
        if (_selectedPackhouseOption == 'Self' && _biltyItems.isEmpty)
          return false;
        return true;
      case 4: // Aadhati Pricing
        // Check if bilty items exist and have prices
        if (_pricedBiltyItems.isEmpty) return false;
        return _pricedBiltyItems.every((item) =>
            item['pricePerKg'] != null && item['pricePerBox'] != null);
      default:
        return true;
    }
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: Text('Driver Selection'),
        content: Column(
          children: [
            _buildDriverSelectionCard(),
            SizedBox(height: 16),
            _buildDriverDetailsCard(),
          ],
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Packhouse Selection'),
        content: Column(
          children: [
            _buildPackhouseSelectionCard(),
            SizedBox(height: 16),
            _buildPackhouseDetailsCard(),
          ],
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Bilty Creation'),
        content: _selectedPackhouseOption == 'Self'
            ? Column(
                children: [
                  _buildPackingTypeSelection(),
                  SizedBox(height: 16),
                  _selectedPackingType == 'Gunny Bags'
                      ? _buildGunnyBagsForm()
                      : _buildDetailedBiltyForm(),
                  SizedBox(height: 16),
                  _buildBiltyItemsTable(),
                ],
              )
            : _buildDummyBiltyCard(),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Review Bilty'),
        content: _buildReviewBiltySection(),
        isActive: _currentStep >= 3,
        state: _currentStep > 3 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Aadhati Pricing'),
        content: _buildAadhatiPricingSection(),
        isActive: _currentStep >= 4,
        state: _currentStep > 4 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  void _onStepContinue() {
    if (_isStepValid(_currentStep)) {
      if (_currentStep == 3) {
        // When moving from Review Bilty to Aadhati Pricing
        setState(() {
          _pricedBiltyItems.clear();
          if (_selectedPackhouseOption == 'Self') {
            _pricedBiltyItems.addAll(_biltyItems);
          } else {
            _pricedBiltyItems.addAll(_dummyBiltyItems);
          }
        });
      }
      if (_currentStep < _buildSteps().length - 1) {
        setState(() {
          _currentStep += 1;
        });
      } else {
        // TODO: Implement form submission
      }
    } else {
      Get.snackbar(
        'Incomplete',
        'Please fill all required fields and resolve any pending requests.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Consignment'),
        backgroundColor: Color(0xff548235),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff548235).withOpacity(0.1), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Stepper(
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  onStepContinue: _onStepContinue,
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() {
                        _currentStep -= 1;
                      });
                    }
                  },
                  onStepTapped: (step) {
                    setState(() {
                      _currentStep = step;
                    });
                  },
                  steps: _buildSteps(),
                  controlsBuilder: (
                    BuildContext context,
                    ControlsDetails controls,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: controls.onStepContinue,
                              child: Text(
                                _currentStep == _buildSteps().length - 1
                                    ? 'Submit'
                                    : 'Next',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff548235),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          if (_currentStep > 0)
                            Expanded(
                              child: TextButton(
                                onPressed: controls.onStepCancel,
                                child: Text('Back'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[700],
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
