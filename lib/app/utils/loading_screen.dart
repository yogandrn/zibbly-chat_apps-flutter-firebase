import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zibbly/app/utils/theme.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: primaryColor,
        ),
        child: Scaffold(
          body: Center(
            child:
                LoadingAnimationWidget.waveDots(color: Colors.blue, size: 48),
          ),
        ),
      ),
    );
  }
}
