import 'package:demo_app/services/app_theme.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';
import 'package:demo_app/widget/button.dart';
import 'package:demo_app/widget/text_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Widget networkImageCircle(context, url, int width, int height) {
  return CachedNetworkImage(
    imageUrl: url,
    imageBuilder: (context, imageProvider) => Container(
      width: width.toDouble(),
      height: height.toDouble(),
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: getWBColor(context), width: 1.0),
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    ),
    placeholder: (context, url) => Container(
        width: width.toDouble(),
        height: height.toDouble(),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: getWBColor(context), width: 1.0),
        ),
        child: Icon(Icons.person_pin, color: getWBColor(context))),
    errorWidget: (context, url, error) => Container(
      width: width.toDouble(),
      height: height.toDouble(),
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: getWBColor(context), width: 1.0),
      ),
      child: Icon(Icons.person_pin, color: getWBColor(context)),
    ),
  );
}

Widget requestBlock(
    context, Map data, onCancel, isCancel, onReject, isReject, onAdd, isAdd) {
  return Card(
    color: getCarBackColor(context),
    child: Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            fit: FlexFit.loose,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                networkImageCircle(
                    context, data['FriendRequestPhotoLink'], 60, 60),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    getTranslate(context, data['FriendRequestName'] ?? ''),
                    style: helveticaWBMedium(context),
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: data['Sent_Recieved'] == 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      isReject
                          ? CircularProgressIndicator()
                          : InkWell(
                              onTap: onReject,
                              child: Container(
                                decoration: new BoxDecoration(
                                    border: Border.all(
                                        color: getWBColor(context), width: 2),
                                    shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.close,
                                      color: getWBColor(context)),
                                ),
                              ),
                            ),
                      SizedBox(width: 20),
                      isAdd
                          ? CircularProgressIndicator()
                          : InkWell(
                              onTap: onAdd,
                              child: Container(
                                decoration: new BoxDecoration(
                                    border: Border.all(
                                        color: getWBColor(context), width: 2),
                                    shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.done,
                                      color: getWBColor(context)),
                                ),
                              ),
                            )
                    ],
                  )
                : primarySmallBotton(context, 'CANCEL', onCancel, isCancel),
          ),
        ],
      ),
    ),
  );
}

Widget friendBlock(
    context, Map data, onRemove, isRemove, showPopUpTap, showPopUp) {
  return Card(
    color: getCarBackColor(context),
    child: Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  flex: 4,
                  fit: FlexFit.loose,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      networkImageCircle(
                          context, data['FriendPhotoLink'], 60, 60),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          getTranslate(context, data['FriendName'] ?? ''),
                          style: helveticaWBMedium(context),
                        ),
                      )
                    ],
                  )),
              SizedBox(width: 10),
              Flexible(
                flex: 2,
                fit: FlexFit.loose,
                child: InkWell(
                  onTap: showPopUpTap,
                  child: Icon(
                    Icons.more_vert_outlined,
                    color: getWBColor(context),
                  ),
                ),
              ),
            ],
          ),
          if (showPopUp)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                primarySmallBotton(context, 'REMOVE', onRemove, isRemove)
              ],
            )
        ],
      ),
    ),
  );
}

Widget friendAddBlock(context, Map data, onAdd, isAdd) {
  return Card(
    color: getCarBackColor(context),
    child: Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              flex: 4,
              fit: FlexFit.loose,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  networkImageCircle(context, data['photoLLink'], 60, 60),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      getTranslate(context, data['name'] ?? ''),
                      style: helveticaWBMedium(context),
                    ),
                  )
                ],
              )),
          SizedBox(width: 10),
          Flexible(
            flex: 3,
            fit: FlexFit.loose,
            child: primarySmallBotton(context, 'ADD', onAdd, isAdd),
          ),
        ],
      ),
    ),
  );
}

Widget friendNormalBlock(context, Map data, Function()? onTap()) {
  return InkWell(
    onTap: onTap,
    child: Card(
      color: getCarBackColor(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    networkImageCircle(
                        context, data['FriendPhotoLink'], 60, 60),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: (data['isSelected'] == true)
                          ? Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: getBWColor(context),
                                border: Border.all(
                                    color: getWBColor(context), width: 1.0),
                              ),
                              child: Icon(Icons.check_circle_sharp,
                                  color: greenLight),
                            )
                          : Container(),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    getTranslate(context, data['FriendName'] ?? ''),
                    style: helveticaWBMedium(context),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget postCart(context, List data, Function()? onTap(), userName, image) {
  return InkWell(
    onTap: onTap,
    child: Card(
        color: primaryColor,
        child: Container(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: networkImageCircle(context, image, 60, 60),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              getTranslate(context, userName ?? ''),
                              style: helveticaWMedium(context),
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: data[0]['ownrating'].toDouble() ?? .0,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemSize: 20,
                            itemBuilder: (context, _) =>
                                Icon(Icons.star, color: white),
                            onRatingUpdate: (ratingData) {},
                          ),
                        ],
                      ),
                      textFieldWithout(context, data[0]['OwnComments'], 'COMMENT'),
                    ],
                  ),
                )
              ],
            ))
        //  ListTile(
        //   leading: Container(
        //       alignment: Alignment.center,
        //       width: 60,
        //       child: networkImageCircle(context, image, 60, 60)),
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Expanded(
        //         child: Text(
        //           getTranslate(context, userName ?? ''),
        //           style: helveticaWMedium(context),
        //         ),
        //       ),
        //       RatingBar.builder(
        //         initialRating: data['ownrating'].toDouble() ?? .0,
        //         direction: Axis.horizontal,
        //         itemCount: 5,
        //         itemSize: 20,
        //         itemBuilder: (context, _) => Icon(Icons.star, color: white),
        //         onRatingUpdate: (ratingData) {},
        //       ),
        //     ],
        //   ),
        //   subtitle: textFieldWithout(context, data['OwnComments'], 'COMMENT'),
        // )),
        ),
  );
}
