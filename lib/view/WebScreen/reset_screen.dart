import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/bloc_validation/Bloc_Validation.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/widgets/AppNavigationBar.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';

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
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2, color: Theme.of(context).primaryColor)
          ),
          height: 415,width: 500,
          child: Column(
            children: [
              SizedBox(height: 35),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.topLeft,
                  child: AppBoldFont(
                      context,msg: 'Reset', color: BLACK_COLOR, fontSize: 30)),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.topLeft,
                  child: AppRegularFont(
                      context,msg: 'Enter your new password to login again.',
                      color: BLACK_COLOR,
                      fontSize: 18)),
              SizedBox(height: 55),
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
                width: 400,
                child: StreamBuilder(
                    stream: validation.checkResetPasswordValidate,
                    builder: (context, snapshot) {
                      return appButton(
                          context,
                          'Reset',
                          SizeConfig.screenWidth * 0.9,
                          60.0,
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

    );
  }

  resetBtnPressed(AuthViewModel authVM, String newPW, String confirmPW) {
    authVM.resetPassword(widget.phone!, newPW, confirmPW, context);
  }
}
