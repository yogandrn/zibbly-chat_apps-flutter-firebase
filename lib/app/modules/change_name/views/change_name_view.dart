import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zibbly/app/controllers/auth_controller.dart';
import 'package:zibbly/app/utils/dimension.dart';
import 'package:zibbly/app/utils/theme.dart';

import '../controllers/change_name_controller.dart';

class ChangeNameView extends GetView<ChangeNameController> {
  // final _nameController = TextEditingController(text: 'Your Name');
  // final controller = Get.put(ChangeNameController());
  final authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  // Toast Success
  Widget successToast = Container(
    padding: EdgeInsets.symmetric(horizontal: size25, vertical: size20),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size15),
        color: Colors.black.withOpacity(0.75)),
    child: Text(
      "Successfully change your name",
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
      "Failed to change name!",
      style: inter400.copyWith(fontSize: size13, color: white),
    ),
  );

  @override
  Widget build(BuildContext context) {
    controller.nameController.text = authController.user.value.name!;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Name',
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
                      .changeName(controller.nameController.text);
                  if (result == 200) {
                    FToast().showToast(child: successToast);
                    Get.back();
                  } else {
                    FToast().showToast(child: errorToast);
                    Get.back();
                  }
                }

                // showDialog(
                //     context: context,
                //     builder: (context) {
                //       return AlertDialog(
                //         content: Container(
                //             child: Center(
                //           child: CircularProgressIndicator(),
                //         )),
                //       );
                //     });
                // Future.delayed(Duration(milliseconds: 5400), () {
                //   Get.back();
                // });
                // final result = await authController
                //     .changeName(controller.nameController.text);
                // if (result == 200) {
                //   // if (Get.isDialogOpen!) {
                //   //   Get.back();
                //   // }
                //   Get.back();
                // } else {
                //   // if (Get.isDialogOpen!) {
                //   //   Get.back();
                //   // }
                //   Get.defaultDialog(
                //     title: 'Failed',
                //     middleText: 'Failed to change your name!',
                //     middleTextStyle: alertTextLight,
                //   );
                //   Future.delayed(Duration(milliseconds: 2400), () {
                //     Get.back();
                //   });
                // }
              },
              icon: Icon(Icons.check),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: size12, horizontal: size24),
          children: [
            SizedBox(height: size20),
            Text(
              'Your current name',
              style: inter400.copyWith(fontSize: size14, color: grey),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                  controller: controller.nameController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  style: formTextstyle,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name field can not be empty!';
                    }
                    if (value.length > 255) {
                      return 'Maximum 255 characters!';
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'Type your name here',
                    hintStyle: hintTextstyle,
                  ),
                  onEditingComplete: () async {
                    if (_formKey.currentState!.validate()) {
                      FToast().init(context);
                      final result = await authController
                          .changeName(controller.nameController.text);
                      if (result == 200) {
                        FToast().showToast(child: successToast);
                        Get.back();
                      } else {
                        FToast().showToast(child: errorToast);
                        Get.back();
                      }
                    }
                  }),
            ),
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

  // Show Loading
  showLoading(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: size40 * 3),
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 0,
            content: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: size24, vertical: size24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size16),
                color: white,
              ),
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: primaryColor, size: size50),
            )));
  }
}
