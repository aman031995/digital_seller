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
import 'package:TychoStream/view/WebScreen/SignUp.dart';
import 'package:TychoStream/view/WebScreen/forgot_password.dart';
import 'package:TychoStream/view/widgets/social_login_view.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/sociallogin_view_model.dart';


class LoginUp extends StatefulWidget {
bool? product;
  LoginUp({Key? key,this.product}) : super(key: key);

  @override
  State<LoginUp> createState() => _LoginUpState();
}

class _LoginUpState extends State<LoginUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final validation = ValidationBloc();
  bool isCheckCredentialPhoneOrEmail = false;
  HomeViewModel homeViewModel = HomeViewModel();

  String? fcmToken;
  bool isPhone = false,
      isEmail = false,
      isName = false,
      isPassword = false,
      isValidate = false;
  @override
  void initState() {
    homeViewModel.getAppConfigData(context);
    super.initState();
  }
  @override
  void dispose() {
    validation.closeStream();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    final socialVM = Provider.of<SocialLoginViewModel>(context);
    return ChangeNotifierProvider.value(
        value: homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          return ResponsiveWidget.isMediumScreen(context)?
    AlertDialog(
        elevation: 8,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).cardColor.withOpacity(0.9),
        content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.6)),
              color: Theme.of(context).cardColor.withOpacity(0.8),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * .02),
                  AppBoldFont(context, msg: StringConstant.login,fontSize: 18),
                  SizedBox(height: SizeConfig.screenHeight * .02),
                  AppRegularFont(context, msg:StringConstant.enterCredentials, fontSize: 16),
                  viewmodel.loginWithPhone == true
                      ? Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: StreamBuilder(
                        stream: validation.emailAndMobile,
                        builder: (context, snapshot) {
                          return AppTextField(
                            maxLine: 1,
                            controller: emailController,
                            labelText: 'email/phone',
                            textCapitalization: TextCapitalization.words,
                            isShowCountryCode: true,
                            isShowPassword: false,
                            secureText: false,
                            maxLength: 40,
                            keyBoardType: TextInputType.emailAddress,
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            onChanged: (m) {
                              validation.sinkEmailAndPhone.add(m);
                              isPhoneCheck(m) == true
                                  ? isCheckCredentialPhoneOrEmail = true
                                  : isCheckCredentialPhoneOrEmail = false;
                              setState(() {});
                            },
                            onSubmitted: (m) {},
                            isTick: null,
                          );
                        }),
                  )   : Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: StreamBuilder(
                        stream: validation.email,
                        builder: (context, snapshot) {
                          return AppTextField(
                              maxLine: null,
                              prefixText: '',
                              controller: emailController,
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
                                isPhone = true;
                                setState(() {});
                              },
                              keyBoardType: TextInputType.emailAddress,
                              onSubmitted: (m) {});
                        }),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * .02),
                  isCheckCredentialPhoneOrEmail == true
                      ? SizedBox()
                      : Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: StreamBuilder(
                        stream: validation.password,
                        builder: (context, snapshot) {
                          return AppTextField(
                              maxLine: 1,
                              controller: passwordController,
                              labelText: StringConstant.password,
                              prefixText: '',
                              isShowPassword: true,
                              isTick: true,
                              isColor: isPassword,
                              keyBoardType: TextInputType.visiblePassword,
                              errorText: snapshot.hasError
                                  ? snapshot.error.toString()
                                  : null,
                              onChanged: (m) {
                                validation.sinkPassword.add(m);
                                isPassword = true;
                                setState(() {});
                              },
                              onSubmitted: (m) {});
                        }),
                  ),
                  SizedBox(height: 35),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: StreamBuilder(
                        stream: viewmodel.loginWithPhone == false
                            ? validation.checkUserEmailLogin
                            : isCheckCredentialPhoneOrEmail == true
                            ? validation.checkEmailAndPhoneValidate
                            : validation.submitValid,
                        builder: (context, snapshot) {
                          return appButton(
                              context,
                              StringConstant.login,
                              SizeConfig.screenWidth /2.2,
                              50.0,
                              LIGHT_THEME_COLOR,
                              Theme.of(context).backgroundColor,
                              18,
                              10,
                              snapshot.data != true ? false : true,
                              onTap: () {
                                snapshot.data != true
                                    ? ToastMessage.message(StringConstant.fillOut)
                                    : emailController.text.length > 10 &&
                                    isCheckCredentialPhoneOrEmail == true
                                    ? ToastMessage.message("'mobile number cant be more than 10 digits'")
                                    : loginButtonPressed(
                                    authVM,
                                    emailController.text,
                                    passwordController.text,
                                    fcmToken ?? '',
                                    '',
                                    viewmodel.loginWithPhone == true &&
                                        isCheckCredentialPhoneOrEmail == true
                                        ? 'phone'
                                        : 'email',
                                    viewmodel,
                                    isCheckCredentialPhoneOrEmail);
                              });
                        }),
                  ),
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
                            return  ForgotPassword(viewModel: viewmodel,);
                          });
                    }),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * .03),
                  SizedBox(height: SizeConfig.screenHeight * .03),
                  viewmodel.appConfigModel?.androidConfig?.socialLogin != null
                      ? socialLoginView(socialVM,viewmodel) : Container(),
                  SizedBox(height: SizeConfig.screenHeight * .03),
                  SizedBox(height: SizeConfig.screenHeight * .02),
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
                  SizedBox(height: SizeConfig.screenHeight * .02),
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
                color: Theme.of(context).cardColor),
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
                      viewmodel.loginWithPhone == true
                          ? Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: StreamBuilder(
                            stream: validation.emailAndMobile,
                            builder: (context, snapshot) {
                              return AppTextField(
                                maxLine: 1,
                                controller: emailController,
                                labelText: 'email/phone',
                                textCapitalization: TextCapitalization.words,
                                isShowCountryCode: true,
                                isShowPassword: false,
                                secureText: false,
                                maxLength: 40,
                                keyBoardType: TextInputType.emailAddress,
                                errorText: snapshot.hasError
                                    ? snapshot.error.toString()
                                    : null,
                                onChanged: (m) {
                                  validation.sinkEmailAndPhone.add(m);
                                  isPhoneCheck(m) == true
                                      ? isCheckCredentialPhoneOrEmail = true
                                      : isCheckCredentialPhoneOrEmail = false;
                                  setState(() {});
                                },
                                onSubmitted: (m) {},
                                isTick: null,
                              );
                            }),
                      )
                          : Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: StreamBuilder(
                            stream: validation.email,
                            builder: (context, snapshot) {
                              return AppTextField(
                                  maxLine: null,
                                  prefixText: '',
                                  controller: emailController,
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
                                    isPhone = true;
                                    setState(() {});
                                  },
                                  keyBoardType: TextInputType.emailAddress,
                                  onSubmitted: (m) {});
                            }),
                      ),
                      SizedBox(height: 15),
                      isCheckCredentialPhoneOrEmail == true
                          ? SizedBox()
                          : Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: StreamBuilder(
                            stream: validation.password,
                            builder: (context, snapshot) {
                              return AppTextField(
                                  maxLine: 1,
                                  controller: passwordController,
                                  labelText: StringConstant.password,
                                  prefixText: '',
                                  isShowPassword: true,
                                  isTick: true,
                                  isColor: isPassword,
                                  keyBoardType: TextInputType.visiblePassword,
                                  errorText: snapshot.hasError
                                      ? snapshot.error.toString()
                                      : null,
                                  onChanged: (m) {
                                    validation.sinkPassword.add(m);
                                    isPassword = true;
                                    setState(() {});
                                  },
                                  onSubmitted: (m) {});
                            }),
                      ),
                      SizedBox(height: 35),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: StreamBuilder(
                            stream: viewmodel.loginWithPhone == false
                                ? validation.checkUserEmailLogin
                                : isCheckCredentialPhoneOrEmail == true
                                ? validation.checkEmailAndPhoneValidate
                                : validation.submitValid,
                            builder: (context, snapshot) {
                              return appButton(
                                  context,
                                  StringConstant.login,
                                  SizeConfig.screenWidth * 0.8,
                                  50.0,
                                  LIGHT_THEME_COLOR,
                                  Theme.of(context).backgroundColor,
                                  18,
                                  10,
                                  snapshot.data != true ? false : true,
                                  onTap: () {
                                    snapshot.data != true
                                        ? ToastMessage.message(StringConstant.fillOut)
                                        : emailController.text.length > 10 &&
                                        isCheckCredentialPhoneOrEmail == true
                                        ? ToastMessage.message("'mobile number cant be more than 10 digits'")
                                        : loginButtonPressed(
                                        authVM,
                                        emailController.text,
                                        passwordController.text,
                                        fcmToken ?? '',
                                        '',
                                        viewmodel.loginWithPhone == true &&
                                            isCheckCredentialPhoneOrEmail == true
                                            ? 'phone'
                                            : 'email',
                                        viewmodel,
                                        isCheckCredentialPhoneOrEmail);
                                  });
                            }),
                      ),
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
                                return  ForgotPassword(viewModel:viewmodel,product: widget.product);
                              });
                        }),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * .03),
                      SizedBox(height: SizeConfig.screenHeight * .03),
                      viewmodel.appConfigModel?.androidConfig?.socialLogin != null
                          ? socialLoginView(socialVM,viewmodel) : Container(),
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
        }));}

  // regex to check whether enter detail is phoneNumber or email
  bool isPhoneCheck(String phoneNo) {
    String value = r'(^[0-9]*$)';
    RegExp regExp = RegExp(value);
    return regExp.hasMatch(phoneNo) ? true : false;
  }
  Widget socialLoginView(
      SocialLoginViewModel socialVM, HomeViewModel viewmodel) {
    return Container(
      width: SizeConfig.screenWidth,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: SizeConfig.screenWidth * 0.05,
                child: Divider(color: Theme.of(context).canvasColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: AppMediumFont(context,
                    msg: StringConstant.orContinueWith, fontSize: 14),
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.05,
                child: Divider(color: Theme.of(context).canvasColor),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * .02),
          SocialLoginView(
              socialLoginViewModel: socialVM, homeViewModel: viewmodel)
        ],
      ),
    );
  }
  loginButtonPressed(
      AuthViewModel authVM,
      String phone,
      String password,
      String firebaseId,
      String deviceID,
      String loginType,
      HomeViewModel viewmodel,
      bool checkPhoneEmailValid) {
    authVM.login(phone, password, deviceID, " ", loginType, widget.product,viewmodel,
        checkPhoneEmailValid, context);
  }
}
