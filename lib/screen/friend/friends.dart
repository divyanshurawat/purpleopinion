import 'dart:async';

import 'package:demo_app/screen/friend/add_friend.dart';
import 'package:demo_app/screen/profile/edit_profile.dart';
import 'package:demo_app/services/api_service.dart';
import 'package:demo_app/services/app_theme.dart';
import 'package:demo_app/services/cache_service.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';
import 'package:demo_app/widget/appBar.dart';
import 'package:demo_app/widget/card.dart';
import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  bool isLoading = false, isRemoveRequestLoading = false, isButton = false;
  final TextEditingController searchController = TextEditingController();
  List sendRequestList = [];
  int? isRemoveRequestIndex;
  Map? profileDataValue;
  String? image;

  @override
  void initState() {
    getFriendsData();
    super.initState();
  }

  FutureOr onGoBack(dynamic value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    FocusScope.of(context).unfocus();
    setState(() {});
  }

  FutureOr onGoBackProfile(dynamic value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    FocusScope.of(context).unfocus();
    CacheService.getAllData().then((profileValue) {
      if (profileValue.isNotEmpty) {
        setState(() {
          image = profileValue['Photo'];
        });
      }
    });
    setState(() {});
  }

  getFriendsData() {
    setState(() {
      isLoading = true;
    });
    CacheService.getAllData().then((profileValue) {
      setState(() {
        if (profileValue.isNotEmpty) {
          profileDataValue = profileValue;
          image = profileValue['Photo'];
          print(image);

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

  removeFriend(index) {
    setState(() {
      isRemoveRequestLoading = true;
      isRemoveRequestIndex = index;
    });
    CacheService.getAllData().then((profileValue) {
      setState(() {
        if (profileValue.isNotEmpty) {
          Map body = {
            'UserEmail': profileValue['UserEmail'],
            "FriendEmail": sendRequestList[index]['FriendEmailId'],
            'Pword': profileValue['Password']
          };
          ApiService.removeFriend(body, context).then((value) {
            setState(() {
              isRemoveRequestLoading = false;
              if (value['status'] == 1) {
                sendRequestList.removeAt(index);
              }
              isRemoveRequestIndex = null;
            });
          }).catchError((onError) {
            setState(() {
              isRemoveRequestLoading = false;
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: friendAppBar(context, 'FRIENDS', sendRequestList.length),
      appBar: friendsAppBar(
        context,
        image ?? '',
        () {
          Route route = MaterialPageRoute(builder: (context) => EditProfile());
          Navigator.push(context, route).then(onGoBackProfile);
        },
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      '${sendRequestList.length} ${getTranslate(context, 'FRIENDS')}',
                      style: helveticaWBMedium(context),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: searchController,
                    style: helveticaWBSmall(context),
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          FocusScope.of(context).unfocus();
                          Map body = {
                            'FirstPara': searchController.text,
                            'Email': profileDataValue?['UserEmail'],
                            'pWord': profileDataValue?['Password'],
                          };
                          pushNavigator(context, AddFriend(body));
                        });
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Container(width: 1),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (searchController.text.isNotEmpty) {
                            setState(() {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              FocusScope.of(context).unfocus();
                              Map body = {
                                'FirstPara': searchController.text,
                                'Email': profileDataValue?['UserEmail'],
                                'pWord': profileDataValue?['Password'],
                              };
                              pushNavigator(context, AddFriend(body));
                            });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.symmetric(horizontal: 9),
                          width: 62,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search, color: getWBColor(context))
                            ],
                          ),
                        ),
                      ),
                      labelStyle: helveticaWBSmall(context),
                      labelText: getTranslate(context, 'SEARCH_FRIEND'),
                      contentPadding: EdgeInsets.all(10),
                      border: new OutlineInputBorder(
                        borderSide: BorderSide(color: getWBColor(context)),
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: getWBColor(context)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: getWBColor(context)),
                      ),
                      errorBorder: new OutlineInputBorder(
                        borderSide: BorderSide(color: getWBColor(context)),
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: getWBColor(context)),
                      ),
                    ),
                  ),
                ),
                sendRequestList.length > 0
                    ? listData(sendRequestList)
                    : Center(
                        child: Text(
                          getTranslate(context, 'NO_FRIENDS'),
                          style: helveticaWBSmall(context),
                        ),
                      ),
              ],
            ),
    );
  }

  listData(List list) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      itemBuilder: (context, index) => friendBlock(
          context,
          list[index],
          () {
            removeFriend(index);
          },
          isRemoveRequestLoading && isRemoveRequestIndex == index
              ? true
              : false,
          () {
            setState(() {
              if (isRemoveRequestIndex == index) {
                isRemoveRequestIndex = null;
              } else {
                isRemoveRequestIndex = index;
              }
            });
          },
          isRemoveRequestIndex == index ? true : false),
      itemCount: list.length,
    );
  }
}
