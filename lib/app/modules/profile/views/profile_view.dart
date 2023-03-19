import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:zibbly/app/controllers/auth_controller.dart';
import 'package:zibbly/app/routes/app_pages.dart';
import 'package:zibbly/app/utils/app_const.dart';
import 'package:zibbly/app/utils/dimension.dart';
import 'package:zibbly/app/utils/theme.dart';
import 'package:avatar_glow/avatar_glow.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: appbarTitleStyle,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_rounded),
        ),
        actions: [],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size18),
                    Stack(
                      children: [
                        // USER PROFILE PHOTO
                        Obx(
                          () => AvatarGlow(
                            endRadius: size50 * 2,
                            glowColor: primaryColor.withOpacity(0.75),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(screenWidth / 2.5),
                              // decoration: BoxDecoration(
                              //   color: primaryColor,
                              //   borderRadius:
                              //       BorderRadius.circular(screenWidth / 3),
                              //       ),
                              // ),
                              child: authController.user.value.photoUrl! ==
                                      'noimage'
                                  ? Image.asset(
                                      defaultPhotoUrl,
                                      width: screenWidth / 2.5,
                                      height: screenWidth / 2.5,
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl:
                                          authController.user.value.photoUrl,
                                      width: screenWidth / 2.5,
                                      height: screenWidth / 2.5,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),

                        // BUTTON EDIT PHOTO
                        Positioned(
                            right: size24,
                            bottom: size20,
                            child: Container(
                                padding: EdgeInsets.all(size10),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(size25),
                                ),
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  size: size20,
                                  color: white,
                                ))),
                      ],
                    ),
                    SizedBox(height: size12),
                    // USER DISPLAY NAME
                    Obx(
                      () => Text(
                        authController.user.value.name!,
                        style: inter500.copyWith(
                          fontSize: size16,
                          color: black,
                        ),
                      ),
                    ),

                    // USER EMAIL
                    Obx(
                      () => Text(
                        authController.user.value.email!,
                        style: inter500.copyWith(
                          fontSize: size14,
                          color: grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size32),
              Container(
                child: Column(
                  children: [
                    // BUTTON CHANGE STATUS
                    InkWell(
                      onTap: () => Get.toNamed(Routes.UPDATE_STATUS),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size16),
                        child: Row(
                          children: [
                            Container(
                              width: size50,
                              height: size50,
                              padding: EdgeInsets.symmetric(
                                  horizontal: size10, vertical: size6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(size25),
                              ),
                              child: Image.asset(
                                iconChatStatus,
                              ),
                            ),
                            SizedBox(width: size6),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Status',
                                      style: inter500.copyWith(
                                        fontSize: size14,
                                        color: black,
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        authController.user.value.status!,
                                        style: inter400.copyWith(
                                          fontSize: size13,
                                          color: grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: size20,
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size12),

                    // BUTTON CHANGE NAME
                    InkWell(
                      onTap: () => Get.toNamed(Routes.CHANGE_NAME),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size16),
                        child: Row(
                          children: [
                            Container(
                              width: size50,
                              height: size50,
                              padding: EdgeInsets.symmetric(
                                  horizontal: size10, vertical: size6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(size25),
                              ),
                              child: Image.asset(
                                iconProfile,
                              ),
                            ),
                            SizedBox(width: size6),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Name',
                                      style: inter500.copyWith(
                                        fontSize: size14,
                                        color: black,
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        authController.user.value.name!,
                                        style: inter400.copyWith(
                                          fontSize: size13,
                                          color: grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: size20,
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size12),

                    // BUTTON CHANGE THEME
                    InkWell(
                      onTap: () => Get.toNamed(Routes.CHANGE_NAME),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size16),
                        child: Row(
                          children: [
                            Container(
                              width: size50,
                              height: size50,
                              padding: EdgeInsets.symmetric(
                                  horizontal: size10, vertical: size6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(size25),
                              ),
                              child: Image.asset(
                                iconTheme,
                              ),
                            ),
                            SizedBox(width: size6),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Theme',
                                      style: inter500.copyWith(
                                        fontSize: size14,
                                        color: black,
                                      ),
                                    ),
                                    Text(
                                      'Light Mode',
                                      style: inter400.copyWith(
                                        fontSize: size13,
                                        color: grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: size20,
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size12),

                    // BUTTON LOGOUT
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(size16))),
                            context: context,
                            builder: (context) {
                              return modalConfirmLogout(context);
                              // }
                            });
                        // authController.logout();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size16),
                        child: Row(
                          children: [
                            Container(
                              width: size50,
                              height: size50,
                              padding: EdgeInsets.symmetric(
                                  horizontal: size10, vertical: size6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(size25),
                              ),
                              child: Image.asset(
                                iconTheme,
                              ),
                            ),
                            SizedBox(width: size6),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Log Out',
                                      style: inter500.copyWith(
                                        fontSize: size14,
                                        color: black,
                                      ),
                                    ),
                                    // Text(
                                    //   'Log out from your account',
                                    //   style: inter400.copyWith(
                                    //     fontSize: size13,
                                    //     color: grey,
                                    //   ),
                                    // ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: size20,
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size12),

                    // ListTile(
                    //   leading: Image.asset(
                    //     iconChatStatus,
                    //     height: size28,
                    //   ),
                    //   title: Text(
                    //     'Status',
                    //     style: inter500.copyWith(
                    //       fontSize: size15,
                    //       color: black,
                    //     ),
                    //   ),
                    //   subtitle: Text(
                    //     'your status here',
                    //     style: inter400.copyWith(
                    //       fontSize: size14,
                    //       color: grey,
                    //     ),
                    //   ),
                    //   trailing: Icon(
                    //     Icons.arrow_forward_ios_rounded,
                    //     size: size25,
                    //   ),
                    // ),
                    // ListTile(
                    //   leading: Image.asset(
                    //     iconProfile,
                    //     height: size28,
                    //   ),
                    //   title: Text(
                    //     'Change Profile',
                    //     style: inter500.copyWith(
                    //       fontSize: size15,
                    //       color: black,
                    //     ),
                    //   ),
                    //   trailing: Icon(
                    //     Icons.arrow_forward_ios_rounded,
                    //     size: size25,
                    //   ),
                    // ),
                    // ListTile(
                    //   leading: Image.asset(
                    //     iconTheme,
                    //     height: size28,
                    //   ),
                    //   title: Text(
                    //     'Theme',
                    //     style: inter500.copyWith(
                    //       fontSize: size15,
                    //       color: black,
                    //     ),
                    //   ),
                    //   subtitle: Text(
                    //     'Light',
                    //     style: inter400.copyWith(
                    //       fontSize: size14,
                    //       color: grey,
                    //     ),
                    //   ),
                    //   trailing: Icon(
                    //     Icons.arrow_forward_ios_rounded,
                    //     size: size25,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),

          // APP INFO
          Padding(
            padding: EdgeInsets.only(bottom: size32),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Zibbly',
                    style: inter500.copyWith(fontSize: size13, color: grey),
                  ),
                  Text(
                    'v1.0.0',
                    style: inter400.copyWith(fontSize: size12, color: grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget modalConfirmLogout(BuildContext context) {
    return Container(
      width: screenWidth,
      height: screenHeight / 3.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(size16),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: size20, vertical: size15),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        //Title
        Text("Log Out?",
            style: inter500.copyWith(fontSize: size15, color: black)),
        Image.asset(
          "assets/images/security-error.png",
          width: screenWidth / 2.6,
        ),
        Text("Are you sure want to logout from your account?",
            textAlign: TextAlign.center,
            style: inter400.copyWith(fontSize: size13, color: black)),
        SizedBox(
          height: size8,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Button Logout
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  authController.logout();
                },
                child: Container(
                  width: screenWidth,
                  height: size48,
                  margin: EdgeInsets.only(right: size6),
                  padding:
                      EdgeInsets.symmetric(horizontal: size20, vertical: size8),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: primaryColor, width: 1.2),
                      borderRadius: BorderRadius.circular(size12)),
                  child: Center(
                    child: Text(
                      'Logout',
                      style: inter500.copyWith(
                          fontSize: size14, color: primaryColor),
                    ),
                  ),
                ),
              ),
            ),

            // Button Cancel
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: screenWidth,
                  height: size48,
                  margin: EdgeInsets.only(left: size6),
                  padding:
                      EdgeInsets.symmetric(horizontal: size20, vertical: size8),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(size12)),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: inter500.copyWith(fontSize: size13, color: white),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}
