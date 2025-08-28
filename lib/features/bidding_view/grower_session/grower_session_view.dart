import 'package:apple_grower/features/bidding_view/donut.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../forms/consignmentForm/biltydownloadandshare.dart' as btds;
import '../chart.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animations/animations.dart';

import 'grower_session_controller.dart';

class GrowerSessionView extends GetView<GrowerSessionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Growers Bidding Session',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.green.shade900,
        ),
        body: Obx(() => (controller.activeStatus.value == 'completed')
            ? _buildCompletedMessage()
            : (controller.activeStatus.value == 'active')
            ? _buildActiveDisplay()
            : _buildInactiveMessage()));
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
                                  await btds.downloadBiltyGrower( remark: "", packhouseName: controller.packHouseName.value,consignmentNo: controller.searchId.value ,controller.bilty.value,growerName: controller.growerName.value,aadhatiName: controller.aadhatiName.value, websiteUrl: "https://bookmyloadindia.com");

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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 12,),
          Card(
            elevation: 20,
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(children: [
                Text(
                  "Grower's Approval :",
                  style: TextStyle(fontSize: 18),
                ),
                Expanded(child: SizedBox()),
                Obx(() => (controller.growerApproval.value)
                    ? Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 32,
                )
                    : Icon(
                  Icons.dangerous_rounded,
                  color: Colors.red,
                  size: 32,
                ))
              ]),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          buildHighestBidWidgets(),
          SizedBox(height: 12,),
          Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            elevation: 20,
            child: Container(

              constraints: BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Text("LIVE Procurement Graph",style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold ),),
                    SizedBox(height: 15,),
                    SizedBox(height: 400,child: // --- Using the new reusable chart widget ---
                    Obx(
                          ()=> DynamicBarLineChart(
                        labels: controller.productLabels.value,
                        weights: controller.productWeights.value,
                        prices: controller.productPrices.value,
                      ),
                    ),
                    ),
      
                    ExpansionTile(title: Text("Show Graphs"),children: [
                      BiltyQualityDonutCharts(categoryData: controller.bilty.value.categories)]),
                    // Text("Weight Distribution"),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Container(
                    //     child: Row(children: [],),
                    //
                    //   ),
                    // )
                    Card(
                      color: Colors.white,
                      margin:EdgeInsets.all(8) ,
                      elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 600),
                          child: Row(
                            children: [Expanded(child: ElevatedButton(onPressed: (){controller.giveApproval();}, child: Text("Give Approval",style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700,shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),))],
                          ),
                        ),
                      ),
                    )
      
                  ],
                ),
              ),
            ),
          ),
      
      
        ],
      ),
    );
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





