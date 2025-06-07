import 'package:apple_grower/models/freightForwarder.dart';
import 'package:get/get.dart';
import '../../models/aadhati.dart';
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
    // Initialize with sample data or load from API
    details['Name'] = 'Sample Aadhati';
    details['Phone'] = '1234567890';
    details['APMC'] = 'Sample APMC';
    details['Address'] = 'Sample Address';
  }

  void removeAssociatedGrower(String id) {
    associatedGrowers.removeWhere((grower) => grower.id == id);
  }

  void removeAssociatedBuyer(String id) {
    associatedBuyers.removeWhere((buyer) => buyer.id == id);
  }

  void removeAssociatedLadani(String id) {
    associatedLadanis.removeWhere((ladani) => ladani.id == id);
  }

  void removeAssociatedDriver(String id) {
    associatedDrivers.removeWhere((driver) => driver.id == id);
  }

  void removeConsignment(String id) {
    consignments.removeWhere((consignment) => consignment.id == id);
  }
}
