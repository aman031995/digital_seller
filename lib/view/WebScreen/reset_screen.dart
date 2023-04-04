import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';

class ResetPassword extends StatefulWidget {
  String? phone;
  ResetPassword({Key? key, this.phone}) : super(key: key);

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
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: ResponsiveWidget.isMediumScreen(context)? Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: Theme.of(context).primaryColor)
          ),
          height:ResponsiveWidget.isMediumScreen(context)
              ? 300 : 350,
          width: ResponsiveWidget.isMediumScreen(context)
              ? 600 :500,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height:ResponsiveWidget.isMediumScreen(context)
                    ? 15 : 20),
                AppBoldFont(
                    textAlign: TextAlign.center,
                    context,msg: 'Reset', fontSize:ResponsiveWidget.isMediumScreen(context)
                    ?18: 22),
                AppRegularFont(
                    context,msg: 'Enter your new password to login again.',
                    fontSize:ResponsiveWidget.isMediumScreen(context) ?14: 16),
                SizedBox(height:ResponsiveWidget.isMediumScreen(context) ? 20 : 30),
                Container(
                  width: 400,
                  child: StreamBuilder(
                      stream: validation.password,
                      builder: (context, snapshot) {
                        return AppTextField(
                            maxLine: 1,
                            controller: newPasswordController,
                            labelText: 'New Password',
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
                            labelText: 'Confirm Password',
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
                  child: StreamBuilder(
                      stream: validation.checkResetPasswordValidate,
                      builder: (context, snapshot) {
                        return appButton(
                            context,
                            'Reset',
                            ResponsiveWidget.isMediumScreen(context)
                                ?  220  :   SizeConfig.screenWidth /8,
                            ResponsiveWidget.isMediumScreen(context)
                                ? 50 :60.0,
                            LIGHT_THEME_COLOR,
                            Theme.of(context).canvasColor,
                            18,
                            10,
                            snapshot.data != true ? false : true, onTap: () {
                          snapshot.data != true
                              ? ToastMessage.message(StringConstant.fillOut)
                              : resetBtnPressed(authVM, newPasswordController.text,
                                  confirmPasswordController.text);
                        });
                      }),
                ),
              ],
            ),
          ),
        ) :
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.4)),
                color: Theme.of(context).cardColor),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                height: SizeConfig.screenHeight / 1.35,
                width: SizeConfig.screenWidth * 0.29,
                child: Image.asset(
                  'images/LoginPageLogo.png',
                  fit: BoxFit.fill,
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  width: SizeConfig.screenWidth * 0.29,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height:ResponsiveWidget.isMediumScreen(context)
                            ? 15 : 20),
                        AppBoldFont(
                            textAlign: TextAlign.center,
                            context,msg: 'Reset', fontSize:ResponsiveWidget.isMediumScreen(context)
                            ?18: 22),
                        SizedBox(height: 15,),
                        AppRegularFont(
                            context,msg: 'Enter your new password to login again.',
                            fontSize:ResponsiveWidget.isMediumScreen(context) ?14: 16),
                        SizedBox(height:ResponsiveWidget.isMediumScreen(context) ? 20 : 30),
                        Container(
                          width: 400,
                          child: StreamBuilder(
                              stream: validation.password,
                              builder: (context, snapshot) {
                                return AppTextField(
                                    maxLine: 1,
                                    controller: newPasswordController,
                                    labelText: 'New Password',
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
                                    labelText: 'Confirm Password',
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
                          child: StreamBuilder(
                              stream: validation.checkResetPasswordValidate,
                              builder: (context, snapshot) {
                                return appButton(
                                    context,
                                    'Reset',
                                    ResponsiveWidget.isMediumScreen(context)
                                        ?  220  :   SizeConfig.screenWidth /8,
                                    ResponsiveWidget.isMediumScreen(context)
                                        ? 50 :60.0,
                                    LIGHT_THEME_COLOR,
                                    Theme.of(context).canvasColor,
                                    18,
                                    10,
                                    snapshot.data != true ? false : true, onTap: () {
                                  snapshot.data != true
                                      ? ToastMessage.message(StringConstant.fillOut)
                                      : resetBtnPressed(authVM, newPasswordController.text,
                                      confirmPasswordController.text);
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ])),

    );
  }

  resetBtnPressed(AuthViewModel authVM, String newPW, String confirmPW) {
    authVM.resetPassword(widget.phone!, newPW, confirmPW, context);
  }
}
