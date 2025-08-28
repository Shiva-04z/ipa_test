import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../core/globals.dart' as glb;
import 'package:http/http.dart' as http;

import '../../../models/bilty_model.dart';
import '../../../models/consignment_model.dart';


class BidderSessionController extends GetxController {

  RxString bidderName = "Shivalik".obs;
  TextEditingController bidValueController = TextEditingController();
  Rxn<Consignment> consignment = Rxn<Consignment>();
  RxMap<String, List<double>> qualityWeights = <String, List<double>>{}.obs;
  RxMap<String, List<double>> qualityPrices = <String, List<double>>{}.obs;
  RxMap<String, List<double>> qualityLandingCosts = <String, List<double>>{}.obs;
  RxMap<String, List<String>> qualityCategories = <String, List<String>>{}.obs;
  RxMap<String, double> qualityTotalWeights = <String, double>{}.obs;
  RxMap<String, double> qualityTotalPrices = <String, double>{}.obs;
  RxString activeStatus ="inactive".obs;
  RxString error = ''.obs;

  RxString biddingType1 = "Gadd".obs;
  RxString biddingType2 = "Per Kg".obs;
  late StreamSubscription _bidsSubscription;
  RxString highestBidder ="Nil".obs;
  RxDouble highestBid =0.00.obs;
  RxDouble landingCost= 0.0.obs;

  Rx<Bilty> bilty = Bilty.createDefault().obs;
  RxString searchId = ''.obs;
  RxString growerName = ''.obs;
  RxString date ="".obs;
  RxString startTime ="".obs;
  RxBool canStart =true.obs;
  RxString packHouseName = "".obs;
  RxString aadhatiName = "".obs;


  RxList<String> productLabels =<String> [].obs;
  RxList<double> productWeights = <double>[].obs;
  RxList<double> productPrices = <double>[].obs;



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



  @override
  void onInit() {
    super.onInit();
    loadConsignment();
    _listenToSession();
    _listenToHighest();
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
      print("Here goes ${aadhatiName.value}");
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



  void _listenToSession() {
    final consignmentId = glb.consignmentID.value;
    final statusRef = FirebaseDatabase.instance.ref('sessions/$consignmentId/status');
    statusRef.onValue.listen((DatabaseEvent event) async {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        final status = snapshot.value.toString();
        print("Session Status: $status");
        activeStatus.value =status;
        if (status == 'active') {
          TextEditingController nameFieldController = TextEditingController();
          TextEditingController biddingFieldController = TextEditingController();
          RxString name = glb.personName;
          bidderName.value =name.value;
          nameFieldController.text = name.value;
          biddingFieldController.text = "${glb.landingPrice.value}" ;
          Get.defaultDialog(
            title: "⚠️ Bidding Alert",
            titleStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange[800],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning highlight box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange[300]!, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow[100]!,
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    "You are about to join Bidding.\nPlease enter the Landing Cost.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[900],
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Name input field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      labelText: "Your name in bidding",
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue[400]!, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),

                // Bidding price input field with info icon
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: biddingFieldController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: "Your Landing Cost",
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue[400]!, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      suffixIcon: Tooltip(
                        message: "You can change this value mid-session",
                        triggerMode: TooltipTriggerMode.tap,
                        child: Icon(Icons.info_outline, color: Colors.blue[400]),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey[400]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          name.value = nameFieldController.text.trim();
                          bidderName.value = name.value;

                          // Parse landing cost or use default
                          try {
                            final price = double.tryParse(biddingFieldController.text.trim()) ?? glb.landingPrice.value;
                            // Update your price value here (add your logic)
                            landingCost.value = price;
                            // e.g., glb.landingPrice.value = price;
                          } catch (e) {

                            // e.g., glb.landingPrice.value = glb.defaultLandingPrice;
                          }

                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[600],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            backgroundColor: Colors.grey[50],
            radius: 12,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          );

          final biddingRef = FirebaseDatabase.instance.ref('sessions/$consignmentId/bidding');

          final existingSnapshot = await biddingRef.child(glb.id.value).get();
          if (!existingSnapshot.exists) {
            await biddingRef.child(glb.id.value).set({
              'name': glb.personName.value,
              'amount': 0,
            });
            print("Added ${glb.id.value} to bidding.");
          } else {
            print("${glb.id.value} already exists in bidding.");
          }
        }
      } else {
        print("No status data found for consignment ID: $consignmentId");
      }
    }, onError: (error) {
      print("Error listening to status stream: $error");
    });
  }


  void pushBids() {
    final bidText = bidValueController.text.trim();

    if (bidText.isEmpty) {
      print("Bid value is empty.");
      return;
    }

    final value = num.tryParse(bidText); // accepts both int and double
    if (value == null) {
      print("Invalid bid value.");
      return;
    }

    final consignmentId = glb.consignmentID.value;
    final userId = glb.id.value;

    final amountRef = FirebaseDatabase.instance
        .ref('sessions/$consignmentId/bidding/$userId');

    amountRef.update({"amount": value,"name":bidderName.value}).then((_) {
      print("Bid updated successfully: $value");
    }).catchError((error) {
      print("Failed to update bid: $error");
    });
  }

}
