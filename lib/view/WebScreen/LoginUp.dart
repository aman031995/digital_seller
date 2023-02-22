import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/bloc_validation/Bloc_Validation.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/network/CacheDataManager.dart';
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
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/screens/forgot_password.dart';
import 'package:tycho_streams/view/widgets/social_login_view.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';
import 'package:tycho_streams/viewmodel/sociallogin_view_model.dart';

class LoginUp extends StatefulWidget {
  const LoginUp({Key? key}) : super(key: key);

  @override
  State<LoginUp> createState() => _LoginUpState();
}

class _LoginUpState extends State<LoginUp> {
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
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        content: Container(
          height: 450,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white
          ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * .02),
                  AppBoldFont(msg: 'Login', color: BLACK_COLOR, fontSize: 18),
                  SizedBox(height: SizeConfig.screenHeight * .02),
                  registerMobileForm(),
                  SizedBox(height: SizeConfig.screenHeight * .01),
                  Container(
                    margin: EdgeInsets.only(left: 0, right: 15),
                    child: appTextButton(
                        context,
                        StringConstant.forgotPass,
                        Alignment.centerRight,
                        TEXT_BLACK_COLOR,
                        16,
                        true, onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierColor: Colors.black87,
                          builder: (BuildContext context) {
                            return ForgotPassword();
                          });
                      // Navigator.pushNamed(context, RoutesName.forgot);
                      //Navigator.of(context).push(MaterialPageRoute(builder: (_) => ForgotPassword()));
                    }),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * .02),
                  StreamBuilder(
                      stream: validation.checkUserLogin,
                      builder: (context, snapshot) {
                        return appButton(
                            context,
                            'Login',
                            SizeConfig.screenWidth / 1.5,
                            60.0,
                            LIGHT_THEME_COLOR,
                            WHITE_COLOR,
                            18,
                            10,
                            snapshot.data != true ? false : true, onTap: () {
                          snapshot.data != true
                              ? ToastMessage.message(StringConstant.fillOut)
                              : loginButtonPressed(authVM, phoneController.text,
                              passwordController.text);
                        });
                      }),
                  SizedBox(height: SizeConfig.screenHeight * .01),
                   socialLoginViewMobile(socialVM),
                   SizedBox(height: SizeConfig.screenHeight * .01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppRegularFont(
                          msg: 'Already have an account?', color: TEXT_COLOR,fontSize: 16),
                      appTextButton(context, 'Create', Alignment.bottomRight,
                          Colors.redAccent, 14, true, onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                barrierColor: Colors.black87,
                                builder: (BuildContext context) {
                                  return SignUp();
                                });
                          }),
                    ],
                  ),
                ],
              ),
            ))):AlertDialog(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        content: Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            height: SizeConfig.screenHeight / 1.3,
            width: SizeConfig.screenWidth * 0.29,
            child: Image.asset(
              'images/LoginPageLogo.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: SizeConfig.screenHeight / 1.3,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            width: SizeConfig.screenWidth * 0.36,
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * .05),
                AppBoldFont(msg: 'Login', color: BLACK_COLOR, fontSize: 30),
                SizedBox(height: SizeConfig.screenHeight * .02),
                AppRegularFont(
                    msg: "Enter your credentials to continue with us.",
                    color: Colors.black,
                    fontSize: 18),
                registerForm(),
                Container(
                  margin: EdgeInsets.only(left: 0, right: 100),
                  child: appTextButton(
                      context,
                      StringConstant.forgotPass,
                      Alignment.centerRight,
                      TEXT_BLACK_COLOR,
                      16,
                      true, onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierColor: Colors.black87,
                        builder: (BuildContext context) {
                          return ForgotPassword();
                        });
                    // Navigator.pushNamed(context, RoutesName.forgot);
                    //Navigator.of(context).push(MaterialPageRoute(builder: (_) => ForgotPassword()));
                  }),
                ),
                SizedBox(height: SizeConfig.screenHeight * .03),
                StreamBuilder(
                    stream: validation.checkUserLogin,
                    builder: (context, snapshot) {
                      return appButton(
                          context,
                          'Login',
                          SizeConfig.screenWidth / 4,
                          60.0,
                          LIGHT_THEME_COLOR,
                          WHITE_COLOR,
                          18,
                          10,
                          snapshot.data != true ? false : true, onTap: () {
                        snapshot.data != true
                            ? ToastMessage.message(StringConstant.fillOut)
                            : loginButtonPressed(authVM, phoneController.text,
                                passwordController.text);
                      });
                    }),
                SizedBox(height: SizeConfig.screenHeight * .03),
                socialLoginView(socialVM),
                SizedBox(height: SizeConfig.screenHeight * .03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppRegularFont(
                        msg: 'Already have an account?', color: TEXT_COLOR),
                    appTextButton(context, 'Create', Alignment.bottomRight,
                        Colors.redAccent, 16, true, onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierColor: Colors.black87,
                          builder: (BuildContext context) {
                            return SignUp();
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
        SizedBox(height: SizeConfig.screenHeight * .03),
        StreamBuilder(
            stream: validation.phoneNo,
            builder: (context, snapshot) {
              return AppTextField(
                  maxLine: null,
                  prefixText: '',
                  width: SizeConfig.screenWidth / 4,
                  controller: phoneController,
                  labelText: 'Phone Number',
                  isShowCountryCode: true,
                  isShowPassword: false,
                  secureText: false,
                  isColor: false,
                  isTick: false,
                  maxLength: 10,
                  errorText:
                      snapshot.hasError ? snapshot.error.toString() : null,
                  onChanged: (m) {
                    validation.sinkPhoneNo.add(m);
                    isPhone = true;
                    setState(() {});
                  },
                  keyBoardType: TextInputType.phone,
                  onSubmitted: (m) {});
            }),
        SizedBox(height: SizeConfig.screenHeight * .03),
        StreamBuilder(
            stream: validation.password,
            builder: (context, snapshot) {
              return AppTextField(
                  maxLine: 1,
                  controller: passwordController,
                  labelText: 'Password',
                  prefixText: '',
                  width: SizeConfig.screenWidth / 4,
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
            stream: validation.phoneNo,
            builder: (context, snapshot) {
              return AppTextField(
                  maxLine: null,
                  prefixText: '',
                  width: SizeConfig.screenWidth / 1.5,
                  controller: phoneController,
                  labelText: 'Phone Number',
                  isShowCountryCode: true,
                  isShowPassword: false,
                  secureText: false,
                  isColor: false,
                  isTick: false,
                  maxLength: 10,
                  errorText:
                  snapshot.hasError ? snapshot.error.toString() : null,
                  onChanged: (m) {
                    validation.sinkPhoneNo.add(m);
                    isPhone = true;
                    setState(() {});
                  },
                  keyBoardType: TextInputType.phone,
                  onSubmitted: (m) {});
            }),
        SizedBox(height: SizeConfig.screenHeight * .01),
        StreamBuilder(
            stream: validation.password,
            builder: (context, snapshot) {
              return AppTextField(
                  maxLine: 1,
                  controller: passwordController,
                  labelText: 'Password',
                  prefixText: '',
                  width: SizeConfig.screenWidth / 1.5,
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
  loginButtonPressed(AuthViewModel authVM, String phone, String password) {
    authVM.login(phone, password, context);
  }

  Widget socialLoginViewMobile(SocialLoginViewModel socialVM) {
    return Container(
      width: SizeConfig.screenWidth / 1.5,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.13,
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
                width: SizeConfig.screenWidth * 0.13,
                child: Divider(
                  color: BLACK_COLOR,
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
  Widget socialLoginView(SocialLoginViewModel socialVM) {
    return Container(
      width: SizeConfig.screenWidth / 4,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.09,
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
              Expanded(
                child: Container(
                  width: SizeConfig.screenWidth * 0.09,
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
