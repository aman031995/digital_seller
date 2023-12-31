import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/AssetsConstants.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
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
import 'package:TychoStream/view/WebScreen/authentication/SignUp.dart';
import 'package:TychoStream/view/WebScreen/authentication/forgot_password.dart';
import 'package:TychoStream/view/widgets/social_login_view.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/sociallogin_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

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
  //  getFCMToken();
    homeViewModel.getAppConfig(context);
    super.initState();
  }

  // Future<void> getFCMToken() async {
  //   try {
  //      fcmToken = await FirebaseMessaging.instance.getToken();
  //     print('FCM Token: $fcmToken');
  //   } catch (e) {
  //     print('Error getting FCM token: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    final socialVM = Provider.of<SocialLoginViewModel>(context);
    return ChangeNotifierProvider.value(
        value: homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          return  viewmodel.appConfigModel?.androidConfig!=null?

         AlertDialog(
        elevation: 10,
        actionsPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
             insetPadding: EdgeInsets.all(10),
             backgroundColor:Theme.of(context).cardColor,
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
                SizedBox(height:ResponsiveWidget.isMediumScreen(context)?ResponsiveWidget.isSmallScreen(context) ?5:15: 25),
                AppBoldFont(context, msg: StringConstant.login, fontSize:ResponsiveWidget.isMediumScreen(context)?22: 30),
                SizedBox(height: 10),
                AppMediumFont(context, msg:StringConstant.enterCredentials, fontSize: 16),
                SizedBox(height: 20),
                viewmodel.appConfigModel?.androidConfig?.loginWithPhone == true
                    ? StreamBuilder(
                        stream: validation.emailAndMobile,
                        builder: (context, snapshot) {
                          return AppTextField(
                            maxLine: 1,
                            controller: emailController,
                            labelText: StringConstant.emailAndPhone,
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
                        })
                    : StreamBuilder(
                        stream: validation.email,
                        builder: (context, snapshot) {
                          return AppTextField(
                              maxLine: null,prefixText: '',
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
                SizedBox(height:ResponsiveWidget.isMediumScreen(context)?10: 15),
                isCheckCredentialPhoneOrEmail == true
                    ? SizedBox()
                    : StreamBuilder(
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
                Container(
                  margin: const EdgeInsets.only(left: 0, top: 5),
                  child: appTextButton(
                      context,
                      StringConstant.forgotPass,
                      Alignment.centerRight,
                      Theme.of(context).canvasColor, 14,
                      true, onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ForgotPassword(viewModel : viewmodel, product: widget.product);
                        });
                  }),
                ),
                SizedBox(height: 5),
                StreamBuilder(
                    stream:  viewmodel.appConfigModel?.androidConfig?.loginWithPhone == false
                        ? validation.checkUserEmailLogin
                        : isCheckCredentialPhoneOrEmail == true
                        ? validation.checkEmailAndPhoneValidate
                        : validation.submitValid,
                    builder: (context, snapshot) {
                      return appButton(
                          context,
                          StringConstant.login,
                          SizeConfig.screenWidth,
                          50.0,
                          Theme.of(context).primaryColor,
                          Theme.of(context).hintColor,
                          18,
                          10,
                          snapshot.data != true ? false : true,
                          onTap: () {
                            snapshot.data != true
                                ? ToastMessage.message(StringConstant.fillOut,context)
                                : emailController.text.length > 10 &&
                                isCheckCredentialPhoneOrEmail == true
                                ? ToastMessage.message(StringConstant.mobileNumberLimit,context)
                                : loginButtonPressed(
                                authVM,
                                emailController.text,
                                passwordController.text,
                                fcmToken ?? '',
                                '',
                                viewmodel.appConfigModel?.androidConfig?.loginWithPhone == true &&
                                    isCheckCredentialPhoneOrEmail == true
                                    ? 'phone'
                                    : 'email',
                                viewmodel,
                                isCheckCredentialPhoneOrEmail);
                          });
                    }),
                SizedBox(height:ResponsiveWidget.isMediumScreen(context)?5: 10),
                viewmodel.appConfigModel?.androidConfig?.socialLogin != null
                    ? socialLoginView(socialVM,viewmodel) : Container(),
                SizedBox(height:ResponsiveWidget.isMediumScreen(context)?5: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppRegularFont(context, msg: StringConstant.dontHaveAccount),
                    appTextButton(
                        context, StringConstant.create, Alignment.bottomRight,
                        Theme.of(context).primaryColor, ResponsiveWidget.isMediumScreen(context)?14:16, true, onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const SignUp();
                          });
                    }),
                  ],
                ),
                SizedBox(height:ResponsiveWidget.isMediumScreen(context)?20: 30),
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
                SizedBox(height:ResponsiveWidget.isMediumScreen(context)?ResponsiveWidget.isSmallScreen(context) ?5:15: 20),
              ],
            ),
          ),
        )):
          Center(child: ThreeArchedCircle(size: 45.0));
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
