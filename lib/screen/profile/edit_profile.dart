import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_pickers/country.dart';
import 'package:demo_app/services/alert.dart';
import 'package:demo_app/services/cache_service.dart';
import 'package:demo_app/widget/button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:demo_app/services/api_service.dart';
import 'package:demo_app/services/app_theme.dart';
import 'package:demo_app/services/helper_service.dart';
import 'package:demo_app/style/style.dart';
import 'package:demo_app/widget/appBar.dart';
import 'package:demo_app/widget/text.dart';
import 'package:demo_app/widget/text_form_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';

class EditProfile extends StatefulWidget {
  final bool isHomePage;
  EditProfile({this.isHomePage = false});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _nameformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneformKey = GlobalKey<FormState>();
  File? image;
  String? name, mobile;
  int? country;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false,
      isOpenPass = true,
      isGetUserDataLoading = false,
      isImageUploadLoading = false,
      isNameLoading = false,
      isPhoneLoading = false;
  Map? profileData;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    setState(() {
      isGetUserDataLoading = true;
    });
    CacheService.getAllData().then((value) {
      setState(() {
        profileData = value;
        isGetUserDataLoading = false;
        country = (profileData?['CountryCode'] is String
                ? int.parse(profileData!['CountryCode'])
                : profileData?['CountryCode']) ??
            1;
      });
    });
  }

  Future<Null> _cropImage(imageFile) async {
    File? cropppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile!.path,
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
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    if (cropppedFile != null) {
      setState(() {
        image = cropppedFile;
        updloadImage();
      });
    }
  }

  selectImage() async {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  showYesNo(context, 'SELECT'),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            final pickedFile = await _picker.getImage(
                                source: ImageSource.camera);
                            _cropImage(pickedFile);
                            backNavigator(context);
                          },
                          child: alertText(
                              context, "TAKE_PHOTO", Icon(Icons.camera_alt))),
                      SizedBox(height: 20),
                      GestureDetector(
                          onTap: () async {
                            final pickedFile = await _picker.getImage(
                                source: ImageSource.gallery);
                            _cropImage(pickedFile);
                            backNavigator(context);
                          },
                          child: alertText(context, "CHOOSE_FROM_PHOTOS",
                              Icon(Icons.image))),
                      SizedBox(height: 20),
                      image == null
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  image = null;
                                  backNavigator(context);
                                });
                              },
                              child: alertText(context, "REMOVE_PHOTO",
                                  Icon(Icons.delete_forever))),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }



  updloadImage() async {
    File selfIle = File(image!.path);
    String fileName = selfIle.path.split('/').last;
    MultipartFile fileInfo = await MultipartFile.fromFile(selfIle.path,
        filename: fileName, contentType: MediaType('image', 'jpg'));
    setState(() {
      isImageUploadLoading = true;
    });

    FormData formData = new FormData.fromMap({
      'image': fileInfo,
      'UserEmail': profileData?['UserEmail'],
      'pWord': profileData?['Password'],
    });
    ApiService.updateUserProfilePhoto(formData, context).then((value) {
      setState(() {
        if (value != null && value['status'] == 1) {
          Map body = {
            'UserSingUpId': profileData?['UserEmail'],
            'pWord': profileData?['Password']
          };
          ApiService.userProfile(body, context).then((value) {
            setState(() {
              isImageUploadLoading = false;
              Map body = {
                'Photo': value['photo'],
                'UserEmail': value['emailId'],
                'UserName': value['name'],
                'CountryCode': value['country'],
                'Phone': value['phoneNumber'],
                'Password': profileData?['Password'],
              };
              if (value['photo'] != null &&
                  value['emailId'] != null &&
                  value['name'] != null &&
                  value['country'] != null &&
                  value['phoneNumber'] != null) {
                profileData = body;
                image = null;
                CacheService.setAllData(body);
              } else {
                profileData = body;
                image = null;
              }
            });
          });
        }
      });
    }).catchError((onError) {
      setState(() {
        isImageUploadLoading = false;
      });
    });
  }

  updateName() {
    final formState = _nameformKey.currentState;
    if (formState!.validate()) {
      formState.save();
      setState(() {
        isNameLoading = true;
      });
      Map isNameBody = {
        'UserEmail': profileData?['UserEmail'],
        'pWord': profileData?['Password'],
        'NewName': name,
      };
      ApiService.updateUserName(isNameBody, context).then((value) {
        setState(() {
          isNameLoading = false;
         print(value['status']);
          if (value != null && value['status'] == 1) {
            getUserData();
          } else {
            showNormalAlert(context, value['message']);
          }
        });
      }).catchError((onError) {
        setState(() {
          isNameLoading = false;
        });
      });
    }
  }

  updatePhone() {
    final formState = _phoneformKey.currentState;
    if (formState!.validate()) {
      formState.save();
      setState(() {
        isPhoneLoading = true;
      });
      Map isPhoneBody = {
        'UserEmail': profileData?['UserEmail'],
        'pWord': profileData?['Password'],
        'phone': int.parse(mobile.toString()),
        'country': country,
      };
      ApiService.updateUserPhone(isPhoneBody, context).then((value) {
        setState(() {
          isPhoneLoading = false;
          if (value != null && value['status'] == 1) {
            getUserData();
          } else {
            showNormalAlert(context, value['message']);
          }
        });
      }).catchError((onError) {
        setState(() {
          isPhoneLoading = false;
        });
      });
    }
  }

  getUserData() {
    Map body = {
      'UserSingUpId': profileData?['UserEmail'],
      'pWord': profileData?['Password']
    };
    ApiService.userProfile(body, context).then((value) {
      setState(() {
        isLoading = false;
        if (value != null && value['status'] == 1) {
          Map body = {
            'Photo': value['photo'],
            'UserEmail': value['emailId'],
            'UserName': value['name'],
            'CountryCode': value['country'],
            'Phone': value['phoneNumber'],
            'Password': profileData?['Password'],
          };
          CacheService.setAllData(body);
          FocusScope.of(context).unfocus();
          FocusScope.of(context).requestFocus(new FocusNode());
        } else {
          showNormalAlert(context, value['message']);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isHomePage
          ? editProfileHomeAppBar(context, 'EDIT_PROFILE')
          : editProfileAppBar(context, 'EDIT_PROFILE'),
      body: isGetUserDataLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ListView(
                children: [
                  SizedBox(height: 10),
                  Container(
                    height: 200,
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: isImageUploadLoading
                              ? Container(
                                  width: 150.0,
                                  height: 150.0,
                                  decoration: new BoxDecoration(
                                    border: Border.all(
                                        color: getWBColor(context), width: 1.0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircularProgressIndicator())
                              : image == null
                                  ? CachedNetworkImage(
                                      imageUrl: profileData?['Photo'] ?? '',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 150.0,
                                        height: 150.0,
                                        decoration: new BoxDecoration(
                                          border: Border.all(
                                              color: getWBColor(context),
                                              width: 1.0),
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      placeholder: (context, url) => Container(
                                          width: 150.0,
                                          height: 150.0,
                                          decoration: new BoxDecoration(
                                            border: Border.all(
                                                color: getWBColor(context),
                                                width: 1.0),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.person_pin,
                                              color: getWBColor(context))),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        width: 150.0,
                                        height: 150.0,
                                        decoration: new BoxDecoration(
                                          border: Border.all(
                                              color: getWBColor(context),
                                              width: 1.0),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.person_pin,
                                            color: getWBColor(context)),
                                      ),
                                    )
                                  : Container(
                                      width: 150.0,
                                      height: 150.0,
                                      decoration: new BoxDecoration(
                                        border: Border.all(
                                            color: getWBColor(context),
                                            width: 1.0),
                                        shape: BoxShape.circle,
                                        image: image != null
                                            ? DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(
                                                    File(image!.path)),
                                              )
                                            : null,
                                      ),
                                    ),
                        ),
                        Positioned(
                          left: 180,
                          top: 130,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(30.0)),
                            child: IconButton(
                              onPressed: () {
                                selectImage();
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                color: white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  textField(
                      context, 'EMAIL', profileData?['UserEmail'], Icons.email),
                  SizedBox(height: 30),
                  Form(
                    key: _nameformKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 12,
                          child: textFormFieldName(context, 'NAME', (value) {
                            setState(() {
                              name = value;
                            });
                          }, value: profileData?['UserName']),
                        ),
                        Flexible(
                            flex: 4,
                            child: primarySmallBotton(
                                context, 'UPDATE', updateName, isNameLoading))
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Form(
                    key: _phoneformKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 12,
                          child: textMobileFormField(
                              context, 'MOBILE_NUMBER', country.toString(),
                              (Country? countryCode) {
                            setState(() {
                              country = int.parse(countryCode!.phoneCode);
                            });
                          }, (value) {
                            setState(() {
                              mobile = value;
                            });
                          }, value: profileData?['Phone']),
                        ),
                        Flexible(
                            flex: 4,
                            child: primarySmallBotton(
                                context, 'UPDATE', updatePhone, isPhoneLoading))
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
