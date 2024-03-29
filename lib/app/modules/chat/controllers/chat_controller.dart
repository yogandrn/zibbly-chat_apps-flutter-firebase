import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatController extends GetxController {
  //TODO: Implement ChatController
  var isShowEmoji = false.obs;
  late FocusNode focusNode;
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addEmojiToChat(Emoji emoji) {
    messageController.text += emoji.emoji;
  }

  void deleteEmoji() {
    messageController.text =
        messageController.text.substring(0, messageController.text.length - 2);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChatDialogs(
      {required String chatId}) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamFriendData(
      {required String friendEmail}) {
    return firestore.collection('users').doc(friendEmail).snapshots();
  }

  Future<int> sendChats({
    required String chatId,
    required String sender,
    required String sendTo,
    required String message,
  }) async {
    try {
      String date = DateTime.now().toIso8601String();
      int total_unread = 0;
      CollectionReference chats = firestore.collection('chats');
      CollectionReference users = firestore.collection('users');

      // create new chat message on Chat Collection
      final newChat = await chats.doc(chatId).collection('messages').add({
        'pengirim': sender,
        'penerima': sendTo,
        'message': message,
        'time': date,
        'isRead': false,
        'groupTime': DateFormat("d MMM yyyy").format(DateTime.parse(date)),
      });

      await users
          .doc(sender)
          .collection('chats')
          .doc(chatId)
          .update({'lastTime': date, "isEmpty": false});

      await users.doc(sendTo).collection('chats').doc(chatId).update({
        'lastTime': date,
      });

      final checkReceiverChat =
          await users.doc(sendTo).collection('chats').doc(chatId).get();

      if (checkReceiverChat.exists) {
        // jika ada, update

        // check total unread dahulu
        final checkTotalUnread = await chats
            .doc(chatId)
            .collection("messages")
            .where("isRead", isEqualTo: false)
            .where("pengirim", isEqualTo: sender)
            .get();

        // hitung total unread
        total_unread = checkTotalUnread.docs.length;

        // update total unread di penerima
        await users.doc(sendTo).collection("chats").doc(chatId).update(
            {"lastTime": date, "total_unread": total_unread, "isEmpty": false});
      } else {
        // jika tidak ada, buat baru
        await users.doc(sendTo).collection("chats").doc(chatId).set({
          "connection": sender,
          "lastTime": date,
          "total_unread": 1,
          "isEmpty": false
        });
      }

      // clear messageController
      // messageController.text = '';
      // messageController.clear();

      // jump scroll
      Timer(
          Duration(milliseconds: 200),
          () => scrollController
              .jumpTo(scrollController.position.maxScrollExtent));

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
    scrollController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
