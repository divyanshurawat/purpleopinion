import 'package:demo_app/services/alert.dart';
import 'package:demo_app/services/api_service.dart';
import 'package:demo_app/services/app_theme.dart';
import 'package:demo_app/services/cache_service.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';
import 'package:demo_app/widget/appBar.dart';
import 'package:demo_app/widget/button.dart';
import 'package:demo_app/widget/card.dart';
import 'package:flutter/material.dart';

class AddFriend extends StatefulWidget {
  final Map? searchData;
  const AddFriend(this.searchData);

  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  int offset = 0;
  int? isAddFriendRequestIndex;
  bool isLoading = false,
      isLoaderLoadding = false,
      isAddFriendRequestLoading = true,
      isHideButton = false;
  List friendList = [];
  ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    setState(() {
      searchController.text = widget.searchData?['FirstPara'];
      isLoading = true;
      getUsers();
      CacheService.getAllData().then((profileValue) {
        if ((profileValue['UserName'] == null ||
                profileValue['UserName'] == '') &&
            (profileValue['Photo'] == null || profileValue['Photo'] == '')) {
          showNormalAlert(context, 'NAME_PHOTO_ERROR');
        } else if (profileValue['Photo'] == null ||
            profileValue['Photo'] == '') {
          showNormalAlert(context, 'PHOTO_ERROR');
        } else if (profileValue['UserName'] == null ||
            profileValue['UserName'] == '') {
          showNormalAlert(context, 'NAME_ERROR');
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getUsers() {
    CacheService.getAllData().then((userData) {
      widget.searchData?['offset'] = offset;
      ApiService.getUsers(widget.searchData, context).then((value) {
        setState(() {
          isLoading = false;
          isLoaderLoadding = false;
          if (value['users'].length == 0) {
            isHideButton = true;
          }
          friendList.addAll(value['users']);
          if (friendList.length > 0) {
            for (var element in friendList) {
              if (element['userMail'] == userData['UserEmail']) {
                friendList.remove(element);
              }
            }
          }
        });
      }).catchError((onError) {
        setState(() {
          isLoading = false;
          isLoaderLoadding = false;
        });
      });
    });
  }

  addFriendRequest(index) {
    setState(() {
      isAddFriendRequestLoading = true;
      isAddFriendRequestIndex = index;
    });
    CacheService.getAllData().then((profileValue) {
      setState(() {
        if (profileValue.isNotEmpty) {
          Map body = {
            'UserEmail': profileValue['UserEmail'],
            "FriendEmail": friendList[index]['userMail'],
            'Pword': profileValue['Password']
          };
          ApiService.addFriendRequest(body, context).then((value) {
            setState(() {
              isAddFriendRequestLoading = false;
              if (value['status'] == 1) {
                friendList.removeAt(index);
              }
              isAddFriendRequestIndex = null;
            });
          }).catchError((onError) {
            setState(() {
              isAddFriendRequestLoading = false;
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, 'ADD_FRIEND'),
      body: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
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
                    widget.searchData?['FirstPara'] = value;
                    offset = 0;
                    friendList = [];
                    isLoading = true;
                    isHideButton = false;
                    getUsers();
                  });
                }
              },
              decoration: InputDecoration(
                prefixIcon: Container(width: 1),
                suffixIcon: InkWell(
                  onTap: () {
                    if (searchController.text.isNotEmpty) {
                      setState(() {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        FocusScope.of(context).unfocus();
                        widget.searchData?['FirstPara'] = searchController.text;
                        offset = 0;
                        friendList = [];
                        isLoading = true;
                        isHideButton = false;
                        getUsers();
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
          isLoading
              ? Center(child: CircularProgressIndicator())
              : friendList.length > 0
                  ? ListView(
                      controller: _scrollController,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: listData(friendList)),
                        if (!isHideButton)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: primaryBotton(context, 'LOAD_MORE', () {
                              setState(() {
                                isLoaderLoadding = true;
                                offset++;
                                getUsers();
                              });
                            }, isLoaderLoadding),
                          )
                      ],
                    )
                  : Center(
                      child: Text(
                        getTranslate(context, 'NO_DATA_FOUND'),
                        style: helveticaWBSmall(context),
                      ),
                    ),
        ],
      ),
    );
  }

  listData(List list) {
    return ListView.builder(
      physics: ScrollPhysics(),
      controller: _scrollController,
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      itemBuilder: (context, index) => friendAddBlock(
        context,
        list[index],
        () {
          addFriendRequest(index);
        },
        isAddFriendRequestLoading && isAddFriendRequestIndex == index
            ? true
            : false,
      ),
      itemCount: list.length,
    );
  }
}
