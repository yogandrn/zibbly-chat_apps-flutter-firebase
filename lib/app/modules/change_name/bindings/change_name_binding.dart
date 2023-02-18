import 'package:get/get.dart';

import '../controllers/change_name_controller.dart';

class ChangeNameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangeNameController>(
      () => ChangeNameController(),
    );
  }
}
