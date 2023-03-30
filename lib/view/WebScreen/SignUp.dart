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
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/widgets/social_login_view.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
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
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
  }

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
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Container(
            height: SizeConfig.screenHeight/1.68,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20)
            , border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.6))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * .01),
                  AppBoldFont(
                      context,msg: StringConstant.register, fontSize: 16),
                  AppRegularFont(
                      context,msg: StringConstant.letsRegister,
                      fontSize: 14),
                  SizedBox(height: SizeConfig.screenHeight * .01),
                  registerMobileForm(),
                  SizedBox(height: SizeConfig.screenHeight * .02),
                  StreamBuilder(
                      stream: validation.registerUser,
                      builder: (context, snapshot) {
                        return appButton(
                            context,
                            'Create Account',
                            SizeConfig.screenWidth / 1.5,
                            50.0,
                            LIGHT_THEME_COLOR,
                            Theme.of(context).canvasColor,18,
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
                  viewmodel.appConfigModel?.androidConfig?.socialLogin !=
                      null
                      ? socialLoginView(socialVM, viewmodel)
                      : Container(),
                  // SizedBox(height: SizeConfig.screenHeight * .02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppRegularFont(
                          context,msg: StringConstant.alreadyAccount, fontSize: 14),
                      appTextButton(context, StringConstant.login, Alignment.bottomRight,Theme.of(context).primaryColor,
                        16, true, onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                barrierColor: Colors.black87,
                                builder: (BuildContext context) {
                                  return LoginUp();
                                });
                          }),
                    ],
                  ),
                ],
              ),
            ))):
              AlertDialog(
                  elevation: 8,
                  backgroundColor: Colors.transparent,
                  contentPadding: EdgeInsets.zero,
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  content: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).cardColor.withOpacity(0.8),
                          border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.4))),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20))),
                          height: SizeConfig.screenHeight / 1.35,
                          width: SizeConfig.screenWidth * 0.29,
                          child: Image.asset(
                            'images/LoginPageLogo.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.only(left: 50,right: 50),
                            height: SizeConfig.screenHeight / 1.35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20))),
                            width: SizeConfig.screenWidth * 0.25,
                            child: Column(
                              children: [
                                SizedBox(height: SizeConfig.screenHeight * .05),
                                AppBoldFont(
                                    context,msg:  StringConstant.register, fontSize: 22),
                                SizedBox(height: SizeConfig.screenHeight * .02),
                                AppRegularFont(context,msg: StringConstant.letsRegister, fontSize: 18),
                                registerForm(),
                                SizedBox(height: SizeConfig.screenHeight * .02),
                                StreamBuilder(
                                    stream: validation.registerUser,
                                    builder: (context, snapshot) {
                                      return appButton(
                                          context,
                                          'Create Account',
                                          SizeConfig.screenWidth / 4.2,
                                          55.0,
                                          LIGHT_THEME_COLOR,
                                          Theme.of(context).canvasColor,
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
                                viewmodel.appConfigModel?.androidConfig?.socialLogin !=
                                    null
                                    ? socialLoginView(socialVM, viewmodel)
                                    : Container(),
                                SizedBox(height: SizeConfig.screenHeight * .02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppRegularFont(
                                        context,msg: StringConstant.alreadyAccount, ),
                                    appTextButton(context,StringConstant.login, Alignment.bottomRight,
                                        Theme.of(context).primaryColor,16, true, onPressed: () {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              barrierColor: Colors.black87,
                                              builder: (BuildContext context) {
                                                return LoginUp();
                                              });
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ])));}));

  }
//---Register for website--//
  registerForm() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * .02),
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
          SizedBox(height: SizeConfig.screenHeight * .02),
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
          SizedBox(height: SizeConfig.screenHeight * .02),
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
          SizedBox(height: SizeConfig.screenHeight * .02),
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
        ],
      ),
    );
  }
  Widget socialLoginView(SocialLoginViewModel socialVM, HomeViewModel viewmodel) {
    return Container(
      width: SizeConfig.screenWidth ,
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
          SizedBox(height: 20),
          SocialLoginView(
              socialLoginViewModel: socialVM, homeViewModel: viewmodel)
        ],
      ),
    );
  }
  //--Register for mobile web--//
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
                    context,msg: StringConstant.orContinueWith,
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

  registerButtonPressed(AuthViewModel authVM, String name, String email,
      String phone, String password) {
    authVM.register(name,phone, email, password, context);
  }
}
