import 'package:animations/animations.dart';
import 'package:apple_grower/features/bidding_view/donut.dart';
import 'package:apple_grower/navigation/routes_constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/globals.dart' as glb;
import '../../forms/consignmentForm/biltydownloadandshare.dart' as btds;
import '../chart.dart';
import '../chart2.dart';
import 'bidder_session_controller.dart';

class BidderSessionView extends GetView<BidderSessionController> {
  final Map<String, Map<String, TextEditingController>> bidControllers = {};
  final Map<String, Map<String, bool>> bidSubmitted = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Live Bidding Session',style: TextStyle(color: Colors.white),),

          backgroundColor: Colors.green.shade900,
          centerTitle: true,
        ),
        body: Obx(() => (controller.activeStatus.value == 'completed')
            ? _buildCompletedMessage()
            : (controller.activeStatus.value == 'active')
                ? _buildActiveDisplay()
                : _buildInactiveMessage()));
  }

  Widget _buildInactiveMessage() {
    return Center(
      child: Card(
        color: Colors.white,
        child: Container(
          height: 200,
          width: 300,
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Icon(
                  Icons.warning,
                  color: Colors.orange,
                  size: 64,
                ),
              ),
              Center(
                child: Text(
                  "Aadhati has not Started Bidding yet",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedMessage() {
    return Center(
      child: Card(
        color: Colors.white,
        elevation: 40,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            constraints: BoxConstraints(maxWidth: 600, minWidth: 350,maxHeight: 350),
            color: Colors.green.shade700,
            padding: EdgeInsets.all(16),
            child: Container(
              color: Colors.white,
              constraints: BoxConstraints(maxWidth: 580, minWidth: 330),
              child: Column(
                children: [
                  Text(
                    "Session Ended",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Congratulations to the Winner",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(8),
                    elevation: 30,
                    color: Colors.white,
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 150, // fixed width for header
                                child: Text(
                                  "Winner Name:",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${controller.highestBidder}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 150, // fixed width for header
                                child: Text(
                                  "Winner Amount:",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  " Rs. ${controller.highestBid} ${controller.biddingType2.value}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    margin: EdgeInsets.all(8),
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 600),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await controller.loadConsignment();
                                  await btds.downloadBiltyLadani( remark: "", packhouseName: controller.packHouseName.value,consignmentNo: controller.searchId.value ,controller.bilty.value,growerName: controller.growerName.value,aadhatiName: controller.aadhatiName.value, websiteUrl: "https://bookmyloadindia.com");

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                  shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Download Final Bilty",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveDisplay() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Consignment No.: ${controller.searchId.value}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 10,
          ),
            buildHighestBidWidgets(),
          SizedBox(height: 10,),
          Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            elevation: 20,
            child: Container(
              height: 600,

              constraints: BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 4,
                  children: [
                    Text("LIVE Procurement Graph",style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold ),),
                    ElevatedButton(
                      onPressed: () {
                        final landingCostController = TextEditingController();
                        landingCostController.text =controller.landingCost.value.toString();
                        Get.defaultDialog(
                          title: "Update Landing Cost",
                          titleStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: landingCostController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: "Enter new amount",
                                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey[400]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.green[400]!, width: 1.5),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                              ),
                              const SizedBox(height: 24),
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
                                          borderRadius: BorderRadius.circular(12),
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
                                        final newCost = double.tryParse(landingCostController.text) ?? controller.landingCost.value;
                                        if (newCost > 0) {
                                          controller.landingCost.value = newCost;
                                          Get.back();

                                        } else {

                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[700],
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: const Text(
                                        "Update",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          backgroundColor: Colors.grey[50],
                          radius: 16,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        shadowColor: Colors.green[200],
                      ),
                      child: const Text(
                        "Change your Landing Cost",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 400,child: // --- Using the new reusable chart widget ---
                    Obx(
                          ()=> DynamicChart2(
                        labels: controller.productLabels.value,
                        weights: controller.productWeights.value,
                        prices: controller.productPrices.value,
                            landingCostFactor: controller.landingCost.value,

                      ),
                    ),),
                    ExpansionTile(title: Text("Show Graphs"),children: [
                    BiltyQualityDonutCharts(categoryData: controller.bilty.value.categories)]),
                    SizedBox(height: 10,),
                    Center(
                      child: Card(
                        color: Colors.white,
                        child: Container(
                          height: 150,
                          constraints: BoxConstraints(maxWidth: 600),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(

                                children: [
                                  Column(
                                    children: [
                                      Text("Bid Mode",style: TextStyle(fontWeight: FontWeight.bold),),
                                      Text("${controller.biddingType1.value}"),
                                    ],
                                  ),
                                  Expanded(child: SizedBox()),
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 200),
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      controller: controller.bidValueController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(16)))),
                                    ),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Column(
                                    children: [

                                      Text("Bid Mode",style: TextStyle(fontWeight: FontWeight.bold),),
                                      Text("${controller.biddingType2.value}"),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Container(
                                      constraints: BoxConstraints(
                                        minWidth: 300,
                                      ),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orangeAccent.shade200,
                                              shape: ContinuousRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(16)))),
                                          onPressed: () {
                                            controller.pushBids();
                                          },
                                          child: Text(
                                            "Push My Bid",
                                            style: TextStyle(fontSize: 12,color: Colors.white),
                                          )),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }



  Widget buildHighestBidWidgets() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          // Highest Bidder Card
          Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            elevation: 10,
            color: Colors.white,
            child: Container(
              constraints: BoxConstraints(minHeight: 80),
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.blue),
                  SizedBox(width: 8),
                  Obx(() => Column(
                    children: [
                      Text(
                        "Highest Bidder:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        child: Text(
                          controller.highestBidder.value,
                          style: TextStyle(
                            fontSize: controller.highestBidder.value.length>18?18:12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),

          // Highest Bid Card with Flip Animation
          Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            elevation: 10,
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.currency_rupee_sharp, color: Colors.green),
                  SizedBox(width: 8),
                  Column(
                    children: [
                      Text(
                        "Highest Bid : ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Obx(
                            () => PageTransitionSwitcher(
                          duration: Duration(milliseconds: 600),
                          transitionBuilder:
                              (child, animation, secondaryAnimation) =>
                              SharedAxisTransition(
                                animation: animation,
                                secondaryAnimation: secondaryAnimation,
                                transitionType: SharedAxisTransitionType.vertical,
                                child: child,
                              ),
                          child: Text(
                            "${controller.highestBid.value}",
                            key: ValueKey(controller.highestBid.value),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
