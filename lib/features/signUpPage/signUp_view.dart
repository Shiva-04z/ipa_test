import 'package:apple_grower/features/signUpPage/signUp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import '../../core/globals.dart' as glb;

class SignUpView extends GetView<SignUpController> {
  @override
  Widget build(BuildContext context) {
    bool isSmallScreen =   MediaQuery.of(Get.context!).size.width > 400;
    return Scaffold(
      body: Stack(
        children: [
          Container(height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color:  Colors.black.withOpacity(0.2),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: isSmallScreen? AssetImage("assets/images/background.png"): AssetImage("assets/images/bgmobile.jpg"),
              ),
            ),),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color:  Colors.black.withOpacity(0.3),
            ),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 400),

                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height > 600 ? 10 : 80,
                      ),
                      _buildLogo(context),
                      SizedBox(height: 20),
                      _buildLoginHeader(),
                      SizedBox(height: 30),
                      _buildFormContainer(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width > 600 ? 400 : 200,
      child: Center(
        child: Image(
          image: AssetImage('assets/images/logo.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildLoginHeader() {
    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Obx(
              () => Text(
            "${controller.currentValue.value}${glb.getTranslatedText("'s Login")}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormField(
            label: glb.getTranslatedText("Enter Mobile Number"),
            hintText: glb.getTranslatedText("Mobile Number Hint"),
          ),
          SizedBox(height: 24),
          _buildFormField(
            label: glb.getTranslatedText("Enter Adhaar Number"),
            hintText: glb.getTranslatedText("Adhaar Number Hint"),
          ),
          SizedBox(height: 30),
          Text(
            glb.getTranslatedText("Select Role"),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 12),
          _buildRoleDropdown(),
          SizedBox(height: 30),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildFormField({required String label, required String hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 12),
        TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
            () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.currentValue.value,
            items: controller.roles,
            isExpanded: true,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.green,
            ),
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            onChanged: (value) {
              if (value != null) {
                controller.currentValue.value = value;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: Colors.green.withOpacity(0.3),
              ),
              onPressed: () => controller.navigateToRolePage(),
              child: Text(
                glb.getTranslatedText("SUBMIT"),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}