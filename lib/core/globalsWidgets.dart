import 'package:apple_grower/navigation/routes_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:apple_grower/core/globals.dart' as glb;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

PreferredSizeWidget buildAppbar() {
  return AppBar(
    title: const Image(
      image: AssetImage("assets/images/logo.png"),
      height: 50,
    ),
    centerTitle: true,
    actions: [IconButton(onPressed: (){Get.toNamed(RoutesConstant.chatBot);}, icon: Icon(Icons.chat,color: Colors.white,))],
    flexibleSpace: Container(
      decoration: const BoxDecoration(
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
  print("Person Name : ${glb.personName.value}");
  return Container(
    color: Colors.green,
    padding: const EdgeInsets.all(12),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: const Color(0xff548235),
                  borderRadius: BorderRadius.circular(8.0)),
              constraints: const BoxConstraints(maxWidth: 225),
              child: Text(
                "${glb.roleType.value}'s Dashboard",
                style: const TextStyle(
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  Get.toNamed(RoutesConstant.profile);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                child: const Text(
                  "Settings",
                  style: TextStyle(color: Colors.orange),
                )),
            IconButton(onPressed: () async{
              await glb.logout();
            }, icon: Icon(Icons.logout_rounded, color: Colors.white,))
          ],
        ),
        const Divider(
          color: Colors.white,
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
            () =>Text(
                glb.personName.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Obx(
            ()=>Text(
                glb.personPhone.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Obx(
        //     ()=>Text(
        //         "Village - ${glb.personVillage}",
        //         style: const TextStyle(
        //           color: Colors.white,
        //           fontSize: 14,
        //         ),
        //       ),
        //     ),
        //     Obx(
        //     ()=> Text(
        //         "Post - ${glb.personPost}",
        //         style: const TextStyle(
        //           color: Colors.white,
        //           fontSize: 14,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(
        //   height: 15,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //    Obx(
        //       ()=> Text(
        //         "Bank Account - ${glb.personBank}",
        //         style: const TextStyle(
        //           color: Colors.white,
        //           fontSize: 14,
        //         ),
        //       ),
        //     ),
        //     Obx(
        //       ()=> Text(
        //         "IFSC - ${glb.personIFSC}",
        //         style: const TextStyle(
        //           color: Colors.white,
        //           fontSize: 14,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    ),
  );
}

Widget buildGridCard(String name) {
  return Card(
    color: Colors.white,
    elevation: 0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const ImageIcon(
          AssetImage("assets/images/orchard.png"),
          size: 40,
          color: Colors.green,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            name,
            style: const TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    ),
  );
}
