import 'package:flutter/material.dart';

class MyErrorWidget extends StatelessWidget {
  MyErrorWidget({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.size = 72,
  });
  String title, subtitle, imagePath;
  int size;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
