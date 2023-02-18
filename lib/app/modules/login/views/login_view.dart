import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:zibbly/app/controllers/auth_controller.dart';
import 'package:zibbly/app/routes/app_pages.dart';
import 'package:zibbly/app/utils/app_const.dart';
import 'package:zibbly/app/utils/dimension.dart';
import 'package:zibbly/app/utils/theme.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: primaryColor,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        // appBar: AppBar(
        //   title: Text('LoginView'),
        //   centerTitle: true,
        // ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imageLogin,
                height: screenHeight / 3.6,
              ),
              SizedBox(
                height: size50 * 1.6,
              ),

              // BUTTON LOGIN WITh GOOGLE
              Center(
                child: InkWell(
                  onTap: () async {
                    final result = await authController.loginWithGoogle();
                    if (result) {
                      Get.offAllNamed(Routes.HOME);
                    } else {
                      Fluttertoast.showToast(msg: 'error-login');
                    }
                  },
                  borderRadius: BorderRadius.circular(size15),
                  child: Container(
                    width: screenWidth / 1.65,
                    padding: EdgeInsets.symmetric(
                      vertical: size16,
                      horizontal: size32,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size18),
                      color: primaryColor,
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          Image.asset(
                            icGoogle1,
                            height: size36,
                          ),
                          SizedBox(
                            width: size12,
                          ),
                          Text(
                            'Login with Google',
                            style: inter500.copyWith(
                                fontSize: size14, color: white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size50 * 2.4,
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Zibbly',
                      style: inter500.copyWith(fontSize: size13, color: grey),
                    ),
                    Text(
                      'v1.0.0',
                      style: inter400.copyWith(fontSize: size13, color: grey),
                    ),
                  ],
                ),
              ),
              // Center(
              //   child: Text(
              //     'LoginView is working',
              //     style: TextStyle(fontSize: 20),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
