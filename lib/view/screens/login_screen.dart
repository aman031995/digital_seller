import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/bloc_validation/Bloc_Validation.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/screens/forgot_password.dart';
import 'package:tycho_streams/view/screens/register_screen.dart';
import 'package:tycho_streams/view/widgets/social_login_view.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';
import 'package:tycho_streams/viewmodel/sociallogin_view_model.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final validation = ValidationBloc();
  bool isPhone = false, isPassword = false, isValidate = false;

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
    return Scaffold(
      bottomNavigationBar: Container(
        height: 40,
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppRegularFont(
                msg: "Don't have an account?", color: TEXT_BLACK_COLOR),
            appTextButton(context, 'Create', Alignment.bottomCenter,
                THEME_COLOR, 16, true, onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  // Navigator.pushNamedAndRemoveUntil(context, RoutesName.register, (route) => false);
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
                 // GoRouter.of(context).pushNamed(RoutesName.register);
                }),
          ],
        ),
      ),
      backgroundColor: LIGHT_THEME_BACKGROUND,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 35),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.topLeft,
                  child: AppBoldFont(
                      msg: 'Login', color: BLACK_COLOR, fontSize: 30)),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.topLeft,
                  child: AppRegularFont(
                      msg: 'Enter your credential to login.',
                      color: BLACK_COLOR,
                      fontSize: 18)),
              SizedBox(height: 55),
              StreamBuilder(
                  stream: validation.phoneNo,
                  builder: (context, snapshot) {
                    return AppTextField(
                        maxLine: null,
                        prefixText: '',
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
              // SizedBox(height: 15),
              Container(
                margin: EdgeInsets.only(left: 10, right: 15),
                child: appTextButton(
                    context,
                    'Forgot Password',
                    Alignment.bottomRight,
                    TEXT_BLACK_COLOR,
                    16,
                    true, onPressed: () {
                 // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPassword()));
                  GoRouter.of(context).pushNamed(RoutesName.forgot);
                }),
              ),
              SizedBox(height: 20),
              StreamBuilder(
                  stream: validation.checkUserLogin,
                  builder: (context, snapshot) {
                    return appButton(
                        context,
                        'Login',
                        SizeConfig.screenWidth * 0.9,
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
              SizedBox(height: 30),
              socialLoginView(socialVM),
            ],
          ),
        ),
      ),
    );
  }

  loginButtonPressed(AuthViewModel authVM, String phone, String password) {
    authVM.login(phone, password, context);
    // Navigator.pushNamed(context, RoutesName.verifyOtp);
  }

  Widget socialLoginView(SocialLoginViewModel socialVM) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.15,
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
                width: SizeConfig.screenWidth * 0.15,
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
}