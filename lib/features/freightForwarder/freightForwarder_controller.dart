import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/globalMethods.dart' as glbm;
import '../../core/globals.dart' as glb;
import '../../models/freightForwarder.dart';
import '../../models/grower_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/aadhati.dart';
import '../../models/consignment_model.dart';
import '../../models/ladani_model.dart';
import 'package:http/http.dart' as http;
import '../../models/transport_model.dart';

class FreightForwarderController extends GetxController {
  // ==================== REACTIVE VARIABLES ====================
  RxString companyName = ''.obs;
  RxString licenseNumber = ''.obs;
  final galleryImages = <String>[].obs;
  final RxList<Transport> associatedTransportUnions = <Transport>[].obs;
  final details = Rx<FreightForwarder>(FreightForwarder(
    id: '',
    name: '',
    contact: '',
    address: '',
    licenseNo: '',
    forwardingSinceYears: 0,
    licensesIssuingAuthority: '',
    appleBoxesForwarded2023: 0,
    appleBoxesForwarded2024: 0,
    estimatedForwardingTarget2025: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ));
  final associatedGrowers = <Grower>[].obs;
  final associatedDrivers = <DrivingProfile>[].obs;
  final associatedAadhatis = <Aadhati>[].obs;
  final associatedLadanis = <Ladani>[].obs;
  final consignments = <Consignment>[].obs;

  // ==================== LIFECYCLE METHODS ====================
  @override
  void onInit() {
    super.onInit();
    glb.roleType.value = "Freight Forwarder";
    details.value = FreightForwarder(
      id: 'FF1',
      name: 'Sample Freight Forwarder Agency',
      contact: '+91 9876543210',
      address: '123 Main Street, City',
      licenseNo: 'FF123456',
      forwardingSinceYears: 5,
      licensesIssuingAuthority: 'Authority A',
      locationOnGoogle: 'Lat: 20.0, Lng: 70.0',
      appleBoxesForwarded2023: 1000,
      appleBoxesForwarded2024: 1200,
      estimatedForwardingTarget2025: 1500,
      tradeLicenseOfAadhatiAttached: 'TL123',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    loadData();
  }

  Future<void> loadData()
  async{
    String apiurl = glb.url + "/api/freightforwarders/${glb.id.value}";
    final response = await http.get(Uri.parse(apiurl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body)["data"];
      glb.personName.value = data['name'];
      glb.personPhone.value = "+91" + data['contact'];
      details.value = FreightForwarder(
        id: data['_id'],
        name: data["name"],
        contact: data['contact'],
        address: data['address'],
        licenseNo: data['licenseNo'],
        forwardingSinceYears: data['forwadingExperience'],
        licensesIssuingAuthority: data['issuingAuthority'],
        locationOnGoogle: data['locationOnGoogle'],
        appleBoxesForwarded2023:data['appleBoxesT2'],
        appleBoxesForwarded2024: data['appleBoxesT1'],
        estimatedForwardingTarget2025:data['appleBoxesT0'],
        tradeLicenseOfAadhatiAttached: data['tradeLicenseOfAadhatiAttached'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      associatedGrowers.value = glbm.createGrowerListFromApi(data['grower_IDs']);
      associatedDrivers.value =glbm.createDriverListFromApi(data['driver_IDs']);
      associatedTransportUnions.value =glbm.createTransportListFromApi(data['transportUnion_IDs']);
      associatedAadhatis.value =glbm.createAadhatiListFromApi(data['aadhati_IDs']);
      associatedLadanis.value =glbm.createLadaniListFromApi(data['buyer_IDs']);



    }}

  // ==================== GROWER MANAGEMENT METHODS ====================
  void addAssociatedGrower(Grower agent) {
    if (agent.id == null) {
      createGrower(agent);
    } else {
      associatedGrowers.add(agent);
      uploadGrower(agent.id!);
    }
  }

  void removeAssociatedGrower(String id) {
    associatedGrowers.removeWhere((grower) => grower.id == id);
  }

  Future<void> createGrower(Grower agent) async {
    String apiUrl = glb.url + '/api/growers';
    try {
      final Map<String, dynamic> body = {
        'name': agent.name,
        'phoneNumber': agent.phoneNumber,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        associatedGrowers.add(agent);
        print(data["_id"]);
        await Future.delayed(Duration(seconds: 3));
        uploadGrower(data["_id"]);
        Get.snackbar('Success', 'Agent created successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to create agent: \n${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create agent: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  uploadGrower(String agentID) async {
    final String apiUrl = glb.url + '/api/freightforwarders/${glb.id.value}/add-grower';
    print(apiUrl);
    final Map<String, dynamic> updatePayload = {'growerId': agentID};
    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatePayload),
      );
      if (response.statusCode == 200) {
        print("Sucess");
        Get.snackbar('Success', 'Grower updated successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to update grower: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update grower: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ==================== DRIVER MANAGEMENT METHODS ====================
  void addAssociatedDriver(DrivingProfile driver) {
    if (driver.id == null) {
      createDriver(driver);
    } else {
      uploadDriver(driver.id!);
      associatedDrivers.add(driver);
    }
  }

  void removeAssociatedDriver(String id) {
    associatedDrivers.removeWhere((driver) => driver.id == id);
  }

  Future<void> createDriver(DrivingProfile driver) async {
    String apiUrl = glb.url + '/api/drivers/create';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"name": driver.name, "contact": driver.contact}),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        Future.delayed(Duration(seconds: 3));
        print(data['_id']);
        uploadDriver(data['_id']);
        associatedDrivers.add(driver);
      } else {}
    } catch (e) {
      Get.snackbar('Error', 'Failed to create Driver: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  uploadDriver(String driverID) async {
    final String apiUrl = glb.url + '/api/freightforwarders/${glb.id.value}/add-driver';
    print(apiUrl);
    final Map<String, dynamic> updatePayload = {'driverId': driverID};
    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatePayload),
      );
      if (response.statusCode == 200) {
        print("Sucess");
        Get.snackbar('Success', 'Grower updated successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to update grower: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update grower: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  // ==================== AADHATI MANAGEMENT METHODS ====================
  void addAssociatedAadhatis(Aadhati agent) {
    if (agent.id == null) {
      createAgent(agent);
    } else {
      associatedAadhatis.add(agent);
      uploadAgent(agent.id!);
    }
  }


  Future<void> createAgent(Aadhati agent) async {
    String apiUrl = glb.url + '/api/agents';
    try {
      final Map<String, dynamic> body = {
        'name': agent.name,
        'contact': agent.contact,
        'apmc_ID': agent.apmc,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        associatedAadhatis.add(agent);
        print(data["_id"]);
        await Future.delayed(Duration(seconds: 3));
        uploadAgent(data["_id"]);
        Get.snackbar('Success', 'Agent created successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to create agent: \n${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create agent: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  uploadAgent(String agentID) async {
    final String apiUrl =
        glb.url + '/api/freightforwarders/${glb.id.value}/add-commission-agent';
    print(apiUrl);
    final Map<String, dynamic> updatePayload = {'commissionAgentId': agentID};
    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatePayload),
      );
      if (response.statusCode == 200) {
        print("Sucess");
        Get.snackbar('Success', 'Grower updated successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to update grower: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update grower: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void removeAssociatedAadhati(String id) {
    associatedAadhatis.removeWhere((aadhati) => aadhati.id == id);
  }

  // ==================== LADANI MANAGEMENT METHODS ====================
  void addAssociatedLadani(Ladani ladani) {
    if (ladani.id == null) {
      createLadani(ladani);
    } else {
      uploadLadani(ladani.id!);
      associatedLadanis.add(ladani);
    }
  }

  void removeAssociatedLadani(String id) {
    associatedLadanis.removeWhere((ladani) => ladani.id == id);
  }

  Future<void> createLadani(Ladani ladani) async {
    String apiUrl = glb.url + '/api/buyers';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"name": ladani.name, "contact": ladani.contact, "nameOfFirm":ladani.nameOfTradingFirm,"address": ladani.address}),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        print(data['_id']);
        uploadLadani(data['_id']);
        associatedLadanis.add(ladani);
      } else {}
    } catch (e) {
      Get.snackbar('Error', 'Failed to create Driver: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void uploadLadani(String id) async {
    final String apiUrl = glb.url + '/api/freightforwarders/${glb.id.value}/add-ladani';
    print(apiUrl);
    final Map<String, dynamic> updatePayload = {'buyerID': id};
    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatePayload),
      );
      if (response.statusCode == 200) {
        print("Sucess");
        Get.snackbar('Success', 'Grower updated successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to update grower: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update grower: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ==================== TRANSPORT UNION MANAGEMENT METHODS ====================
  void addAssociatedTransportUnion(Transport union) {
    if (union.id == null) {
      createTransportunion(union);
    } else {
      associatedTransportUnions.add(union);
      uploadTransport(union.id!);
    }
  }

  Future<void> createTransportunion(Transport union) async {
    String apiUrl = glb.url + '/api/transportunion/create';
    try {
      final Map<String, dynamic> body = {
        'name': union.name,
        'contact': union.contact,
        'address': union.address,
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        associatedTransportUnions.add(union);
        print(data["_id"]);
        uploadTransport(data["_id"]);
      } else {
        Get.snackbar('Error', 'Failed to create agent: \n${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create agent: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  uploadTransport(String agentID) async {
    final String apiUrl =
        glb.url + '/api/freightforwarders/${glb.id.value}/add-transport-union';
    print(apiUrl);

    final Map<String, dynamic> updatePayload = {'transportUnionId': agentID};
    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatePayload),
      );
      if (response.statusCode == 200) {
        print("Sucess");
      } else {
        Get.snackbar('Error', 'Failed to update grower: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update grower: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void removeAssociatedTransportUnion(String id) {
    associatedTransportUnions.removeWhere((tu) => tu.id == id);
  }

  // ==================== CONSIGNMENT MANAGEMENT METHODS ====================
  void addConsignments(Consignment consignment) {
    if (!consignments.any((g) => g.id == consignment.id)) {
      consignments.add(consignment);
    }
  }

  void removeConsignment(String id) {
    consignments.removeWhere((consignment) => consignment.id == id);
  }

  // ==================== GALLERY MANAGEMENT METHODS ====================
  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // In a real app, you would upload the image to a server and get back a URL
      // For now, we'll just use the local path
      galleryImages.add(image.path);
    }
  }

  void removeGalleryImage(String imageUrl) {
    galleryImages.remove(imageUrl);
  }
}
