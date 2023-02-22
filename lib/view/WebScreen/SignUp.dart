import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/bloc_validation/Bloc_Validation.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/screens/register_screen.dart';
import 'package:tycho_streams/view/widgets/social_login_view.dart';
import 'package:tycho_streams/view/widgets/terms_condition.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';
import 'package:tycho_streams/viewmodel/sociallogin_view_model.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
    final socialVM = Provider.of<SocialLoginViewModel>(context);
    return ResponsiveWidget.isMediumScreen(context)?AlertDialog(
        elevation: 8,
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Container(
            // width: 450,
            height: 570,
            decoration: BoxDecoration(
              color: Colors.white,
                borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * .02),
                  AppBoldFont(
                      msg: 'Get Started', color: BLACK_COLOR, fontSize: 18),
                  SizedBox(height: SizeConfig.screenHeight * .01),
                  AppRegularFont(
                      msg: "Lets register yourself to make profile.",
                      color: Colors.black,
                      fontSize: 14),
                  SizedBox(height: SizeConfig.screenHeight * .01),
                  registerMobileForm(),
                  SizedBox(height: SizeConfig.screenHeight * .01),
                  StreamBuilder(
                      stream: validation.registerUser,
                      builder: (context, snapshot) {
                        return appButton(
                            context,
                            'Create Account',
                            SizeConfig.screenWidth / 1.5,
                            60.0,
                            LIGHT_THEME_COLOR,
                            WHITE_COLOR,
                            18,
                            10,
                            snapshot.data != true ? false : true,
                            onTap: () {
                              snapshot.data != true
                                  ? ToastMessage.message(StringConstant.fillOut)
                                  : registerButtonPressed(
                                  authVM,
                                  nameController.text,
                                  emailController.text,
                                  phoneController.text,
                                  passwordController.text);
                            });
                      }),
                   SizedBox(height: SizeConfig.screenHeight * .01),
                  socialLoginViewMobile(socialVM),
                  // SizedBox(height: SizeConfig.screenHeight * .02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppRegularFont(
                          msg: 'Already have an account?', color: TEXT_COLOR,fontSize: 14),
                      appTextButton(context, 'Login', Alignment.bottomRight,
                          Colors.red, 16, true, onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                barrierDismissible:false,
                                barrierColor: Colors.black87,
                                builder: (BuildContext context) {
                                  return LoginUp();
                                });
                          }),
                    ],
                  ),
                ],
              ),
            ))):AlertDialog(
        elevation: 8,
        backgroundColor: Colors.transparent,
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Container(
            decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ResponsiveWidget.isMediumScreen(context)? Container() :   Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20))),
                height: SizeConfig.screenHeight / 1.3,
                width: SizeConfig.screenWidth * 0.29,
                child: Image.asset(
                  'images/LoginPageLogo.png',
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                height: SizeConfig.screenHeight / 1.3,
                decoration: BoxDecoration( color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20))),
                width: SizeConfig.screenWidth * 0.36,
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * .05),
                    AppBoldFont(
                        msg: 'Get Started', color: BLACK_COLOR, fontSize: 30),
                    SizedBox(height: SizeConfig.screenHeight * .02),
                    AppRegularFont(
                        msg: "Lets register yourself to make profile.",
                        color: Colors.black,
                        fontSize: 18),
                    registerForm(),
                    SizedBox(height: SizeConfig.screenHeight * .02),
                    StreamBuilder(
                        stream: validation.registerUser,
                        builder: (context, snapshot) {
                          return appButton(
                              context,
                              'Create Account',
                              SizeConfig.screenWidth / 4,
                              60.0,
                              LIGHT_THEME_COLOR,
                              WHITE_COLOR,
                              18,
                              10,
                              snapshot.data != true ? false : true,
                              onTap: () {
                            snapshot.data != true
                                ? ToastMessage.message(StringConstant.fillOut)
                                : registerButtonPressed(
                                    authVM,
                                    nameController.text,
                                    emailController.text,
                                    phoneController.text,
                                    passwordController.text);
                          });
                        }),
                    SizedBox(height: SizeConfig.screenHeight * .02),
                    socialLoginView(socialVM),
                    SizedBox(height: SizeConfig.screenHeight * .02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppRegularFont(
                            msg: 'Already have an account?', color: TEXT_COLOR),
                        appTextButton(context, 'Login', Alignment.bottomRight,
                            Colors.red, 16, true, onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  barrierDismissible:false,
                                  barrierColor: Colors.black87,
                                  builder: (BuildContext context) {
                                    return LoginUp();
                                  });
                        }),
                      ],
                    ),
                  ],
                ),
              )
            ])));
  }

  registerForm() {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * .02),
        StreamBuilder(
            stream: validation.firstName,
            builder: (context, snapshot) {
              return AppTextField(
                  width: SizeConfig.screenWidth / 4,
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
        SizedBox(height: SizeConfig.screenHeight * .02),
        StreamBuilder(
            stream: validation.email,
            builder: (context, snapshot) {
              return AppTextField(
                  maxLine: null,
                  prefixText: '',
                  width: SizeConfig.screenWidth / 4,
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
        SizedBox(height: SizeConfig.screenHeight * .02),
        StreamBuilder(
            stream: validation.phoneNo,
            builder: (context, snapshot) {
              return AppTextField(
                  maxLine: null,
                  prefixText: '',
                  width: SizeConfig.screenWidth / 4,
                  controller: phoneController,
                  labelText: 'Phone',
                  isShowCountryCode: true,
                  isShowPassword: false,
                  secureText: false,
                  isColor: isPhone,
                  isTick: false,
                  maxLength: 100,
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
        SizedBox(height: SizeConfig.screenHeight * .02),
        StreamBuilder(
            stream: validation.password,
            builder: (context, snapshot) {
              return AppTextField(
                  maxLine: 1,
                  width: SizeConfig.screenWidth / 4,
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
      ],
    );
  }
  registerMobileForm() {
    return Column(
      children: [
        StreamBuilder(
            stream: validation.firstName,
            builder: (context, snapshot) {
              return AppTextField(
                  width: SizeConfig.screenWidth / 1.5,
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
        SizedBox(height: SizeConfig.screenHeight * .01),
        StreamBuilder(
            stream: validation.email,
            builder: (context, snapshot) {
              return AppTextField(
                  maxLine: null,
                  prefixText: '',
                  width: SizeConfig.screenWidth / 1.5,
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
        SizedBox(height: SizeConfig.screenHeight * .01),
        StreamBuilder(
            stream: validation.phoneNo,
            builder: (context, snapshot) {
              return AppTextField(
                  maxLine: null,
                  prefixText: '',
                  width: SizeConfig.screenWidth / 1.5,
                  controller: phoneController,
                  labelText: 'Phone',
                  isShowCountryCode: true,
                  isShowPassword: false,
                  secureText: false,
                  isColor: isPhone,
                  isTick: false,
                  maxLength: 100,
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
        SizedBox(height: SizeConfig.screenHeight * .01),
        StreamBuilder(
            stream: validation.password,
            builder: (context, snapshot) {
              return AppTextField(
                  maxLine: 1,
                  width: SizeConfig.screenWidth / 1.5,
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
      ],
    );
  }
  registerButtonPressed(AuthViewModel authVM, String name, String email,
      String phone, String password) {
    authVM.register(name,phone, email, password, context);
  }
  Widget socialLoginViewMobile(SocialLoginViewModel socialVM) {
    return Container(
      width: SizeConfig.screenWidth / 1.5,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: SizeConfig.screenWidth * 0.15,
                  child: Divider(
                    color: BLACK_COLOR,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: AppMediumFont(
                    msg: StringConstant.orContinueWith,
                    color: TEXT_COLOR,
                    fontSize: 14),
              ),
              Expanded(
                child: Container(
                  width: SizeConfig.screenWidth * 0.15,
                  child: Divider(
                    color: BLACK_COLOR,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          SocialLoginView(socialLoginViewModel: socialVM)
        ],
      ),
    );
  }
  Widget socialLoginView(SocialLoginViewModel socialVM) {
    return Container(
      width: SizeConfig.screenWidth / 4,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: SizeConfig.screenWidth * 0.15,
                  child: Divider(
                    color: BLACK_COLOR,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: AppMediumFont(
                    msg: StringConstant.orContinueWith,
                    color: TEXT_COLOR,
                    fontSize: 14),
              ),
              Expanded(
                child: Container(
                  width: SizeConfig.screenWidth * 0.15,
                  child: Divider(
                    color: BLACK_COLOR,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SocialLoginView(socialLoginViewModel: socialVM)
        ],
      ),
    );
  }
}
