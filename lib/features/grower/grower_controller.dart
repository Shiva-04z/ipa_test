import 'package:apple_grower/models/hpmc_collection_center_model.dart';

import '../../core/global_role_loader.dart';
import 'package:apple_grower/models/ladani_model.dart';
import 'package:apple_grower/models/pack_house_model.dart';
import 'package:apple_grower/models/freightForwarder.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../core/globals.dart';
import '../../core/globals.dart' as glb;
import '../../models/aadhati.dart';
import '../../models/grower_model.dart';
import '../../models/orchard_model.dart';
import '../../models/consignment_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/transport_model.dart';

class GrowerController extends GetxController {
  // Text Controllers
  final orchardName = TextEditingController();
  final totalTrees = TextEditingController();
  final commissionAgent = TextEditingController();
  final commissionAgentPhone = TextEditingController();
  final packHouseName = TextEditingController();
  final packHousePhone = TextEditingController();
  final packHouseAddress = TextEditingController();
  final packHouseOwn = false.obs;
  final selectedApmc = ''.obs;
  final selectedHarvestDate = DateTime.now().obs;
  final selectedLocation = ''.obs;
  final selectedPackhouseId = ''.obs;

  // Store Grower model and associated objects
  final Rx<Grower?> grower = Rx<Grower?>(null);
  final RxList<Orchard> orchards = <Orchard>[].obs;
  final RxList<Aadhati> commissionAgents = <Aadhati>[].obs;
  final RxList<Ladani> corporateCompanies = <Ladani>[].obs;
  final RxList<PackHouse> packingHouses = <PackHouse>[].obs;
  final RxList<Consignment> consignments = <Consignment>[].obs;
  final RxList<DrivingProfile> drivers = <DrivingProfile>[].obs;
  final RxList<HpmcCollectionCenter> hpmcDepots = <HpmcCollectionCenter>[].obs;
  final RxList<String> galleryImages = <String>[].obs;
  final RxList<Transport> transportUnions = <Transport>[].obs;
  final RxList<FreightForwarder> freightForwarders = <FreightForwarder>[].obs;

  // Methods for managing orchards
  void addOrchard(Orchard orchard) async {

    await createOrchard(orchard);

  }

  void updateOrchard(Orchard orchard) {

    final index = orchards.indexWhere((o) => o.id == orchard.id);
    if (index != -1) {
      orchards[index] = orchard;
      updateOrchardApi(orchard);
    }
  }

  updateOrchardApi(Orchard orchard)
  async {
    final apiUrl = glb.url + "/api/orchards/${orchard.id!}";
    final payload = <String, dynamic>{
      'name': orchard.name,
      'location': orchard.location,
      'fruitingTrees': orchard.numberOfFruitingTrees,
      'harvestDateExpected': orchard.expectedHarvestDate.toIso8601String(),
      'boundaryPoints': orchard.boundaryPoints
          .map((point) => {'lat': point.latitude, 'lng': point.longitude})
          .toList(),
      'area': orchard.area,
      'boundaryImage': orchard.boundaryImagePath,
      'harvestStatus': 'open', // or 'closed' if you have logic for it
      if (orchard.estimatedBoxes != null)
        'estimatedBoxes': orchard.estimatedBoxes,
      if (orchard.actualHarvestDate != null)
        'actualHarvestDate': orchard.actualHarvestDate!.toIso8601String(),
      'cropstage': orchard.cropStage.toString().split('.').last,
      'cropQuality': {
        'antiHailNet':
        orchard.quality.markers[QualityMarker.antiHailNet] != QualityStatus.poor,
        'openFarm':
        orchard.quality.markers[QualityMarker.openFarm] != QualityStatus.poor,
        'HailingMarks':
        orchard.quality.markers[QualityMarker.hailingMarks] != QualityStatus.poor,
        'Russetting':
        orchard.quality.markers[QualityMarker.russetting] != QualityStatus.poor,
        'UnderSize':
        orchard.quality.markers[QualityMarker.underSize] != QualityStatus.poor,
      },
    };

    final response  = await http.put(Uri.parse(apiUrl),headers: {"Content-Type":"application-json"}
        ,body: jsonEncode(payload)
    );

    if(response.statusCode ==200||response.statusCode==201)
      {
        print("Sucessful");
      }

  }


  void removeOrchard(String orchardId) {
    orchards.removeWhere((o) => o.id == orchardId);
    _updateGrower();
  }

  // Methods for managing commission agents
  void addCommissionAgent(Aadhati agent) {
    if (agent.id == null) {
      createAgent(agent);
    } else {
      commissionAgents.add(agent);
      updateGrowerAgent(agent.id!);
    }
  }

  Future<void> createAgent(Aadhati agent) async {
    String apiUrl =
        glb.url + '/api/agents'; // Use the correct endpoint for agents
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
        commissionAgents.add(agent);
        print(data["_id"]);
        await Future.delayed(Duration(seconds: 3));
        updateGrowerAgent(data["_id"]);
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

  updateGrowerAgent(String agentID) async {
    final String apiUrl =
        glb.url + '/api/growers/${glb.id.value}/add-commission-agent';
    print(apiUrl);
    // Replace with actual endpoint
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

  updateGrowerTransport(String agentID) async {
    final String apiUrl =
        glb.url + '/api/growers/${glb.id.value}/add-transport-union';
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

  void updateCommissionAgent(Aadhati agent) {
    final index = commissionAgents.indexWhere((a) => a.id == agent.id);
    if (index != -1) {
      commissionAgents[index] = agent;
      _updateGrower();
    }
  }

  void removeCommissionAgent(String agentId) {
    commissionAgents.removeWhere((a) => a.id == agentId);
  }

  // Methods for managing corporate companies
  void addCorporateCompany(Ladani company) {
    corporateCompanies.add(company);
    _updateGrower();
  }

  void updateCorporateCompany(Ladani company) {
    final index = corporateCompanies.indexWhere((c) => c.id == company.id);
    if (index != -1) {
      corporateCompanies[index] = company;
      _updateGrower();
    }
  }

  void removeCorporateCompany(String companyId) {
    corporateCompanies.removeWhere((c) => c.id == companyId);
    _updateGrower();
  }

  // Methods for managing packing houses
  void addPackingHouse(PackHouse house) {
    if (house.id == null) {
      packingHouses.add(house);
      updateGrowerPackHouse(house.id!);
    } else {
      createPackhouse(house);
    }
  }

  updateGrowerPackHouse(String houseId) async {
    final String apiUrl =
        glb.url + '/api/growers/${glb.id.value}/add-packhouse';
    print(apiUrl);
    // Replace with actual endpoint
    final Map<String, dynamic> updatePayload = {'packhouseId': houseId};
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

  void updatePackingHouse(PackHouse house) {
    final index = packingHouses.indexWhere((h) => h.id == house.id);
    if (index != -1) {
      packingHouses[index] = house;
    }
  }

  void removePackingHouse(String houseId) {
    packingHouses.removeWhere((h) => h.id == houseId);
  }

  // Methods for managing consignments
  void addConsignment(Consignment consignment) {
    consignments.add(consignment);

    _updateGrower();
  }

  void updateConsignment(Consignment consignment) {
    final index = consignments.indexWhere((c) => c.id == consignment.id);
    if (index != -1) {
      consignments[index] = consignment;
      _updateGrower();
    }
  }

  void removeConsignment(String consignmentId) {
    consignments.removeWhere((c) => c.id == consignmentId);
    _updateGrower();
  }

  void addDriver(DrivingProfile driver) {
    if (driver.id == null) {
      createDriver(driver);
      ;
    } else {
      updateGrowerDriver(driver.id!);
    }
  }

  Future<void> createDriver(DrivingProfile driver) async {
    String apiUrl = glb.url +
        '/api/drivers/create'; // Replace with your actual endpoint if different
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
        updateGrowerDriver(data['_id']);
        drivers.add(driver);
      } else {}
    } catch (e) {
      Get.snackbar('Error', 'Failed to create Driver: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  updateGrowerDriver(String driverID) async {
    final String apiUrl = glb.url + '/api/growers/${glb.id.value}/add-driver';
    print(apiUrl);
    // Replace with actual endpoint
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

  void removeDriver(String id) {
    drivers.removeWhere((driver) => driver.id == id);
  }

  Future<void> pickAndUploadImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // TODO: Implement image upload to your storage service
        // For now, we'll just add the local path to demonstrate the UI
        galleryImages.add(image.path);
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
    // TODO: Implement image deletion from your storage service
  }

  void addTransportUnion(Transport union) {
    if(union.id ==null) {
      createTransportunion(union);
      }
      else{
        transportUnions.add(union);
        updateGrowerTransport(union.id!);
    }
  }

  Future<void> createTransportunion(Transport union) async {
    String apiUrl =
        glb.url + '/api/transportunion/create'; // Use the correct endpoint for agents
    try {
      final Map<String, dynamic> body = {
        'name': union.name,
        'contact': union.contact,
        'address' : union.address,
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        transportUnions.add(union);
        print(data["_id"]);
        updateGrowerTransport(data["_id"]);

      } else {
        Get.snackbar('Error', 'Failed to create agent: \n${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create agent: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }


  void removeTransportUnion(String id) {
    transportUnions.removeWhere((union) => union.id == id);
  }

  // Methods for managing freight forwarders
  void addFreightForwarder(FreightForwarder forwarder) {
    if(forwarder.id == null) {
      createForwarder(forwarder);
    }else{
      updateGrowerForwarder(forwarder.id!);
      freightForwarders.add(forwarder);
    }

  }

  createForwarder( FreightForwarder forwarder) async
  {
    String apiUrl =
        glb.url + '/api/freightforwarders/create'; // Use the correct endpoint for agents
    try {
      final Map<String, dynamic> body = {
        'name': forwarder.name,
        'contact': forwarder.contact,
        'address' :forwarder.address,
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        freightForwarders.add(forwarder);
        print(data["_id"]);
        updateGrowerForwarder(data["_id"]);

      } else {
        Get.snackbar('Error', 'Failed to create agent: \n${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create agent: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  updateGrowerForwarder(String agentID)
  async {
    final String apiUrl =
        glb.url + '/api/growers/${glb.id.value}/add-freight-forwarder';
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

  void updateFreightForwarder(FreightForwarder forwarder) {
    final index = freightForwarders.indexWhere((f) => f.id == forwarder.id);
    if (index != -1) {
      freightForwarders[index] = forwarder;
    }
  }

  void removeFreightForwarder(String id) {
    freightForwarders.removeWhere((f) => f.id == id);
  }

  void addHpmc(HpmcCollectionCenter hpmc) {
   if(hpmc.id==null)
     {
       createHpmc(hpmc);
     }
   else
     {
       hpmcDepots.add(hpmc);
       updateGrowerHPMC(hpmc.id!);
     }
  }

  createHpmc(HpmcCollectionCenter hpmc) async {
    String apiUrl =
        glb.url + '/api/hpmcDepot/create'; // Use the correct endpoint for agents
    try {
      final Map<String, dynamic> body = {
        'hpmcname': hpmc.HPMCname,
        'operatorname': hpmc.operatorName,
        'cellNo': hpmc.cellNo,
        'location': hpmc.location,
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
     ;
     hpmcDepots.add(hpmc);
        print(data["_id"]);
        updateGrowerHPMC(data['_id']);

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

  updateGrowerHPMC(String agentID)
  async {
    final String apiUrl =
        glb.url + '/api/growers/${glb.id.value}/add-hpmc-depot';
    print(apiUrl);

    final Map<String, dynamic> updatePayload = {'hpmcDepotId': agentID};
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

  void removeHpmc(String id) {
    hpmcDepots.removeWhere((f) => f.id == id);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadGrowerData();
  }

  Future<void> loadGrowerData() async {
    print("Hello grower");
  }

  void _updateGrower() {
    if (grower.value != null) {
      grower.value = grower.value!.copyWith(
        orchards: orchards,
        commissionAgents: commissionAgents,
        corporateCompanies: corporateCompanies,
        packingHouses: packingHouses,
        consignments: consignments,
      );
    }
    updateGrowerToApi();
  }

  Future<void> updateGrowerToApi() async {
    final String apiUrl =
        'https://bml-m3ps.onrender.com/api/growers/${glb.id.value}';
    print(apiUrl);
    // Replace with actual endpoint
    final Map<String, dynamic> updatePayload = {
      'orchard_IDs': orchards.map((o) => o.id).toList(),
      'aadhati_IDs': commissionAgents.map((c) => c.id).toList(),
      'packhouse_IDs': packingHouses.map((p) => p.id).toList(),
      'consignment_IDs': consignments.map((c) => c.id).toList(),
      'freightForwarder_IDs': freightForwarders.map((f) => f.id).toList(),
      'driver_IDs': drivers.map((d) => d.id).toList(),
      'transportUnion_IDs': transportUnions.map((t) => t.id).toList(),
    };
    try {
      final response = await http.put(
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

  Future<void> createOrchard(Orchard orchard) async {
    String apiUrl = glb.url +
        '/api/orchards'; // Replace with your actual endpoint if different
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': orchard.name,
          'location': orchard.location,
          'flutternumberOfFruitingTrees': orchard.numberOfFruitingTrees,
          'harvestDateExpected': orchard.expectedHarvestDate.toIso8601String(),
          'boundaryPoints': orchard.boundaryPoints,
          'area': orchard.area
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        orchard = orchard.copyWith(id : data['_id']);
        updateGrowerOrchard(data['_id']);
        orchards.add(orchard);

        Get.snackbar('Success', 'Orchard created successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to create orchard: \\n${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create orchard: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> createPackhouse(PackHouse packhouse) async {
    String apiUrl = glb.url +
        '/api/packhouse'; // Replace with your actual endpoint if different
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(packhouse.toJson()),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Future.delayed(Duration(seconds: 3));
        updateGrowerPackHouse(data['_id']);
        packingHouses.add(packhouse);

        Get.snackbar('Success', 'Orchard created successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to create orchard: \\n${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create orchard: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    orchardName.dispose();
    totalTrees.dispose();
    commissionAgent.dispose();
    commissionAgentPhone.dispose();
    packHouseName.dispose();
    packHousePhone.dispose();
    packHouseAddress.dispose();
    super.onClose();
  }

  Future<void> updateGrowerOrchard(String id) async {
    final apiurl = glb.url + '/api/growers/${glb.id.value}/add-orchard';
    try {
      final Map<String, dynamic> uploadPayload = {'orchardId': id};
      final response = await http.patch(Uri.parse(apiurl),
          body: jsonEncode(uploadPayload),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Added to Grower");
      }
    } catch (e) {
      Get.snackbar("Failure", e.toString());
    }
  }
}
