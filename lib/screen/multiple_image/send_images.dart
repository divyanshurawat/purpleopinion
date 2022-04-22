import 'dart:io';
import 'package:demo_app/screen/home/home.dart';
import 'package:demo_app/screen/profile/edit_profile.dart';
import 'package:demo_app/services/alert.dart';
import 'package:demo_app/services/api_service.dart';
import 'package:demo_app/services/cache_service.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';
import 'package:demo_app/widget/appBar.dart';
import 'package:demo_app/widget/bottom_nav_bar/bottom_navbar_md.dart';
import 'package:demo_app/widget/card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

class SendImagesToFriendsPage extends StatefulWidget {
  final List<File>? images;
  final String? question, comments;
  final List<String> comment, likes;
  final double? rating;
  SendImagesToFriendsPage(
      {this.images,
      this.comments,
      this.question,
      this.rating,
      required this.comment,
      required this.likes});

  @override
  _SendImagesToFriendsPageState createState() =>
      _SendImagesToFriendsPageState();
}

class _SendImagesToFriendsPageState extends State<SendImagesToFriendsPage> {
  bool isLoading = false, isSendLoading = false;
  List sendRequestList = [];
  Map? profileDataValue;
  List<File> images = [];
  File? image;
  @override
  void initState() {


    getFriendsData();
    setState(() {
      print("Selected Image Length ${widget.images!.length}");
      if (widget.images!.length > 1) {
        for (int i = 0; i < widget.images!.length; i++) {
          print(widget.images![i]);
          var img = widget.images![i];
          images.add(img);
          print("Multiple Image Selected ${images}");
        }
      } else {
        image = widget.images?[0];
        print("Single Image Selected ${image}");
      }
    });

    super.initState();
  }

  getFriendsData() {
    setState(() {
      isLoading = true;
    });
    CacheService.getAllData().then((profileValue) {
      setState(() {
        if (profileValue.isNotEmpty) {
          profileDataValue = profileValue;
          Map body = {
            'UserEmail': profileValue['UserEmail'],
            'Pword': profileValue['Password']
          };

          ApiService.getUserFriends(body, context).then((value) {
            setState(() {
              isLoading = false;
              if (value['freindsList'].length > 0) {
                for (var i = 0; i < value['freindsList'].length; i++) {
                  if (value['freindsList'][i]['Sent_Recieved'] == 0 &&
                      value['freindsList'][i]['FriendEmailId'] != null &&
                      value['freindsList'][i]['FriendEmailId'] != '' &&
                      profileValue['UserEmail'] !=
                          value['freindsList'][i]['FriendEmailId']) {
                    value['freindsList'][i]['isSelected'] = true;
                    sendRequestList.add(value['freindsList'][i]);
                  }
                }
              }
            });
          }).catchError((onError) {
            setState(() {
              isLoading = false;
            });
          });
        }
      });
    });
  }

  addPost() {
    CacheService.getAllData().then((profileValue) {
      print(profileValue['Photo']);
      if ((profileValue['UserName'] == null ||
              profileValue['UserName'] == '') &&
          (profileValue['Photo'] == null || profileValue['Photo'] == '')) {
        showNormalAlertPress(context, 'NAME_PHOTO_ERROR', onPress: () {
          backNavigator(context);
          pushNavigator(context, EditProfile());
        });
      } else if (profileValue['Photo'] == null || profileValue['Photo'] == '') {
        showNormalAlertPress(context, 'PHOTO_ERROR', onPress: () {
          backNavigator(context);
          pushNavigator(context, EditProfile());
        });
      } else if (profileValue['UserName'] == null ||
          profileValue['UserName'] == '') {
        showNormalAlertPress(context, 'NAME_ERROR', onPress: () {
          backNavigator(context);
          pushNavigator(context, EditProfile());
        });
      } else {
        setState(() {
          isSendLoading = true;
        });
        CacheService.getAllData().then((profileValue) async {
          var singleImage;
          if (images.length > 1) {

            singleImage = await getImage(images[0]);
            addExtraImage(profileValue, "9");
          } else if (images.isEmpty) {

            singleImage = await getImage(image);
            setState(() {
              if (profileValue.isNotEmpty) {
                FormData formData = new FormData.fromMap({
                  'UserEmail': profileValue['UserEmail'],
                  'question': widget.question,
                  'pWord': profileValue['Password'],
                });
                formData.files.add(MapEntry('image', singleImage));

                formData.fields.add(MapEntry('favorite_array', widget.likes[0]));
                formData.fields.add(MapEntry('comment_array', widget.comment[0]));

                for (var elemnt in sendRequestList) {
                  formData.fields.add(MapEntry(
                      'ResponserEmailId_array', elemnt['FriendEmailId']));
                }
                ApiService.addPost(formData, context).then((value) async {
                  print(value['requestId']);
                  if (value['requestId'] == value['requestId']) {
                    print(value['status']);
                    if (images.isNotEmpty && images.length > 0) {
                      // addExtraImage(profileValue, value['PhotoId']);
                    } else {
                      isSendLoading = false;


                      pushAndRemoveUntilNavigator(
                          context, BottomNavigationBarWithMD());
                    }
                  } else {
                    setState(() {
                      isSendLoading = false;
                    });


                    CacheService.setAllData(value['message']);
                  }
                }).catchError((onError) {
                  print("Error");
                  setState(() {
                    isSendLoading = false;
                  });
                });
              }
            });
          }
        });
      }
    });
  }

  getImage(imageData) async {
    Im.Image? imagedata = Im.decodeImage(imageData.readAsBytesSync());
    var compressedImage = new File(
        '${(await getTemporaryDirectory()).path}/img_${Math.Random().nextInt(10000)}.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imagedata!, quality: 80));
    File selfIle = compressedImage;
    String fileName = selfIle.path.split('/').last;
    MultipartFile fileInfo = await MultipartFile.fromFile(selfIle.path,
        filename: fileName, contentType: MediaType('image', 'jpg'));
    return fileInfo;
  }

  addExtraImage(profileValue, postId) async {
    FormData formDataAddimage = new FormData.fromMap({
      'UserEmail': profileValue['UserEmail'],
      'pWord': profileValue['Password'],
      'question': widget.question,

    });

    for (var elemnt in sendRequestList) {
      formDataAddimage.fields
          .add(MapEntry('ResponserEmailId_array', elemnt['FriendEmailId']));
    }
    for (var elemnt in widget.likes) {
      formDataAddimage.fields.add(MapEntry('favorite_array', elemnt));
    }
    for (var elemnt in widget.comment) {
      formDataAddimage.fields.add(MapEntry('comment_array', elemnt));
    }
    for (var elemnt in images) {
      var imageData;

      imageData = await getImage(elemnt);

      formDataAddimage.files.addAll([MapEntry('image', imageData)]);
      print("Uploaded ${formDataAddimage.files.map((e) => e.value.filename)}");
    }
    ApiService.addImageToPost(formDataAddimage, context).then((value) {
      setState(() async {
        isSendLoading = false;
        if (value['requestId'] != null) {
          pushAndRemoveUntilNavigator(context, BottomNavigationBarWithMD());
        } else {}
      });
    }).catchError((onError) {
      setState(() {
        isSendLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: friendAppBar(context, 'SEND_TO_FRIENDS',
          sendRequestList.where((item) => item['isSelected'] == true).length),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : sendRequestList.length > 0
              ? listData(sendRequestList)
              : Center(
                  child: Text(
                    getTranslate(context, 'NO_FRIENDS'),
                    style: helveticaWBSmall(context),
                  ),
                ),
      floatingActionButton:
          sendRequestList.where((item) => item['isSelected'] == true).length > 0
              ? InkWell(
                  onTap: () {
                    if (!isSendLoading) {
                      addPost();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: primaryColor, shape: BoxShape.circle),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: isSendLoading
                          ? Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator())
                          : Icon(Icons.send, color: white),
                    ),
                  ),
                )
              : Container(),
    );
  }

  listData(List list) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      itemBuilder: (context, index) =>
          friendNormalBlock(context, list[index], () {
        setState(() {
          list[index]['isSelected'] = !list[index]['isSelected'];
        });
      }),
      itemCount: list.length,
    );
  }
}
//  ApiService.addImageToPost(formDataAddimage, context).then((value) {
//
//  setState(() async {
//  isSendLoading = false;
//  if (value['requestId'] != null) {
//  pushAndRemoveUntilNavigator(context, BottomNavigationBarWithMD());
//  } else {
//
//  }
//  });
//  }).catchError((onError) {
//  setState(() {
//  isSendLoading = false;
//  });
//  });
