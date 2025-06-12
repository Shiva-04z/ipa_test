import '../../core/global_role_loader.dart';
import 'package:apple_grower/models/ladani_model.dart';
import 'package:apple_grower/models/pack_house_model.dart';
import 'package:apple_grower/models/freightForwarder.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/globals.dart';
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

  // Getter for the global grower instance
  Grower get grower => globalGrower.value;

  // Observable lists
  RxList<Orchard> get orchards => grower.orchards.obs;
  RxList<Aadhati> get commissionAgents => grower.commissionAgents.obs;
  RxList<Ladani> get corporateCompanies => grower.corporateCompanies.obs;
  RxList<PackHouse> get packingHouses => grower.packingHouses.obs;
  RxList<Consignment> get consignments => grower.consignments.obs;
  RxList<DrivingProfile> drivers = <DrivingProfile>[].obs;
  final RxList<String> galleryImages = <String>[].obs;
  final transportUnions = <Transport>[].obs;
  final freightForwarders = <FreightForwarder>[].obs;

  // Methods for managing orchards
  void addOrchard(Orchard orchard) {
    final updatedGrower = grower.copyWith(
      orchards: [...grower.orchards, orchard],
      updatedAt: DateTime.now(),
    );
    globalGrower.value = updatedGrower;
  }

  void updateOrchard(Orchard orchard) {
    final index = grower.orchards.indexWhere((o) => o.id == orchard.id);
    if (index != -1) {
      final updatedOrchards = List<Orchard>.from(grower.orchards);
      updatedOrchards[index] = orchard;
      final updatedGrower = grower.copyWith(
        orchards: updatedOrchards,
        updatedAt: DateTime.now(),
      );
      globalGrower.value = updatedGrower;
    }
  }

  void removeOrchard(String orchardId) {
    final updatedOrchards =
        grower.orchards.where((o) => o.id != orchardId).toList();
    final updatedGrower = grower.copyWith(
      orchards: updatedOrchards,
      updatedAt: DateTime.now(),
    );
    globalGrower.value = updatedGrower;
  }

  // Methods for managing commission agents
  void addCommissionAgent(Aadhati agent) {
    final updatedGrower = grower.copyWith(
      commissionAgents: [...grower.commissionAgents, agent],
      updatedAt: DateTime.now(),
    );
    globalGrower.value = updatedGrower;
  }

  void updateCommissionAgent(Aadhati agent) {
    final index = grower.commissionAgents.indexWhere((a) => a.id == agent.id);
    if (index != -1) {
      final updatedAgents = List<Aadhati>.from(grower.commissionAgents);
      updatedAgents[index] = agent;
      final updatedGrower = grower.copyWith(
        commissionAgents: updatedAgents,
        updatedAt: DateTime.now(),
      );
      globalGrower.value = updatedGrower;
    }
  }

  void removeCommissionAgent(String agentId) {
    final updatedAgents =
        grower.commissionAgents.where((a) => a.id != agentId).toList();
    final updatedGrower = grower.copyWith(
      commissionAgents: updatedAgents,
      updatedAt: DateTime.now(),
    );
    globalGrower.value = updatedGrower;
  }

  // Methods for managing corporate companies
  void addCorporateCompany(Ladani company) {
    final updatedGrower = grower.copyWith(
      corporateCompanies: [...grower.corporateCompanies, company],
      updatedAt: DateTime.now(),
    );
    globalGrower.value = updatedGrower;
  }

  void updateCorporateCompany(Ladani company) {
    final index = grower.corporateCompanies.indexWhere(
      (c) => c.id == company.id,
    );
    if (index != -1) {
      final updatedCompanies = List<Ladani>.from(
        grower.corporateCompanies,
      );
      updatedCompanies[index] = company;
      final updatedGrower = grower.copyWith(
        corporateCompanies: updatedCompanies,
        updatedAt: DateTime.now(),
      );
      globalGrower.value = updatedGrower;
    }
  }

  void removeCorporateCompany(String companyId) {
    final updatedCompanies =
        grower.corporateCompanies.where((c) => c.id != companyId).toList();
    final updatedGrower = grower.copyWith(
      corporateCompanies: updatedCompanies,
      updatedAt: DateTime.now(),
    );
    globalGrower.value = updatedGrower;
  }

  // Methods for managing packing houses
  void addPackingHouse(PackHouse house) {
    final updatedGrower = grower.copyWith(
      packingHouses: [...grower.packingHouses, house],
      updatedAt: DateTime.now(),
    );
    globalGrower.value = updatedGrower;
  }

  void updatePackingHouse(PackHouse house) {
    final index = grower.packingHouses.indexWhere((h) => h.id == house.id);
    if (index != -1) {
      final updatedHouses = List<PackHouse>.from(grower.packingHouses);
      updatedHouses[index] = house;
      final updatedGrower = grower.copyWith(
        packingHouses: updatedHouses,
        updatedAt: DateTime.now(),
      );
      globalGrower.value = updatedGrower;
    }
  }

  void removePackingHouse(String houseId) {
    final updatedHouses =
        grower.packingHouses.where((h) => h.id != houseId).toList();
    final updatedGrower = grower.copyWith(
      packingHouses: updatedHouses,
      updatedAt: DateTime.now(),
    );
    globalGrower.value = updatedGrower;
  }

  // Methods for managing consignments
  void addConsignment(Consignment consignment) {
    final updatedGrower = grower.copyWith(
      consignments: [...grower.consignments, consignment],
      updatedAt: DateTime.now(),
    );
    globalGrower.value = updatedGrower;
  }

  void updateConsignment(Consignment consignment) {
    final index = grower.consignments.indexWhere((c) => c.id == consignment.id);
    if (index != -1) {
      final updatedConsignments = List<Consignment>.from(grower.consignments);
      updatedConsignments[index] = consignment;
      final updatedGrower = grower.copyWith(
        consignments: updatedConsignments,
        updatedAt: DateTime.now(),
      );
      globalGrower.value = updatedGrower;
    }
  }

  void removeConsignment(String consignmentId) {
    final updatedConsignments =
        grower.consignments.where((c) => c.id != consignmentId).toList();
    final updatedGrower = grower.copyWith(
      consignments: updatedConsignments,
      updatedAt: DateTime.now(),
    );
    globalGrower.value = updatedGrower;
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
        'Failed to pick image: ${e.toString()}',
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
