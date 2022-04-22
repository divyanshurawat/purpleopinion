import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_app/screen/multiple_image/images_selection.dart';
import 'package:demo_app/screen/multiple_image/send_images.dart';
import 'package:demo_app/services/app_theme.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';
import 'package:demo_app/widget/appBar.dart';
import 'package:demo_app/widget/text_form_fields.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SendOpinionRequests extends StatefulWidget {
  final List<File>? images;
  SendOpinionRequests({this.images});

  @override
  _SendOpinionRequestsState createState() => _SendOpinionRequestsState();
}

class _SendOpinionRequestsState extends State<SendOpinionRequests> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _current = 0;
  TextEditingController controller = new TextEditingController();

  String? comments, question;
  double? rating = .0;
  List<String> addedLike = [];
  List<String> comment = [];
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    for (int i = 0; i < widget.images!.length; i++) {
      addedLike.insert(i, "0");
      comment.insert(i, "");

    }
    comment.reversed;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [
          if (widget.images!.isNotEmpty)
          InkWell(
            onTap: () {
              final formState = _formKey.currentState;
              if (formState!.validate()) {
                formState.save();
                pushNavigator(
                  context,
                  SendImagesToFriendsPage(
                    images: widget.images,
                    question: question,
                    comments: comments,
                    comment: comment,
                    likes: addedLike,
                    rating: rating,
                  ),
                );
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 10,
              bottom: 15,right: 20,top:10),
              decoration: BoxDecoration(
                  ),
              child: Image.asset("assets/forward.png",height: 22,width: 22,),
            ),
          ),

        ],
        title: Text(getTranslate(context, 'SEND_OPINION_REQUEST'),
            style: helveticaFixWhite(context)),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Flexible(
              child: ListView(
                children: [
                  Stack(
                    children: [
                      widget.images!.isEmpty
                          ? Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: new BoxDecoration(
                              border: Border.all(
                                  color: getWBColor(context), width: 1.0),
                              shape: BoxShape.rectangle,
                            ),
                            height: 500,),
                          Positioned(
                            bottom: 15,
                            right: 5,
                            child: InkWell(
                              onTap: () {
                                pushNavigator(context, ImagesSelection());
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                    color: primaryColor, shape: BoxShape.circle),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.camera_alt, color: white),
                                ),
                              ),
                            ),
                          )
                        ],

                          )
                          : Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CarouselSlider.builder(

                            carouselController: _controller,
                            options: CarouselOptions(
                              reverse: false,
                              enableInfiniteScroll: false,
                              height: MediaQuery.of(context).size.height*0.79,
                              autoPlay: false,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {print(comment[index]);
                              controller.text=comment[index].toString();

                              setState(() {
                                _current = index;
                              });
                              },
                              viewportFraction: 1.0,
                            ),
                            itemCount: widget.images!.length,
                            itemBuilder:
                                (BuildContext context, int index, int realIndex) {


                              return Container(
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment:Alignment.bottomCenter,
                                      children: [
                                        Container(

                                          margin: EdgeInsets.all(10.0),
                                          color: Colors.black87,
                                          child: ClipRRect(

                                            borderRadius:
                                            BorderRadius.all(Radius.circular(10.0)),
                                            child: Image.file(

                                              File(widget.images![index].path),
                                              fit: BoxFit.contain,

                                              height: MediaQuery.of(context).size.height*0.74,

                                              width: MediaQuery.of(context).size.width,
                                            ),
                                          ),
                                        ),
                                        Column(

                                          children: [
                                            FavoriteButton(
                                              isFavorite: addedLike[index] == 1.toString(),
                                              valueChanged: (bool) async {
                                                if (bool) {
                                                  print(index);
                                                  addedLike.replaceRange(
                                                      index, index + 1, ["1"]);
                                                  print(addedLike);

                                                  return bool;
                                                } else if (!bool) {
                                                  addedLike.replaceRange(
                                                      index, index + 1, ["0"]);

                                                  // addedLike.insert(index,"0");
                                                  print(addedLike);

                                                  return bool;
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 60,),

                                        Container(
                                          decoration:BoxDecoration(
                                            color: getBWColor(context),
                                            borderRadius: BorderRadius.circular(30)
                                          ),
                                          child: TextFormField(

                                            onChanged:(value){
                                              comment.replaceRange(
                                                  index, index + 1, [value]);
                                            },


                                            onFieldSubmitted: (value){
                                              comment.replaceRange(
                                                  index, index + 1, [value]);
                                            },



                                            style: helveticaWBMedium(context),
                                            controller:controller,





                                            decoration: InputDecoration(
                                              labelText: getTranslate(context, 'WRITE_YOUR_COMMENTS'),



                                              prefixIcon: Container(


                                                margin: EdgeInsets.symmetric(vertical: 8),
                                                padding: EdgeInsets.symmetric(horizontal: 9),

                                                width: 62,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [Icon(Icons.message_rounded, color: getWBColor(context))],
                                                ),
                                              ),

                                              labelStyle: helveticaWBMedium(context),
                                              errorStyle: helveticaWBLSmall(context),


                                              contentPadding: EdgeInsets.all(10),
                                              errorBorder: new OutlineInputBorder(
                                                borderSide: BorderSide(color: getWBColor(context)),
                                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                              ),
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
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                                borderSide: BorderSide(color: getWBColor(context)),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),



                                  ],
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 80,
                            right: 10,
                            child: InkWell(
                              onTap: () {
                                pushNavigator(context, ImagesSelection());
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                    color: primaryColor, shape: BoxShape.circle),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.camera_alt, color: white),
                                ),
                              ),
                            ),
                          )
                        ],

                          ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.images!.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 5.0,
                          height: 5.0,
                          margin:
                              EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: getWBColor(context)
                                  .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: textFieldWithText(
                        context, 'TYPE_YOUR_QUESTION', Icons.message, (value) {
                      setState(() {
                        question = value;
                      });
                    }),
                  ),




                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
