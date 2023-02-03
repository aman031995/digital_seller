import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/bloc_validation/Bloc_Validation.dart';
import 'package:tycho_streams/repository/get_image_files_provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/widgets/AppNavigationBar.dart';
import 'package:tycho_streams/view/widgets/image_source.dart';
import 'package:tycho_streams/viewmodel/profile_view_model.dart';
import '../../Utilities/AssetsConstants.dart';

class EditProfile extends StatefulWidget {
  ProfileViewModel? viewmodel;
  EditProfile({Key? key, this.viewmodel}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<EditProfile> {
  TextEditingController? emailController,
      nameController,
      phoneController;
  String mediaFile = "", mediaFileName = "";
  final validation = ValidationBloc();
  String? name;
  String? email;
  String? phone;
  String? profileImg;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    fetchCurrentUserDetails();
  }

  fetchCurrentUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    name = widget.viewmodel?.userInfoModel?.name;
    phone = widget.viewmodel?.userInfoModel?.phone;
    email = widget.viewmodel?.userInfoModel?.email;
    nameController!.text = name!;
    phoneController!.text = phone!;
    emailController!.text = email!;
    validateEditDetails();
    setState(() {});
  }

  validateEditDetails() {
    // validation.sinkFirstName.add(firstName);
    // validation.sinkEmail.add(email);
    // validation.sinkLastName.add(lastName);
  }

  @override
  void dispose() {
    validation.closeStream();
    super.dispose();
  }

  // imageUpload(var uploadImage, String png, String profile, BuildContext context) {
  //   AppNetworkManager.uploadImage([uploadImage], png, profile, context,
  //           (result, success) {
  //         if (success) {
  //           setState(() {
  //             UploadImageModal res = ((result as SuccessState).value as ASResponseModal).dataModal;
  //             mediaFile = res.filename!;
  //             mediaFileName = res.fullpath!;
  //           });
  //         }
  //       });
  // }

  // void _askVideoPermission() async {
  //   var status = await Permission.camera.status;
  //   if (status.isGranted) {
  //     AppDialog.galleryOptionDialog(context,
  //         title: StringConstant.makeChoice,
  //         text1: StringConstant.gallery,
  //         text2: StringConstant.camera, onCameraTap: () {
  //           Navigator.pop(context);
  //           GetImageFile.pickImage(context, (result, isSuccess) {
  //             if (isSuccess) {
  //               FilePickerResult? selectedImage;
  //               selectedImage = result;
  //               var uploadImage = selectedImage!.files[0].path;
  //               imageUpload(uploadImage, 'png', 'profile', context);
  //             }
  //           });
  //         }, onVideoTap: () {
  //           Navigator.pop(context);
  //           GetImageFile.pickFromCamera(ImageSource.camera, context,
  //                   (result, isSuccess) {
  //                 if (isSuccess) {
  //                   var imageToUpload = File(result.path);
  //                   imageUpload(imageToUpload.path, 'png', 'profile', context);
  //                 }
  //               });
  //         });
  //   } else if (status.isDenied) {
  //     var granted = await Permission.camera.request();
  //     if (granted.isGranted) {
  //     } else if (granted.isPermanentlyDenied) {
  //       return showDialog(
  //           context: context,
  //           builder: (BuildContext context) =>
  //               AppDialog.permissionPopUp(context, true));
  //     }
  //   } else if (status.isPermanentlyDenied) {
  //     return showDialog(
  //         context: context,
  //         builder: (BuildContext context) =>
  //             AppDialog.permissionPopUp(context, true));
  //   }
  //   // Navigator.pop(context, true);
  // }

  //--------Edit Profile--------
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: LIGHT_THEME_BACKGROUND,
        appBar: getAppBarWithBackBtn('Edit Profile'),
        bottomNavigationBar: Container(
          height: 130,
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              StreamBuilder(
                  stream: validation.validateUserEditProfile,
                  builder: (context, snapshot) {
                    return appButton(
                        context,
                        StringConstant.Save,
                        SizeConfig.screenWidth! * 0.8,
                        60,
                        BUTTON_TEXT_COLOR,
                        APP_TEXT_COLOR,
                        16,
                        10,
                        snapshot.data != true ? false : true, onTap: () {
                      // snapshot.data != true ? null : " ";
                      // snapshot.data != true ? null : saveButtonPressed();
                    });
                  }),
            ],
          ),
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: WHITE_COLOR,
                          radius: 57,
                          child: CircleAvatar(
                            backgroundColor: YELLOW_COLOR,
                            backgroundImage: NetworkImage(
                                widget.viewmodel?.userInfoModel?.profilePic ??
                                    ''),
                            radius: 55.0,
                          ),
                        ),
                      ],
                    )),
                Expanded(
                  child: Container(
                      color: BG_COLOR,
                      child: Column(children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 70, left: 15, bottom: 15, right: 15),
                          width: SizeConfig.screenWidth!,
                          alignment: Alignment.center,
                          child: StreamBuilder(
                              stream: validation.firstName,
                              builder: (context, snapshot) {
                                return AppTextField(
                                    maxLine: 1,
                                    controller: nameController,
                                    labelText: StringConstant.fullName,
                                    textCapitalization:
                                    TextCapitalization.words,
                                    isShowCountryCode: true,
                                    isShowPassword: false,
                                    secureText: false,
                                    maxLength: 30,
                                    keyBoardType: TextInputType.name,
                                    errorText: snapshot.hasError
                                        ? snapshot.error.toString()
                                        : null,
                                    onChanged: (m) {
                                      validation.sinkFirstName.add(m);
                                      setState(() {});
                                    },
                                    onSubmitted: (m) {}, isTick: null,);
                              }),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: SizeConfig.screenWidth!,
                          alignment: Alignment.center,
                          child: StreamBuilder(
                              stream: validation.phoneNo,
                              builder: (context, snapshot) {
                                return AppTextField(
                                    maxLine: 1,
                                    controller: phoneController,
                                    labelText: StringConstant.mobileNumber,
                                    isShowCountryCode: true,
                                    isShowPassword: false,
                                    secureText: false,
                                    isEnable: false,
                                    maxLength: 30,
                                    keyBoardType: TextInputType.phone,
                                    errorText: snapshot.hasError
                                        ? snapshot.error.toString()
                                        : null,
                                    onChanged: (m) {
                                      validation.sinkPhoneNo.add(m);
                                      setState(() {});
                                    },
                                    onSubmitted: (m) {}, isTick: null,);
                              }),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: SizeConfig.screenWidth!,
                          alignment: Alignment.center,
                          child: StreamBuilder(
                              stream: validation.email,
                              builder: (context, snapshot) {
                                return AppTextField(
                                  maxLine: 1,
                                  controller: emailController,
                                  labelText: StringConstant.email,
                                  isShowCountryCode: true,
                                  textCapitalization:
                                  TextCapitalization.words,
                                  isShowPassword: false,
                                  secureText: false,
                                  maxLength: 30,
                                  isEnable: false,
                                  keyBoardType: TextInputType.emailAddress,
                                  errorText: snapshot.hasError
                                      ? snapshot.error.toString()
                                      : null,
                                  onChanged: (m) {
                                    validation.sinkEmail.add(m);
                                    setState(() {});
                                  },
                                  onSubmitted: (m) {}, isTick: null,);
                              }),
                        ),
                      ])),
                )
              ],
            ),
            Positioned(
              left: (SizeConfig.screenWidth! * 0.5) + 15,
              top: 65,
              child: IconButton(
                alignment: Alignment.bottomCenter,
                onPressed: () {
                  // _askVideoPermission(profileVM);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          PhotoAndVideoPopUp(
                            onCameraSelection: () {
                              GetImageFile.pickImage(
                                  ImageSource.camera, context,
                                      (result, isSuccess) {
                                    if (isSuccess) {
                                      widget.viewmodel?.imageUpload(context, result);
                                    }
                                  });
                            },
                            onGallerySelection: () {
                              GetImageFile.pickImage(
                                  ImageSource.gallery, context,
                                      (result, isSuccess) {
                                    if (isSuccess) {
                                      widget.viewmodel?.imageUpload(
                                          context, result);
                                    }
                                  });
                            },
                          ));
                },
                icon: Image.asset(
                  AssetsConstants.icAddImage,
                  height: 30,
                  width: 30,
                ),
              ),
            )
          ],
        ));
  }
}
