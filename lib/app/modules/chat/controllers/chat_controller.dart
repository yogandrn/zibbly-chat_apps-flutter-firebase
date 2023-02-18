import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  //TODO: Implement ChatController
  var isShowEmoji = false.obs;
  late FocusNode focusNode;
  final messageController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addEmojiToChat(Emoji emoji) {
    messageController.text += emoji.emoji;
  }

  void deleteEmoji() {
    messageController.text =
        messageController.text.substring(0, messageController.text.length - 2);
  }

  Future<int> sendChats({
    required String chatId,
    required String sender,
    required String sendTo,
    required String message,
  }) async {
    try {
      CollectionReference chats = firestore.collection('chats');

      // create new chat message on Chat Collection
      await chats.doc(chatId).collection('chats').add({
        'pengirim': sender,
        'penerima': sendTo,
        'message': message,
        'time': DateTime.now().toIso8601String(),
        'isRead': false,
      });
      return 200;
    } catch (error) {
      print('error-send-chat' + error.toString());
      return 500;
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShowEmoji.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    messageController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
