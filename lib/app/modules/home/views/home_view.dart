import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zibbly/app/controllers/auth_controller.dart';
import 'package:zibbly/app/data/models/user_model.dart';
import 'package:zibbly/app/routes/app_pages.dart';
import 'package:zibbly/app/utils/app_const.dart';
import 'package:zibbly/app/utils/dimension.dart';
import 'package:zibbly/app/utils/theme.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: primaryColor,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              header(),
              // content()

              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream:
                      controller.chatStream(authController.user.value.email!),
                  builder: (context, snapshotChats) {
                    if (snapshotChats.connectionState ==
                        ConnectionState.waiting) {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                          vertical: size12,
                          horizontal: size4,
                        ),
                        itemBuilder: (context, index) => itemChatOnLoading(),
                        itemCount: 3,
                      );
                    } else if (snapshotChats.data!.docs.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            imageNoChats,
                            width: size50 * 3,
                          ),
                          SizedBox(height: size15),
                          Text(
                            'No Message',
                            textAlign: TextAlign.center,
                            style: inter500.copyWith(
                              fontSize: size14,
                              color: black,
                            ),
                          ),
                          SizedBox(height: size10),
                          Text(
                            'You have no messages yet',
                            textAlign: TextAlign.center,
                            style: inter400.copyWith(
                              fontSize: size13,
                              color: grey,
                            ),
                          )
                        ],
                      );
                    } else if (snapshotChats.hasData &&
                        snapshotChats.data != null) {
                      var chatDocs = snapshotChats.data!.docs;
                      print("List of Connections");
                      print(chatDocs[0]['isEmpty']);
                      final listChats = chatDocs
                          .where(
                            (element) => element['isEmpty'] == false,
                          )
                          .toList();
                      print(
                          'listChats : ' + listChats[0]['isEmpty'].toString());
                      if (listChats.isEmpty) {
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: listChats.length,
                          itemBuilder: (context, index) {
                            return StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              stream: controller.friendDataStream(
                                  listChats[index]["connection"]),
                              builder: (context, snapshotFriend) {
                                if (snapshotFriend.connectionState ==
                                    ConnectionState.waiting) {
                                  return itemChatOnLoading();
                                } else if (snapshotFriend.hasData &&
                                    snapshotFriend.data != null) {
                                  var friendData = snapshotFriend.data!.data()!;
                                  return itemChat(
                                    chatId: listChats[index].id,
                                    email: friendData['email'],
                                    name: friendData['name'],
                                    status: friendData['status'],
                                    photoUrl: friendData['photoUrl'],
                                    unread: chatDocs[index]['total_unread'],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            );
                          },
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              imageNoChats,
                              width: size50 * 3,
                            ),
                            SizedBox(height: size15),
                            Text(
                              'No Message',
                              textAlign: TextAlign.center,
                              style: inter500.copyWith(
                                fontSize: size14,
                                color: black,
                              ),
                            ),
                            SizedBox(height: size10),
                            Text(
                              'You have no messages yet',
                              textAlign: TextAlign.center,
                              style: inter400.copyWith(
                                fontSize: size13,
                                color: grey,
                              ),
                            )
                          ],
                        );
                      }
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                          vertical: size12,
                          horizontal: size4,
                        ),
                        itemBuilder: (context, index) => itemChatOnLoading(),
                        itemCount: 3,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.SEARCH),
          backgroundColor: primaryColor,
          child: Icon(
            FontAwesomeIcons.message,
            color: white,
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Material(
      elevation: size6,
      child: Container(
        height: size40 * 1.7,
        padding: EdgeInsets.symmetric(horizontal: size25),
        color: primaryColor,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Chats',
                style: appbarTitleStyle.copyWith(fontSize: size20),
              ),
              Material(
                color: primaryColor,
                borderRadius: BorderRadius.circular(size40),
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.PROFILE),
                  child: Image.asset(
                    iconProfileWhite,
                    width: size32 - 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget content() {
    // return Obx(() {
    //   if (authController.user.value.chats!.isEmpty ||
    //       authController.user.value.chats == null) {
    //     return Expanded(
    //         child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Image.asset(
    //           imageNoChats,
    //           width: size50 * 3,
    //         ),
    //         SizedBox(height: size15),
    //         Text(
    //           'No Message',
    //           textAlign: TextAlign.center,
    //           style: inter500.copyWith(
    //             fontSize: size14,
    //             color: black,
    //           ),
    //         ),
    //         SizedBox(height: size10),
    //         Text(
    //           'You have no messages yet',
    //           textAlign: TextAlign.center,
    //           style: inter400.copyWith(
    //             fontSize: size13,
    //             color: grey,
    //           ),
    //         )
    //       ],
    //     ));
    //   } else {
    //     return Expanded(
    //       child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    //           stream: controller.chatStream(authController.user.value.email!),
    //           builder: (context, snapshotChat) {
    //             print(snapshotChat.data!.docs);
    //             if (snapshotChat.connectionState == ConnectionState.active) {
    //               // var allChats = (snapshotChat.data!.data()!
    //               //     as Map<String, dynamic>)['chats'] as List;
    //               var chatDocs = snapshotChat.data!.docs;
    //               return ListView.builder(
    //                   padding: EdgeInsets.symmetric(
    //                     vertical: size12,
    //                     horizontal: size4,
    //                   ),
    //                   itemCount: chatDocs.length,
    //                   itemBuilder: (context, index) {
    //                     return StreamBuilder<
    //                         DocumentSnapshot<Map<String, dynamic>>>(
    //                       stream: controller
    //                           .friendDataStream(chatDocs[index]['connection']),
    //                       builder: (context, snapshotFriend) {
    //                         if (snapshotFriend.connectionState ==
    //                             ConnectionState.active) {
    //                           var friendData = snapshotFriend.data!.data()!;
    //                           return itemChat(
    //                             status: friendData['status'],
    //                             name: friendData['name'],
    //                             photoUrl: friendData['photoUrl'],
    //                             unread: chatDocs[index]['total_unread'],
    //                           );
    //                         }
    //                         return itemChatOnLoading();
    //                       },
    //                     );
    //                   });
    //             }
    //             return ListView.builder(
    //                 padding: EdgeInsets.symmetric(
    //                   vertical: size12,
    //                   horizontal: size4,
    //                 ),
    //                 itemCount: 3,
    //                 itemBuilder: (context, index) {
    //                   return itemChatOnLoading();
    //                 });
    //             // return Center(
    //             //   child: LoadingAnimationWidget.waveDots(
    //             //       color: primaryColor, size: size50),
    //             // );
    //           }),
    //     );
    //   }
    // });

    return Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.chatStream(authController.user.value.email!),
          builder: (context, snapshotChat) {
            print(snapshotChat.data!.docs);
            // if (snapshotChat.hasError) {
            //   return Center(
            //     child: Text(
            //       snapshotChat.error.toString(),
            //     ),
            //   );
            // }
            if (snapshotChat.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshotChat.hasData && snapshotChat.data != null) {
              // var allChats = (snapshotChat.data!.data()!
              //     as Map<String, dynamic>)['chats'] as List;
              // if (snapshotChat.data!.docs.isEmpty) {
              //   return Center(
              //     child: Text('Empty'),
              //   );
              // } else {
              var chatDocs = snapshotChat.data!.docs;
              if (chatDocs.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imageNoChats,
                      width: size50 * 3,
                    ),
                    SizedBox(height: size15),
                    Text(
                      'No Message',
                      textAlign: TextAlign.center,
                      style: inter500.copyWith(
                        fontSize: size14,
                        color: black,
                      ),
                    ),
                    SizedBox(height: size10),
                    Text(
                      'You have no messages yet',
                      textAlign: TextAlign.center,
                      style: inter400.copyWith(
                        fontSize: size13,
                        color: grey,
                      ),
                    )
                  ],
                );
              } else {
                return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      vertical: size12,
                      horizontal: size4,
                    ),
                    itemCount: chatDocs.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        stream: controller
                            .friendDataStream(chatDocs[index]['connection']),
                        builder: (context, snapshotFriend) {
                          if (snapshotFriend.connectionState ==
                              ConnectionState.waiting) {}
                          if (snapshotFriend.hasData &&
                              snapshotChat.data != null) {
                            var friendData = snapshotFriend.data!.data()!;
                            return itemChat(
                              chatId: chatDocs[index].id,
                              email: friendData['email'],
                              name: friendData['name'],
                              status: friendData['status'],
                              photoUrl: friendData['photoUrl'],
                              unread: chatDocs[index]['total_unread'],
                            );
                          }
                          return SizedBox();
                        },
                      );
                    });
              }
              // }
            }
            return ListView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: size12,
                  horizontal: size4,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return itemChatOnLoading();
                });
            // return Center(
            //   child: LoadingAnimationWidget.waveDots(
            //       color: primaryColor, size: size50),
            // );
          }),
    );

    return Expanded(
      child: ListView.separated(
          padding: EdgeInsets.symmetric(
            vertical: size12,
            horizontal: size4,
          ),
          itemCount: 12,
          separatorBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: size12),
              // child: Divider(
              //   color: silver,
              //   height: size10,
              //   thickness: 1.2,
              // ),
            );
          },
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Get.toNamed(Routes.CHAT),
              child: ListTile(
                leading: CircleAvatar(),
                title: Text(
                  'Orang ke ${index + 1}',
                  style: inter500.copyWith(fontSize: size16, color: black),
                ),
                subtitle: Text(
                  'Status orang ke ${index + 1}',
                  style: inter400.copyWith(fontSize: size14, color: grey),
                ),
                trailing: Chip(label: Text('1')),
              ),
            );
            // return Container(
            //   height: size40,
            //   margin: EdgeInsets.symmetric(vertical: size8),
            //   color: silver,
            //   child: Text(index.toString()),
            // );
          }),
    );
  }

  Widget itemChat({
    required String chatId,
    required String email,
    required String name,
    required String status,
    required String photoUrl,
    int unread = 0,
  }) {
    return InkWell(
      onTap: () async {
        final result =
            await controller.goToChatRoom(chat_id: chatId, email: email);
        if (result == true) {
          Get.toNamed(
            Routes.CHAT,
            arguments: {'chat_id': chatId, 'sendTo': email},
          );
        }
        Fluttertoast.showToast(msg: result.toString());
      },
      child: ListTile(
        contentPadding:
            EdgeInsets.symmetric(vertical: size6, horizontal: size12),
        leading:
            // Container(
            //   height: size50,
            //   width: size50,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(size50),
            //       image: DecorationImage(
            //           image: CachedNetworkImageProvider(photoUrl),
            //           fit: BoxFit.cover)),
            // ),

            // CircleAvatar(
            //   radius: size50 + 10,
            //   child: CachedNetworkImage(
            //     imageUrl: photoUrl,
            //     fit: BoxFit.cover,
            //     width: size50 + 10,
            //     height: size50 + 10,
            //   ),
            // ),

            ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: CachedNetworkImage(
            imageUrl: photoUrl,
            fit: BoxFit.cover,
            width: size50,
            height: size50,
          ),
        ),
        title: Text(
          name,
          style: inter500.copyWith(fontSize: size16, color: black),
        ),
        subtitle: Text(
          status,
          style: inter400.copyWith(fontSize: size14, color: grey),
        ),
        trailing:
            unread == 0 ? SizedBox() : Chip(label: Text(unread.toString())),
      ),
    );
  }

  Widget itemChatOnLoading() {
    return ListTile(
      contentPadding:
          EdgeInsets.symmetric(vertical: size10, horizontal: size12),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(size40 * 2),
        child: Image.asset(
          defaultPhotoUrl,
          fit: BoxFit.cover,
          width: size50 + 10,
          height: size50 + 10,
        ),
      ),
      title: Container(
        height: size16,
        width: screenWidth / 2.5,
        color: silver,
      ),
      subtitle: Container(
        height: size14,
        width: screenWidth / 1.9,
        color: silver,
      ),
    );
  }
}
