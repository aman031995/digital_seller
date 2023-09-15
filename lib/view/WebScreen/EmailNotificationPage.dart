import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';

final validation = ValidationBloc();
Widget emailNotificationUpdatePage(BuildContext context, TextEditingController emailController, AuthViewModel authVM) {
    return Container(
      height: ResponsiveWidget.isMediumScreen(context) ?220: SizeConfig.screenWidth * 0.2,
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.only(left: ResponsiveWidget.isMediumScreen(context) ?8:0,right: ResponsiveWidget.isMediumScreen(context) ?8:0),
      color: Theme.of(context).primaryColor.withOpacity(0.4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppMediumFont(context, msg: "SIGN UP AND SAVE UP TO 20%", fontSize:  ResponsiveWidget.isMediumScreen(context) ?16:32, fontWeight: FontWeight.w600, color: Theme.of(context).canvasColor),
          SizedBox(height:  ResponsiveWidget.isMediumScreen(context) ?10:30,),
          AppRegularFont(context, msg: 'Be updated on new arrivals, trends and offers. Sign up now! ', fontSize: ResponsiveWidget.isMediumScreen(context) ?14: 28, fontWeight: FontWeight.w500, color: Theme.of(context).canvasColor),
          SizedBox(height: ResponsiveWidget.isMediumScreen(context) ?10: 30,),
          ResponsiveWidget.isMediumScreen(context) ? getLatestUpdateRowTextFieldMobile(context,emailController,authVM):getLatestUpdateRowTextField(context,emailController,authVM),
        ],
      ),
    );
  }

  Widget getLatestUpdateRowTextField(BuildContext context, TextEditingController emailController, AuthViewModel authVM) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputNormalTextField(emailController, TextInputType.emailAddress, StringConstant.enterEmail, null,context,authVM),
        SizedBox(width: 40),
        ResponsiveWidget.isMediumScreen(context) ? SizedBox()  :Container(
          height: 50,
          width: SizeConfig.screenWidth * 0.2,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(0)),
          ),
          child: StreamBuilder(
              stream:validation.checkEmailValidate,
              builder: (context, snapshot) {
                return appButton(
                    context,
                    StringConstant.subscribe,
                    SizeConfig.screenWidth ,
                    50.0,
                    Theme.of(context).primaryColor,
                    Theme.of(context).hintColor,
                    18,
                    10,
                    snapshot.data != true ? false : true,
                    onTap: () {
                      snapshot.data != true ? ToastMessage.message(StringConstant.worngEmail,context) : authVM.subscribedEmail(emailController.text, context);
                      emailController.clear();
                    });
              }),
        ),
      ],
    );
  }

Widget getLatestUpdateRowTextFieldMobile(BuildContext context, TextEditingController emailController, AuthViewModel authVM) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      inputNormalTextField(emailController, TextInputType.emailAddress, StringConstant.enterEmail, null,context,authVM),
       SizedBox(height: 8),
      Container(
        height:50,
        width:200,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(0)),
        ),
        child: StreamBuilder(
            stream:validation.checkEmailValidate,
            builder: (context, snapshot) {
              return appButton(
                  context,
                  StringConstant.subscribe,
                  SizeConfig.screenWidth ,
                  50.0,
                  Theme.of(context).primaryColor,
                  Theme.of(context).hintColor,
                  18,
                  10,
                  snapshot.data != true ? false : true,
                  onTap: () {
                    snapshot.data != true ? ToastMessage.message(StringConstant.worngEmail,context) : authVM.subscribedEmail(emailController.text, context);
                    emailController.clear();
                  });
            }),
      )

    ],
  );
}


Widget inputNormalTextField(var ctrl,var keyType, String msg, var sinkValue,BuildContext context,AuthViewModel authVM) {
  return
    Container(
      height:ResponsiveWidget.isMediumScreen(context) ?80: 80,
      width:ResponsiveWidget.isMediumScreen(context) ?300: SizeConfig.screenWidth * 0.2,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(0)),
      ),
      child: StreamBuilder(
          stream: validation.email,
          builder: (context, snapshot) {
            return AppTextField(
                maxLine: null,
                prefixText: '',
                controller: ctrl,
                labelText: StringConstant.email,
                isShowCountryCode: true,
                isShowPassword: false,
                secureText: false,
                isColor: false,
                isTick: false,
                maxLength: 40,
                errorText: snapshot.hasError
                    ? snapshot.error.toString()
                    : null,
                onChanged: (m) {
                  validation.sinkEmail.add(m);

                },
                keyBoardType: TextInputType.emailAddress,
                onSubmitted: (m) {});
          }),
    );
}