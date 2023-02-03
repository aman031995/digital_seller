import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/bloc_validation/Regex.dart';
import 'package:tycho_streams/model/data/UserInfoModel.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/TextStyling.dart';
import 'package:tycho_streams/utilities/Validator.dart';
import 'package:tycho_streams/view/widgets/AppNavigationBar.dart';
import 'package:tycho_streams/view/widgets/PinEntryTextFiled.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';

String? otpValue;

class VerifyOtp extends StatefulWidget {
  String? mobileNo;
  String? email;
  String? password;
  String? name;
  bool? isForgotPassword;

  VerifyOtp(
      {Key? key,
      this.mobileNo,
      this.isForgotPassword,
      this.name,
      this.email,
      this.password})
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

  void initState() {
    super.initState();
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

  void dispose() {
    timer?.cancel();
    otpValue = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);

    if (otpValue != null) {
      otpValue!.length == 4 ? isOTPInput = true : isOTPInput = false;
    }
    return Scaffold(
        appBar: getAppBarWithBackBtn(''),
        backgroundColor: LIGHT_THEME_BACKGROUND, body: verificationSection(authVM));
  }

  Widget verificationSection(AuthViewModel authVM) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Container(
                  alignment: Alignment.topLeft,
                  child: AppBoldFont(
                      msg: 'Verify OTP', fontSize: 26, color: TEXT_COLOR)),
              SizedBox(height: 5),
              headerTextWidget(),
              SizedBox(height: 10),
              Container(
                height: 100,
                width: SizeConfig.screenWidth! - 50,
                child: PinEntryTextFiledView(),
              ),
              SizedBox(height: 10),
              isOTPInput == true ? Container() : errorText(),
              SizedBox(height: 10),
              appButton(context, 'Verify', 300, 60.0, THEME_BUTTON,
                  BUTTON_TEXT_COLOR, 16, 10.0, isOTPInput, onTap: () {
                checkVerificationValidate(authVM);
              }),
              SizedBox(height: 10),
              resendPin(authVM),
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
                      msg: errorPin,
                      color: RED_COLOR,
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
        alignment: Alignment.topLeft,
        child: AppMediumFont(
            textAlign: TextAlign.left,
            msg:
                'Please check your email we have sent\n you a 4-digit code to verify.',
            color: TEXT_COLOR,
            fontSize: 14,
            maxLines: 2));
  }

  TextSpan headerText(String text, double fontSize) {
    return TextSpan(
      text: text,
      style: CustomTextStyle.textFormFieldGILROYMedium
          .copyWith(color: BLACK_COLOR, fontSize: fontSize),
    );
  }

  //--------Resend PIN/OTP-------
  Widget resendPin(AuthViewModel authVM) {
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
                        style: CustomTextStyle.textFormFieldGILROYBold
                            .copyWith(color: THEME_COLOR, fontSize: 16)),
                    TextSpan(
                        text: 'in ',
                        style: CustomTextStyle.textFormFieldGILROYRegular
                            .copyWith(color: TEXT_COLOR, fontSize: 16)),
                    TextSpan(
                        text: '00:$secondsRemaining',
                        style: CustomTextStyle.textFormFieldGILROYMedium
                            .copyWith(color: BLACK_COLOR, fontSize: 16)),
                    TextSpan(
                        text: " seconds",
                        style: CustomTextStyle.textFormFieldGILROYRegular
                            .copyWith(color: TEXT_COLOR, fontSize: 16))
                  ])))
              : Text(""),
          enableResend == true
              ? Container(
                  width: SizeConfig.screenWidth!,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppMediumFont(
                          msg: 'Resend Otp', color: TEXT_COLOR, fontSize: 16),
                      TextButton(
                        child: AppBoldFont(
                            msg: 'Resend' + ' >',
                            color: THEME_COLOR,
                            fontSize: 16),
                        onPressed: () {
                          if (enableResend == true) {
                            _resendCode(authVM);
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

  _resendCode(AuthViewModel authVM) {
    authVM.resendOtp(widget.mobileNo!, context);
  }

  checkVerificationValidate(AuthViewModel authVM) async {
    errorPin = Regex.validatePinNumber(otpValue!)!;
    if (errorPin != "") {
      isPinError = true;
    } else {
      isPinError = false;
      verificationButtonPressed(authVM, otpValue!);
    }
    setState(() {});
  }

  verificationButtonPressed(AuthViewModel authVM, String otpValue) async {
    authVM.verifyOTP(context, widget.mobileNo!, otpValue,
        isForgotPW: widget.isForgotPassword,
        name: widget.name,
        email: widget.email,
        password: widget.password);
  }
}
