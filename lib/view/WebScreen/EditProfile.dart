import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/repository/auth_repository.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/screens/verify_otp_screen.dart';
import 'package:TychoStream/view/widgets/AppDialog.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class EditProfile extends StatefulWidget {
  ProfileViewModel? viewmodel;
  // String? isEmailVerified;
  // String? isPhoneVerified;

  EditProfile({Key? key, this.viewmodel}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
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

  @override
  void initState() {
    profileViewModel.getProfileDetails(context);
    getUser();

    addressController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
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
    // profileViewModel.getVerificationButtonStatus(
    //     context,
    //     profileViewModel?.userInfoModel?.isPhoneVerified,
    //     profileViewModel?.userInfoModel?.isEmailVerified);
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
    // profileViewModel.getVerificationButtonStatus(
    //     context,
    //     profileViewModel.userInfoModel?.isPhoneVerified,
    //     profileViewModel.userInfoModel?.isEmailVerified);
    validateEditDetails();
    setState(() {});
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

  //-------Profile Screen---------
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    return ChangeNotifierProvider.value(
        value: profileViewModel,
        child: Consumer<ProfileViewModel>(builder: (context, viewmodel, _) {
          return GestureDetector(
            onTap: () {
              if (isLogins == true) {
                isLogins = false;
                setState(() {});
              }
              if(isSearch==true){
                isSearch=false;
                setState(() {

                });
              }
            },
            child: Scaffold(
                appBar: getAppBarWithBackBtn(
                    title: StringConstant.editProfile,
                    isBackBtn: false,
                    context: context,
                    onBackPressed: () {
                      Navigator.pop(context, true);
                    }),
                backgroundColor: Theme.of(context).backgroundColor,
                body: checkInternet == "Offline"
                    ? NOInternetScreen()
                    : SafeArea(
                    child: SingleChildScrollView(
                        child: Center(
                          child: Column(

                              children: [
                            SizedBox(height: 35),
                            _profileImageView(viewmodel),
                            SizedBox(height: 40),
                            _editFormField(viewmodel, authVM),
                                SizedBox(height:ResponsiveWidget.isMediumScreen(context)
                                    ?100: 220),
                                ResponsiveWidget.isMediumScreen(context)
                                    ?  footerMobile(context) : footerDesktop()
                          ]),
                        )))),
          );
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
                        ? ToastMessage.message(StringConstant.enterValidEmail)
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
                        ? ToastMessage.message(StringConstant.enterValidNumber)
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
          SizedBox(height: 20),
          SizedBox(height: 20),
          StreamBuilder(
              stream: validation.validateUserEditProfile,
              builder: (context, snapshot) {
                return appButton(
                    context,
                    StringConstant.Save,
                    ResponsiveWidget.isMediumScreen(context)
                        ? SizeConfig.screenWidth/1.5  :SizeConfig.screenWidth/4.5,
                    50,
                    LIGHT_THEME_COLOR,
                    WHITE_COLOR,
                    20,
                    10,
                    snapshot.data != true ? false : true, onTap: () {
                  snapshot.data != true
                      ? ToastMessage.message(StringConstant.fillOut)
                      : viewmodel.enableMobileField != true &&
                      viewmodel.enableEmailField != true
                      ? ToastMessage.message(StringConstant.verifyDetails)
                      : saveButtonPressed(
                      widget.viewmodel ?? profileViewModel,
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
          GestureDetector(
            onTap: () {
              // AppNavigator.push(
              //     context,
              //     FullImage(
              //         imageUrl:
              //         '${viewmodel.userInfoModel?.profilePic ?? widget.viewmodel?.userInfoModel?.profilePic ?? profileImg}'));
            },
            child: CircleAvatar(
              backgroundColor: WHITE_COLOR,
              radius: 57,
              child: CachedNetworkImage(
                imageUrl:
                '${viewmodel.userInfoModel?.profilePic ?? widget.viewmodel?.userInfoModel?.profilePic ?? profileImg}',
                imageBuilder: (context, imageProvider) => Container(
                  width: 110.0,
                  height: 110.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
              ),
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
            ((result as SuccessState).value as ASResponseModal).message);
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
          : ToastMessage.message(StringConstant.enterOtp);
    }, resendOtp: () {
      resendCode(authVM, verifyType);
    });
  }
}
