import 'package:apple_grower/models/employee_model.dart';
import 'package:get/get.dart';
import '../../core/globals.dart' as glb;
import '../../models/hpmc_collection_center_model.dart';
import '../../models/pack_house_model.dart';
import '../../models/grower_model.dart';
import '../../models/aadhati.dart';
import '../../models/ladani_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/consignment_model.dart';
import '../../core/global_role_loader.dart' as gld;
import 'package:image_picker/image_picker.dart';

class PackHouseController extends GetxController {
  // Observable lists for all associated entities
  final RxList<Grower> associatedGrowers = <Grower>[].obs;
  final RxList<Aadhati> associatedAadhatis = <Aadhati>[].obs;
  final RxList<Ladani> associatedLadanis = <Ladani>[].obs;
  final RxList<Employee> associatedPackers = <Employee>[].obs;
  final RxList<DrivingProfile> associatedDrivers = <DrivingProfile>[].obs;
  final RxList<dynamic> associatedFreightForwarders = <dynamic>[].obs;
  final RxList<dynamic> associatedTransportUnions = <dynamic>[].obs;
  final RxList<Consignment> consignments = <Consignment>[].obs;
  final RxList<String> galleryImages = <String>[].obs;
  RxList<HpmcCollectionCenter> hpmcDepots = <HpmcCollectionCenter>[].obs;
  String name = gld.packHouse.value.name;
  final Map details = {
    'Grading Machine': '${gld.packHouse.value.gradingMachineCapacity}',
    'Sorting Machine': '${gld.packHouse.value.sortingMachineCapacity}',
    'Daily Capacity': '${gld.packHouse.value.perDayCapacity}',
    'Crates': '${gld.packHouse.value.numberOfCrates}',
    'Boxes 2023': '${gld.packHouse.value.boxesPacked2023}',
    'Boxes 2024': '${gld.packHouse.value.boxesPacked2024}',
    'Boxes 2025': '${gld.packHouse.value.estimatedBoxes2025}',
  }.obs;

  void removeAssociatedGrower(String id) {
    associatedGrowers.removeWhere((grower) => grower.id == id);
  }

  void removeAssociatedAadhati(String id) {
    associatedAadhatis.removeWhere((aadhati) => aadhati.id == id);
  }

  void removeAssociatedLadani(String id) {
    associatedLadanis.removeWhere((ladani) => ladani.id == id);
  }

  void removeAssociatedPacker(String id) {
    associatedPackers.removeWhere((packer) => packer.id == id);
  }

  void removeAssociatedDriver(String id) {
    associatedDrivers.removeWhere((driver) => driver.id == id);
  }

  void removeAssociatedFreightForwarder(String id) {
    associatedFreightForwarders.removeWhere((ff) => ff.id == id);
  }

  void removeAssociatedTransportUnion(String id) {
    associatedTransportUnions.removeWhere((tu) => tu.id == id);
  }

  // Methods to add associated entities
  void addAssociatedGrower(Grower grower) {
    if (!associatedGrowers.any((g) => g.id == grower.id)) {
      associatedGrowers.add(grower);
    }
  }

  void addAssociatedAadhati(Aadhati aadhati) {
    if (!associatedAadhatis.any((a) => a.id == aadhati.id)) {
      associatedAadhatis.add(aadhati);
    }
  }

  void addAssociatedLadani(Ladani ladani) {
    if (!associatedLadanis.any((l) => l.id == ladani.id)) {
      associatedLadanis.add(ladani);
    }
  }

  void addAssociatedPacker(Employee packer) {
    if (!associatedPackers.any((p) => p.id == packer.id)) {
      associatedPackers.add(packer);
    }
  }

  void addAssociatedDriver(DrivingProfile driver) {
    if (!associatedDrivers.any((d) => d.id == driver.id)) {
      associatedDrivers.add(driver);
    }
  }

  void addAssociatedFreightForwarder(dynamic freightForwarder) {
    if (!associatedFreightForwarders
        .any((ff) => ff.id == freightForwarder.id)) {
      associatedFreightForwarders.add(freightForwarder);
    }
  }

  void addAssociatedTransportUnion(dynamic transportUnion) {
    if (!associatedTransportUnions.any((tu) => tu.id == transportUnion.id)) {
      associatedTransportUnions.add(transportUnion);
    }
  }

  void addConsignment(Consignment consignment) {
    if (!consignments.any((c) => c.id == consignment.id)) {
      consignments.add(consignment);
    }
  }

  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Here you would typically upload the image to your storage
      // For now, we'll just add the path to the list
      galleryImages.add(image.path);
    }
  }

  void removeGalleryImage(String imageUrl) {
    galleryImages.remove(imageUrl);
  }

  void addHpmc(HpmcCollectionCenter hpmc) {
    hpmcDepots.add(hpmc);
  }

  void removeHpmc(String id) {
    hpmcDepots.removeWhere((f) => f.id == id);
  }
  // Method to load initial data
  @override
  void onInit() {
    super.onInit();
    glb.roleType.value="PackHouse";
  }
}
