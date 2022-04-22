import 'package:demo_app/services/api_service.dart';
import 'package:demo_app/services/cache_service.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';
import 'package:demo_app/widget/appBar.dart';
import 'package:demo_app/widget/card.dart';
import 'package:flutter/material.dart';

class FriendsRequest extends StatefulWidget {
  @override
  _FriendsRequestState createState() => _FriendsRequestState();
}

class _FriendsRequestState extends State<FriendsRequest> {
  bool isLoading = false,
      iscancelSendRequestLoading = false,
      isAcceptReceivedRequestLoading = false,
      isRejectReceivedRequestLoading = false,
      isRemoveRequestLoading = false;
  List sendRequestList = [];
  List receivedRequestList = [];
  int? iscancelSendRequestIndex,
      isAcceptReceivedRequestIndex,
      isRejectReceivedRequestIndex,
      isRemoveRequestIndex;
  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  getProfileData() {
    setState(() {
      isLoading = true;
    });
    CacheService.getAllData().then((profileValue) {
      setState(() {
        if (profileValue.isNotEmpty) {
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
                      value['freindsList'][i]['FriendRequestEmailId'] != null &&
                      value['freindsList'][i]['FriendRequestEmailId'] != '' &&
                      profileValue['UserEmail'] !=
                          value['freindsList'][i]['FriendRequestEmailId']) {
                    sendRequestList.add(value['freindsList'][i]);
                  } else if (value['freindsList'][i]['Sent_Recieved'] == 1 &&
                      value['freindsList'][i]['FriendRequestEmailId'] != null &&
                      value['freindsList'][i]['FriendRequestEmailId'] != '' &&
                      profileValue['UserEmail'] !=
                          value['freindsList'][i]['FriendRequestEmailId']) {
                    receivedRequestList.add(value['freindsList'][i]);
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

  cancelSendRequest(index) {
    setState(() {
      iscancelSendRequestLoading = true;
      iscancelSendRequestIndex = index;
    });
    CacheService.getAllData().then((profileValue) {
      setState(() {
        if (profileValue.isNotEmpty) {
          Map body = {
            'UserEmail': profileValue['UserEmail'],
            "FriendEmail": sendRequestList[index]['FriendRequestEmailId'],
            'Pword': profileValue['Password']
          };
          ApiService.cancelFriendRequest(body, context).then((value) {
            setState(() {
              iscancelSendRequestLoading = false;
              iscancelSendRequestIndex = null;
              if (value['status'] == 1) {
                sendRequestList.removeAt(index);
              }
            });
          }).catchError((onError) {
            setState(() {
              iscancelSendRequestLoading = false;
            });
          });
        }
      });
    });
  }

  acceptRecievedRequest(index) {
    setState(() {
      isAcceptReceivedRequestLoading = true;
      isAcceptReceivedRequestIndex = index;
    });
    CacheService.getAllData().then((profileValue) {
      setState(() {
        if (profileValue.isNotEmpty) {
          Map body = {
            'UserEmail': profileValue['UserEmail'],
            "FriendEmail": receivedRequestList[index]['FriendRequestEmailId'],
            'Pword': profileValue['Password']
          };
          ApiService.addFriend(body, context).then((value) {
            setState(() {
              isAcceptReceivedRequestLoading = false;
              if (value['status'] == 1) {
                receivedRequestList.removeAt(index);
              }
              isAcceptReceivedRequestIndex = null;
            });
          }).catchError((onError) {
            setState(() {
              isAcceptReceivedRequestLoading = false;
            });
          });
        }
      });
    });
  }

  rejectRecievedRequest(index) {
    setState(() {
      isRejectReceivedRequestLoading = true;
      isRejectReceivedRequestIndex = index;
    });
    CacheService.getAllData().then((profileValue) {
      setState(() {
        if (profileValue.isNotEmpty) {
          Map body = {
            'UserEmail': profileValue['UserEmail'],
            "FriendEmail": receivedRequestList[index]['FriendRequestEmailId'],
            'Pword': profileValue['Password']
          };
          ApiService.rejectFriendRequest(body, context).then((value) {
            setState(() {
              isRejectReceivedRequestLoading = false;
              if (value['status'] == 1) {
                receivedRequestList.removeAt(index);
              }
              iscancelSendRequestIndex = null;
            });
          }).catchError((onError) {
            setState(() {
              isRejectReceivedRequestLoading = false;
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
            "FriendEmail": receivedRequestList[index]['FriendEmailId'],
            'Pword': profileValue['Password']
          };
          ApiService.removeFriend(body, context).then((value) {
            setState(() {
              isRemoveRequestLoading = false;
              if (value['status'] == 1) {
                receivedRequestList.removeAt(index);
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: friendRequestAppBar(context, 'FRIENDS_REQUEST', isLoading,
            sendRequestList.length, receivedRequestList.length),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  sendRequestList.length > 0
                      ? listData(sendRequestList)
                      : Center(
                          child: Text(
                            getTranslate(context, 'NO_SENT_REQUEST'),
                            style: helveticaWBSmall(context),
                          ),
                        ),
                  receivedRequestList.length > 0
                      ? listData(receivedRequestList)
                      : Center(
                          child: Text(
                            getTranslate(context, 'NO_RECEIVED_REQUEST'),
                            style: helveticaWBSmall(context),
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  listData(List list) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      itemBuilder: (context, index) => list[index]['FriendEmailId'] != null &&
              list[index]['FriendEmailId'] != ''
          ? friendBlock(
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
              isRemoveRequestIndex == index ? true : false)
          : requestBlock(
              context,
              list[index],
              () {
                cancelSendRequest(index);
              },
              iscancelSendRequestLoading && iscancelSendRequestIndex == index
                  ? true
                  : false,
              () {
                rejectRecievedRequest(index);
              },
              isRejectReceivedRequestLoading &&
                      isRejectReceivedRequestIndex == index
                  ? true
                  : false,
              () {
                acceptRecievedRequest(index);
              },
              isAcceptReceivedRequestLoading &&
                      isAcceptReceivedRequestIndex == index
                  ? true
                  : false,
            ),
      itemCount: list.length,
    );
  }
}
