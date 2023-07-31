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
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/widgets/social_login_view.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/sociallogin_view_model.dart';

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

    homeViewModel.getAppConfig(context);
    super.initState();
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
            ResponsiveWidget.isMediumScreen(context)
              ? AlertDialog(
                  elevation: 8,
                  titlePadding: EdgeInsets.zero,
                     backgroundColor: Theme.of(context).cardColor.withOpacity(0.9),
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  content: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.6))),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: SizeConfig.screenHeight * .02),
                            AppBoldFont(context, msg: StringConstant.register, fontSize: 16),
                            SizedBox(height: SizeConfig.screenHeight * .02),
                            AppRegularFont(context, msg: StringConstant.letsRegister, fontSize: 14),
                            SizedBox(height: SizeConfig.screenHeight * .02),
                            registerForms(viewmodel),
                            SizedBox(
                                height: SizeConfig.screenHeight * .02),
                            StreamBuilder(
                                stream:  viewmodel.appConfigModel?.androidConfig?.loginWithPhone  == false
                                    ? validation.registerWithoutNumberUser
                                    : validation.registerUser,
                                builder: (context, snapshot) {
                                  return appButton(
                                      context,
                                      StringConstant.createAccount,
                                      SizeConfig.screenWidth * 0.8,
                                      50.0,
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
                                            phoneController.text ?? '',
                                            passwordController.text,
                                            viewmodel.appConfigModel?.androidConfig?.loginWithPhone == true? 'phone':'email', viewmodel);
                                      });
                                }),
                            SizedBox(height: SizeConfig.screenHeight * .02),
                            viewmodel.appConfigModel?.androidConfig
                                        ?.socialLogin !=
                                    null
                                ? socialLoginView(socialVM, viewmodel)
                                : Container(),
                            // SizedBox(height: SizeConfig.screenHeight * .02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppRegularFont(context,
                                    msg: StringConstant.alreadyAccount,
                                    fontSize: 14),
                                appTextButton(
                                    context,
                                    StringConstant.login,
                                    Alignment.bottomRight,
                                    Theme.of(context).primaryColor,
                                    16,
                                    true, onPressed: () {
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
                            SizedBox(height: SizeConfig.screenHeight * .02),
                          ],
                        ),
                      )))
              :


          AlertDialog(
                  elevation: 0.2,
                  actionsPadding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  content: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).cardColor.withOpacity(0.9),
                          border: Border.all(
                              width: 2,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.4))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/LoginPageLogo.png',
                              fit: BoxFit.fill,   height: SizeConfig.screenHeight / 1.45,
                              width: SizeConfig.screenWidth * 0.29,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 50, right: 50),
                              height: SizeConfig.screenHeight / 1.45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              width: SizeConfig.screenWidth * 0.25,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: SizeConfig.screenHeight * .05),
                                    AppBoldFont(context,
                                        msg: StringConstant.register,
                                        fontSize: 22),
                                    SizedBox(
                                        height: SizeConfig.screenHeight * .02),
                                    AppRegularFont(context,
                                        msg: StringConstant.letsRegister,
                                        fontSize: 18),
                                    SizedBox(
                                        height: SizeConfig.screenHeight * .02),
                                    registerForms(viewmodel),
                                    SizedBox(
                                        height: SizeConfig.screenHeight * .02),
                                    StreamBuilder(
                                        stream: viewmodel.appConfigModel?.androidConfig?.loginWithPhone == false
                                            ? validation.registerWithoutNumberUser
                                            : validation.registerUser,
                                        builder: (context, snapshot) {
                                          return appButton(
                                              context,
                                              StringConstant.createAccount,
                                              SizeConfig.screenWidth * 0.8,
                                              50.0,
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
                                                    phoneController.text ?? '',
                                                    passwordController.text,
                                                    viewmodel.appConfigModel?.androidConfig?.loginWithPhone == true? 'phone':'email', viewmodel);
                                              });
                                        }),
                                    SizedBox(
                                        height: SizeConfig.screenHeight * .02),
                                    viewmodel.appConfigModel?.androidConfig
                                                ?.socialLogin !=
                                            null
                                        ? socialLoginView(socialVM, viewmodel)
                                        : Container(),
                                    SizedBox(
                                        height: SizeConfig.screenHeight * .02),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppRegularFont(
                                          context,
                                          msg: StringConstant.alreadyAccount,
                                        ),
                                        appTextButton(
                                            context,
                                            StringConstant.login,
                                            Alignment.bottomRight,
                                            Theme.of(context).primaryColor,
                                            16,
                                            true, onPressed: () {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
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
                          ])));
        }));
  }

  // widget of register forms
  registerForms(HomeViewModel viewmodel) {
    return Column(
      children: [
        signUpAppTextField(nameController, StringConstant.name, TextInputType.text, validation.sinkFirstName, 100, validation.firstName, isName),
        SizedBox(height: 15),
        signUpAppTextField(emailController, StringConstant.email, TextInputType.emailAddress, validation.sinkEmail, 100, validation.email, isEmail),
        viewmodel.appConfigModel?.androidConfig?.loginWithPhone  == false ? SizedBox() : SizedBox(height: 15),
        viewmodel.appConfigModel?.androidConfig?.loginWithPhone == false
            ? SizedBox()
            : signUpAppTextField(phoneController, StringConstant.phone, TextInputType.number, validation.sinkPhoneNo, 10, validation.phoneNo, isPhone),
        SizedBox(height: 15),
        StreamBuilder(
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
        //signUpAppTextField(passwordController, StringConstant.password, TextInputType.visiblePassword, validation.sinkPassword, 100, validation.password, isPassword),
        const SizedBox(height: 15),
        // Container(
        //     alignment: Alignment.topLeft,
        //     child: TermsConditionAgreement(width: SizeConfig.screenWidth)),
      ],
    );
  }
  Widget signUpAppTextField(TextEditingController signUpController, String msg, var keyBoardType, var validationType, int maximumLength, var streamValidationType, bool isValidation){
    return StreamBuilder(
        stream: streamValidationType,
        builder: (context, snapshot) {
          return AppTextField(
              maxLine: null,
              prefixText: '',
              controller: signUpController,
              labelText: msg,
              isShowCountryCode: true,
              isShowPassword: false,
              secureText: false,
              isColor: isValidation,
              isTick: false,
              maxLength: maximumLength,
              errorText:
              snapshot.hasError ? snapshot.error.toString() : null,
              onChanged: (m) {
                validationType.add(m);
                isValidation = true;
                setState(() {});
              },
              keyBoardType: keyBoardType,
              onSubmitted: (m) {});
        });
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


  //
  // Widget socialLoginViewMobile(SocialLoginViewModel socialVM) {
  //   return Container(
  //     width: SizeConfig.screenWidth / 1.5,
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Expanded(
  //               child: Container(
  //                 width: SizeConfig.screenWidth * 0.15,
  //                 child: Divider(
  //                   color: BLACK_COLOR,
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(left: 10, right: 10),
  //               child: AppMediumFont(context,
  //                   msg: StringConstant.orContinueWith,
  //                   color: TEXT_COLOR,
  //                   fontSize: 14),
  //             ),
  //             Expanded(
  //               child: Container(
  //                 width: SizeConfig.screenWidth * 0.15,
  //                 child: Divider(
  //                   color: BLACK_COLOR,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 15),
  //         SocialLoginView(socialLoginViewModel: socialVM)
  //       ],
  //     ),
  //   );
  // }
  // register button pressed handle
  registerButtonPressed(
      AuthViewModel authVM,
      String name,
      String email,
      String phone,
      String password,
      String loginType,
      HomeViewModel viewModel) {
    authVM.register(
        viewModel, name, phone, email, password, loginType, context);
  }
  // registerButtonPressed(AuthViewModel authVM, String name, String email,
  //     String phone, String password, HomeViewModel viewModel) {
  //   authVM.register(viewModel,name, phone, email, password, context);
  // }
}
