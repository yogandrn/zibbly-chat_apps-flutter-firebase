import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zibbly/app/controllers/auth_controller.dart';
import 'package:zibbly/app/utils/app_const.dart';
import 'package:zibbly/app/utils/dimension.dart';
import 'package:zibbly/app/utils/theme.dart';
import 'package:zibbly/app/widgets/chat_bubble.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  final authController = Get.find<AuthController>();
  final arguments = Get.arguments as Map<String, dynamic>;

  // Toast Error
  Widget errorToast = Container(
    padding: EdgeInsets.symmetric(horizontal: size24, vertical: size18),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size15),
        color: Colors.black.withOpacity(0.75)),
    child: Text(
      "Failed to send message!",
      style: inter400.copyWith(fontSize: size12, color: white),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: chatBackgroundLight,
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream:
                controller.streamFriendData(friendEmail: arguments['sendTo']),
            builder: (context, snapshotFriend) {
              if (snapshotFriend.hasData && snapshotFriend.data != null) {
                var data = snapshotFriend.data!.data();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${data!['name']}',
                      style: appbarTitleStyle,
                    ),
                    Text(
                      '${data['status']}',
                      style: appbarTitleStyle.copyWith(
                          fontWeight: FontWeight.w400, fontSize: size13),
                    ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: size50 + 20,
                      height: size16,
                      color: white.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: size6,
                    ),
                    Container(
                      width: size50 * 2,
                      height: size14,
                      color: white.withOpacity(0.5),
                    ),
                  ],
                );
              }
            }),
        centerTitle: false,
        leadingWidth: size40 * 2.15,
        leading: InkWell(
          borderRadius: BorderRadius.circular(size50),
          onTap: () => Get.back(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: size6),
              Icon(Icons.arrow_back_rounded),
              SizedBox(width: size6),
              // Container(
              //   width: size40 - 3,
              //   height: size40 - 3,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(
              //         size40,
              //       ),
              //       color: silver,
              //       image: DecorationImage(
              //           image:
              //           AssetImage(
              //             imageLogin,
              //           ),
              //           fit: BoxFit.cover)),
              // ),
              ClipRRect(
                borderRadius: BorderRadius.circular(size40),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: controller.streamFriendData(
                        friendEmail: arguments['sendTo']),
                    builder: (context, snapshotFriend) {
                      if (snapshotFriend.hasData &&
                          snapshotFriend.data != null) {
                        var data = snapshotFriend.data!.data();
                        return CachedNetworkImage(
                          imageUrl: data!['photoUrl'],
                          width: size40,
                          height: size40,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return Image.asset(
                          defaultPhotoUrl,
                          width: size40,
                          height: size40,
                          fit: BoxFit.cover,
                        );
                      }
                    }),
              ),
              SizedBox(width: size6),
            ],
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          if (controller.isShowEmoji.isTrue) {
            controller.isShowEmoji.value = false;
          } else {
            Navigator.pop(context);
          }
          return Future.value(false);
        },
        child: Column(
          children: [
            // CHAT DIALOGS
            // Expanded(
            //   child: Container(
            //     width: screenWidth,
            //     child: ListView(children: [
            //       ChatBubble(
            //         isSender: true,
            //         message: 'Halo dek.',
            //       ),
            //       ChatBubble(
            //         isSender: true,
            //         message: 'Kuliah apa kerja?',
            //       ),
            //       ChatBubble(
            //         isSender: false,
            //         message: 'nge-punk',
            //       ),
            //       ChatBubble(
            //         isSender: true,
            //         message: 'anjink',
            //       ),
            //       ChatBubble(
            //         isSender: false,
            //         message: 'awokwowkwokwok',
            //       ),
            //     ]),
            //   ),
            // ),

            Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  controller.streamChatDialogs(chatId: arguments['chat_id']),
              builder: (context, snapshotChats) {
                if (snapshotChats.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.waveDots(
                      color: primaryColor,
                      size: size50,
                    ),
                  );
                } else if (snapshotChats.hasData &&
                    snapshotChats.data != null) {
                  var dialogs = snapshotChats.data!.docs;
                  Timer(
                    Duration.zero,
                    () => controller.scrollController.jumpTo(
                        controller.scrollController.position.maxScrollExtent),
                  );
                  return ListView.builder(
                      controller: controller.scrollController,
                      padding: EdgeInsets.only(top: size10),
                      itemCount: dialogs.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            children: [
                              SizedBox(height: size8),
                              Text(
                                "${dialogs[index]['groupTime']}",
                                style: inter400.copyWith(
                                  fontSize: size12,
                                  color: black,
                                ),
                              ),
                              SizedBox(height: size8),
                              ChatBubble(
                                  isSender: dialogs[index]['pengirim'] ==
                                          authController.user.value.email
                                      ? true
                                      : false,
                                  message: dialogs[index]['message'],
                                  time: dialogs[index]['time']),
                            ],
                          );
                        } else {
                          if (dialogs[index]['groupTime'] ==
                              dialogs[index - 1]['groupTime']) {
                            return ChatBubble(
                                isSender: dialogs[index]['pengirim'] ==
                                        authController.user.value.email
                                    ? true
                                    : false,
                                message: dialogs[index]['message'],
                                time: dialogs[index]['time']);
                          } else {
                            return Column(
                              children: [
                                SizedBox(height: size8),
                                Text(
                                  "${dialogs[index]['groupTime']}",
                                  style: inter400.copyWith(
                                    fontSize: size12,
                                    color: black,
                                  ),
                                ),
                                SizedBox(height: size8),
                                ChatBubble(
                                    isSender: dialogs[index]['pengirim'] ==
                                            authController.user.value.email
                                        ? true
                                        : false,
                                    message: dialogs[index]['message'],
                                    time: dialogs[index]['time']),
                              ],
                            );
                          }
                        }
                      });
                  return ListView(children: [
                    ChatBubble(
                      isSender: true,
                      message: 'Halo dek.',
                      time: '2023-02-25T18:49:15.486311',
                    ),
                    ChatBubble(
                      isSender: true,
                      message: 'Kuliah apa kerja?',
                      time: '2023-02-25T18:49:15.486311',
                    ),
                    ChatBubble(
                      isSender: false,
                      message: 'nge-punk',
                      time: '2023-02-25T18:49:15.486311',
                    ),
                    ChatBubble(
                      isSender: true,
                      message: 'anjink',
                      time: '2023-02-25T18:49:15.486311',
                    ),
                    ChatBubble(
                      isSender: false,
                      message: 'awokwowkwokwok',
                      time: '2023-02-25T18:49:15.486311',
                    ),
                  ]);
                } else {
                  return Text('Something went wrong');
                }
              },
            )),

            // CHAT INPUT
            Container(
              width: screenWidth,
              color: white,
              padding: controller.isShowEmoji.isTrue
                  ? EdgeInsets.fromLTRB(size20, size12, size20, size6)
                  : EdgeInsets.fromLTRB(size20, size12, size20, size16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // EMOJI BUTTON TOGGLE
                    InkWell(
                      onTap: () {
                        controller.focusNode.unfocus();
                        controller.isShowEmoji.toggle();
                      },
                      borderRadius: BorderRadius.circular(size40),
                      child: Icon(
                        Icons.emoji_emotions_outlined,
                        size: size30,
                        color: grey,
                      ),
                    ),

                    // MESSAGE INPUT
                    Expanded(
                      child: Container(
                        height: size24 * 2 - 4,
                        padding: EdgeInsets.symmetric(horizontal: size6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(size10),
                          color: Colors.transparent,
                        ),
                        child: TextField(
                          controller: controller.messageController,
                          focusNode: controller.focusNode,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.newline,
                          style: formTextstyle,
                          decoration: InputDecoration(
                            filled: false,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: size12),
                            hintText: 'Type message',
                            hintStyle: hintTextstyle,
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) {},
                        ),
                      ),
                    ),
                    SizedBox(width: size4),

                    // BUTTON SEND MESSAGE
                    Material(
                      borderRadius: BorderRadius.circular(size40),
                      color: primaryColor,
                      child: InkWell(
                        onTap: () async {
                          final argument =
                              Get.arguments as Map<String, dynamic>;
                          if (controller.messageController.text != '' ||
                              controller.messageController.text != null) {
                            final msg = controller.messageController.text;
                            controller.messageController.clear();
                            final result = await controller.sendChats(
                                chatId: argument['chat_id'],
                                sender: authController.user.value.email!,
                                sendTo: argument['sendTo'],
                                message: msg);
                            if (result == 200) {
                              return;
                            } else {
                              FToast().init(context);
                              FToast().showToast(
                                  child: errorToast,
                                  gravity: ToastGravity.CENTER);
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(size40),
                        child: Padding(
                          padding: EdgeInsets.all(size16),
                          child: Icon(
                            Icons.send_rounded,
                            color: white,
                            size: size24,
                          ),
                        ),
                      ),
                    )
                  ]),
            ),

            // EMOJI INPUT
            Obx(
              () => (controller.isShowEmoji.isTrue)
                  ? Container(
                      height: size40 * 8,
                      child: EmojiPicker(
                        onEmojiSelected: (Category category, Emoji emoji) {
                          // Do something when emoji is tapped (optional)
                          controller.addEmojiToChat(emoji);
                        },
                        onBackspacePressed: () {
                          controller.deleteEmoji();
                          // Do something when the user taps the backspace button (optional)
                        }, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                        config: Config(
                          columns: 8,

                          emojiSizeMax: size30,
                          // Issue: https://github.com/flutter/flutter/issues/28894

                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          initCategory: Category.RECENT,
                          bgColor: white,
                          indicatorColor: primaryColor,
                          iconColor: Colors.grey,
                          iconColorSelected: primaryColor,
                          backspaceColor: primaryColor,
                          showRecentsTab: true,
                          recentsLimit: 35,
                          noRecents: Text(
                            'No Recents',
                            style: inter400.copyWith(
                                fontSize: size12, color: grey),
                          ),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
