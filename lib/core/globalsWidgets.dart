import 'package:apple_grower/navigation/routes_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:apple_grower/core/globals.dart' as glb;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

PreferredSizeWidget buildAppbar() {
  return AppBar(
    title: Image(
      image: AssetImage("assets/images/logo.png"),
      height: 50,
    ),
    centerTitle: true,
    flexibleSpace: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Color(0xffb2dec5), Color(0xffc0bcbb)],
        stops: [0.25, 0.75],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      )),
    ),
  );
}

Widget buildInfo() {
  return Container(
    color: Colors.green,
    padding: EdgeInsets.all(12),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Color(0xff548235),
                  borderRadius: BorderRadius.circular(8.0)),
              constraints: BoxConstraints(maxWidth: 225),
              child: Text(
                "${glb.roleType.value}'s Dashboard",
                style: TextStyle(
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Get.toNamed(RoutesConstant.profile);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                child: Text(
                  "Update",
                  style: TextStyle(color: Colors.orange),
                ))
          ],
        ),
        Divider(
          color: Colors.white,
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
            () =>Text(
                glb.personName.value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Obx(
            ()=>Text(
                glb.personPhone.value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
            ()=>Text(
                "Village - ${glb.personVillage}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            Obx(
            ()=> Text(
                "Post - ${glb.personPost}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Obx(
              ()=> Text(
                "Bank Account - ${glb.personBank}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            Obx(
              ()=> Text(
                "IFSC - ${glb.personIFSC}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
} // TODO Implement this library.

Widget buildGridCard(String name) {
  return Card(
    color: Colors.white,
    elevation: 0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageIcon(
          AssetImage("assets/images/orchard.png"),
          size: 40,
          color: Colors.green,
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            name,
            style: TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    ),
  );
}
