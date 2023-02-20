import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zibbly/app/controllers/auth_controller.dart';
import 'package:zibbly/app/utils/error_screen.dart';
import 'package:zibbly/app/utils/loading_screen.dart';
import 'package:zibbly/app/utils/splashscreen.dart';
import 'package:zibbly/app/utils/theme.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    final authCtrl = Get.put(AuthController(), permanent: true);

    return FutureBuilder(
        future: authCtrl.firstInitialized(),
        // future: Future.delayed(Duration(microseconds: 2400)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Obx(
              () => GetMaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  Locale('en', 'EN'),
                  Locale('in', 'ID'),
                ],
                theme: ThemeData(
                  fontFamily: 'Inter',
                  visualDensity: VisualDensity.comfortable,
                  colorScheme: ThemeData().colorScheme.copyWith(
                        primary: primaryColor,
                        onPrimary: white,
                        secondary: primaryColor,
                        onSecondary: white,
                        onError: errorColor,
                      ),
                ),
                title: "Zibbly",
                initialRoute: authCtrl.isSkipIntro.isTrue
                    ? authCtrl.isAuth.value == true
                        ? Routes.HOME
                        : Routes.LOGIN
                    : Routes.INTRODUCTION,
                getPages: AppPages.routes,
              ),
            );
          }
          return LoadingScreen();
        });

    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            // return GetMaterialApp(
            //   initialRoute: Routes.HOME,
            //   getPages: AppPages.routes,
            //   debugShowCheckedModeBanner: false,
            //   theme: ThemeData(
            //     fontFamily: 'Inter',
            //     visualDensity: VisualDensity.comfortable,
            //     colorScheme: ThemeData().colorScheme.copyWith(
            //           primary: primaryColor,
            //           onPrimary: white,
            //           secondary: primaryColor,
            //           onSecondary: white,
            //           onError: errorColor,
            //         ),
            //   ),
            // );
            return FutureBuilder(
                // future: authCtrl.firstInitialized(),
                future: Future.delayed(Duration(microseconds: 2400)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Obx(
                      () => GetMaterialApp(
                        debugShowCheckedModeBanner: false,
                        localizationsDelegates: [
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        supportedLocales: [
                          Locale('en', 'EN'),
                          Locale('in', 'ID'),
                        ],
                        theme: ThemeData(
                          fontFamily: 'Inter',
                          visualDensity: VisualDensity.comfortable,
                          colorScheme: ThemeData().colorScheme.copyWith(
                                primary: primaryColor,
                                onPrimary: white,
                                secondary: primaryColor,
                                onSecondary: white,
                                onError: errorColor,
                              ),
                        ),
                        title: "Zibbly",
                        initialRoute: authCtrl.isSkipIntro.isTrue
                            ? authCtrl.isAuth.isTrue
                                ? Routes.HOME
                                : Routes.LOGIN
                            : Routes.INTRODUCTION,
                        getPages: AppPages.routes,
                      ),
                    );
                  }
                  return SplashScreen();
                });
          }

          return LoadingScreen();
        });
  }
}
