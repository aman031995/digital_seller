import 'dart:async';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:url_launcher/url_launcher.dart';

String? otpValue;

class VerifyOtp extends StatefulWidget {
  String? mobileNo;
  String? email;
  String? password;
  String? name;
  bool? isForgotPassword;
  HomeViewModel? viewmodel;
  bool? loginPage;
  bool? product;
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
        this.viewmodel,this.product})
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
  String? fcmToken;
  bool? mobileOTPVerificaton;
  HomeViewModel homeViewModel = HomeViewModel();
  AuthViewModel newAuthVm = AuthViewModel();

  void initState() {
    mobileOTPVerificaton = widget.viewmodel!.appConfigModel!.androidConfig!.loginWithPhone!;
    homeViewModel.getLoginType(context, widget.viewmodel?.appConfigModel?.androidConfig?.loginWithPhone ?? false);
    super.initState();
    getFCMToken();
    startTimer();
  }
  Future<void> getFCMToken() async {
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
      print('FCM Token: $fcmToken');
    } catch (e) {
      print('Error getting FCM token: $e');
    }
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
        titlePadding: EdgeInsets.zero,
        backgroundColor: Theme.of(context).cardColor,
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(10),

        content: verificationSection(authVM,mobileOTPVerificaton!));
  }

  Widget verificationSection(AuthViewModel authVM,bool mobileOTPVerificaton) {
    return
      ResponsiveWidget.isMediumScreen(context) ?
      Container(
          padding: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Positioned(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            }, icon: Image.asset(AssetsConstants.icCross, color: Theme.of(context).canvasColor)),
                      ),
                    )
                  ],
                ),
                AppBoldFont(context,
                  msg: StringConstant.verification,
                  fontSize: 22,
                ),
                SizedBox(height: 10),
                AppMediumFont(
                    context,textAlign: TextAlign.left,
                    msg: mobileOTPVerificaton == true ? StringConstant.codeVerify : StringConstant.emailVerify,
                    fontSize:16,
                    maxLines: 2),
                SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 400,
                  child: PinEntryTextFiledView(),
                ),
                SizedBox(height: 5),
                resendPin(authVM,mobileOTPVerificaton),
                isOTPInput == true ? Container() : errorText(),
                SizedBox(height: 10),
                appButton(context, StringConstant.verify,SizeConfig.screenWidth, 50,
                    Theme.of(context).primaryColor,
                    Theme.of(context).hintColor,
                    16, 5.0, isOTPInput, onTap: () {
                      checkVerificationValidate(authVM,mobileOTPVerificaton);
                    }),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async{
                    const url = 'http://digitalseller.in/';
                    if (await canLaunch(url)) {
                      await launch(url, forceWebView: false, enableJavaScript: true);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Center(
                    child: GlobalVariable.isLightTheme == true ?
                    Image.network(StringConstant.digitalSellerLitelogo, fit: BoxFit.fill, width: 100) :
                    Image.network(StringConstant.digitalSellerDarklogo, fit: BoxFit.fill, width: 100),
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          )) :
      Container(
          height: SizeConfig.screenHeight / 1.8,
          margin:  EdgeInsets.only(left: 50, right: 50,top: 20),
          width: SizeConfig.screenWidth * 0.25,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            }, icon: Image.asset(AssetsConstants.icCross, color: Theme.of(context).canvasColor)),
                      ),
                    )
                  ],
                ),

                Container(
                  alignment: Alignment.topLeft,

                  child: AppBoldFont(context,
                    msg: StringConstant.verification,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  alignment: Alignment.topLeft,

                  child: AppMediumFont(
                      context,textAlign: TextAlign.left,
                      msg: mobileOTPVerificaton == true ? StringConstant.codeVerify : StringConstant.emailVerify,
                      fontSize: 16,
                      maxLines: 2),
                ),
                SizedBox(height: 30),
                Container(
                  height: 60,
                  width: 400,
                  child: PinEntryTextFiledView(),
                ),
                SizedBox(height: 10),
                resendPin(authVM,mobileOTPVerificaton),
                isOTPInput == true ? Container() : errorText(),
                SizedBox(height: 30),
                appButton(context, StringConstant.verify, SizeConfig.screenWidth/8, 50.0,
                    Theme.of(context).primaryColor,
                    Theme.of(context).hintColor,
                    16, 5.0, isOTPInput, onTap: () {
                      checkVerificationValidate(authVM,mobileOTPVerificaton);
                    }),
                SizedBox(height:20),
                GestureDetector(
                  onTap: () async{
                    const url = 'http://digitalseller.in/';
                    if (await canLaunch(url)) {
                      await launch(url, forceWebView: false, enableJavaScript: true);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Center(
                      child: GlobalVariable.isLightTheme == true ?
                      Image.network(StringConstant.digitalSellerLitelogo, fit: BoxFit.fill, width:SizeConfig.screenWidth*0.12,height: SizeConfig.screenWidth*0.03) :
                      Image.network(StringConstant.digitalSellerDarklogo, fit: BoxFit.fill, width: SizeConfig.screenWidth*0.12,height:SizeConfig.screenWidth*0.03)),
                ),
                SizedBox(height:10),
              ],
            ),
          ));
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
          '', fcmToken ?? "", mobileOTPVerificaton);
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
        product: widget.product,
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
