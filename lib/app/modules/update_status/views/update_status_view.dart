import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:zibbly/app/controllers/auth_controller.dart';
import 'package:zibbly/app/utils/dimension.dart';
import 'package:zibbly/app/utils/theme.dart';

import '../controllers/update_status_controller.dart';

class UpdateStatusView extends GetView<UpdateStatusController> {
  // final _statusController = TextEditingController(text: 'my status');
  final authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  // Toast Success
  Widget successToast = Container(
    padding: EdgeInsets.symmetric(horizontal: size25, vertical: size20),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size15),
        color: Colors.black.withOpacity(0.75)),
    child: Text(
      "Successfully change your status",
      style: inter400.copyWith(fontSize: size13, color: white),
    ),
  );

  // Toast Error
  Widget errorToast = Container(
    padding: EdgeInsets.symmetric(horizontal: size25, vertical: size20),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size15),
        color: Colors.black.withOpacity(0.75)),
    child: Text(
      "Failed to change status!",
      style: inter400.copyWith(fontSize: size13, color: white),
    ),
  );

  @override
  Widget build(BuildContext context) {
    controller.statusController.text = authController.user.value.status!;
    return Scaffold(
        // resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            'Status',
            style: appbarTitleStyle,
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_rounded),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    FToast().init(context);
                    final result = await authController
                        .changeStatus(controller.statusController.text);
                    if (result == 200) {
                      FToast().showToast(child: successToast);
                      Get.back();
                    } else {
                      FToast().showToast(child: errorToast);
                      Get.back();
                    }
                  }
                },
                icon: Icon(Icons.check)),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: size12),
          children: [
            SizedBox(height: size20),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size24,
              ),
              child: Text(
                'Your current status',
                style: inter400.copyWith(fontSize: size14, color: grey),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size24,
              ),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: controller.statusController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Status field can not be empty!';
                    }
                    if (value.length > 255) {
                      return 'Maximum 255 characters!';
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: formTextstyle,
                  decoration: InputDecoration(
                    // contentPadding: EdgeInsets.symmetric(vertical: size6),
                    hintText: 'Type your status here',
                    hintStyle: hintTextstyle,
                  ),
                  onEditingComplete: () async {
                    if (_formKey.currentState!.validate()) {
                      FToast().init(context);
                      final result = await authController
                          .changeStatus(controller.statusController.text);
                      if (result == 200) {
                        FToast().showToast(child: successToast);
                        Get.back();
                      } else {
                        FToast().showToast(child: errorToast);
                        Get.back();
                      }
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: size25),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size24,
              ),
              child: Text(
                'Select your status',
                style: inter400.copyWith(fontSize: size14, color: grey),
              ),
            ),
            SizedBox(height: size12),
            statusOption(context, 'Available'),
            statusOption(context, 'Busy'),
            statusOption(context, 'Emergency Call Only'),
          ],
        )
        // Divider(
        //   height: size40,
        //   thickness: 1.2,
        //   color: silver,
        // ),
        // Center(
        //   child: Text(
        //     'UpdateStatusView is working',
        //     style: TextStyle(fontSize: 20),
        //   ),
        // ),

        );
  }

  Widget statusOption(BuildContext context, String status) {
    return InkWell(
      onTap: () async {
        controller.statusController.text = status;
        FToast().init(context);
        final result =
            await authController.changeStatus(controller.statusController.text);
        if (result == 200) {
          FToast().showToast(child: successToast);
          Get.back();
        } else {
          FToast().showToast(child: errorToast);
          Get.back();
        }
      },
      child: Container(
        width: screenWidth,
        height: size48 * 1.0,
        // margin: EdgeInsets.symmetric(vertical: size6),
        child: Row(
          children: [
            SizedBox(
              width: size25,
            ),
            Text(
              status,
              style: formTextstyle,
            ),
          ],
        ),
      ),
    );
  }
}
