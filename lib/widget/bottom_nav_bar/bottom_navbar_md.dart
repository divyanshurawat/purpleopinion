import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:demo_app/model/opinion_request.dart';
import 'package:demo_app/screen/friend/friends.dart';
import 'package:demo_app/screen/friend/friends_request.dart';
import 'package:demo_app/screen/home/home.dart';
import 'package:demo_app/screen/home/opinion_requests.dart';
import 'package:demo_app/screen/multiple_image/send_opinion_requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class BottomNavigationBarWithMD extends StatefulWidget {
  BottomNavigationBarWithMD({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarWithMDState createState() =>
      _BottomNavigationBarWithMDState();
}

class _BottomNavigationBarWithMDState extends State<BottomNavigationBarWithMD>
    with SingleTickerProviderStateMixin {
  var _bottomNavIndex = 0; //default index of a first screen

  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;

  final iconList = <IconData>[
    Icons.home,
    Icons.search,
    Icons.person_add,
    Icons.chat,
  ];

  final pageViewController = PageController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageViewController,
        children: [
          HomePage(),
          FriendsPage(),
          FriendsRequest(),
          OpinionRequests(),
        ],
        onPageChanged: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.themeColor,
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(builder: (_) => SendOpinionRequests(images: [])));
        },
        child: Container(
          padding: EdgeInsets.only(left: 2),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? HexColor('#FFA400') : Colors.white;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconList[index],
                size: 24,
                color: color,
              ),
            ],
          );
        },
        backgroundColor: Constants.themeColor,
        activeIndex: _bottomNavIndex,
        splashColor: HexColor('#FFA400'),
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.softEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
          setState(() => _bottomNavIndex = index);
          pageViewController.jumpToPage(index);
        },
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
