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
      elevation: 10,
      titlePadding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).cardColor,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.all(10),
      content: Container(
        margin:  EdgeInsets.only(left:ResponsiveWidget.isMediumScreen(context)?15: 50, right:ResponsiveWidget.isMediumScreen(context)?15: 50,top:ResponsiveWidget.isMediumScreen(context)?10: 20),
        width:ResponsiveWidget.isMediumScreen(context)?SizeConfig.screenWidth :SizeConfig.screenWidth * 0.25,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                  children: [
                    Positioned(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                              alignment: Alignment.topRight,
                              child:Image.asset(AssetsConstants.icCross, color: Theme.of(context).canvasColor,width:ResponsiveWidget.isMediumScreen(context)?20: 25,height:ResponsiveWidget.isMediumScreen(context)?20: 25)),
                        ))]),
              SizedBox(height:ResponsiveWidget.isMediumScreen(context)?5: 25),
              AppBoldFont(context,msg:StringConstant.reset, fontSize:ResponsiveWidget.isMediumScreen(context)?22: 30),
              SizedBox(height:ResponsiveWidget.isMediumScreen(context)?10: 15),
              AppRegularFont(
                  context,msg: StringConstant.enterNewPassword,
                  fontSize:16),
              SizedBox(height: ResponsiveWidget.isMediumScreen(context)?10:20),

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
              SizedBox(height:ResponsiveWidget.isMediumScreen(context)?10: 20),
              StreamBuilder(
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
              SizedBox(height: ResponsiveWidget.isMediumScreen(context)?10:20),
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
              SizedBox(height:ResponsiveWidget.isMediumScreen(context)?10:30),
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
                  child: Container(
                      child: GlobalVariable.isLightTheme == true ?
                      Image.network(StringConstant.digitalSellerLitelogo, fit: BoxFit.fill, width:ResponsiveWidget.isMediumScreen(context)?150:SizeConfig.screenWidth*0.12,height:ResponsiveWidget.isMediumScreen(context)?50: SizeConfig.screenWidth*0.03) :
                      Image.network(StringConstant.digitalSellerDarklogo, fit: BoxFit.fill, width:ResponsiveWidget.isMediumScreen(context)?150: SizeConfig.screenWidth*0.12,height:ResponsiveWidget.isMediumScreen(context)?50:SizeConfig.screenWidth*0.03)),
                ),
              ),
              SizedBox(height:ResponsiveWidget.isMediumScreen(context)?15:40),
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
