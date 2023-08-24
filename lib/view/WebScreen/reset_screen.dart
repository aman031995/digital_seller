import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ResetPassword extends StatefulWidget {
  String? phone;
  String? loginType;
  bool? product;

  ResetPassword({Key? key, this.phone,this.loginType,this.product}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final validation = ValidationBloc();
  bool isPassword2 = false, isPassword = false, isValidate = false;

  @override
  void dispose() {
    super.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    return AlertDialog(
      elevation: 8,
      titlePadding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).cardColor,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.all(10),
      content: ResponsiveWidget.isMediumScreen(context)? Container(
        padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 15),
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
              AppBoldFont(
                  textAlign: TextAlign.center,
                  context,msg: StringConstant.reset, fontSize: 22),
              AppRegularFont(
                  context,msg: StringConstant.enterNewPassword,
                  fontSize:16),
              SizedBox(height: 25),
              StreamBuilder(
                  stream: validation.password,
                  builder: (context, snapshot) {
                    return AppTextField(
                        maxLine: 1,
                        controller: newPasswordController,
                        labelText: StringConstant.newPassword,
                        prefixText: '',
                        isShowPassword: true,
                        isTick: true,
                        isColor: isPassword,
                        keyBoardType: TextInputType.visiblePassword,
                        errorText:
                        snapshot.hasError ? snapshot.error.toString() : null,
                        onChanged: (m) {
                          validation.sinkPassword.add(m);
                          isPassword = true;
                          setState(() {});
                        },
                        onSubmitted: (m) {});
                  }),
              SizedBox(height: 10),
              StreamBuilder(
                  stream: validation.confirmPassword,
                  builder: (context, snapshot) {
                    return AppTextField(
                        maxLine: 1,
                        controller: confirmPasswordController,
                        labelText: StringConstant.confirmPassword,
                        prefixText: '',
                        isShowPassword: true,
                        isTick: true,
                        isColor: isPassword2,
                        keyBoardType: TextInputType.visiblePassword,
                        errorText:
                        snapshot.hasError ? snapshot.error.toString() : null,
                        onChanged: (m) {
                          validation.sinkConfirmPassword.add(m);
                          isPassword2 = true;
                          setState(() {});
                        },
                        onSubmitted: (m) {});
                  }),
              SizedBox(height: 20),
              StreamBuilder(
                  stream: validation.checkResetPasswordValidate,
                  builder: (context, snapshot) {
                    return appButton(
                        context,
                        StringConstant.reset,
                        SizeConfig.screenWidth,
                        50.0,
                        Theme.of(context).primaryColor,
                        Theme.of(context).hintColor,
                        18,
                        10,
                        snapshot.data != true ? false : true, onTap: () {
                      snapshot.data != true
                          ? ToastMessage.message(StringConstant.fillOut,context)
                          : resetBtnPressed(authVM, newPasswordController.text,
                          confirmPasswordController.text,widget.loginType);
                    });
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
        ),
      ) :
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
                child: AppBoldFont(
                    context,msg:StringConstant.reset, fontSize: 30),
              ),
              SizedBox(height: 15,),
              Container(
                alignment: Alignment.topLeft,
                child: AppRegularFont(
                    context,msg: StringConstant.enterNewPassword,
                    fontSize:16),
              ),
              SizedBox(height: 30),
              Container(
                width: 400,
                child: StreamBuilder(
                    stream: validation.password,
                    builder: (context, snapshot) {
                      return AppTextField(
                          maxLine: 1,
                          controller: newPasswordController,
                          labelText: StringConstant.newPassword,
                          prefixText: '',
                          isShowPassword: true,
                          isTick: true,
                          isColor: isPassword,
                          keyBoardType: TextInputType.visiblePassword,
                          errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
                          onChanged: (m) {
                            validation.sinkPassword.add(m);
                            isPassword = true;
                            setState(() {});
                          },
                          onSubmitted: (m) {});
                    }),
              ),
              SizedBox(height: 15),
              Container(
                width: 400,
                child: StreamBuilder(
                    stream: validation.confirmPassword,
                    builder: (context, snapshot) {
                      return AppTextField(
                          maxLine: 1,
                          controller: confirmPasswordController,
                          labelText:  StringConstant.confirmPassword,
                          prefixText: '',
                          isShowPassword: true,
                          isTick: true,
                          isColor: isPassword2,
                          keyBoardType: TextInputType.visiblePassword,
                          errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
                          onChanged: (m) {
                            validation.sinkConfirmPassword.add(m);
                            isPassword2 = true;
                            setState(() {});
                          },
                          onSubmitted: (m) {});
                    }),
              ),
              SizedBox(height: 20),
              Container(
                width: 400,
                child: StreamBuilder(
                    stream: validation.checkResetPasswordValidate,
                    builder: (context, snapshot) {
                      return appButton(
                          context,
                          StringConstant.reset,
                            SizeConfig.screenWidth,
                           50.0,
                          Theme.of(context).primaryColor,
                          Theme.of(context).hintColor,
                          18,
                          10,
                          snapshot.data != true ? false : true, onTap: () {
                        snapshot.data != true
                            ? ToastMessage.message(StringConstant.fillOut,context)
                            : resetBtnPressed(authVM, newPasswordController.text,
                            confirmPasswordController.text,widget.loginType);
                      });
                    }),
              ),
              SizedBox(height:30),
              GestureDetector(
                onTap: () async{
                  const url = 'http://digitalseller.in/';
                  if (await canLaunch(url)) {
                    await launch(url, forceWebView: false, enableJavaScript: true);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Container(
                    width: SizeConfig.screenWidth * 0.08,
                    child: GlobalVariable.isLightTheme == true ?
                    Image.network(StringConstant.digitalSellerLitelogo,  fit: BoxFit.fill, width: 50) :
                    Image.network(StringConstant.digitalSellerDarklogo, fit: BoxFit.fill, width: 50)),
              ),
              SizedBox(height:10),
            ],
          ),
        ),
      ),

    );
  }

  resetBtnPressed(AuthViewModel authVM, String newPW, String confirmPW,String? loginType) {
    authVM.resetPassword(widget.phone!, newPW, confirmPW,loginType ?? '', context);
  }
}
