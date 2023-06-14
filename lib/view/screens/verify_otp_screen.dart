import 'dart:async';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:TychoStream/bloc_validation/Regex.dart';
import 'package:TychoStream/model/data/UserInfoModel.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AssetsConstants.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/TextStyling.dart';
import 'package:TychoStream/view/widgets/PinEntryTextFiled.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';

String? otpValue;

class VerifyOtp extends StatefulWidget {
  String? mobileNo;
  String? email;
  String? password;
  String? name;
  bool? isForgotPassword;
  HomeViewModel? viewmodel;
  bool? loginPage;
  bool? isNotVerified;
  VerifyOtp(
      {Key? key,
      this.mobileNo,
      this.isForgotPassword,
      this.name,
      this.email,
        this.loginPage,
        this.isNotVerified,
      this.password,
        this.viewmodel})
      : super(key: key);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}


class _VerifyOtpState extends State<VerifyOtp> {
  Timer? timer;
  bool enableResend = false, isPinError = false, isOTPInput = false;
  int secondsRemaining = 30;
  String errorPin = "";
  UserInfoModel? userModel;
  bool isVerifyOtpMobile = false;
  bool isVerifyOtpEmail = false;
  String? fcmToken;String deviceName ='';
  bool? mobileOTPVerificaton;
  HomeViewModel homeViewModel = HomeViewModel();
  AuthViewModel newAuthVm = AuthViewModel();

  void initState() {
    mobileOTPVerificaton = widget.viewmodel!.appConfigModel!.androidConfig!.loginWithPhone!;
    homeViewModel.getLoginType(context, widget.viewmodel?.appConfigModel?.androidConfig?.loginWithPhone ?? false);
    super.initState();
    startTimer();
  }

  void dispose() {
    timer?.cancel();
    otpValue = '';
    super.dispose();
  }

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    if (otpValue != null) {
      otpValue!.length == 4 ? isOTPInput = true : isOTPInput = false;
    }
    return AlertDialog(
        elevation: 8,
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: verificationSection(authVM,mobileOTPVerificaton!));
  }

  Widget verificationSection(AuthViewModel authVM,bool mobileOTPVerificaton) {
    return
      ResponsiveWidget.isMediumScreen(context) ?
      Container(
          height: 350,
          width: 500,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).cardColor.withOpacity(0.8),
              border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.6))
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                AppBoldFont(context,
                  msg: StringConstant.verification,
                  fontSize:  ResponsiveWidget.isMediumScreen(context)
                      ? 18 :22,
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.only(left: ResponsiveWidget.isMediumScreen(context)
                      ?10:0,right: ResponsiveWidget.isMediumScreen(context)
                      ?10:0),
                  child: AppMediumFont(
                      context,textAlign: TextAlign.left,
                      msg: mobileOTPVerificaton == true ? StringConstant.codeVerify : StringConstant.emailVerify,
                      fontSize: ResponsiveWidget.isMediumScreen(context)? 14:16,
                      maxLines: 2),
                ),
                SizedBox(height: 30),
                Container(
                  height:ResponsiveWidget.isMediumScreen(context)
                      ?50: 60,
                  width: 400,
                  child: PinEntryTextFiledView(),
                ),
                SizedBox(height: 10),
                resendPin(authVM,mobileOTPVerificaton),
                isOTPInput == true ? Container() : errorText(),
                SizedBox(height: 30),
                appButton(context, StringConstant.verify, ResponsiveWidget.isMediumScreen(context)
                    ?  SizeConfig.screenWidth*0.67  :SizeConfig.screenWidth/8,ResponsiveWidget.isMediumScreen(context)
                    ? 50: 60.0, LIGHT_THEME_COLOR,Theme.of(context).canvasColor,
                    16, 5.0, isOTPInput, onTap: () {
                      checkVerificationValidate(authVM,mobileOTPVerificaton);
                    }),
                SizedBox(height: 10),

              ],
            ),
          )) :
      Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.4)),
              color: Theme.of(context).cardColor),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center, children: [
            Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                  height: SizeConfig.screenHeight / 1.35,
                  width: SizeConfig.screenWidth * 0.29,
                  child: Image.asset(
                    'images/LoginPageLogo.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Container(
                width: SizeConfig.screenWidth * 0.29,
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    AppBoldFont(context,
                      msg: StringConstant.verification,
                      fontSize:  ResponsiveWidget.isMediumScreen(context)
                          ? 18 :22,
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.only(left: ResponsiveWidget.isMediumScreen(context)
                          ?10:0,right: ResponsiveWidget.isMediumScreen(context)
                          ?10:0),
                      child: AppMediumFont(
                          context,textAlign: TextAlign.left,
                          msg: mobileOTPVerificaton == true ? StringConstant.codeVerify : StringConstant.emailVerify,
                          fontSize: ResponsiveWidget.isMediumScreen(context)? 14:16,
                          maxLines: 2),
                    ),
                    SizedBox(height: 30),
                    Container(
                      height:ResponsiveWidget.isMediumScreen(context)
                          ?50: 60,
                      width: 400,
                      child: PinEntryTextFiledView(),
                    ),
                    SizedBox(height: 10),
                    resendPin(authVM,mobileOTPVerificaton),
                    isOTPInput == true ? Container() : errorText(),
                    SizedBox(height: 30),
                    appButton(context, StringConstant.verify, ResponsiveWidget.isMediumScreen(context)
                        ?  SizeConfig.screenWidth*0.67  :SizeConfig.screenWidth/8,ResponsiveWidget.isMediumScreen(context)
                        ? 50: 60.0, LIGHT_THEME_COLOR,Theme.of(context).canvasColor,
                        16, 5.0, isOTPInput, onTap: () {
                          checkVerificationValidate(authVM,mobileOTPVerificaton);
                        }),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            )
          ]));
  }

  Widget errorText() {
    return isPinError == true
        ? Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          IconButton(
            icon: Image.asset(AssetsConstants.icError,
                height: 23, width: 23),
            onPressed: () {},
          ),
          Container(
            child: AppMediumFont(
                context,msg: errorPin,
                fontSize: 16,
                maxLines: 3),
          )
        ],
      ),
    )
        : Container();
  }

  Widget headerTextWidget() {
    return Container(
        alignment: Alignment.topCenter,
        child: AppMediumFont(
            context,textAlign: TextAlign.left,
            msg: StringConstant.codeVerify,
            fontSize: ResponsiveWidget.isMediumScreen(context)? 14:16,
            maxLines: 1));
  }

  TextSpan headerText(String text, double fontSize) {
    return TextSpan(
      text: text,
      style: CustomTextStyle.textFormFieldInterMedium
          .copyWith(color: BLACK_COLOR, fontSize: fontSize),
    );
  }

  //--------Resend PIN/OTP-------
  Widget resendPin(AuthViewModel authVM,bool mobileOTPVerificaton) {
    return Container(
      child: Column(
        children: <Widget>[
          enableResend == false
              ? Container(
              margin: EdgeInsets.only(top: 20),
              child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Resend OTP ',
                        style: CustomTextStyle.textFormFieldInterRegular
                            .copyWith(color: Theme.of(context).canvasColor, fontSize: 16)),
                    TextSpan(
                        text: 'in ',
                        style: CustomTextStyle.textFormFieldInterRegular
                            .copyWith(color: Theme.of(context).canvasColor, fontSize: 16)),
                    TextSpan(
                        text: '00:$secondsRemaining',
                        style: CustomTextStyle.textFormFieldInterMedium
                            .copyWith(color: Theme.of(context).primaryColor, fontSize: 16)),
                    TextSpan(
                        text: " seconds",
                        style: CustomTextStyle.textFormFieldInterRegular
                            .copyWith(color: Theme.of(context).canvasColor, fontSize: 16))
                  ])))
              : Text(""),
          enableResend == true
              ? Container(
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppMediumFont(
                    context,msg: StringConstant.resendOtp, fontSize: 16),
                TextButton(
                  child: Text(
                      StringConstant.resend + ' >',
                      style: TextStyle( color: Theme.of(context).primaryColor,
                          fontSize: 16, fontWeight: FontWeight.bold, fontFamily: Theme.of(context).textTheme.displayMedium?.fontFamily)),
                  onPressed: () {
                    if (enableResend == true) {
                      _resendCode(authVM,mobileOTPVerificaton);
                    }
                  },
                )
              ],
            ),
          )
              : Container(),
          enableResend == true ? Container() : Container(),
        ],
      ),
    );
  }

  _resendCode(AuthViewModel authVM,bool mobileOTPVerificaton) {
    authVM.resendOtp(
        mobileOTPVerificaton == false
            ? (widget.email ?? '')
            : (widget.mobileNo ?? ''),
        verifyDetailType: widget.loginPage == true? 'login':'verify',
        context, (result, isSuccess) {
      if (isSuccess) {
        enableResend = false;
        startTimer();
      }
    });
  }

  checkVerificationValidate(
      AuthViewModel authVM, bool mobileOTPVerificaton) async {
    errorPin = Regex.validatePinNumber(otpValue!)!;
    if (errorPin != "") {
      isPinError = true;
    } else {
      isPinError = false;
      verificationButtonPressed(authVM, otpValue!,
          '',  '', mobileOTPVerificaton);
    }
    setState(() {});
  }

  //VerificationButton Method
  verificationButtonPressed(AuthViewModel authVM, String otpValue,
      String deviceId, String firebaseId, bool mobileOTPVerification) async {
    authVM.verifyOTP(
        context,
        mobileOTPVerification == false
            ? (widget.email ?? '')
            : (widget.mobileNo ?? ''),
        otpValue,
        isForgotPW: widget.isForgotPassword,
        name: widget.name,
        email: widget.email,
        mobileNumber: mobileOTPVerification == false
            ? '':widget.mobileNo,
        password: widget.password,
        deviceId: deviceId,
        firebaseId: firebaseId,
        isNotVerified:widget.isNotVerified,
        loginType: mobileOTPVerification == false
            ? 'email'
            : 'phone', handler: (result, isSuccess) {
      isVerifyOtpMobile = true;
      setState(() {});
    });
  }
}
