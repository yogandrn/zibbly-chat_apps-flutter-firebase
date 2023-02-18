import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeNameController extends GetxController {
  //TODO: Implement ChangeNameController
  var nameController = TextEditingController();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    // nameController.text = 'Your Name';
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
