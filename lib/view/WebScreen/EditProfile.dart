import 'dart:io';

import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/bloc_validation/Bloc_Validation.dart';
import 'package:tycho_streams/main.dart';
import 'package:tycho_streams/model/data/UserInfoModel.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/repository/auth_repository.dart';
import 'package:tycho_streams/repository/profile_repository.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppIndicator.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/utilities/three_arched_circle.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
import 'package:tycho_streams/view/screens/verify_otp_screen.dart';
import 'package:tycho_streams/view/widgets/AppDialog.dart';
import 'package:tycho_streams/view/widgets/FullImageView.dart';
import 'package:tycho_streams/view/widgets/image_source.dart';
import 'package:tycho_streams/view/widgets/search_view.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';
import 'package:tycho_streams/viewmodel/profile_view_model.dart';

import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

import '../../model/data/AppConfigModel.dart';
import '../widgets/app_menu.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserInfoModel? _userInfoModel;

  UserInfoModel? get userInfoModel => _userInfoModel;
  final ProfileViewModel profileViewModel = ProfileViewModel();
  bool enableMobileField = false;
  bool enableVerifyButton = false;
  bool enableEmailField = false;
  bool enableEmailVerifyButton = false;
  final _authRepo = AuthRepository();
  HomeViewModel homeViewModel = HomeViewModel();
  ScrollController scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  final validation = ValidationBloc();
  String? name;
  String? email;
  String? phone;
  String? address;
  String? profileImg;
  String? pageTitle;
  Uint8List webImage = Uint8List(10);
  TextEditingController? addressController,
      nameController,
      phoneController,
      emailController;

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
    return ChangeNotifierProvider<HomeViewModel>(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, homemodel, _) {
          return ChangeNotifierProvider<ProfileViewModel>(
              create: (BuildContext context) => profileViewModel,
              child: Consumer<ProfileViewModel>(builder: (context, profilemodel, _) {
                return GestureDetector(
                  onTap: () {
                    if (isSearch == true) {
                      isSearch = false;
                      searchController?.clear();
                      setState(() {});
                    }
                    if( isLogins == true){
                      isLogins=false;
                      setState(() {

                      });
                    }
                  },
                  child: Scaffold(
                    backgroundColor:  Theme.of(context).scaffoldBackgroundColor,
                    appBar:   homePageTopBar(),
                    body:
                    Scaffold(
                      key: _scaffoldKey,
                      // drawer: AppMenu(homeViewModel: homemodel),
                      body: Stack(
                        children: [

                          SingleChildScrollView(
                             child: Center(
                               child: ResponsiveWidget.isMediumScreen(context)
                                   ?Container(
                                   height: 450,
                                   margin: EdgeInsets.only(top: 30),
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(10),
                                       color: Theme.of(context).cardColor,
                                       border: Border.all(
                                           width: 2,
                                           color: Theme.of(context)
                                               .primaryColor
                                               .withOpacity(0.6))),
                                   child: Column(
                                     children: [
                                       SizedBox(
                                         height: 5,
                                       ),
                                       Container(
                                         child: Stack(
                                           children: [
                                             SizedBox(
                                                 width: 80,
                                                 height: 80,
                                                 child: ClipOval(
                                                     child: profilemodel.userInfoModel?.profilePic != null ?
                                                     Image.network('${profilemodel.userInfoModel?.profilePic}', fit: BoxFit.cover)
                                                         : Center(child: ThreeArchedCircle(size: 20.0))
                                                 )
                                             ),
                                             Positioned(
                                               right: 3,
                                               top: 55,
                                               child: GestureDetector(
                                                 onTap: () => profilemodel.uploadProfileImage(context),
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
                                       SizedBox(height: 5),
                                       Container(
                                         margin: const EdgeInsets.all(10),
                                         width: SizeConfig.screenWidth/1.3,
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
                                                 onSubmitted: (m) {},
                                                 isTick: null,
                                               );
                                             }),
                                       ),
                                       Container(
                                         margin: const EdgeInsets.all(10),
                                         width: SizeConfig.screenWidth/1.3,
                                         alignment: Alignment.center,
                                         child: StreamBuilder(
                                             stream: validation.email,
                                             builder: (context, snapshot) {
                                               return AppTextField(
                                                 maxLine: 1,
                                                 controller: emailController,
                                                 labelText: StringConstant.email,
                                                 textCapitalization:
                                                 TextCapitalization.words,
                                                 isShowCountryCode: true,
                                                 isShowPassword: false,
                                                 secureText: false,
                                                 isVerifyNumber:
                                                 enableEmailVerifyButton,
                                                 isEnable: enableEmailField,
                                                 maxLength: 30,
                                                 keyBoardType:
                                                 TextInputType.emailAddress,
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
                                                       : verifyInput(authVM,
                                                       StringConstant.emailVerify);
                                                   ;
                                                 },
                                                 isTick: null,
                                               );
                                             }),
                                       ),
                                       Container(
                                         margin: const EdgeInsets.all(10),
                                         width: SizeConfig.screenWidth/1.3,
                                         alignment: Alignment.center,
                                         child: StreamBuilder(
                                             stream: validation.phoneNo,
                                             builder: (context, snapshot) {
                                               return AppTextField(
                                                 maxLine: 1,
                                                 controller: phoneController,
                                                 labelText:
                                                 StringConstant.mobileNumber,
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
                                                       authVM,
                                                       StringConstant
                                                           .numberVerify);
                                                 },
                                                 isTick: null,
                                               );
                                             }),
                                       ),
                                       Container(
                                         margin: const EdgeInsets.all(10),
                                         width: SizeConfig.screenWidth/1.3,
                                         alignment: Alignment.center,
                                         child: StreamBuilder(
                                             stream: validation.address,
                                             builder: (context, snapshot) {
                                               return AppTextField(
                                                 maxLine: 1,
                                                 controller: addressController,
                                                 labelText: 'Address',
                                                 isShowCountryCode: true,
                                                 textCapitalization:
                                                 TextCapitalization.words,
                                                 isShowPassword: false,
                                                 secureText: false,
                                                 maxLength: 150,
                                                 isEnable: true,
                                                 keyBoardType:
                                                 TextInputType.emailAddress,
                                                 errorText: null,
                                                 onChanged: (m) {},
                                                 onSubmitted: (m) {},
                                                 isTick: true,
                                               );
                                             }),
                                       ),
                                       SizedBox(height: 5),
                                       Container(
                                         margin: const EdgeInsets.all(10),
                                         child: StreamBuilder(
                                             stream:
                                             validation.validateUserEditProfile,
                                             builder: (context, snapshot) {
                                               return appButton(
                                                   context,
                                                   StringConstant.Save,
                                                   SizeConfig.screenWidth/1.5,
                                                   50,
                                                   LIGHT_THEME_COLOR,
                                                   WHITE_COLOR,
                                                   18,
                                                   10,
                                                   snapshot.data != true
                                                       ? false
                                                       : true, onTap: () {
                                                 // snapshot.data != true ? null : " ";
                                                 snapshot.data != true
                                                     ? ToastMessage.message(
                                                     StringConstant.fillOut)
                                                     : enableVerifyButton == true ||
                                                     enableEmailVerifyButton ==
                                                         true
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
                                       SizedBox(height: 5),

                                     ],
                                   )):
                               Container(
                                   height: 580,
                                   width: 500,
                                   margin: EdgeInsets.only(top: 50),
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(20),
                                       color: Theme.of(context).cardColor,
                                       border: Border.all(
                                           width: 2,
                                           color: Theme.of(context)
                                               .primaryColor
                                               .withOpacity(0.6))),
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
                                                     child: profilemodel.userInfoModel?.profilePic != null ?
                                                     Image.network('${profilemodel.userInfoModel?.profilePic}', fit: BoxFit.cover)
                                                         : Center(child: ThreeArchedCircle(size: 50.0))
                                                 )),
                                             Positioned(
                                               right: 5,
                                               top: 80,
                                               child: GestureDetector(
                                                 onTap: () => profilemodel.uploadProfileImage(context),
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
                                                 textCapitalization:
                                                 TextCapitalization.words,
                                                 isShowCountryCode: true,
                                                 isShowPassword: false,
                                                 secureText: false,
                                                 isVerifyNumber:
                                                 enableEmailVerifyButton,
                                                 isEnable: enableEmailField,
                                                 maxLength: 30,
                                                 keyBoardType:
                                                 TextInputType.emailAddress,
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
                                                       : verifyInput(authVM,
                                                       StringConstant.emailVerify);
                                                   ;
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
                                                 labelText:
                                                 StringConstant.mobileNumber,
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
                                                       authVM,
                                                       StringConstant
                                                           .numberVerify);
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
                                                 textCapitalization:
                                                 TextCapitalization.words,
                                                 isShowPassword: false,
                                                 secureText: false,
                                                 maxLength: 150,
                                                 isEnable: true,
                                                 keyBoardType:
                                                 TextInputType.emailAddress,
                                                 errorText: null,
                                                 onChanged: (m) {},
                                                 onSubmitted: (m) {},
                                                 isTick: true,
                                               );
                                             }),
                                       ),
                                       SizedBox(height: 20),
                                       Container(
                                         margin: EdgeInsets.only(left: 10, right: 10),
                                         child: StreamBuilder(
                                             stream:
                                             validation.validateUserEditProfile,
                                             builder: (context, snapshot) {
                                               return appButton(
                                                   context,
                                                   StringConstant.Save,
                                                   SizeConfig.screenWidth /4.5,
                                                   60,
                                                   LIGHT_THEME_COLOR,
                                                   WHITE_COLOR,
                                                   20,
                                                   10,
                                                   snapshot.data != true
                                                       ? false
                                                       : true, onTap: () {
                                                 // snapshot.data != true ? null : " ";
                                                 snapshot.data != true
                                                     ? ToastMessage.message(
                                                     StringConstant.fillOut)
                                                     : enableVerifyButton == true ||
                                                     enableEmailVerifyButton ==
                                                         true
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
                                       SizedBox(height: 20),
                                     ],
                                   )),
                             ),
                           ),
                          isLogins == true
                              ? profile(context, setState)
                              : Container(),
                          if (homeViewModel.searchDataModel != null)
                            searchView(context, homeViewModel, isSearch, scrollController, homeViewModel, searchController!, setState)
                        ],
                      ),
                    ),
                  ),
                );
              }));
        }));
  }
  homePageTopBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).cardColor,
      title: Row(children: <Widget>[
        GestureDetector(
            onTap: (){
              GoRouter.of(context).pushNamed(RoutesName.home);
            },
            child: Image.asset(AssetsConstants.icLogo,width: ResponsiveWidget.isMediumScreen(context) ? 35:45, height:ResponsiveWidget.isMediumScreen(context) ? 35: 45)),
        SizedBox(width: SizeConfig.screenWidth*0.04),
        AppBoldFont(context,msg:"EditProfile",fontSize:ResponsiveWidget.isMediumScreen(context) ? 16: 20, fontWeight: FontWeight.w700),
      ]),
      actions: [
        GestureDetector(
          onTap: () {
            setState(() {
              isLogins = true;
              if (isSearch == true) {
                isSearch = false;
                searchController?.clear();
                setState(() {});
              }
            });
          },
          child: Row(
            children: [
              appTextButton(context, names!, Alignment.center, Theme.of(context).canvasColor,ResponsiveWidget.isMediumScreen(context)
                  ?16: 18, true),
              Image.asset(
                AssetsConstants.icProfile,
                height:ResponsiveWidget.isMediumScreen(context)
                    ?20: 30,
                color: Theme.of(context).canvasColor,
              ),
            ],
          ),
        ),
        SizedBox(width: SizeConfig.screenWidth*0.04),
      ],
    );
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
