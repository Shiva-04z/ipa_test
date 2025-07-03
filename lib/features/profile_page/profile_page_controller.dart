import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../core/globals.dart';
import '../../core/globals.dart' as glb;

class ProfilePageController extends GetxController {
  // Observable variables for user information
  late RxString userName;
  late RxString phoneNumber;
  final RxString email = 'john.doe@example.com'.obs;
  late RxString currentLanguage;

  @override
  void onInit() {
    super.onInit();
    glb.loadIDData();
    userName = RxString(personName.value);
    phoneNumber = RxString(personPhone.value);
    currentLanguage = RxString(isHindiLanguage.value ? 'हिंदी' : 'English');

    // Listen to changes in global variables
    ever(personName, (value) => userName.value = value);
    ever(personPhone, (value) => phoneNumber.value = value);
    ever(isHindiLanguage,
        (value) => currentLanguage.value = value ? 'हिंदी' : 'English');
  }

  // Methods to handle user actions
  void changeName() {
    final TextEditingController textController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text(getTranslatedText('Change Name')),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: getTranslatedText('Enter new name'),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              userName.value = value;
              personName.value = value;
              Get.back();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(getTranslatedText('Cancel')),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                userName.value = textController.text;
                personName.value = textController.text;
                Get.back();
              }
            },
            child: Text(getTranslatedText('Save')),
          ),
        ],
      ),
    );
  }

  void changePhoneNumber() {
    final TextEditingController textController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text(getTranslatedText('Change Phone Number')),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: getTranslatedText('Enter new phone number'),
          ),
          keyboardType: TextInputType.phone,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              phoneNumber.value = value;
              personPhone.value = value;
              Get.back();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(getTranslatedText('Cancel')),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                phoneNumber.value = textController.text;
                personPhone.value = textController.text;
                Get.back();
              }
            },
            child: Text(getTranslatedText('Save')),
          ),
        ],
      ),
    );
  }

  void changeLanguage() {
    Get.dialog(
      AlertDialog(
        title: Text(getTranslatedText('Change Language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('English'),
              onTap: () {
                isHindiLanguage.value = false;
                currentLanguage.value = 'English';
                Get.back();
              },
            ),
            ListTile(
              title: Text('हिंदी'),
              onTap: () {
                isHindiLanguage.value = true;
                currentLanguage.value = 'हिंदी';
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
