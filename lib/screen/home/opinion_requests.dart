import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:demo_app/model/opinion_request.dart';
import 'package:demo_app/services/alert.dart';
import 'package:demo_app/services/api_service.dart';
import 'package:demo_app/services/app_theme.dart';
import 'package:demo_app/services/cache_service.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';
import 'package:demo_app/widget/appBar.dart';
import 'package:demo_app/widget/button.dart';
import 'package:demo_app/widget/card.dart';
import 'package:demo_app/widget/comments.dart';
import 'package:demo_app/widget/text.dart';
import 'package:dio/dio.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:share/share.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

import '../../constants.dart';

class OpinionRequests extends StatefulWidget {
  const OpinionRequests({Key? key}) : super(key: key);

  @override
  _OpinionRequestsState createState() => _OpinionRequestsState();
}

class _OpinionRequestsState extends State<OpinionRequests> {
  bool isGetPostLoading = false,
      isRemoveLoading = false;
  List? post = [],
      images = [],

      list = [],
      groupData = [];
 // List? indexItem=[];
  List? groupedList = [];
  List? opinionReq = [];
  List? favorite =[];
  List? recievedRequests = [];
  int Cindex = 0;

  final CarouselController _controller = CarouselController();
  int? isRemoveRequestIndex, id;
  Map? userData;
  int _current = 0;
  Dio dio = new Dio();

  @override
  void initState() {
    //setPushNotificationToken();
    getPost();

    super.initState();
  }

  setPushNotificationToken() {
    CacheService.getFCMToken().then((token) {
      CacheService.getAllData().then((profileValue) {
        setState(() {
          userData = profileValue;
          if (profileValue.isNotEmpty) {
            Map body = {
              'UserEmail': profileValue['UserEmail'],
              'pWord': profileValue['Password'],
              'Token': token
            };
            ApiService.addPushNotificationToken(body, context);
          }
        });
      });
    });
  }

  deletePost(postData) {
    setState(() {
      isRemoveLoading = true;
      id = postData['postId'];
    });
    CacheService.getAllData().then((profileValue) {
      setState(() {
        userData = profileValue;
        if (profileValue.isNotEmpty) {
          Map body = {
            'UserEmail': profileValue['UserEmail'],
            'pWord': profileValue['Password'],
            'postId': postData['postId']
          };
          ApiService.removepost(body, context).then((value) {
            setState(() {
              isRemoveLoading = false;
              id = null;
              if (value['status'] == 1) {
                //  post?.remove(postData);
              } else {
                showNormalAlert(context, value['message']);
              }
            });
          }).catchError((onError) {
            setState(() {
              isRemoveLoading = false;
              id = null;
            });
          });
        }
      });
    });
  }

  Future<bool> addLike(String value, String senderId, String requestId,
      String photoId) async {
    CacheService.getAllData().then((profileValue) {
      setState(() {
        if (profileValue.isNotEmpty) {
          print(profileValue);
          print(senderId);
          print(requestId);
          print(photoId);
          print(value);

          FormData formData = new FormData.fromMap({
            'UserEmail': profileValue['UserEmail'],
            'pWord': profileValue['Password'],
          });

          formData.fields.add(MapEntry('requestId', "$requestId"));
          formData.fields.add(MapEntry('photoId_array', "$photoId"));
          formData.fields.add(MapEntry('favorite_array', '$value'));
          ApiService.addLike(formData, context).then((value) {
            print(value);
          }).catchError((onError) {});
        }
      });
    });
    return value == "0" ? false : true;
  }

  getPost() async {
    setState(() {
      isGetPostLoading = true;
    });
    CacheService.getAllData().then((profileValue) {
      setState(() {
        if (profileValue.isNotEmpty) {
          Map body = {
            'UserEmail': profileValue['UserEmail'],
            'pWord': profileValue['Password']
          };
          ApiService.getRecievedOpinionRequests(body, context).then((value) {
            setState(() {
              isGetPostLoading = false;
              print(value['status']);

              if (value['status'] == value['status']) {
                List? response = value['TempPhotosOfOpinionRequests'];
                recievedRequests = response!.reversed.toList();

                if (recievedRequests!.isNotEmpty) {
                  List? data = [];

                  for (var postData in recievedRequests!) {
                    var groupedData;
                    var peopleByLocation;

                    if (!data.contains(postData['OpinionRequestId'])) {
                      data.add(postData['OpinionRequestId']);

                      peopleByLocation =
                          recievedRequests!.groupingBy('OpinionRequestId');
                      groupedData =
                      peopleByLocation[postData['OpinionRequestId']];
                      groupedList = peopleByLocation.values.toList();
                      groupData!.add(groupedData);
                      favorite!.add(groupedData);
                      print(favorite![0]);
                    }

                    List<String> tempimagesUrl = [];
                    tempimagesUrl.add(postData['PhotoLink']);
                    if (recievedRequests!.isNotEmpty) {
                      for (var imagesData in recievedRequests!) {
                        // print("Image Data $imagesData");
                        if (imagesData['PhotoId'] == postData['PhotoId']) {
                          tempimagesUrl.add(imagesData['PhotoLink']);
                        }
                      }
                    }
                    postData['PhotoLink'] = tempimagesUrl;
                  }
                  //  print(groupData);
                }
              }
            });
          }).catchError((onError) {
            setState(() {
              isGetPostLoading = false;
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, Constants.opionRequest),
      body: isGetPostLoading
          ? Center(child: CircularProgressIndicator())
          : recievedRequests!.isEmpty
          ? Center(
        child: Text(getTranslate(context, 'NO_POST_AVAILABLE'),
            style: helveticaWBSmall(context)),
      )
          : postListData(groupedList, groupData),
    );
  }

  postListData(List? grouped, List? group) {
    return SafeArea(
      child: PageView.builder(

        itemCount: grouped?.length,
        scrollDirection: Axis.vertical,

        itemBuilder: (context, index) {

          return Container(
            width: MediaQuery.of(context).size.width,
            height:MediaQuery.of(context).size.height ,
            child: Column(
              children: [
                if (group![index][0]['timeofentry'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              "${group[index][0]['SenderPhoto']}"),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                  getTranslate(
                                      context, group[index][0]['SenderName']),
                                  style: helveticaWBMedium(context)),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                  getTranslate(
                                      context,
                                      DateFormat('MMM dd yy, hh:mm').format(
                                          DateTime.parse(group[index][0]
                                          ['timeofentry'] ??
                                              '')
                                              .toLocal())),
                                  style: helveticaWBSmall(context)),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CarouselSlider.builder(
                    itemCount:  group[index].length,
                    itemBuilder:
                        (BuildContext context, int itemIndex, int pageViewIndex) {
                      print( group[index].length.toString());
                      return Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            child: Stack(
                              alignment:Alignment.bottomCenter,
                                children: [
                              CachedNetworkImage(
                                imageUrl: "${ group[index][itemIndex]['PhotoLink'][0]}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.70,
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.contain,

                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) =>    Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.70,
          decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius:
          BorderRadius.all(Radius.circular(12)),

          ),
          ),
                                errorWidget: (context, url, error) =>
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.error),
                                      ],
                                    ),
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Stack(
                                    alignment:Alignment.center,
                                    children:[
                                      Icon(
                                     Icons.favorite,
                                        color: Colors.black,
                                        size: 46,

                                      ),
                                      FavoriteButton(
                                        isFavorite:
                                        favorite![index][itemIndex]['favorite'].toString() == "1",
                                        valueChanged: (bool) async {
                                          if (bool) {
                                            favorite![index][itemIndex]['favorite']=1;

                                            print(favorite![index][itemIndex]['favorite']);

                                            final sbool = await addLike(
                                                "1",
                                                group[index][itemIndex]['SenderId']
                                                    .toString(),
                                                group[index][itemIndex]['OpinionRequestId']
                                                    .toString(),
                                                group[index][itemIndex]['PhotoId']
                                                    .toString());
                                            return sbool;
                                          } else if (!bool) {
                                            favorite![index][itemIndex]['favorite']=0;

                                            print(favorite![index][itemIndex]['favorite']);
                                            final sbool = await addLike(
                                                "0",
                                                group[index][itemIndex]['SenderId']
                                                    .toString(),
                                                group[index][itemIndex]['OpinionRequestId']
                                                    .toString(),
                                                group[index][itemIndex]['PhotoId']
                                                    .toString());
                                            return sbool;
                                          }
                                        },
                                      ),
                          ]

                                  ),
                                  SizedBox(height: 50,),
                                ],
                              ),


                            ]),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${itemIndex+1}/${group[index].length.toString()}",style: TextStyle(color: Colors.white),),
                              ),
                              SizedBox(height: 10,)
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Comments(
                                  comment:  group[index][itemIndex]['comment'],
                                ),
                              ),
                              SizedBox(height: 10,)
                            ],
                          ),
                        ],
                      );
                    },
                    options: CarouselOptions(
                      height:MediaQuery.of(context).size.height*0.6,
                      aspectRatio: 9 / 16,
                      viewportFraction: 0.9,
                      initialPage: 0,

                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: false,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
                if (group[index][0]['question'] != null)
                  questionWidget(context, group[index][0]['question']),


              ],
            ),
          );
        },
      ),
    );
  }

}

extension GroupingBy on Iterable<dynamic> {
  Map<int, List<dynamic>> groupingBy(String key) {
    var result = <int, List<dynamic>>{};
    for (var element in this) {
      result[element[key]] = (result[element[key]] ?? [])..add(element);
    }
    return result;
  }
}
