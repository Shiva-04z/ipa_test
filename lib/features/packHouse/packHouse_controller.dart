import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackHouseController extends GetxController {
  // Add packHouse-specific properties and methods here
  RxString packHouseName = ''.obs;
  RxString location = ''.obs;

  RxList attributes =[ 'Machine',
    'Crates',
    'Growers',
    'Packers',
    'Box 2023',
    'Box 2024',
    'Box 2025',
    'Drivers',
  ].obs;

  RxList images = [].obs;
}
