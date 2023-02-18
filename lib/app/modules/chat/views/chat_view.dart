import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:zibbly/app/controllers/auth_controller.dart';
import 'package:zibbly/app/utils/app_const.dart';
import 'package:zibbly/app/utils/dimension.dart';
import 'package:zibbly/app/utils/theme.dart';
import 'package:zibbly/app/widgets/chat_bubble.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: chatBackgroundLight,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: appbarTitleStyle,
            ),
            Text(
              'the status',
              style: appbarTitleStyle.copyWith(
                  fontWeight: FontWeight.w400, fontSize: size13),
            ),
          ],
        ),
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
              Container(
                width: size40 - 3,
                height: size40 - 3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      size40,
                    ),
                    color: silver,
                    image: DecorationImage(
                        image: AssetImage(
                          imageLogin,
                        ),
                        fit: BoxFit.cover)),
              ),
              SizedBox(width: size6),
              // ClipRRect(
              //   child: Image.asset(
              //     imageLogin,
              //     width: size50,
              //     height: size50,
              //     fit: BoxFit.cover,
              //   ),
              // )
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
            Expanded(
              child: Container(
                width: screenWidth,
                child: ListView(children: [
                  ChatBubble(
                    isSender: true,
                    message: 'Halo dek.',
                  ),
                  ChatBubble(
                    isSender: true,
                    message: 'Kuliah apa kerja?',
                  ),
                  ChatBubble(
                    isSender: false,
                    message: 'nge-punk',
                  ),
                  ChatBubble(
                    isSender: true,
                    message: 'anjink',
                  ),
                  ChatBubble(
                    isSender: false,
                    message: 'awokwowkwokwok',
                  ),
                ]),
              ),
            ),

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
                          textInputAction: TextInputAction.done,
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
                          final result = await controller.sendChats(
                              chatId: argument['chat_id'],
                              sender: authController.user.value.email!,
                              sendTo: argument['sendTo'],
                              message: controller.messageController.text);
                          if (result == 200) {
                            Fluttertoast.showToast(msg: 'success');
                          } else {
                            Fluttertoast.showToast(msg: 'error');
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
