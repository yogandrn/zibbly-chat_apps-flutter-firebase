import 'package:get/get.dart';

import 'package:zibbly/app/modules/change_name/bindings/change_name_binding.dart';
import 'package:zibbly/app/modules/change_name/views/change_name_view.dart';
import 'package:zibbly/app/modules/chat/bindings/chat_binding.dart';
import 'package:zibbly/app/modules/chat/views/chat_view.dart';
import 'package:zibbly/app/modules/home/bindings/home_binding.dart';
import 'package:zibbly/app/modules/home/views/home_view.dart';
import 'package:zibbly/app/modules/introduction/bindings/introduction_binding.dart';
import 'package:zibbly/app/modules/introduction/views/introduction_view.dart';
import 'package:zibbly/app/modules/login/bindings/login_binding.dart';
import 'package:zibbly/app/modules/login/views/login_view.dart';
import 'package:zibbly/app/modules/profile/bindings/profile_binding.dart';
import 'package:zibbly/app/modules/profile/views/profile_view.dart';
import 'package:zibbly/app/modules/search/bindings/search_binding.dart';
import 'package:zibbly/app/modules/search/views/search_view.dart';
import 'package:zibbly/app/modules/update_status/bindings/update_status_binding.dart';
import 'package:zibbly/app/modules/update_status/views/update_status_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.INTRODUCTION,
      page: () => IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_STATUS,
      page: () => UpdateStatusView(),
      binding: UpdateStatusBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_NAME,
      page: () => ChangeNameView(),
      binding: ChangeNameBinding(),
    ),
    // GetPage(
    //   name: _Paths.CHAT_ROOM,
    //   page: () => ChatRoomView(),
    //   binding: ChatRoomBinding(),
    // ),
  ];
}
