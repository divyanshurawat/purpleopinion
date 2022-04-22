import 'dart:io';
import 'package:demo_app/screen/multiple_image/send_opinion_requests.dart';
import 'package:demo_app/services/app_theme.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';
import 'package:demo_app/widget/appBar.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class MultipleImage extends StatefulWidget {
  final List<File>? images;
  MultipleImage({this.images});

  @override
  _MultipleImageState createState() => _MultipleImageState();
}

class _MultipleImageState extends State<MultipleImage> {
  List<File>? images = [];
  int imageIndex = 0;
  @override
  void initState() {
    setState(() {
      images = widget.images!;
    });
    super.initState();
  }

  Widget buildGridView() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: images?.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, int index) {
          return InkWell(
            onTap: () async {
              setState(() {
                imageIndex = index;
              });
            },
            child: Container(
                decoration: new BoxDecoration(
                  border: Border.all(
                      color: imageIndex == index ? green : white, width: 2.0),
                ),
                margin: EdgeInsets.all(10.0),
                height: 50,
                width: 50,
                child: Image.file(File(images![index].path))),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: imageAppBar(context, "IMAGES", images!.length, () {
        if (images!.length > 0) {
          backNavigator(context);
          backNavigator(context);
          pushNavigator(context, SendOpinionRequests(images: widget.images));
        }
      }),
      body: images!.length > 0
          ? Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 50, bottom: 10, right: 25, left: 25.0),
                  child: Center(
                    child: Image.file(
                      File(images![imageIndex].path),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            setState(() async {
                              File? cropppedFile = await ImageCropper.cropImage(
                                sourcePath: images![imageIndex].path,
                                aspectRatioPresets: Platform.isAndroid
                                    ? [
                                        CropAspectRatioPreset.square,
                                        CropAspectRatioPreset.ratio3x2,
                                        CropAspectRatioPreset.original,
                                        CropAspectRatioPreset.ratio4x3,
                                        CropAspectRatioPreset.ratio16x9
                                      ]
                                    : [
                                        CropAspectRatioPreset.original,
                                        CropAspectRatioPreset.square,
                                        CropAspectRatioPreset.ratio3x2,
                                        CropAspectRatioPreset.ratio4x3,
                                        CropAspectRatioPreset.ratio5x3,
                                        CropAspectRatioPreset.ratio5x4,
                                        CropAspectRatioPreset.ratio7x5,
                                        CropAspectRatioPreset.ratio16x9
                                      ],
                                androidUiSettings: AndroidUiSettings(
                                    initAspectRatio:
                                        CropAspectRatioPreset.original,
                                    lockAspectRatio: false),
                              );
                              if (cropppedFile != null) {
                                setState(() {
                                  images![imageIndex] = cropppedFile;
                                });
                              }
                            });
                          },
                          child: Container(
                            decoration: new BoxDecoration(
                                border: Border.all(
                                    color: getWBColor(context), width: 1),
                                shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:
                                  Icon(Icons.edit, color: getWBColor(context)),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            setState(() {
                              images!.removeAt(imageIndex);
                              if (images!.length >= 1) {
                                imageIndex = 0;
                              } else {
                                backNavigator(context);
                              }
                            });
                          },
                          child: Container(
                            decoration: new BoxDecoration(
                                border: Border.all(
                                    color: getWBColor(context), width: 1),
                                shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:
                                  Icon(Icons.close, color: getWBColor(context)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Container(),
      bottomNavigationBar: images!.length > 0 ? buildGridView() : Container(),
    );
  }
}
