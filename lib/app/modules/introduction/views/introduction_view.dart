import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zibbly/app/controllers/auth_controller.dart';
import 'package:zibbly/app/routes/app_pages.dart';
import 'package:zibbly/app/utils/app_const.dart';
import 'package:zibbly/app/utils/dimension.dart';
import 'package:zibbly/app/utils/theme.dart';

import '../controllers/introduction_controller.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionView extends GetView<IntroductionController> {
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "First Page",
              body:
                  "Welcome to the app! This is a description on a page with a blue background.",
              image: Image.asset(
                imageGroupChats,
                height: size50 * 4.0,
              ),
            ),
            PageViewModel(
              title: "Second Page",
              body:
                  "Welcome to the app! This is a description on a page with a blue background.",
              image: Image.asset(
                imageSocmed,
                height: size50 * 4,
              ),
            ),
            PageViewModel(
              title: "Third Page",
              body:
                  "Welcome to the app! This is a description on a page with a blue background.",
              image: Image.asset(
                imageVoiceChats,
                height: size50 * 4.5,
              ),
            ),
          ],
          showSkipButton: true,
          skip: Text(
            'Skip',
            style: inter400.copyWith(
              fontSize: size14,
              color: grey,
            ),
          ),
          next: const Text(
            "Next",
          ),
          done:
              const Text("Done", style: TextStyle(fontWeight: FontWeight.w700)),
          onDone: () {
            authController.skipIntro();
            Get.offAllNamed(Routes.LOGIN);
          },
          // onSkip: () {
          //   // On Skip button pressed
          // },
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Theme.of(context).colorScheme.secondary,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
        ));
  }
}
