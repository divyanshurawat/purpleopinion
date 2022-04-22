import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_app/constants.dart';
import 'package:demo_app/screen/home/carousel_slider.dart';
import 'package:demo_app/services/alert.dart';
import 'package:demo_app/services/api_service.dart';
import 'package:demo_app/services/cache_service.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';
import 'package:demo_app/widget/appBar.dart';
import 'package:demo_app/widget/card.dart';
import 'package:demo_app/widget/comments.dart';
import 'package:demo_app/widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isGetPostLoading = false, isRemoveLoading = false;
  List? post = [],
      images = [],
      responses = [],
      groupData = [],
      likeData = [],
      likesGroupData = [],
      tempFriendList = [];
  List? newU = [];
  bool showCard= false;
  List? groupedList = [];
  final CarouselController _controller = CarouselController();
  int? isRemoveRequestIndex, id;
  Map? userData;
  int _current = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    setPushNotificationToken();
    getPost();
    _scrollController.addListener(() {
      setState(() {
        showCard=false;
      });

    });
    CacheService.getAllData().then((profileValue) {
      if ((profileValue['UserName'] == null ||
              profileValue['UserName'] == '') &&
          (profileValue['Photo'] == null || profileValue['Photo'] == '')) {
        showNormalAlert(context, 'NAME_PHOTO_ERROR');
      } else if (profileValue['Photo'] == null || profileValue['Photo'] == '') {
        showNormalAlert(context, 'PHOTO_ERROR');
      } else if (profileValue['UserName'] == null ||
          profileValue['UserName'] == '') {
        showNormalAlert(context, 'NAME_ERROR');
      } else {
        userData = profileValue;
      }
    });
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
                post?.remove(postData);
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

  getLikes(int photoId) {
    print(photoId);
    CacheService.getAllData().then((profileValue) {
      setState(() {
        if (profileValue.isNotEmpty) {
          Map body = {
            'UserEmail': profileValue['UserEmail'],
            'pWord': profileValue['Password']
          };
          ApiService.getResponseForAllPostsOfUser(body, context).then((value) {
            setState(() {
              if (value['status'] == value['status']) {
                List? tempReplies = value['TempFriendReplies'];

                List tmpFriendList = tempReplies!.reversed.toList();
                tempFriendList = tmpFriendList
                    .where((element) => element['photoId'] == photoId)
                    .toList();
                print(tempFriendList);

                if (post!.isNotEmpty) {
                  List? data = [];
                  List? likedData = [];
                  for (var friendList in tempFriendList!) {
                    var groupedData;
                    var peopleByLocation;

                    if (!likedData.contains(friendList['photoId'])) {
                      likedData.add(friendList['photoId']);

                      peopleByLocation = tempFriendList!.likeGroupBy('photoId');
                      groupedData = peopleByLocation[friendList['photoId']];

                      likesGroupData = peopleByLocation.values.toList();
                      print(likesGroupData![0]);

                      //
                    }
                  }
                }
              }
            });
          }).catchError((onError) {});
        }
      });
    });
  }

  getPost() {
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
          ApiService.getResponseForAllPostsOfUser(body, context).then((value) {
            setState(() {
              isGetPostLoading = false;
              if (value['status'] == value['status']) {
                List? tempReplies = value['TempFriendReplies'];

                List? response = value['TempSentPhotosForOpinion'];
                post = response!.reversed.toList();
                tempFriendList = tempReplies!.reversed.toList();
                final releaseDateMap = tempFriendList!.groupBy((m) => m['photoId']);
                groupedList!.add(releaseDateMap.values.toList());


                for (int i = 0; i < tempFriendList!.length; i++) {


                  for (int j = 0; j < post!.length; j++) {
                    List temp = [];

                    print("bbb ${groupedList![0][i][0]['photoId']} == ${post![j]['photoId']}");


                    if(post![j]['photoId']==groupedList![0][i][0]['photoId']){
                      print(groupedList![0][i][0]['photoId']);
                      List tempr = [];
                      print("yes");
                      temp.add(groupedList![0][i]);
                      tempr.add([post![j]]);

                      var newgfgList = new List.from(temp)..addAll(tempr);
                      newU!.add(newgfgList);
                      i++;


                    }else if(post![j]['photoId']!=groupedList![0][i][0]['photoId']|| groupedList![0].isEmpty)  {
                      List tempr = [];
                      print("No ${groupedList![0][i][0]['photoId']}");
                      temp.add([]);
                      tempr.add([post![j]]);

                      var newgfgList = new List.from(temp)..addAll(tempr);

                      newU!.add(newgfgList);
                      print(newgfgList);




                    }



                  }
                }
              }

              //Grouping with Request Id
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
      appBar: normalAppBar(context, Constants.appName),
      body: isGetPostLoading
          ? Center(child: CircularProgressIndicator())
          : post!.isEmpty
              ? Center(
                  child: Text(getTranslate(context, 'NO_POST_AVAILABLE'),
                      style: helveticaWBSmall(context)),
                )
              : SafeArea(
                child: Builder(
                  builder: (context) {
                    if(newU!.isNotEmpty&&newU!=null){
                      return Carouselider(slider:newU!,userData: userData!,);
                    }
                    return Text("Loading");

                  }
                ),
              ),
    );
  }




}

extension LikeGroupBy on Iterable<dynamic> {
  Map<int, List<dynamic>> likeGroupBy(String key) {
    var result = <int, List<dynamic>>{};
    for (var element in this) {
      result[element[key]] = (result[element[key]] ?? [])..add(element);
    }
    return result;
  }
}

extension GroupingByReq on Iterable<dynamic> {
  Map<int, List<dynamic>> groupingByReq(String key) {
    var result = <int, List<dynamic>>{};
    for (var element in this) {
      result[element[key]] = (result[element[key]] ?? [])..add(element);
    }
    return result;
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
