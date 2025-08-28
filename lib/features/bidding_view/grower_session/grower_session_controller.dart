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

class GrowerSessionController extends GetxController {
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
  RxString highestBidder = "Nil".obs;
  RxString packHouseName ="".obs;
  RxString aadhatiName ="".obs;
  RxDouble highestBid = 00.00.obs;

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
    });
    _listenToSession();
    _listenToHighest();
  }




  void _listenToSession() {
    final consignmentId = glb.consignmentID.value;
    final statusRef = FirebaseDatabase.instance.ref('sessions/$consignmentId/status');
    statusRef.onValue.listen((DatabaseEvent event) async {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        final status = snapshot.value.toString();
        print("Session Status: $status");
        activeStatus.value =status;
      } else {
        print("No status data found for consignment ID: $consignmentId");
      }
    }, onError: (error) {
      print("Error listening to status stream: $error");
    });
  }


  Future<void> loadConsignment() async {
    _loadImage();
    String api = glb.url.value + "/api/consignment/${glb.consignmentID.value}";
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      searchId.value = json['searchId'] ?? '';
      growerName.value = json['growerName'] ?? '';
      aadhatiName.value =json['aadhatiId']??'';
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



  void _listenToHighest() {
    final consignmentId = glb.consignmentID.value;
    final bidderRef = FirebaseDatabase.instance.ref('sessions/$consignmentId/HighestBidder');

    bidderRef.onValue.listen((DatabaseEvent event) async {
      final snapshot = event.snapshot;

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        highestBidder.value = data['Name'].toString();
        highestBid.value = double.parse(data['Amount'].toString());
        _updateGraph();
      }

    });
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

  void giveApproval()
  {
    final consignmentId = glb.consignmentID.value;
    final userRef = FirebaseDatabase.instance.ref("sessions/$consignmentId");
    userRef.update({"growerApproval":true});
    growerApproval.value=true;
  }

}
