import 'package:apple_grower/models/freightForwarder.dart';
import 'package:apple_grower/models/pack_house_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/grower_model.dart';
import '../../models/ladani_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/consignment_model.dart';
import '../../models/transport_model.dart';
import '../../models/employee_model.dart';

class AadhatiController extends GetxController {
  final details = <String, String>{}.obs;
  final associatedGrowers = <Grower>[].obs;
  final associatedBuyers = <FreightForwarder>[].obs;
  final associatedLadanis = <Ladani>[].obs;
  final associatedDrivers = <DrivingProfile>[].obs;
  final consignments = <Consignment>[].obs;
  final galleryImages = <String>[].obs;

  // Transport Unions
  final RxList<Transport> associatedTransportUnions = <Transport>[].obs;
  final RxList<PackHouse> associatedPackHouses = <PackHouse>[].obs;

  // Staff Management
  final RxMap<String, Employee> staff = <String, Employee>{}.obs;

  RxString key = "".obs;
  @override
  void onInit() {
    super.onInit();
    details['Name'] = 'Sample Aadhati';
    details['Phone'] = '1234567890';
    details['APMC'] = 'Sample APMC';
    details['Address'] = 'Sample Address';
  }

  void addStaff(Employee employee) {
    staff[key.value] = employee;
    print(
        'Added staff: ${key.value} - ${employee.name} - ${employee.phoneNumber}');
  }

  void addAssociatedGrower(Grower grower) {
    if (!associatedGrowers.any((g) => g.id == grower.id)) {
      associatedGrowers.add(grower);
    }
  }

  void addAssociatedPackhouses(PackHouse house) {
    if (!associatedPackHouses.any((g) => g.id == house.id)) {
      associatedPackHouses.add(house);
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

  void removeAssociatedPackhouse(String id) {
    associatedPackHouses.removeWhere((ladani) => ladani.id == id);
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

  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Here you would typically upload the image to your storage service
      // For now, we'll just add the local path to the gallery
      galleryImages.add(image.path);
    }
  }

  void removeGalleryImage(String imageUrl) {
    galleryImages.remove(imageUrl);
  }

  void addAssociatedTransportUnion(Transport union) {
    associatedTransportUnions.add(union);
  }

  void removeAssociatedTransportUnion(String id) {
    associatedTransportUnions.removeWhere((union) => union.id == id);
  }

  void removeStaff(String role) {
    staff.remove(role);
  }
}
