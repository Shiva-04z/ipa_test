import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apple_grower/core/globals.dart' as glb;

import 'package:apple_grower/navigation/routes_constant.dart';

class SignUpController extends GetxController{

  RxString currentValue="Grower".obs;
  List<DropdownMenuItem<String>> roles = [
    DropdownMenuItem(value: "Grower", child: Text("Grower")),
    DropdownMenuItem(value: "PackHouse", child: Text("PackHouse")),
    DropdownMenuItem(value: "Aadhati", child: Text("Aadhati")),
    DropdownMenuItem(value: "Ladani/Buyers", child: Text("Ladani/Buyers")),
    DropdownMenuItem(value: "Freight Forwarder", child: Text("Freight Forwarder")),
    DropdownMenuItem(value: "Driver", child: Text("Driver")),
    DropdownMenuItem(value: "Transport Union", child: Text("Transport Union")),
    DropdownMenuItem(value: "AMPC Office", child: Text("AMPC Office")),
    DropdownMenuItem(value: "HP Police", child: Text("HP Police")),
    DropdownMenuItem(value: "HP State Agriculture Board", child: Text("HP State Agriculture Board")),
  ];

  void navigateToRolePage() {
    switch (currentValue.value) {
      case "Grower":
        glb.roleType.value = "Grower";
        Get.toNamed(RoutesConstant.grower);
        break;
      case "PackHouse":
        glb.roleType.value = "PackHouse";
        Get.toNamed(RoutesConstant.packHouse);
        break;
      case "Aadhati":
        glb.roleType.value = "Aadhati";
        Get.toNamed(RoutesConstant.aadhati);
        break;
      case "Ladani/Buyers":
        glb.roleType.value = "Ladani/Buyers";
        Get.toNamed(RoutesConstant.ladaniBuyers);
        break;
      case "Freight Forwarder":
        glb.roleType.value = "Freight Forwarder";
        Get.toNamed(RoutesConstant.freightForwarder);
        break;
      case "Driver":
        glb.roleType.value = "Driver";
        Get.toNamed(RoutesConstant.driver);
        break;
      case "Transport Union":
        glb.roleType.value = "Transport Union";
        Get.toNamed(RoutesConstant.transportUnion);
        break;
      case "AMPC Office":
        glb.roleType.value = "AMPC Office";
        Get.toNamed(RoutesConstant.ampcOffice);
        break;
      case "HP Police":
        glb.roleType.value = "HP Police";
        Get.toNamed(RoutesConstant.hpPolice);
        break;
      case "HP State Agriculture Board":
        glb.roleType.value = "HP State Agriculture Board";
        Get.toNamed(RoutesConstant.hpAgriBoard);
        break;
      default:
        Get.snackbar("Error", "Invalid role selected");
    }
  }

}