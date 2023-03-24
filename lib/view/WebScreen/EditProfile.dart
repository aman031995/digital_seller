import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/bloc_validation/Bloc_Validation.dart';
import 'package:tycho_streams/main.dart';
import 'package:tycho_streams/model/data/TermsPrivacyModel.dart';
import 'package:tycho_streams/model/data/UserInfoModel.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/repository/auth_repository.dart';
import 'package:tycho_streams/repository/get_image_files_provider.dart';
import 'package:tycho_streams/repository/profile_repository.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppIndicator.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/three_arched_circle.dart';
import 'package:tycho_streams/view/screens/verify_otp_screen.dart';
import 'package:tycho_streams/view/widgets/AppDialog.dart';
import 'package:tycho_streams/view/widgets/FullImageView.dart';
import 'package:tycho_streams/view/widgets/image_source.dart';
import 'package:tycho_streams/view/widgets/profile_bottom_view.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';
import 'package:tycho_streams/viewmodel/profile_view_model.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
class EditProfile extends StatefulWidget {
 EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
      final _profileRepo = ProfileRepository();

      UserInfoModel? _userInfoModel;
      UserInfoModel? get userInfoModel => _userInfoModel;
      final ProfileViewModel profileViewModel = ProfileViewModel();
      bool enableMobileField = false;
      bool enableVerifyButton = false;
      bool enableEmailField = false;
      bool enableEmailVerifyButton = false;
      final _authRepo = AuthRepository();

      final validation = ValidationBloc();
      String? name;
      String? email;
      String? phone;
      String? address;
      String? profileImg;
      String? pageTitle;
      File? _profileImage = File('zz');
      Uint8List webImage = Uint8List(10);
      TextEditingController? addressController,
          nameController,
          phoneController,
          emailController;
      Future _pickProfileImage() async {
            if (!kIsWeb) {
                  final ImagePicker _picker = await ImagePicker();
                  XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                        var selected = File(image.path);
                        setState(() {
                              _profileImage = selected;
                        });
                  } else {
                        print("no image has been picked");
                  }
            }
            else if (kIsWeb) {
                  final ImagePicker _picker = await ImagePicker();
                  XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                        var f = await image.readAsBytes();
                        setState(() {
                              _profileImage = File('a');
                              webImage = f;
                        });
                  } else {
                        print("no image has been picked");
                  }
            } else {
                  print("some things goes wrong");
            }
      }
      @override
      void initState() {
            profileViewModel.getUserDetails(context);
            addressController = TextEditingController();
            nameController = TextEditingController();
            phoneController = TextEditingController();
            emailController = TextEditingController();
            getUser();
            super.initState();
      }

      getUser() async {
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            name = sharedPreferences.getString('name');
            profileImg = sharedPreferences.getString('profileImg');
            email = sharedPreferences.getString('email');
            phone = sharedPreferences.getString('phone');
            address = sharedPreferences.getString('address');
            nameController?.text = name ?? '';
            phoneController?.text = phone ?? '';
            addressController?.text = address ?? '';
            emailController?.text = email ?? '';
            if (email != '') {
                  enableEmailField = false;
                  enableEmailVerifyButton = false;
            } else {
                  enableEmailField = true;
                  enableEmailVerifyButton = true;
            }
            if (phone != '') {
                  enableMobileField = false;
                  enableVerifyButton = false;
            } else {
                  enableMobileField = true;
                  enableVerifyButton = true;
            }
            validateEditDetails();
            setState(() {});
      }

      validateEditDetails() {
            validation.sinkFirstName.add(name ?? '');
            validation.sinkPhoneNo.add(phone ?? '');
            validation.sinkAddress.add(address ?? '');
            validation.sinkEmail.add(email ?? '');
      }

      @override
      void dispose() {
            validation.closeStream();
            addressController?.dispose();
            nameController?.dispose();
            phoneController?.dispose();
            emailController?.dispose();
            otpValue = '';
            super.dispose();
      }

      @override
      Widget build(BuildContext context) {
            SizeConfig().init(context);
            final authVM = Provider.of<AuthViewModel>(context);
            return
            ChangeNotifierProvider<ProfileViewModel>(
                create: (BuildContext context) => profileViewModel,
                child: Consumer<ProfileViewModel>(
                    builder: (context, viewmodel, _) {
                          return
                                Container(
                                  color:  Theme.of(context).scaffoldBackgroundColor,
                                  child: Center(
                                    child: Container(
                                              height: 670,
                                              width: 500,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Theme.of(context).cardColor,
                                                  border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.6))
                                              ),
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 30),
                                              child:Center(
                                                child: Column(
                                                      children: [
                                                            SizedBox(
                                                                  height: 25,
                                                            ),
                                                            Container(
                                                                  child: Stack(
                                                                        children: [
                                                                              SizedBox(
                                                                                  width: 120,
                                                                                  height: 120,
                                                                                  child: ClipOval(
                                                                                      child: _profileImage?.path == 'zz'
                                                                                          ? viewmodel.userInfoModel?.profilePic==null?Center(
                                                                                          child: ThreeArchedCircle( size: 50.0)
                                                                                      )    :Image.network(
                                                                                            '${viewmodel.userInfoModel?.profilePic}',
                                                                                            fit: BoxFit.cover,
                                                                                      )
                                                                                          : (kIsWeb)
                                                                                          ? Image.memory(
                                                                                            webImage,
                                                                                            fit: BoxFit.cover,
                                                                                      )
                                                                                          : Image.file(_profileImage!,
                                                                                          fit: BoxFit.cover))


                                                                                       ),
                                                                              Positioned(
                                                                                    right: 5,
                                                                                    top: 80,
                                                                                    child: GestureDetector(
                                                                                          onTap: _pickProfileImage,
                                                                                          child: const Icon(
                                                                                                Icons.camera_alt_sharp,
                                                                                                color: Colors.red,
                                                                                                size: 25,
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
                                                                                stream: validation.email,
                                                                                builder: (context, snapshot) {
                                                                                      return AppTextField(
                                                                                            maxLine: 1,
                                                                                            controller: emailController,
                                                                                            labelText: StringConstant.email,
                                                                                            textCapitalization: TextCapitalization.words,
                                                                                            isShowCountryCode: true,
                                                                                            isShowPassword: false,
                                                                                            secureText: false,
                                                                                            isVerifyNumber: enableEmailVerifyButton,
                                                                                            isEnable: enableEmailField,
                                                                                            maxLength: 30,
                                                                                            keyBoardType: TextInputType.emailAddress,
                                                                                            errorText: snapshot.hasError
                                                                                                ? snapshot.error.toString()
                                                                                                : null,
                                                                                            onChanged: (m) {
                                                                                                  validation.sinkEmail.add(m);
                                                                                                  setState(() {});
                                                                                            },
                                                                                            onSubmitted: (m) {},
                                                                                            verifySubmit: () {
                                                                                                  emailController?.text == '' ||
                                                                                                      snapshot.hasError == true
                                                                                                      ? ToastMessage.message(
                                                                                                      'Enter a valid email address')
                                                                                                      : verifyInput(
                                                                                                      authVM, StringConstant.emailVerify);;
                                                                                            },
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
                                                                                            isVerifyNumber: enableVerifyButton,
                                                                                            isEnable: enableMobileField,
                                                                                            maxLength: 10,
                                                                                            keyBoardType: TextInputType.phone,
                                                                                            errorText: snapshot.hasError
                                                                                                ? snapshot.error.toString()
                                                                                                : null,
                                                                                            onChanged: (m) {
                                                                                                  validation.sinkPhoneNo.add(m);
                                                                                                  setState(() {});
                                                                                            },
                                                                                            onSubmitted: (m) {},
                                                                                            verifySubmit: () {
                                                                                                  phoneController!.text.length < 10
                                                                                                      ? ToastMessage.message(
                                                                                                      'Enter a valid number')
                                                                                                      : verifyInput(
                                                                                                      authVM, StringConstant.numberVerify);
                                                                                            },
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
                                                                                            },
                                                                                            onSubmitted: (m) {},
                                                                                            isTick: true,
                                                                                      );
                                                                                }),
                                                                      ),
                                                                      SizedBox(height: 20),
                                                                      Container(
                                                                            margin: EdgeInsets.only(left: 10,right: 10),
                                                                        child: StreamBuilder(
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
                                                                                            snapshot.data != true
                                                                                                ? ToastMessage.message(StringConstant.fillOut)
                                                                                                : enableVerifyButton == true ||
                                                                                                enableEmailVerifyButton == true
                                                                                                ? ToastMessage.message(
                                                                                                'Please Verify your details')
                                                                                                : saveButtonPressed(
                                                                                                profileViewModel,
                                                                                                nameController?.text,
                                                                                                phoneController?.text,
                                                                                                emailController?.text,
                                                                                                addressController?.text);
                                                                                      });
                                                                            }),
                                                                      ),
                                                                ])),
                                                            SizedBox(height: 40),
                                                            confirmButton(context,60, 480, "Delete Account",(){
                                                                  profileViewModel.deleteProfile(context);
                                                            }),
                                                      ],
                                                ),
                                              )),
                                  ),
                                );
                    }));
      }

      saveButtonPressed(ProfileViewModel? viewmodel, String? name, String? phone,
          String? email, String? address) {
            viewmodel?.updateProfile(context, name, phone, address, email);
      }
//--------Profile Screen Item Selection---------

      verifyInput(AuthViewModel authVM, String msg) {
            AppIndicator.loadingIndicator(context);
            resendCode(authVM);
            AppDialog.verifyOtp(context, msg: msg, onTap: () {
                  otpValue != ''
                      ? verificationButtonPressed(authVM, otpValue ?? "")
                      : ToastMessage.message('Enter OTP');
            }, resendOtp: () {
                  resendCode(authVM);
            });
      }
      verificationButtonPressed(AuthViewModel authVM, String otpValue) async {
            AppIndicator.loadingIndicator(context);
            _authRepo.verifyOTP(
                '${phoneController?.text != '' ? phoneController?.text : emailController?.text}',
                otpValue,
                context, (result, isSuccess) {
                  if (isSuccess) {
                        Navigator.of(context, rootNavigator: true).pop();
                        AppIndicator.disposeIndicator();
                        ToastMessage.message(
                            ((result as SuccessState).value as ASResponseModal).message);
                        print('otp verified Successfully');
                        otpValue = '';
                        if (phoneController?.text != '') {
                              enableMobileField = false;
                              enableVerifyButton = false;
                        } else {
                              enableEmailField = false;
                              enableEmailVerifyButton = false;
                        }
                        setState(() {});
                  }
            });
      }

      resendCode(AuthViewModel authVM) {
            authVM.resendOtp(
                nameController?.text ?? '',
                emailController?.text,
                '',
                phoneController?.text,
                false,
                context,
                editPage: true,
                    (result, isSuccess) {});
      }
}
