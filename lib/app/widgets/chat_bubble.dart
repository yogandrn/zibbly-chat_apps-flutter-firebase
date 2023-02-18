import 'package:flutter/material.dart';
import 'package:zibbly/app/utils/dimension.dart';
import 'package:zibbly/app/utils/theme.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({
    Key? key,
    required this.isSender,
    required this.message,
  }) : super(key: key);

  String message;
  bool isSender;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size16, vertical: size12),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.75),
            padding: EdgeInsets.symmetric(
              vertical: size12,
              horizontal: size14,
            ),
            decoration: BoxDecoration(
                borderRadius: isSender
                    ? BorderRadius.only(
                        topLeft: Radius.circular(size12),
                        bottomLeft: Radius.circular(size12),
                        topRight: Radius.circular(size12),
                      )
                    : BorderRadius.only(
                        bottomRight: Radius.circular(size12),
                        bottomLeft: Radius.circular(size12),
                        topRight: Radius.circular(size12),
                      ),
                color: isSender ? senderLightBg : replyLightBg),
            child: Text(
              message,
              style: chatTextLight,
            ),
          ),
          SizedBox(
            height: size4,
          ),
          Text(
            ' 12:09 PM ',
            style: chatTextLight.copyWith(fontSize: size10),
          )
        ],
      ),
    );
  }
}
