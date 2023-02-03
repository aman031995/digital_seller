import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/bloc_validation/Bloc_Validation.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/repository/get_image_files_provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/screens/edit_profile.dart';
import 'package:tycho_streams/view/widgets/AppNavigationBar.dart';
import 'package:tycho_streams/view/widgets/image_source.dart';
import 'package:tycho_streams/view/widgets/profile_bottom_view.dart';
import 'package:tycho_streams/viewmodel/profile_view_model.dart';
import 'login_screen.dart';

class Test extends StatefulWidget {
  ProfileViewModel? viewmodel;

  Test({Key? key, this.viewmodel}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final ProfileViewModel profileViewModel = ProfileViewModel();

  final validation = ValidationBloc();
  String? name;
  String? email;
  String? phone;
  String? profileImg;

  TextEditingController? addressController, nameController, phoneController;

  @override
  void initState() {
    addressController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    fetchCurrentUserDetails();
    super.initState();
  }

  fetchCurrentUserDetails() {
    name = widget.viewmodel?.userInfoModel?.name;
    phone = widget.viewmodel?.userInfoModel?.phone;
    nameController!.text = name!;
    phoneController!.text = phone!;
    validateEditDetails();
    setState(() {});
  }

  validateEditDetails() {
    validation.sinkFirstName.add(name!);
    validation.sinkPhoneNo.add(phone!);
  }

  @override
  void dispose() {
    validation.closeStream();
    super.dispose();
  }

  //-------Profile Screen---------
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: getAppBarWithBackBtn('Edit Profile'),
      backgroundColor: LIGHT_THEME_BACKGROUND,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Container(
                child: Stack(
                  children: [
                    Container(
                      // margin: EdgeInsets.only(top: 20),
                      child: CircleAvatar(
                        backgroundColor: WHITE_COLOR,
                        radius: 57,
                        child: CircleAvatar(
                          backgroundColor: YELLOW_COLOR,
                          backgroundImage: NetworkImage(
                              widget.viewmodel?.userInfoModel?.profilePic ?? ''),
                          radius: 55.0,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 75,
                      top: 60,
                      // left: (SizeConfig.screenWidth! * 0.50),
                      // top: 60,
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
                                          // profileVM.imageUpload(context, result);
                                        }
                                      });
                                    },
                                    onGallerySelection: () {
                                      GetImageFile.pickImage(
                                          ImageSource.gallery, context,
                                          (result, isSuccess) {
                                        if (isSuccess) {
                                          // profileVM.imageUpload(
                                          //     context, result);
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
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                  child: Column(children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: SizeConfig.screenWidth!,
                      alignment: Alignment.center,
                      child: StreamBuilder(
                          stream: validation.firstName,
                          builder: (context, snapshot) {
                            return AppTextField(
                              maxLine: 1,
                              controller: nameController,
                              labelText: StringConstant.fullName,
                              textCapitalization: TextCapitalization.words,
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
                              onSubmitted: (m) {},
                              isTick: null,
                            );
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
                              onSubmitted: (m) {},
                              isTick: null,
                            );
                          }),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: SizeConfig.screenWidth!,
                      alignment: Alignment.center,
                      child: StreamBuilder(
                          stream: validation.address,
                          builder: (context, snapshot) {
                            return AppTextField(
                              maxLine: 1,
                              controller: addressController,
                              labelText: 'Address',
                              isShowCountryCode: true,
                              textCapitalization: TextCapitalization.words,
                              isShowPassword: false,
                              secureText: false,
                              maxLength: 30,
                              isEnable: false,
                              keyBoardType: TextInputType.emailAddress,
                              errorText: snapshot.hasError
                                  ? snapshot.error.toString()
                                  : null,
                              onChanged: (m) {
                                validation.sinkAddress.add(m);
                                setState(() {});
                              },
                              onSubmitted: (m) {},
                              isTick: null,
                            );
                          }),
                    ),
                    SizedBox(height: 20),
                    StreamBuilder(
                        stream: validation.validateUserEditProfile,
                        builder: (context, snapshot) {
                          return appButton(
                              context,
                              StringConstant.Save,
                              SizeConfig.screenWidth! * 0.89,
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
                  ])),
            ],
          ),
        ),
      ),
    );
    // : Center(child: CircularProgressIndicator());
  }
}
