import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/repository/auth_repository.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/authentication/verify_otp_screen.dart';
import 'package:TychoStream/view/WebScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/search/search_list.dart';
import 'package:TychoStream/view/widgets/AppDialog.dart';
import 'package:TychoStream/view/widgets/NotificationScreen.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/footerDesktop.dart';
import 'package:TychoStream/view/widgets/getAppBar.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/notification_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../AppRouter.gr.dart';

@RoutePage()
class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileViewModel profileViewModel = ProfileViewModel();
  final _authRepo = AuthRepository();
  final validation = ValidationBloc();
  String? name, email, phone, address, profileImg, checkInternet;
  TextEditingController? addressController,
      nameController,
      phoneController,
      emailController;
  HomeViewModel homeViewModel=HomeViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  ScrollController scrollController = ScrollController();
  TextEditingController? searchController = TextEditingController();
  CartViewModel cartViewModel = CartViewModel();
  NotificationViewModel notificationViewModel = NotificationViewModel();

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    cartViewModel.getCartCount(context);

    homeViewModel.getAppConfig(context);
    profileViewModel.getProfileDetail(context);
    getUser();
    addressController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    notificationViewModel.getNotificationCountText(context);

    fetchCurrentUserDetails();
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
    validateEditDetails();
    setState(() {});
  }

  validateEditDetails() {
    validation.sinkFirstName.add(name ?? '');
    validation.sinkPhoneNo.add(phone ?? '');
    validation.sinkAddress.add(address ?? '');
    validation.sinkEmail.add(email ?? '');
  }
  fetchCurrentUserDetails() {
    validateEditDetails();
    setState(() {});
  }


  //-------Profile Screen---------
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    AppNetwork.checkInternet((isSuccess, result) {
      setState(() {
        checkInternet = result;
      });
    });
    return  checkInternet == "Offline"
        ? NOInternetScreen()
        :ChangeNotifierProvider.value(
        value: profileViewModel,
        child: Consumer<ProfileViewModel>(builder: (context, profilemodel, _) {
          return ChangeNotifierProvider.value(
              value: homeViewModel,
              child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
                return ChangeNotifierProvider.value(
                    value: notificationViewModel,
                    child: Consumer<NotificationViewModel>(
                        builder: (context, model, _) {return GestureDetector(
            onTap: () {
              if (GlobalVariable.isLogins == true) {
                GlobalVariable.isLogins = false;
                setState(() {});
              }
              if(GlobalVariable.isSearch==true){
                GlobalVariable.isSearch=false;
                setState(() {
                });
              }
              if(GlobalVariable.isnotification==true){
                GlobalVariable.isnotification=false;
                setState(() {
                });
              }
            },
            child: Scaffold(
                appBar:  ResponsiveWidget.isMediumScreen(context)
                    ? homePageTopBar(context, _scaffoldKey,cartViewModel.cartItemCount,
                  viewmodel,
                  profilemodel,notificationViewModel)
                    : getAppBar(
                    context,
                    model,
                    viewmodel,
                    profilemodel,
                    cartViewModel.cartItemCount,1,
                    searchController, () async {
                  SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
                  if (sharedPreferences.get('token') ==
                      null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return LoginUp(
                            product: true,
                          );
                        });
                  } else {
                    if (GlobalVariable.isLogins == true) {
                      GlobalVariable.isLogins = false;
                      setState(() {});
                    }
                    if (GlobalVariable.isSearch == true) {
                      GlobalVariable.isSearch = false;
                      setState(() {});
                    }
                    if(GlobalVariable.isnotification==true){
                      GlobalVariable.isnotification=false;
                      setState(() {

                      });
                    }
                    context.router.push(FavouriteListPage());
                  }
                }, () async {
                  SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
                  if (sharedPreferences
                      .getString('token')== null) {
                    showDialog(
                        context: context,
                        barrierColor: Theme.of(context)
                            .canvasColor
                            .withOpacity(0.6),
                        builder: (BuildContext context) {
                          return LoginUp(
                            product: true,
                          );
                        });
                  } else {
                    if (GlobalVariable.isLogins == true) {
                      GlobalVariable.isLogins = false;
                      setState(() {});
                    }
                    if (GlobalVariable.isSearch == true) {
                      GlobalVariable.isSearch = false;
                      setState(() {});
                    }
                    if(GlobalVariable.isnotification==true){
                      GlobalVariable. isnotification=false;
                      setState(() {

                      });
                    }
                    context.router.push(CartDetail(
                        itemCount:
                        '${cartViewModel.cartItemCount}'));
                  }
                }),
                body:  Scaffold(
                extendBodyBehindAppBar: true,
                key: _scaffoldKey,
                backgroundColor: Theme.of(context)
                    .scaffoldBackgroundColor,
                drawer:
                ResponsiveWidget.isMediumScreen(context)
                ? AppMenu() : SizedBox(),
                body: Stack(
                      children: [
                        SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              SizedBox(height: 35),
                              _profileImageView(profilemodel),
                              SizedBox(height: 40),
                              _editFormField(profilemodel, authVM),
                                  SizedBox(height: 20),
                                  StreamBuilder(
                                      stream: validation.validateUserEditProfile,
                                      builder: (context, snapshot) {
                                        return appButton(
                                            context,
                                            StringConstant.logout,
                                            ResponsiveWidget.isMediumScreen(context)
                                                ?   SizeConfig.screenWidth/1.5:  SizeConfig.screenWidth/4.5,
                                            50,
                                            Theme.of(context).primaryColor,
                                            Theme.of(context).hintColor,
                                            20,
                                            10,
                                            snapshot.data != true ? false : true, onTap: () {
                                          authVM.logoutButtonPressed(context);
                                          context.router.stack.clear();
                                          context.router.dispose();
                                        });
                                      }),
                                  SizedBox(height:ResponsiveWidget.isMediumScreen(context)
                                      ?ResponsiveWidget.isSmallScreen(context)?100:200: 100),
                                  ResponsiveWidget.isMediumScreen(context)
                                      ?  footerMobile(context,homeViewModel) : footerDesktop(),

                            ])),
                        ResponsiveWidget.isMediumScreen(context)
                            ? Container()
                            : GlobalVariable.isnotification == true
                            ?    Positioned(
                            top:  0,
                            right:  SizeConfig
                                .screenWidth *
                                0.20,
                            child: notification(notificationViewModel,context,_scrollController)):Container(),
                        ResponsiveWidget.isMediumScreen(context)
                            ? Container()
                            : GlobalVariable.isLogins == true
                            ? Positioned(
                            top: 0,
                            right: 180,
                            child: profile(context,
                                setState, profilemodel))
                            : Container(),
                        ResponsiveWidget
                            .isMediumScreen(context)
                            ? Container():
                        GlobalVariable.isSearch == true
                            ? Positioned(
                            top:  SizeConfig.screenWidth *
                                0.001,
                            right: SizeConfig.screenWidth *
                                0.20,
                            child: searchList(
                                context,
                                viewmodel,
                                scrollController,
                                searchController!,
                                cartViewModel
                                    .cartItemCount))
                            : Container()
                      ],
                    ))),
          );}));
              }));
        }));
  }

  // form field
  _editFormField(ProfileViewModel viewmodel, AuthViewModel authVM) {
    return Container(
        width: ResponsiveWidget.isMediumScreen(context)
            ? SizeConfig.screenWidth/1.1  :SizeConfig.screenWidth/3.8,
        margin: const EdgeInsets.all(10),
        child: Column(children: [
          StreamBuilder(
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
                  errorText:
                  snapshot.hasError ? snapshot.error.toString() : null,
                  onChanged: (m) {
                    validation.sinkFirstName.add(m);
                    setState(() {});
                  },
                  isTick: null,
                );
              }),
          SizedBox(height: 20),
          StreamBuilder(
              stream: validation.email,
              builder: (context, snapshot) {
                return AppTextField(
                  maxLine: 1,
                  controller: emailController,
                  labelText: StringConstant.email,
                  textCapitalization: TextCapitalization.words,
                  isShowCountryCode: true,
                  isEditPage: true,
                  isShowPassword: false,
                  secureText: false,
                  isVerifyNumber:
                  viewmodel.enableEmailField == true ? false : true,
                  isEnable: viewmodel.enableEmailField == true ? false : true,
                  maxLength: 30,
                  keyBoardType: TextInputType.emailAddress,
                  errorText:
                  snapshot.hasError ? snapshot.error.toString() : null,
                  onChanged: (m) {
                    validation.sinkEmail.add(m);
                    setState(() {});
                  },
                  verifySubmit: () {
                    emailController?.text == '' || snapshot.hasError == true
                        ? ToastMessage.message(StringConstant.enterValidEmail,context)
                        : verifyInput(authVM, StringConstant.emailVerify,
                        emailController?.text ?? '', 'email');
                  },
                  isTick: null,
                );
              }),
          SizedBox(height: 20),
          StreamBuilder(
              stream: validation.phoneNo,
              builder: (context, snapshot) {
                return AppTextField(
                  maxLine: 1,
                  controller: phoneController,
                  labelText: StringConstant.mobileNumber,
                  isShowCountryCode: true,
                  isShowPassword: false,
                  secureText: false,
                  isEditPage: true,
                  isVerifyNumber:
                  viewmodel.enableMobileField == true ? false : true,
                  isEnable: viewmodel.enableMobileField == true ? false : true,
                  maxLength: 10,
                  keyBoardType: TextInputType.phone,
                  errorText:
                  snapshot.hasError ? snapshot.error.toString() : null,
                  onChanged: (m) {
                    validation.sinkPhoneNo.add(m);
                    setState(() {});
                  },
                  verifySubmit: () {
                    phoneController!.text.length < 10
                        ? ToastMessage.message(StringConstant.enterValidNumber,context)
                        : verifyInput(authVM, StringConstant.numberVerify,
                        phoneController?.text ?? '', 'phone');
                  },
                  isTick: null,
                );
              }),
          SizedBox(height: 20),
          StreamBuilder(
              stream: validation.address,
              builder: (context, snapshot) {
                return AppTextField(
                  maxLine: 1,
                  controller: addressController,
                  labelText: StringConstant.addressSmall,
                  isShowCountryCode: true,
                  textCapitalization: TextCapitalization.words,
                  isShowPassword: false,
                  secureText: false,
                  maxLength: 150,
                  isEnable: true,
                  keyBoardType: TextInputType.emailAddress,
                  errorText: null,
                  isTick: true,
                );
              }),
          SizedBox(height: 50),
          StreamBuilder(
              stream: validation.validateUserEditProfile,
              builder: (context, snapshot) {
                return appButton(
                    context,
                    StringConstant.Save,
                    ResponsiveWidget.isMediumScreen(context)
                        ? SizeConfig.screenWidth/1.5  :SizeConfig.screenWidth/4.5,
                    50,
                    Theme.of(context).primaryColor,
                    Theme.of(context).hintColor,
                    20,
                    10,
                    snapshot.data != true ? false : true, onTap: () {
                  snapshot.data != true
                      ? ToastMessage.message(StringConstant.fillOut,context)
                      : viewmodel.enableMobileField != true &&
                      viewmodel.enableEmailField != true
                      ? ToastMessage.message(StringConstant.verifyDetails,context)
                      : saveButtonPressed(
                      profileViewModel,
                      nameController?.text,
                      phoneController?.text,
                      emailController?.text,
                      addressController?.text);
                });
              }),
        ]));
  }

  // profile image section
  _profileImageView(ProfileViewModel viewmodel) {
    return Container(
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: WHITE_COLOR,
            radius: 57,
            child: CachedNetworkImage(
              imageUrl:
              '${viewmodel.userInfoModel?.profilePic  ?? profileImg}',
              imageBuilder: (context, imageProvider) => Container(
                width: 110.0,
                height: 110.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(color: Colors.grey,strokeWidth: 2),
            ),
          ),
          Positioned(
            left: 75,
            top: 60,
            child: IconButton(
              alignment: Alignment.bottomCenter,
              onPressed: () => viewmodel.uploadProfileImage(context),
              icon: Image.asset(
                AssetsConstants.icAddImage,
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SaveButton Method
  saveButtonPressed(ProfileViewModel? viewmodel, String? name, String? phone,
      String? email, String? address) {
    viewmodel?.updateProfile(context, name, phone, address, email);
  }

  // VerificationButton Method
  verificationButtonPressed(
      AuthViewModel authVM, String otpValue, String verifyType) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.verifyOTP(
        verifyType != 'email'
            ? (phoneController?.text ?? '')
            : (emailController?.text ?? ''),
        otpValue,
        "",
        "",
        context, (result, isSuccess) {
      if (isSuccess) {
        Navigator.of(context, rootNavigator: true).pop();
        AppIndicator.disposeIndicator();
        ToastMessage.message(
            ((result as SuccessState).value as ASResponseModal).message,context);
        otpValue = '';
        if (verifyType == 'email') {
          profileViewModel.getVerificationButtonStatus(
              context, profileViewModel.userInfoModel?.isPhoneVerified, true);
        }
        else {
          profileViewModel.getVerificationButtonStatus(
              context, true,profileViewModel.userInfoModel?.isEmailVerified);
        }}}
        );
  }

  //ResendCode Method
  resendCode(AuthViewModel authVM, String detail) {
    authVM.resendOtp(
        detail, context, verifyDetailType: 'verify', (result, isSuccess) {});
  }

  //VerifyInput Method
  verifyInput(
      AuthViewModel authVM, String msg, String detail, String verifyType) {
    AppIndicator.loadingIndicator(context);
    resendCode(authVM, detail);
    AppDialog.verifyOtp(context, msg: msg, onTap: () {
      otpValue != ''
          ? verificationButtonPressed(authVM, otpValue ?? "", verifyType)
          : ToastMessage.message(StringConstant.enterOtp,context);
    }, resendOtp: () {
      resendCode(authVM, verifyType);
    });
  }
}
