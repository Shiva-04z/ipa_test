import 'package:apple_grower/models/freightForwarder.dart';
import 'package:get/get.dart';
import '../../models/grower_model.dart';
import '../../models/ladani_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/consignment_model.dart';

class AadhatiController extends GetxController {
  final details = <String, String>{}.obs;
  final associatedGrowers = <Grower>[].obs;
  final associatedBuyers = <FreightForwarder>[].obs;
  final associatedLadanis = <Ladani>[].obs;
  final associatedDrivers = <DrivingProfile>[].obs;
  final consignments = <Consignment>[].obs;

  @override
  void onInit() {
    super.onInit();
    details['Name'] = 'Sample Aadhati';
    details['Phone'] = '1234567890';
    details['APMC'] = 'Sample APMC';
    details['Address'] = 'Sample Address';
  }

  void addAssociatedGrower(Grower grower) {
    if (!associatedGrowers.any((g) => g.id == grower.id)) {
      associatedGrowers.add(grower);
    }
  }

  void addConsignment(Consignment consignment) {
    if (!consignments.any((c) => c.id == consignment.id)) {
      consignments.add(consignment);
    }
  }
  void removeAssociatedGrower(String id) {
    associatedGrowers.removeWhere((grower) => grower.id == id);
  }

  void addAssociatedBuyer(FreightForwarder buyer) {
    if (!associatedBuyers.any((g) => g.id == buyer.id)) {
      associatedBuyers.add(buyer);
    }
  }

  void removeAssociatedBuyer(String id) {
    associatedBuyers.removeWhere((buyer) => buyer.id == id);
  }

  void addAssociatedLadani(Ladani buyer) {
    if (!associatedLadanis.any((g) => g.id == buyer.id)) {
      associatedLadanis.add(buyer);
    }
  }

  void removeAssociatedLadani(String id) {
    associatedLadanis.removeWhere((ladani) => ladani.id == id);
  }

  void addAssociatedDriver(DrivingProfile driver) {
    if (!associatedDrivers.any((g) => g.id == driver.id)) {
      associatedDrivers.add(driver);
    }
  }

  void removeAssociatedDriver(String id) {
    associatedDrivers.removeWhere((driver) => driver.id == id);
  }

  void addAssociatedConsignment(Consignment consignment) {
    if (!consignments.any((g) => g.id == consignment.id)) {
      consignments.add(consignment);
    }
  }
  void removeConsignment(String id) {
    consignments.removeWhere((consignment) => consignment.id == id);
  }
}
