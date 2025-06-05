import 'package:apple_grower/features/packHouse/packHouse_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/globalsWidgets.dart' as glbw;
import '../../navigation/routes_constant.dart';

class PackHouseView extends GetView<PackHouseController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: glbw.buildAppbar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [glbw.buildInfo(),
              SizedBox(height: 20,),
              _buildOrchardContainer(context),
              SizedBox(height: 20,),
              _buildPictures(context)

            ],
          ),
        )
    );
  }


  Widget _buildPictures(BuildContext context)
  {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Color(0xff548235),
          padding: EdgeInsets.all(8),
          child: Center(child: Text("Pack House Pictures -",style: TextStyle(color: Colors.white,fontSize: 22, fontWeight: FontWeight.bold),)),
        ),
        SizedBox(height: 10,),

  Obx(() => controller.images.isEmpty
  ? Container(
  height: 200,
  color: Colors.transparent.withOpacity(0.1),
  child: Center(child: Text("Add Images To See Here")),
  )
      : ListView.builder(
    shrinkWrap: true,
    itemCount: controller.images.length,
  itemBuilder: (context, index) {
  return ListTile(
  title: Text("Image ${index + 1}"),
  );
  },
    ))

    ],
    );
  }

  Widget _buildOrchardContainer( BuildContext context)
  {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black26, width: 1) ,borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,crossAxisSpacing: 4,mainAxisSpacing: 12),itemCount: controller.attributes.length +1 ,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildAddNewCard();
                    return glbw.buildGridCard(controller.attributes[index - 1]);}),
            ),
          ),

        ),
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
          decoration: BoxDecoration(color: Color(0xff548235),borderRadius:BorderRadius.circular(8.0) ),

          constraints: BoxConstraints(maxWidth: 225),
          child: Text(
            "My Pack House",
            style: TextStyle(
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildAddNewCard(){
    return InkWell(
      onTap: () {},
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_circle, size: 40, color: Colors.red),
            SizedBox(height: 8),
            Text("ADD NEW", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }





}

