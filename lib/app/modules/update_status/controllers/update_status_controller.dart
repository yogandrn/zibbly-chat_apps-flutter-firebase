import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zibbly/app/controllers/auth_controller.dart';

class UpdateStatusController extends GetxController {
  //TODO: Implement UpdateStatusController
  final authController = Get.find<AuthController>();
  final statusController = TextEditingController();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    statusController.text = authController.user.value.name!;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    statusController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
