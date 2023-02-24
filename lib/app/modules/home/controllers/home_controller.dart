import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream(String email) {
    return firestore
        .collection('users')
        .doc(email)
        .collection('chats')
        .orderBy('lastTime', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendDataStream(
      String email) {
    return firestore.collection('users').doc(email).snapshots();
  }

  Future<dynamic> goToChatRoom({
    required String chat_id,
    required String email,
  }) async {
    CollectionReference users = firestore.collection('users');
    CollectionReference chats = firestore.collection('users');

    try {
      // cari dokumen chat dengan penerima
      final updateReadChat = await chats
          .doc(chat_id)
          .collection('chats')
          .where('isRead', isEqualTo: false)
          .where('penerima', isEqualTo: email)
          .get();

      // ubah status chat menjadi isRead = true
      updateReadChat.docs.forEach((element) async {
        element.id;
        await chats.doc(chat_id).collection('chats').doc(element.id).update({
          'isRead': true,
        });
      });

      // ubah total_unread = 0
      await users
          .doc(email)
          .collection('chats')
          .doc(chat_id)
          .update({'total_unread': 0});

      return true;
    } catch (error) {
      print('error-detail-chat : ' + error.toString());
      return error.toString();
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
  void onClose() {}
  void increment() => count.value++;
}
