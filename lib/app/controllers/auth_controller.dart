import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:zibbly/app/data/models/user_model.dart';
import 'package:zibbly/app/routes/app_pages.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? _userCredential;

  var user = UserModel().obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // INIT FUNCTION
  Future<void> firstInitialized() async {
    await checkLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });

    await checkIntro().then((value) {
      if (value) {
        isSkipIntro.value = true;
      }
    });
  }

  // CHECK INTRODUCTION SCREEN
  Future<bool> checkIntro() async {
    final box = GetStorage();
    // JIKA SUDAH ADA SESI, SKIP INTRO
    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
      return true;
    }
    return false;
  }

  // CHECK LOGIN
  Future<bool> checkLogin() async {
    try {
      final isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);
        final googleAuth = await _currentUser!.authentication;

        final credentials = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        await FirebaseAuth.instance
            .signInWithCredential(credentials)
            .then((value) => _userCredential = value);

        CollectionReference users = firestore.collection('users');
        final checkUser = await users.doc(_currentUser!.email).get();
        final userData = checkUser.data() as Map<String, dynamic>;
        print(userData);

        // Update User Model on local
        user.value = UserModel.fromJson(userData);
        user.refresh();

        // user(
        //   UserModel(
        //     uid: userData["uid"],
        //     name: userData["name"],
        //     keyName: userData["keyName"],
        //     email: userData["email"],
        //     photoUrl: userData["photoUrl"],
        //     status: userData["status"],
        //     creationTime: userData["creationTime"],
        //     lastSignInTime: userData["lastSignInTime"],
        //     updateTime: userData["updateTime"],
        //   ),
        // );

        // Fetching Chats collection from user document
        final listChats =
            await users.doc(_currentUser!.email).collection('chats').get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUser> listChatUser = [];
          listChats.docs.forEach((element) {
            listChatUser.add(ChatUser(
                chatId: element.id,
                connection: element.data()['connection'],
                total_unread: element.data()['total_unread'],
                lastTime: element.data()['lastTime']));
          });

          // user.value = UserModel(
          //   uid: userData["uid"],
          //   name: userData["name"],
          //   keyName: userData["keyName"],
          //   email: userData["email"],
          //   photoUrl: userData["photoUrl"],
          //   status: userData["status"],
          //   creationTime: userData["creationTime"],
          //   lastSignInTime: userData["lastSignInTime"],
          //   updateTime: userData["updateTime"],
          // );

          user.update((user) {
            user!.chats = listChatUser;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }
        user.refresh();
        print(user.value.toString());
        // print(user.value.chats![0].chatId ?? 'empty');
        return true;
      }
      return false;
    } catch (error) {
      print('error-autologin : ' + error.toString());
      return false;
    }
  }

  // SIGN IN WITH GOOGLE
  Future<bool> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut(); // Hapus akun sebelumnya
      await _googleSignIn.signIn().then(
          (value) => _currentUser = value); // Untuk login dengan akun google
      final isSignedIn =
          await _googleSignIn.isSignedIn(); // Ambil nilai apakah sudah login

      if (isSignedIn) {
        // jika login berhasil
        final googleAuth = await _currentUser!.authentication;

        final credentials = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        await FirebaseAuth.instance
            .signInWithCredential(credentials)
            .then((value) => _userCredential = value);

        CollectionReference users = firestore.collection('users');
        final checkUser = await users.doc(_currentUser!.email).get();

        if (checkUser.data() == null) {
          await users.doc(_currentUser!.email).set({
            "uid": _userCredential!.user!.uid,
            "name": _currentUser!.displayName,
            "keyName": _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            "email": _currentUser!.email,
            "photoUrl": _currentUser!.photoUrl ?? "noimage",
            "status": "Hi, everyone!",
            "creationTime":
                _userCredential!.user!.metadata.creationTime!.toIso8601String(),
            "lastSignInTime": _userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "updateTime": DateTime.now().toIso8601String(),
          });
          await users.doc(_currentUser!.email).collection('chats');
        } else {
          await users.doc(_currentUser!.email).update({
            "lastSignInTime": _userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "updateTime": DateTime.now().toIso8601String(),
          });
        }

        final thisUser = await users.doc(_currentUser!.email).get();
        final userData = thisUser.data() as Map<String, dynamic>;
        print(userData);

        user.value = UserModel.fromJson(userData);
        // user(UserModel.fromJson(userData));

        // user(
        //   UserModel(
        //     uid: userData["uid"],
        //     name: userData["name"],
        //     keyName: userData["keyName"],
        //     email: userData["email"],
        //     photoUrl: userData["photoUrl"],
        //     status: userData["status"],
        //     creationTime: userData["creationTime"],
        //     lastSignInTime: userData["lastSignInTime"],
        //     updateTime: userData["updateTime"],
        //   ),
        // );

        user.refresh();
        print(user);

        // Fetching Chats collection from user document
        final listChats =
            await users.doc(_currentUser!.email).collection('chats').get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUser> listChatUser = [];
          listChats.docs.forEach((element) {
            listChatUser.add(ChatUser(
                chatId: element.id,
                connection: element.data()['connection'],
                total_unread: element.data()['total_unread'],
                lastTime: element.data()['lastTime']));
          });

          // Update UserModel on Local
          // user(UserModel.fromJson(userData));
          user.update((user) {
            user!.chats = listChatUser;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        print(_userCredential.toString());
        print('Berhasil Login :');
        print(_currentUser.toString());

        // SKIP INTRODUCTION
        // final box = GetStorage();
        // if (box.read('skipIntro') != null) {
        //   box.remove('skipIntro');
        // }
        // box.write('skipIntro', true);

        isAuth.value = true;
        user.refresh();
        // Get.offAllNamed(Routes.HOME);
        return true;
      }
      // GAGAL LOGIN
      else {
        print('Gagal Login');
        return false;
      }
    } catch (error) {
      print('error-login : ' + error.toString());
      return false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  // SKIP INTRODUCTION
  void skipIntro() {
    final box = GetStorage();
    box.write('skipIntro', true);
  }

  // CHANGE DISPLAY NAME
  Future<int> changeName(String name) async {
    try {
      String date = DateTime.now().toIso8601String();
      CollectionReference users = firestore.collection('users');
      await users.doc(_currentUser!.email).update({
        "name": name,
        "keyName": name.substring(0, 1).toUpperCase(),
        "updateTime": date,
      });
      // Update data user model
      user.update(
        (val) {
          val!.name = name;
          val.keyName = name.substring(0, 1).toUpperCase();
          val.updateTime = date;
        },
      );
      user.refresh();
      // Get.defaultDialog(
      //   title: "Success",
      //   middleText: "Successfully Change "
      // );
      return 200;
    } catch (error) {
      print(error);
      return 500;
    }
  }

  // CHANGE STATUS
  Future<int> changeStatus(String status) async {
    try {
      String date = DateTime.now().toIso8601String();
      // Update data di firestore
      CollectionReference users = firestore.collection('users');
      await users.doc(_currentUser!.email).update({
        "status": status,
        "updateTime": date,
      });

      // Ubah UserModel
      user.update(
        (val) {
          val!.status = status;
          val.updateTime = date;
        },
      );
      user.refresh();

      return 200;
    } catch (error) {
      print(error);
      return 500;
    }
  }

  // CREATE NEW CONNECTION
  Future<String?> createConnection(String sendTo) async {
    try {
      bool flagConnection = false;
      String? chat_id;
      String date = DateTime.now().toIso8601String();
      CollectionReference chats = firestore.collection('chats');
      CollectionReference users = firestore.collection('users');
      List<ChatUser> chatUser = [];

      final userDoc = await users.doc(_currentUser!.email).get();

      final userDocChats =
          await users.doc(_currentUser!.email).collection("chats").get();
      print(userDocChats);

      if (userDocChats.docs.isNotEmpty) {
        // user sudah pernah chat dengan user lain
        final checkConnection = await users
            .doc(_currentUser!.email)
            .collection('chats')
            .where('connection', isEqualTo: sendTo)
            .get();
        if (checkConnection.docs.isNotEmpty) {
          // jika sudah pernah chat dgn => sendTo
          chat_id = checkConnection
              .docs[0].id; // chat_id dari collection chat yang sudah ada
          flagConnection = false;
        } else {
          // jika belum pernah maka buat connection baru
          flagConnection = true;
        }
      } else {
        // user belum pernah chat dengan siapapun
        // buat connection baru
        flagConnection = true;
      }

      if (flagConnection == true) {
        // cek chats collection apakah sudah ada koneksi berdua
        final checkConnection = await chats.where('connection', whereIn: [
          [_currentUser!.email, sendTo],
          [sendTo, _currentUser!.email],
        ]).get();

        if (checkConnection.docs.isNotEmpty) {
          // jika sudah ada koneksi berdua
          final chatData =
              checkConnection.docs[0].data() as Map<String, dynamic>;

          await users
              .doc(_currentUser!.email)
              .collection('chats')
              .doc(checkConnection.docs[0].id)
              .set({
            "connection": sendTo,
            "lastTime": chatData['lastTime'],
            "total_unread": chatData['total_unread'],
            "isEmpty": chatData['isEmpty']
          });

          // Fetching Chats collection from user document
          final listChats =
              await users.doc(_currentUser!.email).collection('chats').get();

          if (listChats.docs.isNotEmpty) {
            List<ChatUser> listChatUser = [];
            listChats.docs.forEach((element) {
              listChatUser.add(ChatUser(
                  chatId: element.id,
                  connection: element.data()['connection'],
                  total_unread: element.data()['total_unread'],
                  lastTime: element.data()['lastTime']));
            });
            user.update((user) {
              user!.chats = listChatUser;
            });
          } else {
            user.update((user) {
              user!.chats = [];
            });
          }

          user.refresh();
          chat_id = checkConnection.docs[0].id;

          // chatUser.add(ChatUser(
          //     chatId: checkConnection.docs[0].id,
          //     connection: sendTo,
          //     lastTime: chatData['lastTime']));

          // userChats.add(ChatUser(
          //     chatId: chatDoc.docs[0].id,
          //     connection: sendTo,
          //     lastTime: chatData['lastTime']));

          // userChats.add({
          //   "connection": sendTo,
          //   "chat_id": checkConnection.docs[0].id,
          //   "lastTime": chatData['lastTime'],
          // });
          // await users.doc(_currentUser!.email).update({"chats": userChats});
          // user.update((user) {
          //   user!.chats = chatUser;
          // });

        } else {
          // jika belum, buat baru
          final newChatDoc = await chats.add({
            "connection": [_currentUser!.email, sendTo],
          });

          await chats.doc(newChatDoc.id).collection('chats');

          await users
              .doc(_currentUser!.email)
              .collection('chats')
              .doc(newChatDoc.id)
              .set({
            "connection": sendTo,
            "lastTime": date,
            "total_unread": 0,
            "isEmpty": true
          });

          // Fetching Chats collection from user document
          final listChats =
              await users.doc(_currentUser!.email).collection('chats').get();

          if (listChats.docs.isNotEmpty) {
            List<ChatUser> listChatUser = [];
            listChats.docs.forEach((element) {
              listChatUser.add(ChatUser(
                  chatId: element.id,
                  connection: element.data()['connection'],
                  total_unread: element.data()['total_unread'],
                  lastTime: element.data()['lastTime']));
            });
            user.update((user) {
              user!.chats = listChatUser;
            });
          } else {
            user.update((user) {
              user!.chats = [];
            });
          }

          // chatUser.add(ChatUser(
          //     chatId: newChatDoc.id, connection: sendTo, lastTime: date));

          // userChats.add({
          //   "connection": sendTo,
          //   "chat_id": newChatDoc.id,
          //   "lastTime": date,
          // });

          // await users.doc(_currentUser!.email).update({"chats": userChats});

          // user.update((user) {
          //   user!.chats = chatUser;
          // });

          user.refresh();
          chat_id = newChatDoc.id;
        }
      }

      print('chat_id :' + chat_id.toString());
      print('user-chats :' + user.value.chats!.toString());

      return chat_id;

      // final userChats =
      //     (userDoc.data() as Map<String, dynamic>)['chats'] as List;
      // print(userChats);
      // userChats.forEach((element) {
      //   chatUser.add(ChatUser.fromJson(element));
      // });
      // print(chatUser);

      // if (chatUser.isNotEmpty) {
      //   chatUser.forEach((chat) {
      //     if (chat.connection == sendTo) {
      //       chat_id = chat.chatId;
      //     }
      //   });

      //   if (chat_id != null) {
      //     // jika sudah pernah buat koneksi dgn sendTo
      //     print('skip');
      //     flagConnection = false;
      //     // Get.toNamed(Routes.CHAT, arguments: chat_id);
      //   } else {
      //     // belum pernah buat koneksi dgn sendTo
      //     flagConnection = true;
      //   }
      // } else {
      //   flagConnection = true;
      // }

    } catch (error) {
      print('error-connection : ' + error.toString());
      return null;
    }
  }

  Future<String?> connectUser(String friendEmail) async {
    try {
      bool flagNewConnection = false;
      String? chat_id;
      String date = DateTime.now().toIso8601String();
      CollectionReference chats = firestore.collection("chats");
      CollectionReference users = firestore.collection("users");

      final docChats =
          await users.doc(_currentUser!.email).collection("chats").get();

      if (docChats.docs.length != 0) {
        // user sudah pernah chat dengan siapapun
        final checkConnection = await users
            .doc(_currentUser!.email)
            .collection("chats")
            .where("connection", isEqualTo: friendEmail)
            .get();

        if (checkConnection.docs.length != 0) {
          // sudah pernah buat koneksi dengan => friendEmail
          flagNewConnection = false;

          //chat_id from chats collection
          chat_id = checkConnection.docs[0].id;
        } else {
          // blm pernah buat koneksi dengan => friendEmail
          // buat koneksi ....
          flagNewConnection = true;
        }
      } else {
        // blm pernah chat dengan siapapun
        // buat koneksi ....
        flagNewConnection = true;
      }

      if (flagNewConnection) {
        // cek dari chats collection => connections => mereka berdua...
        final chatsDocs = await chats.where(
          "connections",
          whereIn: [
            [
              _currentUser!.email,
              friendEmail,
            ],
            [
              friendEmail,
              _currentUser!.email,
            ],
          ],
        ).get();

        if (chatsDocs.docs.length != 0) {
          // terdapat data chats (sudah ada koneksi antara mereka berdua)
          final chatDataId = chatsDocs.docs[0].id;
          final chatsData = chatsDocs.docs[0].data() as Map<String, dynamic>;

          await users
              .doc(_currentUser!.email)
              .collection("chats")
              .doc(chatDataId)
              .set({
            "connection": friendEmail,
            "lastTime": chatsData["lastTime"],
            "total_unread": 0,
          });

          final listChats =
              await users.doc(_currentUser!.email).collection("chats").get();

          if (listChats.docs.length != 0) {
            List<ChatUser> dataListChats = [];
            listChats.docs.forEach((element) {
              var dataDocChat = element.data();
              var dataDocChatId = element.id;
              dataListChats.add(ChatUser(
                chatId: dataDocChatId,
                connection: dataDocChat["connection"],
                lastTime: dataDocChat["lastTime"],
                total_unread: dataDocChat["total_unread"],
              ));
            });
            user.update((user) {
              user!.chats = dataListChats;
            });
          } else {
            user.update((user) {
              user!.chats = [];
            });
          }

          chat_id = chatDataId;

          user.refresh();
        } else {
          // buat baru , mereka berdua benar2 belum ada koneksi
          final newChatDoc = await chats.add({
            "connections": [
              _currentUser!.email,
              friendEmail,
            ],
          });

          await chats.doc(newChatDoc.id).collection("chat");

          await users
              .doc(_currentUser!.email)
              .collection("chats")
              .doc(newChatDoc.id)
              .set({
            "connection": friendEmail,
            "lastTime": date,
            "total_unread": 0,
          });

          final listChats =
              await users.doc(_currentUser!.email).collection("chats").get();

          if (listChats.docs.length != 0) {
            List<ChatUser> dataListChats = [];
            listChats.docs.forEach((element) {
              var dataDocChat = element.data();
              var dataDocChatId = element.id;
              dataListChats.add(ChatUser(
                chatId: dataDocChatId,
                connection: dataDocChat["connection"],
                lastTime: dataDocChat["lastTime"],
                total_unread: dataDocChat["total_unread"],
              ));
            });
            user.update((user) {
              user!.chats = dataListChats;
            });
          } else {
            user.update((user) {
              user!.chats = [];
            });
          }

          chat_id = newChatDoc.id;

          user.refresh();
        }
      }

      print(chat_id);
      return chat_id;
    } catch (error) {
      print('error connect-user : ' + error.toString());
      return null;
    }
  }
}
