import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/services/global_variable.dart';
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
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
import 'package:TychoStream/view/widgets/social_login_view.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/sociallogin_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

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


  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    final socialVM = Provider.of<SocialLoginViewModel>(context);
    return ChangeNotifierProvider<HomeViewModel>(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          return viewmodel.appConfigModel?.androidConfig!=null?
            AlertDialog(
                  elevation: 10,
                  titlePadding: EdgeInsets.zero,
                insetPadding: EdgeInsets.all(ResponsiveWidget.isSmallScreen(context) ?10:130),
                actionsPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                backgroundColor:Theme.of(context).cardColor,
                content: Container(
                    margin: EdgeInsets.only(left:ResponsiveWidget.isMediumScreen(context)?15: 50, right:ResponsiveWidget.isMediumScreen(context)?15: 50,top:ResponsiveWidget.isMediumScreen(context)?10: 20),
                  //  height: SizeConfig.screenHeight / 1.45,
                    width: ResponsiveWidget.isMediumScreen(context)?SizeConfig.screenWidth:SizeConfig.screenWidth * 0.25,
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
                          SizedBox(height:ResponsiveWidget.isMediumScreen(context)?ResponsiveWidget.isSmallScreen(context) ?5:15: 10),

                          SizedBox(height:ResponsiveWidget.isMediumScreen(context)?5: 15),
                          AppBoldFont(context, msg: StringConstant.register, fontSize:ResponsiveWidget.isMediumScreen(context)?22: 30),
                          SizedBox(height: 10),
                          AppMediumFont(context, msg:StringConstant.letsRegister, fontSize: 16),
                          SizedBox(height: ResponsiveWidget.isMediumScreen(context)?15:20),
                          registerForms(viewmodel),
                          SizedBox(height: 10),
                          StreamBuilder(
                              stream: viewmodel.appConfigModel?.androidConfig?.loginWithPhone == false
                                  ? validation.registerWithoutNumberUser
                                  : validation.registerUser,
                              builder: (context, snapshot) {
                                return appButton(
                                    context,
                                    StringConstant.createAccount,
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
                                          : registerButtonPressed(
                                          authVM,
                                          nameController.text,
                                          emailController.text,
                                          phoneController.text ?? '',
                                          passwordController.text,
                                          viewmodel.appConfigModel?.androidConfig?.loginWithPhone == true? 'phone':'email', viewmodel);
                                    });
                              }),
                          SizedBox(height:ResponsiveWidget.isMediumScreen(context)?5: 10),
                          viewmodel.appConfigModel?.androidConfig?.socialLogin != null ? socialLoginView(socialVM, viewmodel) : Container(),
                          SizedBox(
                              height:ResponsiveWidget.isMediumScreen(context)?5: 10),
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
                                  ResponsiveWidget.isMediumScreen(context)?14:16,
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
                          SizedBox(height: ResponsiveWidget.isMediumScreen(context)?20:30),
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
                            )   ),
                          SizedBox(height:ResponsiveWidget.isMediumScreen(context)?ResponsiveWidget.isSmallScreen(context) ?5:15: 10),

                        ],
                      ),
                    ),
                  )):
          Center(child: ThreeArchedCircle(size: 45.0));
        }));
  }

  // widget of register forms
  registerForms(HomeViewModel viewmodel) {
    return Column(
      children: [
        signUpAppTextField(nameController, StringConstant.name, TextInputType.text, validation.sinkFirstName, 50, validation.firstName, isName),
        SizedBox(height: 15),
        signUpAppTextField(emailController, StringConstant.email, TextInputType.emailAddress, validation.sinkEmail, 50, validation.email, isEmail),
        viewmodel.appConfigModel?.androidConfig?.loginWithPhone  == false ? SizedBox() : SizedBox(height: 15),
        viewmodel.appConfigModel?.androidConfig?.loginWithPhone == false ? SizedBox()
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
        SizedBox(height: 15),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

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
}
