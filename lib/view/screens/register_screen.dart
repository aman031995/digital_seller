import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/bloc_validation/Bloc_Validation.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/widgets/terms_condition.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final validation = ValidationBloc();
  bool isPhone = false,
      isEmail = false,
      isName = false,
      isPassword = false,
      isValidate = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    return Scaffold(
      backgroundColor: LIGHT_THEME_BACKGROUND,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.topLeft,
                child: AppBoldFont(
                    msg: 'Register', color: TEXT_COLOR, fontSize: 30)),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.topLeft,
                child: AppRegularFont(
                    msg: 'Lets register your self to make profile. ',
                    color: TEXT_COLOR,
                    fontSize: 18)),
            SizedBox(height: 45),
            registerForm(),
            SizedBox(height: 20),
            StreamBuilder(
                stream: validation.registerUser,
                builder: (context, snapshot) {
                  return appButton(
                      context,
                      'Create Account',
                      SizeConfig.screenWidth! * 0.93,
                      60.0,
                      THEME_BUTTON,
                      WHITE_COLOR,
                      18,
                      10,
                      snapshot.data != true ? false : true, onTap: () {
                    snapshot.data != true
                        ? null
                        : registerButtonPressed(
                            authVM,
                            nameController.text,
                            emailController.text,
                            phoneController.text,
                            passwordController.text);
                  });
                }),
            SizedBox(height: 20),
            socialLoginView(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppRegularFont(
                    msg: 'Already have an account?', color: TEXT_COLOR),
                appTextButton(context, 'Login', Alignment.bottomRight,
                    THEME_BUTTON, 16, true, onPressed: () {
                  Navigator.pushNamed(context, RoutesName.login);
                }),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      )),
    );
  }

  registerForm() {
    return Column(
      children: [
        StreamBuilder(
            stream: validation.firstName,
            builder: (context, snapshot) {
              return AppTextField(
                  maxLine: null,
                  prefixText: '',
                  controller: nameController,
                  labelText: 'Name',
                  isShowCountryCode: true,
                  isShowPassword: false,
                  secureText: false,
                  isColor: isName,
                  isTick: false,
                  maxLength: 100,
                  errorText:
                      snapshot.hasError ? snapshot.error.toString() : null,
                  onChanged: (m) {
                    validation.sinkFirstName.add(m);
                    isName = true;
                    setState(() {});
                  },
                  keyBoardType: TextInputType.text,
                  onSubmitted: (m) {});
            }),
        SizedBox(height: 15),
        StreamBuilder(
            stream: validation.email,
            builder: (context, snapshot) {
              return AppTextField(
                  maxLine: null,
                  prefixText: '',
                  controller: emailController,
                  labelText: 'Email',
                  isShowCountryCode: true,
                  isShowPassword: false,
                  secureText: false,
                  isColor: isEmail,
                  isTick: false,
                  maxLength: 100,
                  errorText:
                      snapshot.hasError ? snapshot.error.toString() : null,
                  onChanged: (m) {
                    validation.sinkEmail.add(m);
                    isEmail = true;
                    setState(() {});
                  },
                  keyBoardType: TextInputType.emailAddress,
                  onSubmitted: (m) {});
            }),
        SizedBox(height: 15),
        StreamBuilder(
            stream: validation.phoneNo,
            builder: (context, snapshot) {
              return AppTextField(
                  maxLine: null,
                  prefixText: '',
                  controller: phoneController,
                  labelText: 'Phone',
                  isShowCountryCode: true,
                  isShowPassword: false,
                  secureText: false,
                  isColor: isPhone,
                  isTick: false,
                  maxLength: 10,
                  errorText:
                      snapshot.hasError ? snapshot.error.toString() : null,
                  onChanged: (m) {
                    validation.sinkPhoneNo.add(m);
                    isPhone = true;
                    setState(() {});
                  },
                  keyBoardType: TextInputType.number,
                  onSubmitted: (m) {});
            }),
        SizedBox(height: 15),
        StreamBuilder(
            stream: validation.password,
            builder: (context, snapshot) {
              return AppTextField(
                  maxLine: 1,
                  controller: passwordController,
                  labelText: 'Password',
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
        const SizedBox(height: 15),
        Container(
            alignment: Alignment.topLeft,
            child: termsAndCondition(context, SizeConfig.screenWidth!)),
      ],
    );
  }

  registerButtonPressed(AuthViewModel authVM, String name, String email,
      String phone, String password) {
    authVM.register(name, email, phone, password, context);
  }

  Widget socialLoginView() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: SizeConfig.screenWidth! * 0.15,
                child: Divider(
                  color: BLACK_COLOR,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: AppMediumFont(
                    msg: StringConstant.orContinueWith,
                    color: TEXT_COLOR,
                    fontSize: 14),
              ),
              Container(
                width: SizeConfig.screenWidth! * 0.15,
                child: Divider(
                  color: BLACK_COLOR,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              socialNetworkButton(AssetsConstants.icGoogle, () {
                // isGoogle = true;
                // loginWithGoogle(context, fcmToken!, true);
              }),
              SizedBox(width: 10),
              socialNetworkButton(AssetsConstants.icFacebook, () {
                // loginWithFB(context, fcmToken!);
                // isGoogle = false;
              }),
              SizedBox(width: 10),
              // Platform.isIOS ? socialNetworkButton(AssetsConstants.icApple, () {
              //   // loginWithFB(context, fcmToken!);
              //   // isGoogle = false;
              // }) : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
