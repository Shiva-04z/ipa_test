import 'dart:async';

import 'package:flutter/cupertino.dart' as pw;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:apple_grower/models/bilty_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import '../../../core/globals.dart' as glb;
import 'package:apple_grower/models/consignment_model.dart';

class AadhatiSessionController extends GetxController {
  // Separate data for each quality
  RxMap<String, List<double>> qualityWeights = <String, List<double>>{}.obs;
  RxMap<String, List<double>> qualityPrices = <String, List<double>>{}.obs;
  RxMap<String, List<double>> qualityLandingCosts =
      <String, List<double>>{}.obs;
  RxMap<String, List<String>> qualityCategories = <String, List<String>>{}.obs;
  RxMap<String, double> qualityTotalWeights = <String, double>{}.obs;
  RxMap<String, double> qualityTotalPrices = <String, double>{}.obs;
  RxString biddingType1 = "Gadd".obs;
  RxString biddingType2 = "Per Kg".obs;
  late StreamSubscription _bidsSubscription;
  RxDouble baseAmount = 0.0.obs;
  RxString highestBidder = "Nil".obs;
  RxDouble highestBid = 00.00.obs;
  RxDouble gaddPrice = 0.0.obs;
  RxString packHouseName="".obs;

  RxList<String> productLabels = [
    'ELLMS',
    'ES,EES,240',
    'Pittu',
    'Sepeartor',
    'AA EElMS',
    "AA ES,EES,240",
    "AA Sepertaor"
  ].obs;
  RxList<double> productWeights =
      [1000.0, 950.0, 630.0, 780.0, 900.0, 800.0, 850.0].obs;
  RxList<double> productPrices =
      [120.0, 150.0, 100.0, 170.0, 190.0, 220.0, 230.0].obs;

  RxBool sessionActive = false.obs;
  RxString error = ''.obs;
  DatabaseReference? _sessionRef;
  Stream<DatabaseEvent>? _analyticsStream;
  RxBool growerApproval = false.obs;
  RxMap<String, String> highestBidderPerQuality = <String, String>{}.obs;
  RxMap<String, double> highestLandingPerQuality = <String, double>{}.obs;
  Rxn<Consignment> consignment = Rxn<Consignment>();
  RxString highestTotals = "".obs;
  RxString activeStatus = "inactive".obs;

  Rx<Bilty> bilty = Bilty.createDefault().obs;
  RxString searchId = ''.obs;
  RxString growerName = ''.obs;
  RxString date = "".obs;
  RxString startTime = "".obs;
  RxBool canStart = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadConsignment().then((_) async {
      await ensureSessionExists();
      _listenToGrowerApproval();
    });
    _listenToBids();
  }

  _loadData(Bilty bilty) {
    // Initialize the fixed label groups
    final Map<String, List<String>> qualityGroups = {
      'AAA ELLMS': [
        'Extra Large',
        'Large',
        'Medium',
        'Small',
        'Extra Small',
        'E Extra Small'
      ],
      'AAA Pittu/Sep/240': ['240 Count', 'Pittu', 'Seprator'],
      'AA ELLMS': [
        'Extra Large',
        'Large',
        'Medium',
        'Small',
        'Extra Small',
        'E Extra Small'
      ],
      'AA Pittu/Sep/240': ['240 Count', 'Pittu', 'Seprator'],
      'GP': ['Large', 'Medium', 'Small', 'Extra Small'],
      'Mix/Pear': ['Mix & Pears']
    };

    // Initialize result lists
    List<String> qualityLabels = [];
    List<double> kgList = [];
    List<double> priceList = [];

    // Process each group
    qualityGroups.forEach((groupLabel, categories) {
      double groupWeight = 0;
      double groupPrice = 0;


      // Check each category in the group
      for (var category in bilty.categories) {
        if (categories.contains(category.category)) {
          if (category.quality == groupLabel.split(' ')[0] ||
              (groupLabel == 'GP' && category.quality == 'GP') ||
              (groupLabel == 'Mix/Pear' && category.quality == 'Mix/Pear')) {
            groupWeight += category.totalWeight;
            if(groupPrice==0.0) {
              groupPrice = category.pricePerKg;
            }
          }
        }
      }

      // Only add the group if it has data

        qualityLabels.add(groupLabel);
        kgList.add(groupWeight);
        priceList.add(groupPrice);

    });
    productLabels.value = qualityLabels;
    productWeights.value = kgList;
    productPrices.value = priceList;
  }

  Future<void> loadConsignment() async {
    _loadImage();
    String api = glb.url.value + "/api/consignment/${glb.consignmentID.value}";
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      searchId.value = json['searchId'] ?? '';
      growerName.value = json['growerName'] ?? '';
      packHouseName.value=json['packhouseId']?? "Self";
      if (json['bilty'] != null) {
        bilty.value = Bilty.fromJson(json['bilty']);
        print(bilty.value);
        _loadData(bilty.value);
      }
    }
  }
  Future<void> _loadImage() async {
    final imageBytes =
    (await rootBundle.load('assets/images/apple.png')).buffer.asUint8List();
    // 3. Assign the loaded image to the reactive variable.
    // The UI will automatically update.
    glb.logoImage.value = pw.MemoryImage(imageBytes);
  }
  void _listenToGrowerApproval() {
    final consignmentId = glb.consignmentID.value;
    final approvalRef =
        FirebaseDatabase.instance.ref('sessions/$consignmentId/growerApproval');
    approvalRef.onValue.listen((event) {
      final value = event.snapshot.value;
      growerApproval.value = value == true;
    });
  }



  Future<void> startSession() async {
    activeStatus.value = "active";
    final consignmentId = glb.consignmentID.value;
    _sessionRef = FirebaseDatabase.instance.ref('sessions/$consignmentId');
    await _sessionRef!.update({
      'status': 'active',
      'biddingTypes': [biddingType1.value, biddingType2.value],
    });
  }

  Future<void> endSession() async {
    activeStatus.value = "completed";
    final consignmentId = glb.consignmentID.value;
    if (_sessionRef == null) {
      _sessionRef = FirebaseDatabase.instance.ref('sessions/$consignmentId');
    }
    await _sessionRef!.update({
      'status': 'completed',
      'endedAt': DateTime.now().toIso8601String(),
    }); // S// et prices by category
    gaddPrice.value = highestBid.value;
      final bilty2 = bilty.value;
      final newCategories = bilty2.categories.map((cat) {
        if (cat.boxCount == 0) return cat;
        double? newPrice;
        if (cat.quality.toUpperCase() == 'AAA' &&(cat.category != "240 Count" && cat.category != "Pittu" && cat.category != "Seprator")) {
          newPrice = gaddPrice.value;
        } else if (cat.quality.toUpperCase() == 'GP') {
          newPrice = gaddPrice.value + 10;
        } else if (cat.quality == "AAA") {
          newPrice = (0.6 * gaddPrice.value) ;
        }
        else{
          newPrice = (0.5 * gaddPrice.value);
        }
        if (newPrice != null) {
          final newTotalPrice =
              newPrice * cat.totalWeight;
          final newBoxValue =
              newTotalPrice / cat.boxCount;
          double roundTo2(double value) => double.parse(value.toStringAsFixed(2));

          return cat.copyWith(
            pricePerKg: roundTo2(newPrice),
            totalPrice: roundTo2(newTotalPrice),
            boxValue: roundTo2(newBoxValue),
          );
        }
        return cat;
      }).toList();
     bilty.value =
          bilty2.copyWith(categories: newCategories);

     uploadBilty();
  }




  updateBilty() async {

    print("here it is ${bilty.value.categories.first.totalPrice}");
    print(bilty.value);
    String api = "${glb.url.value}/api/bilty/${bilty.value.id}";
    Map<String, dynamic> data = bilty.value.toJson();
    print(data);
    final respone = await http.put(Uri.parse(api),
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});
  }



  Future<void> ensureSessionExists() async {
    final consignmentId = glb.consignmentID.value;
    final sessionRef = FirebaseDatabase.instance.ref('sessions/$consignmentId');
    final snapshot = await sessionRef.get();
    if (!snapshot.exists) {
      // Build analytics data
      highestBid.value = productPrices.first;
      await sessionRef.set({
        'status': 'inactive',
        'startedAt': DateTime.now().toIso8601String(),
        'bidders': {},
        'growerApproval': false,
        'HighestBidder': {"Name": "Unknown", "Amount": productPrices.first}
      });
    }
    else
      {
        final data = snapshot.value as Map<dynamic, dynamic>;

        // Assuming activeStatus is an RxString or similar
        activeStatus.value = data['status'] ?? 'inactive';
      }
  }

  // Helper to sanitize Firebase keys
  String sanitizeKey(String key) {
    return key.replaceAll(RegExp(r'[.#\$\[\]/]'), '_');
  }

  Future<void> _listenToBids() async {
    final consignmentId = glb.consignmentID.value;
    final sessionRef =
        FirebaseDatabase.instance.ref('sessions/$consignmentId/HighestBidder');
    DatabaseReference bidsRef =
        FirebaseDatabase.instance.ref('sessions/$consignmentId/bidding');
    _bidsSubscription = bidsRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final allBids = Map<String, dynamic>.from(event.snapshot.value as Map);
        allBids.forEach((bidderId, bidData) async {
          final bidInfo = Map<String, dynamic>.from(bidData as Map);
          final double amount = (bidInfo['amount'] ?? 0) * 1.0;
          if (amount > highestBid.value) {
            highestBid.value = amount;
            _updateGraph();
            highestBidder.value =
                (bidInfo['name'] ?? 'Unknown Bidder') as String;
            await sessionRef.update(
                {"Name": highestBidder.value, "Amount": highestBid.value});
          }
        });
      }
    });


  }



  Future<dynamic> uploadBilty() async {
    await updateBilty();
    String api = glb.url.value +
        "/api/consignment/${glb.consignmentID.value}/add-bilty-aadhati";
    Map<String, dynamic> data = {
      "currentStage": "Completed"
    };
    final respone = await http.patch(Uri.parse(api),
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});
  }

  void completeSession()
  {

  }

  _updateGraph()
  {
    print("yes");

    if(biddingType2 =="Per Kg"){
      print("HighestBid");
      productPrices.value=[highestBid.value,highestBid.value*0.6,highestBid.value*0.5,highestBid.value*0.5,highestBid.value+10,highestBid.value*0.5];

    }
    else
    {
      double x = highestBid.value/20.0 ;
      productPrices.value=[x,x*0.6,x*0.5,x*0.5,x+10,x*0.5];

    }
  }

}
