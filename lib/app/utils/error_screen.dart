import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zibbly/app/utils/theme.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

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
            child: Text('Terjadi Kesalahan!'),
          ),
        ),
      ),
    );
  }
}
