import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:zibbly/app/controllers/auth_controller.dart';
import 'package:zibbly/app/routes/app_pages.dart';
import 'package:zibbly/app/utils/app_const.dart';
import 'package:zibbly/app/utils/dimension.dart';
import 'package:zibbly/app/utils/helpers.dart';
import 'package:zibbly/app/utils/theme.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(size40 * 3.2),
          child: AppBar(
            title: Text(
              'Search',
              style: appbarTitleStyle,
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back_rounded),
            ),
            flexibleSpace: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: size20, vertical: size15),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextFormField(
                  controller: controller.searchController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  style: formTextstyle,
                  onChanged: (value) => controller.searchFriend(
                      keyword: value, except: authController.user.value.email!),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: size20,
                      vertical: size8,
                    ),
                    hintText: 'Search contact or people you know',
                    hintStyle: hintTextstyle,
                    filled: true,
                    fillColor: white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(size16),
                      borderSide: BorderSide(color: primaryColor, width: 0.8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(size16),
                      borderSide: BorderSide(color: primaryColor, width: 1.0),
                    ),
                    suffixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isSearching.isTrue) {
            return searchResult();
          }
          return placeHolder();
        }));
  }

  Widget placeHolder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imageSearchData,
            width: size50 * 3,
          ),
          SizedBox(height: size8),
          Text(
            'Search Contacts',
            textAlign: TextAlign.center,
            style: inter500.copyWith(fontSize: size14, color: black),
          ),
          SizedBox(height: size10),
          Text(
            'Search your friends\nyou want to send messages',
            textAlign: TextAlign.center,
            style: inter400.copyWith(
              fontSize: size13,
              color: grey,
            ),
          )
        ],
      ),
    );
  }

  Widget searchResult() {
    return Obx(() {
      if (controller.tempSearch.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                imageEmptySearch,
                width: size50 * 3,
              ),
              SizedBox(height: size15),
              Text(
                'No Result Found',
                textAlign: TextAlign.center,
                style: inter500.copyWith(fontSize: size14, color: grey),
              ),
              // SizedBox(height: size10),
              // Text(
              //   '',
              //   textAlign: TextAlign.center,
              //   style: inter400.copyWith(
              //     fontSize: size13,
              //   ),
              // )
            ],
          ),
        );
      } else {
        return ListView.builder(
            padding: EdgeInsets.symmetric(
              vertical: size12,
              horizontal: size8,
            ),
            itemCount: controller.tempSearch.length,
            // separatorBuilder: (context, index) {
            //   return Padding(
            //     padding: EdgeInsets.symmetric(horizontal: size12),
            //     child: Divider(
            //       color: silver,
            //       height: size16,
            //       thickness: 1.2,
            //     ),
            //   );
            // },
            itemBuilder: (context, index) {
              return itemResult(
                  name: controller.tempSearch[index]['name']!,
                  email: controller.tempSearch[index]['email']!,
                  photoUrl: controller.tempSearch[index]['photoUrl'] ??
                      'https://zultimate.com/wp-content/uploads/2019/12/default-profile.png');
              // return Container(
              //   height: size40,
              //   margin: EdgeInsets.symmetric(vertical: size8),
              //   color: silver,
              //   child: Text(index.toString()),
              // );
            });
      }
    });
  }

  Widget itemResult(
      {required String name, required String email, required String photoUrl}) {
    return InkWell(
      onTap: () async {
        final result = await authController.createConnection(email);
        if (result == null || result == '') {
          Fluttertoast.showToast(msg: ' something went wrong!');
        } else {
          Get.offNamed(Routes.CHAT,
              arguments: {'chat_id': result, 'sendTo': email});
          // Get.toNamed(Routes.CHAT, arguments: result);
        }
      },
      child: ListTile(
        contentPadding:
            EdgeInsets.symmetric(vertical: size8, horizontal: size12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(size50),
          child: CachedNetworkImage(
            imageUrl: photoUrl,
            fit: BoxFit.cover,
            width: size50,
            height: size50,
          ),
        ),
        title: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: inter500.copyWith(fontSize: size15, color: black),
        ),
        subtitle: Text(
          email,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: inter400.copyWith(fontSize: size13, color: grey),
        ),
        trailing: Chip(
          label: Text(
            'Send Message',
            style: inter400.copyWith(
              fontSize: size13,
              color: black,
            ),
          ),
        ),
      ),
    );
  }
}
