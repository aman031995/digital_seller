import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/bloc_validation/Bloc_Validation.dart';
import 'package:tycho_streams/repository/get_image_files_provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/view/widgets/AppNavigationBar.dart';
import 'package:tycho_streams/view/widgets/FullImageView.dart';
import 'package:tycho_streams/view/widgets/image_source.dart';
import 'package:tycho_streams/viewmodel/profile_view_model.dart';

class EditProfile extends StatefulWidget {
  ProfileViewModel? viewmodel;

  EditProfile({Key? key, this.viewmodel}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileViewModel profileViewModel = ProfileViewModel();

  final validation = ValidationBloc();
  String? name;
  String? email;
  String? phone;
  String? address;
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
    address = widget.viewmodel?.userInfoModel?.address;
    nameController!.text = name ?? '';
    phoneController!.text = phone ?? '';
    addressController!.text = address ?? '';
    validateEditDetails();
    setState(() {});
  }

  validateEditDetails() {
    validation.sinkFirstName.add(name!);
    validation.sinkPhoneNo.add(phone!);
    validation.sinkAddress.add(address!);
  }

  @override
  void dispose() {
    validation.closeStream();
    addressController?.dispose();
    nameController?.dispose();
    phoneController?.dispose();
    super.dispose();
  }

  //-------Profile Screen---------
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider(create: (BuildContext context) => profileViewModel,
    child: Consumer<ProfileViewModel>(builder: (context, viewmodel, _){
      return Scaffold(
        appBar: getAppBarWithBackBtn(title : StringConstant.editProfile, isBackBtn: true, context: context),
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
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (_) =>
                                    FullImage(
                                        imageUrl: '${viewmodel.userInfoModel?.profilePic ?? widget.viewmodel?.userInfoModel?.profilePic}')));
                          },
                          child: CircleAvatar(
                            backgroundColor: WHITE_COLOR,
                            radius: 57,
                            child: CircleAvatar(
                              backgroundColor: LIGHT_THEME_BACKGROUND,
                              backgroundImage: NetworkImage(
                                  '${viewmodel.userInfoModel?.profilePic ?? widget.viewmodel?.userInfoModel?.profilePic}'),
                              radius: 55.0,
                            ),
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
                                                viewmodel.imageUpload(context, result);
                                              }
                                            });
                                      },
                                      onGallerySelection: () {
                                        GetImageFile.pickImage(
                                            ImageSource.gallery, context,
                                                (result, isSuccess) {
                                              if (isSuccess) {
                                                viewmodel.imageUpload(context, result);
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
                        width: SizeConfig.screenWidth,
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
                        width: SizeConfig.screenWidth,
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
                        width: SizeConfig.screenWidth,
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
                                maxLength: 150,
                                isEnable: true,
                                keyBoardType: TextInputType.emailAddress,
                                errorText: null,
                                onChanged: (m) {
                                  // validation.sinkAddress.add(m);
                                  // setState(() {});
                                },
                                onSubmitted: (m) {},
                                isTick: true,
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
                                SizeConfig.screenWidth * 0.85,
                                60,
                                LIGHT_THEME_COLOR,
                                WHITE_COLOR,
                                20,
                                10,
                                snapshot.data != true ? false : true,
                                onTap: () {
                                  // snapshot.data != true ? null : " ";
                                  snapshot.data != true ? ToastMessage.message(
                                      StringConstant.fillOut)
                                      : saveButtonPressed(
                                      widget.viewmodel, nameController?.text,
                                      phoneController?.text,
                                      addressController?.text);
                                });
                          }),
                    ])),
              ],
            ),
          ),
        ),
      );
    }));
  }

  saveButtonPressed(ProfileViewModel? viewmodel, String? name, String? phone,
      String? address) {
    viewmodel?.updateProfile(context, name, phone, address);
  }
}
