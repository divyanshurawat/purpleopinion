import 'dart:io';
import 'package:demo_app/screen/multiple_image/multiple_image.dart';
import 'package:demo_app/services/alert.dart';
import 'package:demo_app/services/app_theme.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:flutter/material.dart';
import 'package:media_picker_widget/media_picker_widget.dart';

class ImagesSelection extends StatefulWidget {
  @override
  _ImagesSelectionState createState() => _ImagesSelectionState();
}

class _ImagesSelectionState extends State<ImagesSelection> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MediaPicker(
          mediaList: [],
          onPick: (selectedList) {
            if (selectedList.length > 10) {
              showNormalAlert(context, 'SELECT_ONLY_10_IMAGES');
            } else {
              Navigator.pop(context);
              List<File>? images =
                  selectedList.map((path) => File(path.file!.path)).toList();
              pushNavigator(context, MultipleImage(images: images));
            }
          },
          onCancel: () => Navigator.pop(context),
          mediaCount: MediaCount.multiple,
          mediaType: MediaType.image,
          decoration: PickerDecoration(
            cancelIcon: Icon(Icons.close, color: getWBColor(context)),
            actionBarPosition: ActionBarPosition.top,
            blurStrength: 2,
            columnCount: 3,
            completeText: getTranslate(context, 'NEXT'),
          ),
        ),
      ),
    );
  }
}
