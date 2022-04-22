import 'package:demo_app/screen/friend/friends.dart';
import 'package:demo_app/screen/home/home.dart';
import 'package:demo_app/screen/home/opinion_requests.dart';
import 'package:demo_app/screen/multiple_image/send_opinion_requests.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';

Widget textHelveticaBoldPrimary(context, title, {Function()? onPress}) {
  return InkWell(
      onTap: onPress,
      child: Text(getTranslate(context, title ?? ""),
          style: helveticaWBSmall(context)));
}

Widget textLatoGreyDart(context, title, {Function()? onPress}) {
  return InkWell(
      onTap: onPress,
      child: Text(getTranslate(context, title ?? ""),
          style: helveticaWBSmall(context)));
}

Widget alertText(BuildContext context, title, Icon icon) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(getTranslate(context, title ?? ""),
          style: helveticaWBSmall(context)),
      icon
    ],
  );
}

Widget showYesNo(BuildContext context, data, {onTap}) {
  return InkWell(
    onTap: onTap,
    child: Text(
      getTranslate(context, data),
      style: helveticaWBSmall(context),
    ),
  );
}

Widget bottomButtons(context) {
  return Container(
    color: primaryColor,
    child: Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              pushNavigator(context, FriendsPage());
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: white, width: 1.0),
              ),
              child: Icon(Icons.person, color: white),
            ),
          ),
          InkWell(
            onTap: () {
              pushNavigator(context, SendOpinionRequests());
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: white, width: 1.0),
              ),
              child: Icon(Icons.add, color: white),
            ),
          ),
          InkWell(
            onTap: () {
              pushNavigator(context, OpinionRequests());
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: white, width: 1.0),
              ),
              child: Icon(Icons.question_answer, color: white),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget bottomButtonsOpinion(context) {
  return Container(
    color: primaryColor,
    child: Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              pushNavigator(context, FriendsPage());
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: white, width: 1.0),
              ),
              child: Icon(Icons.person, color: white),
            ),
          ),
          InkWell(
            onTap: () {
              pushAndRemoveUntilNavigator(context, HomePage());
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: white, width: 1.0),
              ),
              child: Icon(Icons.home, color: white),
            ),
          ),
        ],
      ),
    ),
  );
}

questionWidget(context, text) {
  return Padding(padding: EdgeInsets.all(6),
  child: Container(
    width: MediaQuery.of(context).size.width,
    decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: primaryColor),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text ?? '',
          style: helveticaWSmall(context), textAlign: TextAlign.start),
    ),
  ),);
}
