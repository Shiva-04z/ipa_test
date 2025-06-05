import 'package:apple_grower/features/ladaniBuyers/ladaniBuyers_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/globalsWidgets.dart' as glbw;

class LadaniBuyersView extends GetView<LadaniBuyersController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image(image: AssetImage("assets/images/logo.png"),height: 50,
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffb2dec5), Color(0xffc0bcbb)],
                  stops: [0.25, 0.75],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                )

            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [glbw.buildInfo(),],
          ),
        )
    );
  }
}
