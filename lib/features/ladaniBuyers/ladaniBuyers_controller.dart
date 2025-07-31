import 'dart:convert';

import 'package:apple_grower/models/freightForwarder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/globalMethods.dart' as glbm;
import '../../core/globals.dart' as glb;
import '../../models/aadhati.dart';
import '../../models/transport_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/consignment_model.dart';
import 'package:http/http.dart' as http;


class LadaniBuyersController extends GetxController {
  // ==================== REACTIVE VARIABLES ====================
  RxString companyName = ''.obs;
  RxString businessType = ''.obs;
  final galleryImages = <String>[].obs;
  final details = {}.obs;
  final associatedAadhatis = <Aadhati>[].obs;
  final associatedBuyers = <FreightForwarder>[].obs;
  final associatedDrivers = <DrivingProfile>[].obs;
  final associatedTransportUnions = <Transport>[].obs;
  final consignments = <Consignment>[].obs;

  // ==================== LIFECYCLE METHODS ====================
  @override
  void onInit() {
    super.onInit(
    );
    loadData();
    // Initialize with sample data
    details.value = {
      'name': 'Sample Ladani',
      'phoneNumber': '+1234567890',
      'address': 'Sample Address',
      'apmc': 'Sample APMC',
    };
    loadData();
  }

  Future<void> loadData()
  async{
    String apiurl = glb.url + "/api/buyers/${glb.id.value}";
    final response = await http.get(Uri.parse(apiurl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      glb.personName.value = data['name'];
      glb.personPhone.value = "+91" + data['contact'];
      details.value = {
        'name': data['name'],
        'phoneNumber': data['contact'],
        'address': data['address'],

      };
      associatedDrivers.value =glbm.createDriverListFromApi(data['driver_IDs']);
      associatedAadhatis.value =glbm.createAadhatiListFromApi(data['aadhati_IDs']);
      associatedTransportUnions.value =glbm.createTransportListFromApi(data['transportUnion_IDs']);
      associatedBuyers.value =glbm.createFreightListFromApi(data['freightForwarder_IDs']);
      final allConsignments =
      glbm.createConsignmentListFromApi(data['consignment_IDs']);
      glb.allConsignments.value = allConsignments
          .where((c) => c.currentStage == 'Bidding Invite')
          .toList();
      consignments.value = allConsignments
          .where((c) => c.currentStage != 'Bidding Invite')
          .toList();


      galleryImages.value = (data['gallery'] as List).map((item) => item['url'] as String).where((url) => url.isNotEmpty).toList();

      glb.landingPrice.value = (data['perBoxExpensesAfterBidding'] as num?)?.toDouble() ?? 0.0;
    }}



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
        glb.url + '/api/buyers/${glb.id.value}/add-commission-agent';
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

  // ==================== BUYER MANAGEMENT METHODS ====================
  void removeAssociatedBuyer(String id) {
    associatedBuyers.removeWhere((buyer) => buyer.id == id);
  }

  void  addAssociatedBuyers(FreightForwarder forwarder) {
    if (forwarder.id == null) {
      createForwarder(forwarder);
    } else {
      uploadForwarder(forwarder.id!);
      associatedBuyers.add(forwarder);
    }
  }

  createForwarder(FreightForwarder forwarder) async {
    String apiUrl = glb.url + '/api/freightforwarders/create';
    try {
      final Map<String, dynamic> body = {
        'name': forwarder.name,
        'contact': forwarder.contact,
        'address': forwarder.address,
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        associatedBuyers.add(forwarder);
        print(data["_id"]);
        uploadForwarder(data["_id"]);
      } else {
        Get.snackbar('Error', 'Failed to create agent: \n${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create agent: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  uploadForwarder(String agentID) async {
    final String apiUrl =
        glb.url + '/api/buyers/${glb.id.value}/add-freight-forwarder';
    print(apiUrl);

    final Map<String, dynamic> updatePayload = {'freightForwarderId': agentID};
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

  // ==================== DRIVER MANAGEMENT METHODS ====================
  void addAssociatedDrivers(DrivingProfile driver) {
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
    final String apiUrl = glb.url + '/api/buyers/${glb.id.value}/add-driver';
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
        glb.url + '/api/buyers/${glb.id.value}/add-transport-union';
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
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        glb.isUploading.value = true;
        // Use the correct endpoint and pass the XFile
        final result = await glb.uploadImage(image, uploadEndpoint: '/api/buyers/${glb.id.value}/upload',);
        glb.isUploading.value = false;

        if (result != null) {
          galleryImages.add(result); // or parse result if it's a URL

        } else {
          Get.snackbar('Upload Failed', 'Image upload failed.');
        }
      }

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: \\n${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeGalleryImage(String imageUrl) {
    galleryImages.remove(imageUrl);
  }
}
