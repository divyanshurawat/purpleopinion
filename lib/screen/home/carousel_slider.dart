import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:demo_app/screen/grouped_list.dart';
import 'package:demo_app/screen/grouped_listsrc.dart';
import 'package:demo_app/services/alert.dart';
import 'package:demo_app/services/cache_service.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';
import 'package:demo_app/widget/comments.dart';
import 'package:demo_app/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Carouselider extends StatefulWidget {
  final List slider;
  final Map userData;

  const Carouselider({Key? key, required this.slider, required this.userData})
      : super(key: key);

  @override
  _CarouseliderState createState() => _CarouseliderState();
}

class _CarouseliderState extends State<Carouselider> {
  List elements = [];

  Map? userData;
  bool showCard = false;
  PageController _scrollController = new PageController();

  @override
  void initState() {
    userData = widget.userData;

    getGroup();
    _scrollController.addListener(() {
      setState(() {
        showCard=false;
      });

    });

    super.initState();
  }

  getGroup() {
    final releaseDateMap = widget.slider.groupBy((m) => m[1][0]["RequestId"]);

    elements.add(releaseDateMap.values.toList());

  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _scrollController,
        scrollDirection: Axis.vertical,

        itemCount: elements[0].length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                showCard = false;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider("${userData?['Photo']}"),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                  getTranslate(context, userData?['UserName']),
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
                                          DateTime.parse(elements[0][index][0][1]
                                                      [0]['time'] ??
                                                  '')
                                              .toLocal())),
                                  style: helveticaWBSmall(context)),
                            ),
                            //   elements[index][0][0][1][0]['time']
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CarouselSlider.builder(
                      itemCount: elements[0][index]!.length,

                      itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) {

                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      "${elements[0][index][itemIndex][1][0]['photoLLink']}",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height:
                                        MediaQuery.of(context).size.height * 0.74,
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
                                  placeholder: (context, url) =>
                                      Container(
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.74,
                                        decoration: BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(12)),

                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showCard = true;
                                        });
                                      },
                                      child: Stack(
                                        alignment:Alignment.center,
                                          children: [
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.black,
                                          size: 54,
                                        ),
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showCard = true;
                                            });
                                          },
                                          child: SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: Center(
                                                  child: Text(
                                                elements[0][index][itemIndex][0]
                                                    .length
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                                index == index
                                    ? cardView(elements[0][index][itemIndex][0])
                                    : SizedBox()
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Stack(
                        alignment:Alignment.center,
                        children: [

                        Icon(
                        Icons.favorite,
                        color: Colors.black,
                        size: 27,
                        ),
                        Icon(
                        Icons.favorite,
                        color: elements[0][index][itemIndex][1][0]
                        ['OwnFavorite']
                            .toString() ==
                        "1"
                        ? Colors.red
                            : Colors.grey,
                        size: 25,
                        ),
                      ]

                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,

                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("${itemIndex+1}/${elements[0][index].length.toString()}",style: TextStyle(color: Colors.white),),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,)
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,

                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Comments(
                                        comment: elements[0][index][itemIndex][1][0]
                                        ['PhotoComment']
                                            .toString(),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        );
                      },
                      options: CarouselOptions(
                        onPageChanged: (int index, reason) {
                          setState(() {
                            showCard = false;
                          });
                        },
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
                  if (elements[0][index][0][1][0]['question'] != null)
                    questionWidget(
                        context, elements[0][index][0][1][0]['question']),
                ],
              ),
            ),
          );
        });
  }

  cardView(List? cardData) {
    return showCard
        ? GestureDetector(
            onTap: () {
              setState(() {
                showCard = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(38.0),
              child: SingleChildScrollView(
                  child: Container(
                height: 500,
                color: Colors.transparent,
                child: ListView.builder(
                  itemCount: cardData!.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(cardData[index]);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: CachedNetworkImageProvider(
                                "${cardData[index]['ProfilePhoto']}"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(

                                color: Colors.black87.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(

                              child: Text(
                                  getTranslate(context,  "${cardData[index]['FriendName']}"),
                                  style: helveticaWBMediumWhite(context)),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )),
            ),
          )
        : Text("");
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}
