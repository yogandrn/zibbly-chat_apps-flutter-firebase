import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  //TODO: Implement SearchController

  final searchController = TextEditingController();

  var isSearching = false.obs;

  var tempQuery = [].obs;
  var tempSearch = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void searchFriend({required String keyword, required String except}) async {
    if (keyword.length == 0) {
      tempQuery.value = [];
      tempSearch.value = [];
    } else {
      isSearching.value = true;
      var capitalized =
          keyword.substring(0, 1).toUpperCase() + keyword.substring(1);
      print(capitalized);
      if (tempQuery.isEmpty && keyword.length == 1) {
        CollectionReference users = await firestore.collection('users');
        final keyNameResult = await users
            .where('keyName',
                isEqualTo: capitalized.substring(0, 1).toUpperCase())
            .where('email', isNotEqualTo: except)
            .get();
        if (keyNameResult.docs.isNotEmpty) {
          for (var i = 0; i < keyNameResult.docs.length; i++) {
            tempQuery.add(keyNameResult.docs[i].data() as Map<String, dynamic>);
          }
          print('QEURY RESULT : ');
          print(tempQuery.toString());
        } else {
          print('Tidak ada hasil');
        }
      }

      if (tempQuery.isNotEmpty) {
        tempSearch.value = [];
        tempQuery.forEach((element) {
          if (element['name'].startsWith(capitalized)) {
            tempSearch.add(element);
          }
        });
      }

      tempQuery.refresh();
      tempSearch.refresh();
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    isSearching.value = false;
    searchController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
