import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../core/globals.dart' as globals;
import '../../models/consignment_model.dart';
import 'grower_controller.dart';

class ConsignmentFormPage extends StatefulWidget {
  @override
  _ConsignmentFormPageState createState() => _ConsignmentFormPageState();
}

class _ConsignmentFormPageState extends State<ConsignmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final GrowerController controller = Get.find<GrowerController>();

  int _currentStep = 0;

  // Step 1 Controllers
  String? _selectedQuality;
  String? _selectedCategory;
  final TextEditingController _boxesController = TextEditingController();
  int? _piecesInBox;

  // Step 2 Controllers
  String? _selectedPickupOption;
  final TextEditingController _shippingFromController = TextEditingController();
  final TextEditingController _shippingToController = TextEditingController();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _driverContactController =
      TextEditingController();
  RxBool _requestDriverSupportPending = false.obs;
  Map<String, String>? _resolvedDriverDetails;

  // Step 3 Controllers
  final TextEditingController _packhouseNameController =
      TextEditingController();
  final TextEditingController _packhouseContactController =
      TextEditingController();
  bool _hasOwnCrates = false;

  // Step 4 Controllers
  String? _selectedStatus;

  // Step 5 Controllers (only shown if status is "Release for Bid")
  String? _selectedAdhaniOption;
  String? _selectedLadhaniOption;
  final TextEditingController _adhaniNameController = TextEditingController();
  final TextEditingController _adhaniContactController =
      TextEditingController();
  final TextEditingController _adhaniApmcController = TextEditingController();
  final TextEditingController _ladhaniNameController = TextEditingController();
  final TextEditingController _ladhaniContactController =
      TextEditingController();
  final TextEditingController _ladhaniCompanyController =
      TextEditingController();
  RxBool _requestAdhaniSupportPending = false.obs;
  RxBool _requestLadhaniSupportPending = false.obs;
  Map<String, String>? _resolvedAdhaniDetails;
  Map<String, String>? _resolvedLadhaniDetails;

  @override
  void dispose() {
    _boxesController.dispose();
    _shippingFromController.dispose();
    _shippingToController.dispose();
    _driverNameController.dispose();
    _driverContactController.dispose();
    _packhouseNameController.dispose();
    _packhouseContactController.dispose();
    _adhaniNameController.dispose();
    _adhaniContactController.dispose();
    _adhaniApmcController.dispose();
    _ladhaniNameController.dispose();
    _ladhaniContactController.dispose();
    _ladhaniCompanyController.dispose();
    super.dispose();
  }

  List<String> get _availableQualities =>
      globals.consignmentTableData
          .map((e) => e['quality'] as String)
          .toSet()
          .toList();

  List<String> get _availableCategories {
    if (_selectedQuality == null) return [];
    return globals.consignmentTableData
        .where((e) => e['quality'] == _selectedQuality)
        .map((e) => e['category'] as String)
        .toList();
  }

  void _updatePiecesInBox() {
    if (_selectedQuality != null && _selectedCategory != null) {
      final data = globals.consignmentTableData.firstWhereOrNull(
        (e) =>
            e['quality'] == _selectedQuality &&
            e['category'] == _selectedCategory,
      );
      _piecesInBox = data?['piecesInBox'] as int?;
    } else {
      _piecesInBox = null;
    }
  }

  Future<void> _requestDriverSupport() async {
    _requestDriverSupportPending.value = true;
    await Future.delayed(Duration(seconds: 2));
    final randomDriver = (globals.dummyDrivers.toList()..shuffle()).first;
    _resolvedDriverDetails = randomDriver;
    _requestDriverSupportPending.value = false;
    Get.snackbar(
      'Success',
      'Driver details fetched.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> _requestAdhaniSupport() async {
    _requestAdhaniSupportPending.value = true;
    await Future.delayed(Duration(seconds: 2));
    final randomAdhani = (globals.dummyAdhanis.toList()..shuffle()).first;
    _resolvedAdhaniDetails = randomAdhani;
    _requestAdhaniSupportPending.value = false;
    Get.snackbar(
      'Success',
      'Adhani details fetched.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> _requestLadhaniSupport() async {
    _requestLadhaniSupportPending.value = true;
    await Future.delayed(Duration(seconds: 2));
    final randomLadhani = (globals.dummyLadhanis.toList()..shuffle()).first;
    _resolvedLadhaniDetails = randomLadhani;
    _requestLadhaniSupportPending.value = false;
    Get.snackbar(
      'Success',
      'Ladhani details fetched.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> _showMapLocationPicker(
    BuildContext context,
    TextEditingController locationController,
  ) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Error', 'Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Location permissions are permanently denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address =
          placemarks.isNotEmpty
              ? '${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.postalCode}'
              : 'Unknown Location';

      locationController.text = address;
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: ${e.toString()}');
    }
  }

  InputDecoration _getLocationDecoration(String label, VoidCallback onMapTap) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(Icons.location_on),
      suffixIcon: IconButton(icon: Icon(Icons.map), onPressed: onMapTap),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  InputDecoration _getInputDecoration(
    String label, {
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: suffixIcon,
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

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final newConsignment = Consignment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        quality: _selectedQuality!,
        category: _selectedCategory!,
        numberOfBoxes: int.parse(_boxesController.text),
        numberOfPiecesInBox: _piecesInBox!,
        pickupOption: _selectedPickupOption!,
        shippingFrom:
            _selectedPickupOption == 'Request Driver Support'
                ? _shippingFromController.text
                : null,
        shippingTo:
            _selectedPickupOption == 'Request Driver Support'
                ? _shippingToController.text
                : null,
        driverName:
            _selectedPickupOption == 'Own'
                ? _driverNameController.text
                : _resolvedDriverDetails?['name'],
        driverContact:
            _selectedPickupOption == 'Own'
                ? _driverContactController.text
                : _resolvedDriverDetails?['contact'],
        packhouseName: _packhouseNameController.text,
        packhouseContact: _packhouseContactController.text,
        hasOwnCrates: _hasOwnCrates,
        status: _selectedStatus!,
        adhaniOption: _selectedAdhaniOption!,
        ladhaniOption: _selectedAdhaniOption!,
        adhaniName:
            _selectedStatus == 'Release for Bid'
                ? (_selectedAdhaniOption == 'Own'
                    ? _adhaniNameController.text
                    : _resolvedAdhaniDetails?['name'])
                : null,
        adhaniContact:
            _selectedStatus == 'Release for Bid'
                ? (_selectedAdhaniOption == 'Own'
                    ? _adhaniContactController.text
                    : _resolvedAdhaniDetails?['contact'])
                : null,
        adhaniApmc:
            _selectedStatus == 'Release for Bid'
                ? (_selectedAdhaniOption == 'Own'
                    ? _adhaniApmcController.text
                    : _resolvedAdhaniDetails?['apmc'])
                : null,
        ladhaniName:
            _selectedStatus == 'Release for Bid'
                ? (_selectedLadhaniOption == 'Own'
                    ? _ladhaniNameController.text
                    : _resolvedLadhaniDetails?['name'])
                : null,
        ladhaniContact:
            _selectedStatus == 'Release for Bid'
                ? (_selectedLadhaniOption == 'Own'
                    ? _ladhaniContactController.text
                    : _resolvedLadhaniDetails?['contact'])
                : null,
        ladhaniCompany:
            _selectedStatus == 'Release for Bid'
                ? (_selectedLadhaniOption == 'Own'
                    ? _ladhaniCompanyController.text
                    : _resolvedLadhaniDetails?['company'])
                : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      controller.addConsignment(newConsignment);
      Get.back();
      Get.snackbar(
        'Success',
        'Consignment added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Consignment Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff548235),
          ),
        ),
        SizedBox(height: 24),
        DropdownButtonFormField<String>(
          decoration: _getInputDecoration(
            'Quality',
            prefixIcon: Icons.category,
          ),
          value: _selectedQuality,
          items:
              _availableQualities.map((String quality) {
                return DropdownMenuItem<String>(
                  value: quality,
                  child: Text(quality),
                );
              }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedQuality = newValue;
              _selectedCategory = null;
              _updatePiecesInBox();
            });
          },
          validator: (value) => value == null ? 'Please select Quality' : null,
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          items:
              _availableCategories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedCategory = newValue;
              _updatePiecesInBox();
            });
          },
          validator: (value) => value == null ? 'Please select Category' : null,
          disabledHint: Text('Select Quality first'),
          decoration: _getInputDecoration('Category', prefixIcon: Icons.list),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _boxesController,
          decoration: _getInputDecoration(
            'Number of Boxes',
            prefixIcon: Icons.inventory,
          ),
          keyboardType: TextInputType.number,
          validator:
              (value) =>
                  value?.isEmpty ?? true
                      ? 'Please enter number of boxes'
                      : null,
        ),
        SizedBox(height: 16),
        InputDecorator(
          decoration: _getInputDecoration(
            'Pieces in Box',
            prefixIcon: Icons.calculate,
          ),
          child: Text(
            _piecesInBox != null
                ? _piecesInBox.toString()
                : 'Select Quality and Category',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pickup Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff548235),
          ),
        ),
        SizedBox(height: 24),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pickup Option:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: const Text('Own'),
                  leading: Radio<String>(
                    value: 'Own',
                    groupValue: _selectedPickupOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedPickupOption = value;
                        _resolvedDriverDetails = null;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Request Driver Support'),
                  leading: Radio<String>(
                    value: 'Request Driver Support',
                    groupValue: _selectedPickupOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedPickupOption = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_selectedPickupOption == 'Own') ...[
          SizedBox(height: 16),
          TextFormField(
            controller: _driverNameController,
            decoration: _getInputDecoration(
              'Driver Name',
              prefixIcon: Icons.person,
            ),
            validator:
                (value) =>
                    value?.isEmpty ?? true ? 'Please enter driver name' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _driverContactController,
            decoration: _getInputDecoration(
              'Driver Contact',
              prefixIcon: Icons.phone,
            ),
            keyboardType: TextInputType.phone,
            validator:
                (value) =>
                    value?.isEmpty ?? true
                        ? 'Please enter driver contact'
                        : null,
          ),
        ],
        if (_selectedPickupOption == 'Request Driver Support') ...[
          SizedBox(height: 16),
          TextFormField(
            controller: _shippingFromController,
            decoration: _getLocationDecoration(
              'Shipping From',
              () => _showMapLocationPicker(context, _shippingFromController),
            ),
            validator:
                (value) =>
                    value?.isEmpty ?? true
                        ? 'Please enter shipping origin'
                        : null,
            readOnly: true,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _shippingToController,
            decoration: _getLocationDecoration(
              'Shipping To',
              () => _showMapLocationPicker(context, _shippingToController),
            ),
            validator:
                (value) =>
                    value?.isEmpty ?? true
                        ? 'Please enter shipping destination'
                        : null,
            readOnly: true,
          ),
          SizedBox(height: 16),
          Obx(
            () =>
                _requestDriverSupportPending.value
                    ? Center(child: CircularProgressIndicator())
                    : (_resolvedDriverDetails == null)
                    ? ElevatedButton.icon(
                      onPressed: _requestDriverSupport,
                      icon: Icon(Icons.directions_car),
                      label: Text('Request Driver'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff548235),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                    : Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assigned Driver:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text('Name: ${_resolvedDriverDetails!['name']}'),
                            Text(
                              'Contact: ${_resolvedDriverDetails!['contact']}',
                            ),
                          ],
                        ),
                      ),
                    ),
          ),
        ],
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Packhouse Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff548235),
          ),
        ),
        SizedBox(height: 24),
        TextFormField(
          controller: _packhouseNameController,
          decoration: _getInputDecoration(
            'Packhouse Name',
            prefixIcon: Icons.business,
          ),
          validator:
              (value) =>
                  value?.isEmpty ?? true ? 'Please enter packhouse name' : null,
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _packhouseContactController,
          decoration: _getInputDecoration(
            'Packhouse Contact',
            prefixIcon: Icons.phone,
          ),
          keyboardType: TextInputType.phone,
          validator:
              (value) =>
                  value?.isEmpty ?? true
                      ? 'Please enter packhouse contact'
                      : null,
        ),
        SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: CheckboxListTile(
            title: Text('Do you have your own crates?'),
            value: _hasOwnCrates,
            onChanged: (bool? newValue) {
              setState(() {
                _hasOwnCrates = newValue ?? false;
              });
            },
            activeColor: Color(0xff548235),
          ),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Final Action',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff548235),
          ),
        ),
        SizedBox(height: 24),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consignment Status:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: const Text('Keep'),
                  leading: Radio<String>(
                    value: 'Keep',
                    groupValue: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                    activeColor: Color(0xff548235),
                  ),
                ),
                ListTile(
                  title: const Text('Release for Bid'),
                  leading: Radio<String>(
                    value: 'Release for Bid',
                    groupValue: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                    activeColor: Color(0xff548235),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bidding Partners',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff548235),
          ),
        ),
        SizedBox(height: 24),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adhani Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Adhani Option:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: const Text('Own'),
                  leading: Radio<String>(
                    value: 'Own',
                    groupValue: _selectedAdhaniOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedAdhaniOption = value;
                        _resolvedAdhaniDetails = null;
                      });
                    },
                    activeColor: Color(0xff548235),
                  ),
                ),
                ListTile(
                  title: const Text('Request Adhani Support'),
                  leading: Radio<String>(
                    value: 'Request Adhani Support',
                    groupValue: _selectedAdhaniOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedAdhaniOption = value;
                      });
                    },
                    activeColor: Color(0xff548235),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_selectedAdhaniOption == 'Own') ...[
          SizedBox(height: 16),
          TextFormField(
            controller: _adhaniNameController,
            decoration: _getInputDecoration(
              'Adhani Name',
              prefixIcon: Icons.person,
            ),
            validator:
                (value) =>
                    value?.isEmpty ?? true ? 'Please enter adhani name' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _adhaniContactController,
            decoration: _getInputDecoration(
              'Adhani Contact',
              prefixIcon: Icons.phone,
            ),
            keyboardType: TextInputType.phone,
            validator:
                (value) =>
                    value?.isEmpty ?? true
                        ? 'Please enter adhani contact'
                        : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _adhaniApmcController,
            decoration: _getInputDecoration(
              'Adhani APMC',
              prefixIcon: Icons.location_city,
            ),
            validator:
                (value) =>
                    value?.isEmpty ?? true ? 'Please enter adhani APMC' : null,
          ),
        ],
        if (_selectedAdhaniOption == 'Request Adhani Support') ...[
          SizedBox(height: 16),
          Obx(
            () =>
                _requestAdhaniSupportPending.value
                    ? Center(child: CircularProgressIndicator())
                    : (_resolvedAdhaniDetails == null)
                    ? ElevatedButton.icon(
                      onPressed: _requestAdhaniSupport,
                      icon: Icon(Icons.person_add),
                      label: Text('Request Adhani'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff548235),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                    : Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assigned Adhani:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text('Name: ${_resolvedAdhaniDetails!['name']}'),
                            Text(
                              'Contact: ${_resolvedAdhaniDetails!['contact']}',
                            ),
                            Text('APMC: ${_resolvedAdhaniDetails!['apmc']}'),
                          ],
                        ),
                      ),
                    ),
          ),
        ],
        SizedBox(height: 24),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ladhani Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Ladhani Option:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: const Text('Own'),
                  leading: Radio<String>(
                    value: 'Own',
                    groupValue: _selectedLadhaniOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedLadhaniOption = value;
                        _resolvedLadhaniDetails = null;
                      });
                    },
                    activeColor: Color(0xff548235),
                  ),
                ),
                ListTile(
                  title: const Text('Request Ladhani Support'),
                  leading: Radio<String>(
                    value: 'Request Ladhani Support',
                    groupValue: _selectedLadhaniOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedLadhaniOption = value;
                      });
                    },
                    activeColor: Color(0xff548235),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_selectedLadhaniOption == 'Own') ...[
          SizedBox(height: 16),
          TextFormField(
            controller: _ladhaniNameController,
            decoration: _getInputDecoration(
              'Ladhani Name',
              prefixIcon: Icons.person,
            ),
            validator:
                (value) =>
                    value?.isEmpty ?? true ? 'Please enter ladhani name' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _ladhaniContactController,
            decoration: _getInputDecoration(
              'Ladhani Contact',
              prefixIcon: Icons.phone,
            ),
            keyboardType: TextInputType.phone,
            validator:
                (value) =>
                    value?.isEmpty ?? true
                        ? 'Please enter ladhani contact'
                        : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _ladhaniCompanyController,
            decoration: _getInputDecoration(
              'Ladhani Company',
              prefixIcon: Icons.business,
            ),
            validator:
                (value) =>
                    value?.isEmpty ?? true
                        ? 'Please enter ladhani company'
                        : null,
          ),
        ],
        if (_selectedLadhaniOption == 'Request Ladhani Support') ...[
          SizedBox(height: 16),
          Obx(
            () =>
                _requestLadhaniSupportPending.value
                    ? Center(child: CircularProgressIndicator())
                    : (_resolvedLadhaniDetails == null)
                    ? ElevatedButton.icon(
                      onPressed: _requestLadhaniSupport,
                      icon: Icon(Icons.person_add),
                      label: Text('Request Ladhani'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff548235),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                    : Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assigned Ladhani:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text('Name: ${_resolvedLadhaniDetails!['name']}'),
                            Text(
                              'Contact: ${_resolvedLadhaniDetails!['contact']}',
                            ),
                            Text(
                              'Company: ${_resolvedLadhaniDetails!['company']}',
                            ),
                          ],
                        ),
                      ),
                    ),
          ),
        ],
      ],
    );
  }

  bool _isStepValid(int step) {
    switch (step) {
      case 0:
        return _selectedQuality != null &&
            _selectedCategory != null &&
            _boxesController.text.isNotEmpty &&
            _piecesInBox != null;
      case 1:
        if (_selectedPickupOption == null) return false;
        if (_selectedPickupOption == 'Own') {
          return _driverNameController.text.isNotEmpty &&
              _driverContactController.text.isNotEmpty;
        } else {
          return !_requestDriverSupportPending.value &&
              _resolvedDriverDetails != null &&
              _shippingFromController.text.isNotEmpty &&
              _shippingToController.text.isNotEmpty;
        }
      case 2:
        return _packhouseNameController.text.isNotEmpty &&
            _packhouseContactController.text.isNotEmpty;
      case 3:
        return _selectedStatus != null;
      case 4:
        if (_selectedStatus != 'Release for Bid') return true;

        // Validate Adhani details
        if (_selectedAdhaniOption == null) return false;
        bool adhaniValid =
            _selectedAdhaniOption == 'Own'
                ? (_adhaniNameController.text.isNotEmpty &&
                    _adhaniContactController.text.isNotEmpty &&
                    _adhaniApmcController.text.isNotEmpty)
                : (!_requestAdhaniSupportPending.value &&
                    _resolvedAdhaniDetails != null);

        // Validate Ladhani details
        if (_selectedLadhaniOption == null) return false;
        bool ladhaniValid =
            _selectedLadhaniOption == 'Own'
                ? (_ladhaniNameController.text.isNotEmpty &&
                    _ladhaniContactController.text.isNotEmpty &&
                    _ladhaniCompanyController.text.isNotEmpty)
                : (!_requestLadhaniSupportPending.value &&
                    _resolvedLadhaniDetails != null);

        return adhaniValid && ladhaniValid;
      default:
        return true;
    }
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('Consignment Details'),
        content: _buildStep1(),
        isActive: _currentStep >= 0,
        state:
            _currentStep > 0 && !_isStepValid(0)
                ? StepState.error
                : (_currentStep > 0 ? StepState.complete : StepState.indexed),
      ),
      Step(
        title: const Text('Pickup Details'),
        content: _buildStep2(),
        isActive: _currentStep >= 1,
        state:
            _currentStep > 1 && !_isStepValid(1)
                ? StepState.error
                : (_currentStep > 1 ? StepState.complete : StepState.indexed),
      ),
      Step(
        title: const Text('Packhouse Details'),
        content: _buildStep3(),
        isActive: _currentStep >= 2,
        state:
            _currentStep > 2 && !_isStepValid(2)
                ? StepState.error
                : (_currentStep > 2 ? StepState.complete : StepState.indexed),
      ),
      Step(
        title: const Text('Final Action'),
        content: _buildStep4(),
        isActive: _currentStep >= 3,
        state:
            _currentStep > 3 && !_isStepValid(3)
                ? StepState.error
                : (_currentStep > 3 ? StepState.complete : StepState.indexed),
      ),
      Step(
        title: const Text('Bidding Partners'),
        content: _buildStep5(),
        isActive: _currentStep >= 4 && _selectedStatus == 'Release for Bid',
        state:
            _currentStep > 4 && !_isStepValid(4)
                ? StepState.error
                : (_currentStep > 4 ? StepState.complete : StepState.indexed),
      ),
    ];
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
                  onStepContinue: () {
                    if (_isStepValid(_currentStep)) {
                      if (_currentStep < _buildSteps().length - 1) {
                        setState(() {
                          _currentStep += 1;
                        });
                      } else {
                        _submitForm();
                      }
                    } else {
                      Get.snackbar(
                        'Incomplete',
                        'Please fill all required fields and resolve any pending requests.',
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() {
                        _currentStep -= 1;
                      });
                    }
                  },
                  onStepTapped: (step) {
                    if (step == 4 && _selectedStatus != 'Release for Bid') {
                      Get.snackbar(
                        'Not Available',
                        'Please select "Release for Bid" status first.',
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                      return;
                    }
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
