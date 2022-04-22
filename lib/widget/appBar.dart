import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app/screen/friend/friends.dart';
import 'package:demo_app/screen/friend/friends_request.dart';
import 'package:demo_app/screen/home/home.dart';
import 'package:demo_app/screen/settings/setting.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';

import 'bottom_nav_bar/bottom_navbar_md.dart';

normalAppBar(context, title) {
  return AppBar(
    backgroundColor: primaryColor,
    centerTitle: true,
    title: Text(getTranslate(context, title ?? ""),
        style: helveticaFixWhite(context)),
  );
}

friendsAppBar(context, url, profile) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: primaryColor,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [


       Spacer(),
        InkWell(
          onTap: profile,
          child: CachedNetworkImage(
            imageUrl: url,
            imageBuilder: (context, imageProvider) => Container(
              width: 35,
              height: 35,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: white, width: 1.0),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => Container(
                width: 35,
                height: 35,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: white, width: 1.0),
                ),
                child: Icon(Icons.person_pin, color: white)),
            errorWidget: (context, url, error) => Container(
              width: 35,
              height: 35,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: white, width: 1.0),
              ),
              child: Icon(Icons.person_pin, color: white),
            ),
          ),
        ),
      ],
    ),
  );
}

editProfileHomeAppBar(context, title) {
  return AppBar(
    leading: InkWell(
      onTap: () {
        pushAndRemoveUntilNavigator(context, BottomNavigationBarWithMD());
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          decoration: new BoxDecoration(
              border: Border.all(color: white, width: 1),
              shape: BoxShape.circle),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(Icons.home, color: white),
          ),
        ),
      ),
    ),
    backgroundColor: primaryColor,
    centerTitle: true,
    title: Text(getTranslate(context, title ?? ""),
        style: helveticaFixWhite(context)),
  );
}

editProfileAppBar(context, title) {
  return AppBar(
    backgroundColor: primaryColor,
    centerTitle: true,
    title: Text(getTranslate(context, title ?? ""),
        style: helveticaFixWhite(context)),
    actions: [
      InkWell(
        onTap: () {
          pushNavigator(context, SettingsPage());
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            decoration: new BoxDecoration(
                border: Border.all(color: white, width: 1),
                shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(Icons.settings, color: white),
            ),
          ),
        ),
      )
    ],
  );
}

friendRequestAppBar(context, title, isLoading, sent, received) {
  return AppBar(
      backgroundColor: primaryColor,
      centerTitle: true,
      bottom: isLoading
          ? null
          : TabBar(
              labelStyle: helveticaFixWhite(context),
              tabs: [
                Tab(text: '${getTranslate(context, 'SENT')} ($sent)'),
                Tab(text: '${getTranslate(context, 'RECEIVED')} ($received)'),
              ],
            ),
      title: Text(getTranslate(context, title ?? ""),
          style: helveticaFixWhite(context)));
}

friendAppBar(context, title, friend) {
  return AppBar(
    backgroundColor: primaryColor,
    centerTitle: true,
    title: Text(
      '${getTranslate(context, title ?? "")} ($friend)',
      style: helveticaFixWhite(context),
    ),
  );
}

imageAppBar(context, title, friend, Function()? sendTab) {
  return AppBar(
    backgroundColor: primaryColor,
    centerTitle: true,
    title: Text(
      '${getTranslate(context, title ?? "")} ($friend)',
      style: helveticaFixWhite(context),
    ),
    actions: [
      InkWell(
        onTap: sendTab,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            decoration: new BoxDecoration(
                border: Border.all(color: white, width: 1),
                shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(Icons.send, color: white),
            ),
          ),
        ),
      ),
    ],
  );
}
