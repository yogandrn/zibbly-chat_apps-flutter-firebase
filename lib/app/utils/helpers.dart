import 'package:intl/intl.dart';

class Helpers {
  String? validateName(String? name) {
    if (name!.isEmpty) {
      return 'Name can not be empty';
    }
    if (name.length > 255) {
      return 'Maximum 255 characters';
    }
    if (!RegExp(r'[a-zA-Z]').hasMatch(name)) {
      return 'Enter a valid name';
    }
    return null;
  }

  bool nameValidation(String name) {
    if (RegExp(r'[a-zA-Z]').hasMatch(name)) {
      return true;
    }
    return false;
  }

  String? validateStatus(String? status) {
    if (status!.isEmpty) {
      return 'Status can not be empty';
    }
    if (status.length > 255) {
      return 'Maximum 255 characters';
    }
    return null;
  }
}
