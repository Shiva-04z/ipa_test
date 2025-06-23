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
  void addOrchard(Orchard orchard) {
    orchards.add(orchard);
    _updateGrower();
  }

  void updateOrchard(Orchard orchard) {
    final index = orchards.indexWhere((o) => o.id == orchard.id);
    if (index != -1) {
      orchards[index] = orchard;
      _updateGrower();
    }
  }

  void removeOrchard(String orchardId) {
    orchards.removeWhere((o) => o.id == orchardId);
    _updateGrower();
  }

  // Methods for managing commission agents
  void addCommissionAgent(Aadhati agent) {
    commissionAgents.add(agent);
    _updateGrower();
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
    _updateGrower();
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
    packingHouses.add(house);
    _updateGrower();
  }

  void updatePackingHouse(PackHouse house) {
    final index = packingHouses.indexWhere((h) => h.id == house.id);
    if (index != -1) {
      packingHouses[index] = house;
      _updateGrower();
    }
  }

  void removePackingHouse(String houseId) {
    packingHouses.removeWhere((h) => h.id == houseId);
    _updateGrower();
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
    drivers.add(driver);
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
    transportUnions.add(union);
  }

  void removeTransportUnion(String id) {
    transportUnions.removeWhere((union) => union.id == id);
  }

  // Methods for managing freight forwarders
  void addFreightForwarder(FreightForwarder forwarder) {
    freightForwarders.add(forwarder);
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
    hpmcDepots.add(hpmc);
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

    String apiUrl =
        'https://bml-m3ps.onrender.com/api/growers/${glb.id.value}';

    try {

      final uri = Uri.parse(apiUrl);
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 10)) // Add timeout
          .catchError((e) {
        print("HTTP request error: $e");
        throw Exception("HTTP request failed: $e");
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        orchards.clear();
        commissionAgents.clear();
        packingHouses.clear();
        consignments.clear();
        freightForwarders.clear();
        drivers.clear();
        transportUnions.clear();

        if (data['orchard_IDs'] != null) {
          final orchardFutures = (data['orchard_IDs'] as List)
              .map((id) => fetchOrchardById(id as String));
          orchards.addAll(await Future.wait(orchardFutures));
        }
        if (data['aadhati_IDs'] != null) {
          final agentFutures = (data['aadhati_IDs'] as List)
              .map((id) => fetchAadhatiById(id as String));
          commissionAgents.addAll(await Future.wait(agentFutures));
        }
        // Fetch and add packing houses
        if (data['packhouse_IDs'] != null) {
          final houseFutures = (data['packhouse_IDs'] as List)
              .map((id) => fetchPackHouseById(id as String));
          packingHouses.addAll(await Future.wait(houseFutures));
        }
        if (data['consignment_IDs'] != null) {
          final consignmentFutures = (data['consignment_IDs'] as List)
              .map((id) => fetchConsignmentById(id as String));
          consignments.addAll(await Future.wait(consignmentFutures));
        }
        if (data['freightForwarder_IDs'] != null) {
          final ffFutures = (data['freightForwarder_IDs'] as List)
              .map((id) => fetchFreightForwarderById(id as String));
          freightForwarders.addAll(await Future.wait(ffFutures));
        }

        if (data['driver_IDs'] != null) {
          final driverFutures = (data['driver_IDs'] as List)
              .map((id) => fetchDriverById(id as String));
          drivers.addAll(await Future.wait(driverFutures));
        }
        if (data['transportUnion_IDs'] != null) {
          final tuFutures = (data['transportUnion_IDs'] as List)
              .map((id) => fetchTransportUnionById(id as String));
          transportUnions.addAll(await Future.wait(tuFutures));
        }
      } else {}
    } catch (e) {
      rethrow; // Or handle it appropriately
    } finally {}
  }

  // Helper methods for fetching by ID
  Future<Orchard> fetchOrchardById(String id) async {
    final response = await http
        .get(Uri.parse('https://bml-m3ps.onrender.com/api/orchards/$id'));
    if (response.statusCode == 200) {
      return Orchard.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load orchard $id');
    }
  }

  Future<Aadhati> fetchAadhatiById(String id) async {
    final response = await http
        .get(Uri.parse('https://bml-m3ps.onrender.com/api/aadhatis/$id'));
    if (response.statusCode == 200) {
      return Aadhati.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load aadhati $id');
    }
  }

  Future<PackHouse> fetchPackHouseById(String id) async {
    final response = await http
        .get(Uri.parse('https://bml-m3ps.onrender.com/api/packhouses/$id'));
    if (response.statusCode == 200) {
      return PackHouse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load packhouse $id');
    }
  }

  Future<Consignment> fetchConsignmentById(String id) async {
    final response = await http
        .get(Uri.parse('https://bml-m3ps.onrender.com/api/consignments/$id'));
    if (response.statusCode == 200) {
      return Consignment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load consignment $id');
    }
  }

  Future<FreightForwarder> fetchFreightForwarderById(String id) async {
    final response = await http.get(
        Uri.parse('https://bml-m3ps.onrender.com/api/freightForwarders/$id'));
    if (response.statusCode == 200) {
      return FreightForwarder.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load freight forwarder $id');
    }
  }

  Future<DrivingProfile> fetchDriverById(String id) async {
    final response = await http
        .get(Uri.parse('https://bml-m3ps.onrender.com/api/drivers/$id'));
    if (response.statusCode == 200) {
      return DrivingProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load driver $id');
    }
  }

  Future<Transport> fetchTransportUnionById(String id) async {
    final response = await http.get(
        Uri.parse('https://bml-m3ps.onrender.com/api/transportUnions/$id'));
    if (response.statusCode == 200) {
      return Transport.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load transport union $id');
    }
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
  }

  Future<void> updateGrowerToApi() async {
    if (grower.value == null) return;
    final String apiUrl =
        'https://bml-m3ps.onrender.com/api/growers/${grower.value!.id}'; // Replace with actual endpoint
    final Map<String, dynamic> updatePayload = {
      'orchard_IDs': orchards.map((o) => o.id).toList(),
      'aadhati_IDs': commissionAgents.map((a) => a.id).toList(),
      'packhouse_IDs': packingHouses.map((p) => p.id).toList(),
      'consignment_IDs': consignments.map((c) => c.id).toList(),
      'freightForwarder_IDs': freightForwarders.map((f) => f.id).toList(),
      'driver_IDs': drivers.map((d) => d.id).toList(),
      'transportUnion_IDs': transportUnions.map((t) => t.id).toList(),
      // Add other fields as needed
    };
    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatePayload),
      );
      if (response.statusCode == 200) {
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
}
