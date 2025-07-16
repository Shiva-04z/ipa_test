import 'package:apple_grower/features/signUpPage/signUp_controller.dart';
import 'package:apple_grower/navigation/routes_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import '../../core/globals.dart' as glb;

// SignIn Screen: This view provides the UI for user sign-in (mobile, Aadhaar, role selection)
class SignUpView extends GetView<SignUpController> {
  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(Get.context!).size.width > 400;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: isSmallScreen
                    ? AssetImage("assets/images/background.png")
                    : AssetImage("assets/images/bgmobile.jpg"),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.width > 600 ? 30 : 100,
                      ),
                      _buildLogo(context),
                      SizedBox(height: 10),
                      _buildLoginHeader(),

                    _buildFormContainer(context),

                  ],
                ),
              ),
            ),
          ),)
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width > 600 ? 230 : 180,
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
        child:Text(
            "User Login",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )
      ),
    );
  }

  Widget _buildFormContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mobile number input for sign-in
          _buildFormField(
            controller: controller.phoneController,
            label: glb.getTranslatedText("Enter Mobile Number"),
            hintText: glb.getTranslatedText("Mobile Number Hint"),
            keyboardType: TextInputType.number,
            maxLength: 10
          ),
          // Aadhaar number input for sign-in
          _buildFormField(
            controller: controller.aadharController,
            label: glb.getTranslatedText("Enter Adhaar Number"),
            hintText: glb.getTranslatedText("Adhaar Number Hint"),
            keyboardType: TextInputType.number,
            maxLength: 12
          ),

          // Role selection dropdown for sign-in
          Text(
            glb.getTranslatedText("Select Role"),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          _buildRoleDropdown(),
          SizedBox(height: 16),
          // Sign In button (calls controller.navigateToRolePage)
          _buildSubmitButton(),
          // Register button (navigates to registration page)
          _buildRegisterButton()
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.transparent, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Get.toNamed(RoutesConstant.register),
                child: Text(
                  "Create New Account",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    required int maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
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
    // Dropdown for selecting user role during sign-in
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
    // Sign In button: triggers sign-in logic in the controller
    return Padding(
      padding: const EdgeInsets.only(top:32),
      child: Row(
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
                // On press, call controller.navigateToRolePage (sign-in logic)
                onPressed: () => controller.signInWithApi(),
                child: Text(
                  glb.getTranslatedText("Sign In"),
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
      ),
    );
  }
}
