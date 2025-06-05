import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../core/globals.dart';
import '../../models/commission_agent_model.dart';
import '../../models/corporate_company_model.dart';
import '../../models/grower_model.dart';
import '../../models/orchard_model.dart';
import '../../models/packing_house_status_model.dart';
import '../../models/consignment_model.dart';

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
  RxList<CommissionAgent> get commissionAgents => grower.commissionAgents.obs;
  RxList<CorporateCompany> get corporateCompanies =>
      grower.corporateCompanies.obs;
  RxList<PackingHouse> get packingHouses => grower.packingHouses.obs;
  RxList<Consignment> get consignments => grower.consignments.obs;

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
  void addCommissionAgent(CommissionAgent agent) {
    final updatedGrower = grower.copyWith(
      commissionAgents: [...grower.commissionAgents, agent],
      updatedAt: DateTime.now(),
    );
    globalGrower.value = updatedGrower;
  }

  void updateCommissionAgent(CommissionAgent agent) {
    final index = grower.commissionAgents.indexWhere((a) => a.id == agent.id);
    if (index != -1) {
      final updatedAgents = List<CommissionAgent>.from(grower.commissionAgents);
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
  void addCorporateCompany(CorporateCompany company) {
    final updatedGrower = grower.copyWith(
      corporateCompanies: [...grower.corporateCompanies, company],
      updatedAt: DateTime.now(),
    );
    globalGrower.value = updatedGrower;
  }

  void updateCorporateCompany(CorporateCompany company) {
    final index = grower.corporateCompanies.indexWhere(
      (c) => c.id == company.id,
    );
    if (index != -1) {
      final updatedCompanies = List<CorporateCompany>.from(
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
  void addPackingHouse(PackingHouse house) {
    final updatedGrower = grower.copyWith(
      packingHouses: [...grower.packingHouses, house],
      updatedAt: DateTime.now(),
    );
    globalGrower.value = updatedGrower;
  }

  void updatePackingHouse(PackingHouse house) {
    final index = grower.packingHouses.indexWhere((h) => h.id == house.id);
    if (index != -1) {
      final updatedHouses = List<PackingHouse>.from(grower.packingHouses);
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
