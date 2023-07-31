import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TychoStream/Utilities/AssetsConstants.dart';
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
import 'package:TychoStream/viewmodel/auth_view_model.dart';

class ForgotPassword extends StatefulWidget {
  HomeViewModel? viewModel;
  bool? product;
 ForgotPassword({Key? key,this.viewModel,this.product}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String errorPhoneNumber = "";
  final validation = ValidationBloc();
  bool isPhone = false, isPhoneType = false, isValidate = false;
  int? type;

  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  void dispose() {
    validation.closeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    return AlertDialog(
        elevation: 8,
        titlePadding: EdgeInsets.zero,
        backgroundColor: Theme.of(context).cardColor,
        contentPadding: EdgeInsets.zero,
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content:  forgotPasswordSection(authVM));
  }

  Widget forgotPasswordSection(AuthViewModel authVM) {
    return
      ResponsiveWidget.isMediumScreen(context)? Stack(
        children: [
          Container(
              padding: EdgeInsets.only(top: 10, bottom: 30),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.8)),
                  borderRadius: BorderRadius.circular(20)
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    AppBoldFont(
                      textAlign: TextAlign.center,
                      context,msg: StringConstant.forgotPassword,
                      fontSize: 18 ,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding:EdgeInsets.only(left: 25,right: 15),
                      child: AppMediumFont(
                          context,msg: widget.viewModel?.appConfigModel?.androidConfig
                          ?.loginWithPhone == false
                          ? "Please check your email we will send you a verification code."
                          : StringConstant.enterOtpText,
                          fontSize: 14 ,
                          textAlign: TextAlign.left),
                    ),
                    const SizedBox(height: 35),
                    Container(
                      width: ResponsiveWidget.isMediumScreen(context)
                          ?500:400,
                      child: widget.viewModel?.appConfigModel?.androidConfig
                          ?.loginWithPhone == false
                          ? StreamBuilder(
                          stream: validation.email,
                          builder: (context, snapshot) {
                            return AppTextField(
                              maxLine: 1,
                              controller: emailController,
                              labelText: StringConstant.email,
                              textCapitalization: TextCapitalization.words,
                              isShowCountryCode: true,
                              isShowPassword: false,
                              secureText: false,
                              maxLength: 30,
                              keyBoardType: TextInputType.emailAddress,
                              errorText: snapshot.hasError
                                  ? snapshot.error.toString()
                                  : null,
                              onChanged: (m) {
                                validation.sinkEmail.add(m);
                                setState(() {});
                              },
                              onSubmitted: (m) {},
                              isTick: null,
                            );
                          })
                          : StreamBuilder(
                          stream: validation.emailAndMobile,
                          builder: (context, snapshot) {
                            return AppTextField(
                                maxLine: null,
                                prefixText: '',
                                controller: phoneController,
                                labelText: "Email/Phone",
                                isShowCountryCode: true,
                                isShowPassword: false,
                                secureText: false,
                                isColor: isPhone,
                                isTick: false,
                                maxLength: 40,
                                errorText: snapshot.hasError
                                    ? snapshot.error.toString()
                                    : null,
                                onChanged: (m) {
                                  validation.sinkEmailAndPhone.add(m);
                                  isPhone = true;
                                  setState(() {});
                                },
                                keyBoardType: TextInputType.emailAddress,
                                onSubmitted: (m) {});
                          }),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      alignment: Alignment.center,
                      child: StreamBuilder(
                          stream: widget.viewModel?.appConfigModel?.androidConfig?.loginWithPhone == false
                              ? validation.checkEmailValidate
                              : validation.checkEmailAndPhoneValidate,
                          builder: (context, snapshot) {
                            return appButton(
                                context,
                                StringConstant.send,
                                SizeConfig.screenWidth /2.2,
                                50,
                                LIGHT_THEME_COLOR,
                                BUTTON_TEXT_COLOR,
                                16,
                                10,
                                snapshot.data != true ? false : true, onTap: () {
                              snapshot.data != true
                                  ? ToastMessage.message(StringConstant.fillOut)
                                  : sendButtonPressed(
                                  authVM,
                                  widget.viewModel?.appConfigModel?.androidConfig
                                      ?.loginWithPhone == false
                                      ? emailController.text
                                      : phoneController.text,
                                  widget.viewModel!);
                            });
                          }),
                    ),
                  ],
                ),
              )),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).cardColor,
              ),
              margin: EdgeInsets.all(15),
              child: IconButton(onPressed: (){
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LoginUp();
                    });
              }, icon: Image.asset(AssetsConstants.icBack, color: Theme.of(context).canvasColor,),))
        ],
      ) :
      Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.4)),
              color: Theme.of(context).cardColor),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20))),
                      height: SizeConfig.screenHeight / 1.45,
                      width: SizeConfig.screenWidth * 0.29,
                      child: Image.asset(
                        'images/LoginPageLogo.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).cardColor,
                        ),
                        margin: EdgeInsets.all(15),
                        child: IconButton(onPressed: (){
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return LoginUp();
                              });
                        }, icon: Image.asset(AssetsConstants.icBack, color: Theme.of(context).canvasColor,),))
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      AppBoldFont(
                        textAlign: TextAlign.center,
                        context,msg: StringConstant.forgotPassword,
                        fontSize: ResponsiveWidget.isMediumScreen(context)
                            ? 18 :22,
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding:EdgeInsets.only(left: 25,right: 15),
                        child: AppMediumFont(
                            context,msg: widget.viewModel?.appConfigModel?.androidConfig
                            ?.loginWithPhone == false
                            ? "Please check your email we will send you a verification code."
                            : StringConstant.enterOtpText,
                            fontSize: 16,
                            textAlign: TextAlign.left),
                      ),
                      const SizedBox(height: 35),
                      Container(
                        width: ResponsiveWidget.isMediumScreen(context)
                            ?500:400,
                        child: widget.viewModel?.appConfigModel?.androidConfig
                            ?.loginWithPhone == false
                            ? StreamBuilder(
                            stream: validation.email,
                            builder: (context, snapshot) {
                              return AppTextField(
                                maxLine: 1,
                                controller: emailController,
                                labelText: StringConstant.email,
                                textCapitalization: TextCapitalization.words,
                                isShowCountryCode: true,
                                isShowPassword: false,
                                secureText: false,
                                maxLength: 30,
                                keyBoardType: TextInputType.emailAddress,
                                errorText: snapshot.hasError
                                    ? snapshot.error.toString()
                                    : null,
                                onChanged: (m) {
                                  validation.sinkEmail.add(m);
                                  setState(() {});
                                },
                                onSubmitted: (m) {},
                                isTick: null,
                              );
                            })
                            : StreamBuilder(
                            stream: validation.emailAndMobile,
                            builder: (context, snapshot) {
                              return AppTextField(
                                  maxLine: null,
                                  prefixText: '',
                                  controller: phoneController,
                                  labelText: "Email/Phone",
                                  isShowCountryCode: true,
                                  isShowPassword: false,
                                  secureText: false,
                                  isColor: isPhone,
                                  isTick: false,
                                  maxLength: 40,
                                  errorText: snapshot.hasError
                                      ? snapshot.error.toString()
                                      : null,
                                  onChanged: (m) {
                                    validation.sinkEmailAndPhone.add(m);
                                    isPhone = true;
                                    setState(() {});
                                  },
                                  keyBoardType: TextInputType.emailAddress,
                                  onSubmitted: (m) {});
                            }),
                      ),
                      const SizedBox(height: 35),
                      Container(
                        alignment: Alignment.center,
                        child: StreamBuilder(
                            stream: widget.viewModel?.appConfigModel?.androidConfig?.loginWithPhone == false
                                ? validation.checkEmailValidate
                                : validation.checkEmailAndPhoneValidate,
                            builder: (context, snapshot) {
                              return appButton(
                                  context,
                                  StringConstant.send,
                                  SizeConfig.screenWidth /5.5,
                                  50,
                                  LIGHT_THEME_COLOR,
                                  BUTTON_TEXT_COLOR,
                                  16,
                                  10,
                                  snapshot.data != true ? false : true, onTap: () {
                                snapshot.data != true
                                    ? ToastMessage.message(StringConstant.fillOut)
                                    : sendButtonPressed(
                                    authVM,
                                    widget.viewModel?.appConfigModel?.androidConfig
                                        ?.loginWithPhone == false
                                        ? emailController.text
                                        : phoneController.text,
                                    widget.viewModel!);
                              });
                            }),
                      ),
                    ],
                  ),
                )
              ]));
  }

  sendButtonPressed(AuthViewModel authVM, String phone,HomeViewModel viewModel) {
    authVM.forgotPassword(phone, viewModel.appConfigModel?.androidConfig?.loginWithPhone ?? false,widget.product,context,viewModel);
  }
}
