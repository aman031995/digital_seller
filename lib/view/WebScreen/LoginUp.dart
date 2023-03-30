import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/bloc_validation/Bloc_Validation.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/WebScreen/forgot_password.dart';
import 'package:tycho_streams/view/widgets/social_login_view.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';
import 'package:tycho_streams/viewmodel/sociallogin_view_model.dart';

class LoginUp extends StatefulWidget {
  const LoginUp({Key? key}) : super(key: key);

  @override
  State<LoginUp> createState() => _LoginUpState();
}

class _LoginUpState extends State<LoginUp> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final validation = ValidationBloc();
  HomeViewModel homeViewModel = HomeViewModel();
  bool isPhone = false,
      isEmail = false,
      isName = false,
      isPassword = false,
      isValidate = false;
  @override
  void initState() {
    super.initState();
    homeViewModel.getAppConfigData(context);
  }
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    final socialVM = Provider.of<SocialLoginViewModel>(context);
      return ChangeNotifierProvider<HomeViewModel>(
          create: (BuildContext context) => homeViewModel,
          child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
            return
              ResponsiveWidget.isMediumScreen(context)?
              AlertDialog(
                elevation: 8,
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Theme.of(context).cardColor,
                content: Container(
                    height: 380,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.4)),
                      color: Theme.of(context).cardColor.withOpacity(0.8),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.screenHeight * .02),
                          AppBoldFont(context, msg: 'Login',
                              fontSize: 18),
                          SizedBox(height: SizeConfig.screenHeight * .01),
                          AppRegularFont(
                              context, msg:StringConstant.enterCredentials,
                              fontSize: 16),
                          SizedBox(height: SizeConfig.screenHeight * .02),
                          registerMobileForm(),
                          SizedBox(height: SizeConfig.screenHeight * .01),
                          Container(
                            margin: const EdgeInsets.only(left: 0, right: 10),
                            child: appTextButton(
                                context,
                                StringConstant.forgotPass,
                                Alignment.centerRight,
                                Theme.of(context).canvasColor, 16,
                                true, onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const ForgotPassword();
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
                                    50.0,
                                    LIGHT_THEME_COLOR,
                                    Theme
                                        .of(context)
                                        .canvasColor,
                                    18,
                                    10,
                                    snapshot.data != true ? false : true,
                                    onTap: () {
                                      snapshot.data != true
                                          ? ToastMessage.message(
                                          StringConstant.fillOut)
                                          : loginButtonPressed(
                                          authVM, phoneController.text,
                                          passwordController.text);
                                    });
                              }),
                          SizedBox(height: SizeConfig.screenHeight * .02),
                          socialLoginViewMobile(socialVM),
                          SizedBox(height: SizeConfig.screenHeight * .01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppRegularFont(
                                  context, msg: StringConstant.dontHaveAccount,
                                  fontSize: 16),
                              appTextButton(context, 'Create',
                                  Alignment.bottomRight,
                                  Theme.of(context).primaryColor, 14, true, onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        barrierColor: Colors.black87,
                                        builder: (BuildContext context) {
                                          return const SignUp();
                                        });
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ))):
              AlertDialog(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Colors.transparent,
                  content: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.4)),
                          color: Theme.of(context).cardColor.withOpacity(0.8)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20))),
                          height: SizeConfig.screenHeight / 1.35,
                          width: SizeConfig.screenWidth * 0.29,
                          child: Image.asset(
                            'images/LoginPageLogo.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SingleChildScrollView(
                          child: Container(
                            margin:  EdgeInsets.only(left: 50, right: 50),
                            height: SizeConfig.screenHeight / 1.35,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                            width: SizeConfig.screenWidth * 0.25,
                            child: Column(
                              children: [
                                SizedBox(height: SizeConfig.screenHeight * .05),
                                AppBoldFont(context, msg: 'Login',
                                    fontSize: 22),
                                SizedBox(height: SizeConfig.screenHeight * .02),
                                AppRegularFont(
                                    context, msg:StringConstant.enterCredentials,
                                    fontSize: 18),
                                registerForm(),
                                Container(
                                  margin: const EdgeInsets.only(left: 0, right: 8),
                                  child: appTextButton(
                                      context,
                                      StringConstant.forgotPass,
                                      Alignment.centerRight,
                                      Theme.of(context).canvasColor, 16,
                                      true, onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const ForgotPassword();
                                        });
                                  }),
                                ),
                                SizedBox(height: SizeConfig.screenHeight * .03),
                                StreamBuilder(
                                    stream: validation.checkUserLogin,
                                    builder: (context, snapshot) {
                                      return appButton(
                                          context,
                                          'Login',
                                          SizeConfig.screenWidth / 4.2,
                                          55.0,
                                          LIGHT_THEME_COLOR,
                                          Theme.of(context).canvasColor,
                                          18,
                                          10,
                                          snapshot.data != true ? false : true,
                                          onTap: () {
                                            snapshot.data != true
                                                ? ToastMessage.message(
                                                StringConstant.fillOut)
                                                : loginButtonPressed(
                                                authVM, phoneController.text,
                                                passwordController.text);
                                          });
                                    }),
                                SizedBox(height: SizeConfig.screenHeight * .03),
                                viewmodel.appConfigModel?.androidConfig?.socialLogin != null ? socialLoginView(socialVM, viewmodel) : Container(),
                                SizedBox(height: SizeConfig.screenHeight * .03),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppRegularFont(context, msg: StringConstant.dontHaveAccount),
                                    appTextButton(
                                        context, 'Create', Alignment.bottomRight,
                                        Theme.of(context).primaryColor, 16, true, onPressed: () {
                                      Navigator.pop(context);
                                      showDialog(
                                          context: context,
                                          barrierColor: Colors.black87,
                                          builder: (BuildContext context) {
                                            return const SignUp();
                                          });
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ])));
          }));
  }

//---Mobileweb--//
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
  Widget socialLoginViewMobile(SocialLoginViewModel socialVM) {
    return SizedBox(
      width: SizeConfig.screenWidth / 1.5,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: SizeConfig.screenWidth * 0.08,
                child:  Divider(
                    color: Theme.of(context).canvasColor
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: AppMediumFont(
                    context,msg: StringConstant.orContinueWith,
                    fontSize: 14),
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.08,
                child: Divider(
                  color: Theme.of(context).canvasColor
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SocialLoginView(socialLoginViewModel: socialVM)
        ],
      ),
    );
  }

//--Website--///
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
        SizedBox(height: 15),
      ],
    );
  }
  Widget socialLoginView(SocialLoginViewModel socialVM,HomeViewModel viewmodel) {
    return SizedBox(
      width: SizeConfig.screenWidth / 4,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: SizeConfig.screenWidth * 0.05,
                child: Divider(
                  color: Theme.of(context).canvasColor
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: AppMediumFont(
                    context,msg: StringConstant.orContinueWith,
                    fontSize: 14),
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.05,
                child:  Divider(
                    color: Theme.of(context).canvasColor
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SocialLoginView(socialLoginViewModel: socialVM, homeViewModel: homeViewModel)

        ],
      ),
    );
  }
  loginButtonPressed(AuthViewModel authVM, String phone, String password) {
    authVM.login(phone, password, context);
  }
}
