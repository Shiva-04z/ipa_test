import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/globalMethods.dart' as glbm;
import '../../core/globals.dart' as glb;
import '../../models/hpmc_collection_center_model.dart';
import '../../models/grower_model.dart';
import '../../models/consignment_model.dart';
import '../../models/pack_house_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/transport_model.dart';
import 'package:http/http.dart' as http;

class HPAgriBoardController extends GetxController {
  // ==================== REACTIVE VARIABLES ====================
  final details = <String, String>{}.obs;
  final associatedGrowers = <Grower>[].obs;
  final associatedDrivers = <DrivingProfile>[].obs;
  final consignments = <Consignment>[].obs;
  final galleryImages = <String>[].obs;
  final RxList<Transport> associatedTransportUnions = <Transport>[].obs;
  final RxList<PackHouse> associatedPackHouses = <PackHouse>[].obs;

  // ==================== SAMPLE DATA ====================
  Rx<HpmcCollectionCenter> sampleCollectionCenter = HpmcCollectionCenter(
    id: 'HPMC001',
    HPMCname: 'Rajesh Kumar',
    operatorName: 'Vikram Singh',
    cellNo: '9876543210',
    aadharNo: '123456789012',
    licenseNo: 'HPMC2024001',
    operatingSince: "2015",
    location: 'Kotkhai, Shimla',
    boxesTransported2023: 250,
    boxesTransported2024: 100,
    target2025: 300.0,
    associatedGrowers: [
      Grower(
        id: 'G001',
        name: 'Ramesh Chand',
        aadharNumber: '123456789013',
        phoneNumber: '9876543211',
        address: 'Kotkhai, Shimla',
        pinCode: '171201',
        orchards: [],
        commissionAgents: [],
        corporateCompanies: [],
        consignments: [],
        packingHouses: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Grower(
        id: 'G002',
        name: 'Suresh Kumar',
        aadharNumber: '123456789014',
        phoneNumber: '9876543212',
        address: 'Kotkhai, Shimla',
        pinCode: '171201',
        orchards: [],
        commissionAgents: [],
        corporateCompanies: [],
        consignments: [],
        packingHouses: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ],
  ).obs;

  // ==================== LIFECYCLE METHODS ====================
  @override
  void onInit() {
    super.onInit();
    glb.loadIDData();
    glb.roleType.value = "HPMC DEPOT";
    loadData();
  }

  // ==================== DATA LOADING METHODS ====================
  Future<void> loadData()
  async{
    String apiurl = glb.url + "/api/hpmcDepot/${glb.id.value}";
    final response = await http.get(Uri.parse(apiurl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body)['data'];
      glb.personName.value = data['operatorName'];
      glb.personPhone.value = "+91" + data['cellNo'];
      associatedGrowers.value = glbm.createGrowerListFromApi(data['grower_IDs']);
      associatedDrivers.value =glbm.createDriverListFromApi(data['drivers_IDs']);
      associatedTransportUnions.value =glbm.createTransportListFromApi(data['transportUnions_IDs']);
      associatedPackHouses.value=glbm.createPackhouseListFromApi(data['packhouse_IDs']);
      galleryImages.value = (data['gallery'] as List).map((item) => item['url'] as String).where((url) => url.isNotEmpty).toList();
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
    final String apiUrl =
        glb.url + '/api/hpmcDepot/${glb.id.value}/add-grower';
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

  // ==================== PACKHOUSE MANAGEMENT METHODS ====================
  void addAssociatedPackHouse(PackHouse house) {
    if (house.id != null) {
      associatedPackHouses.add(house);
      uploadPackHouse(house.id!);
    } else {
      createPackhouse(house);
    }
  }

  Future<void> createPackhouse(PackHouse packhouse) async {
    String apiUrl = glb.url + '/api/packhouse';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(packhouse.toJson()),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Future.delayed(Duration(seconds: 3));
        uploadPackHouse(data['_id']);
        associatedPackHouses.add(packhouse);

        Get.snackbar('Success', 'Orchard created successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to create orchard: \n${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create orchard: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  uploadPackHouse(String houseId) async {
    final String apiUrl =
        glb.url + '/api/hpmcDepot/${glb.id.value}/add-packhouse';
    print(apiUrl);
    final Map<String, dynamic> updatePayload = {'packhouseId': houseId};
    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatePayload),
      );
      if (response.statusCode == 200) {
        print("Success");
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

  void removeAssociatedPackHouse(String id) {
    associatedPackHouses.removeWhere((ladani) => ladani.id == id);
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
    final String apiUrl = glb.url + '/api/hpmcDepot/${glb.id.value}/add-driver';
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
        glb.url + '/api/hpmcDepot/${glb.id.value}/add-transport-union';
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
  void addConsignment(Consignment consignment) {
    if (!consignments.any((c) => c.id == consignment.id)) {
      consignments.add(consignment);
    }
  }

  void removeConsignment(String id) {
    consignments.removeWhere((consignment) => consignment.id == id);
  }

  // ==================== GALLERY MANAGEMENT METHODS ====================
  void addGalleryImage(String imageUrl) {
    galleryImages.add(imageUrl);
  }

  void removeGalleryImage(String imageUrl) {
    galleryImages.remove(imageUrl);
  }

  Future<void> pickAndUploadImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        glb.isUploading.value = true;
        // Use the correct endpoint and pass the XFile
        final result = await glb.uploadImage(
          image,
          uploadEndpoint: '/api/hpmcDepot/${glb.id.value}/upload',
        );
        glb.isUploading.value = false;

        if (result != null) {
          galleryImages.add(result); // or parse result if it's a URL
          Get.snackbar('Success', 'Image uploaded successfully!');
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
}
