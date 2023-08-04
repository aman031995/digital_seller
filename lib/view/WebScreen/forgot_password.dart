import 'package:TychoStream/services/global_variable.dart';
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
import 'package:url_launcher/url_launcher.dart';

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
        insetPadding: EdgeInsets.all(10),
        content: forgotPasswordSection(authVM));
  }

  Widget forgotPasswordSection(AuthViewModel authVM) {
    return
      ResponsiveWidget.isMediumScreen(context)?
      Container(
          padding: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Positioned(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            }, icon: Image.asset(AssetsConstants.icCross, color: Theme.of(context).canvasColor)),
                      ),
                    )
                  ],
                ),
                AppBoldFont(
                  textAlign: TextAlign.start,
                  context,msg: StringConstant.forgotPassword,
                  fontSize: 18 ,
                ),
                SizedBox(height: 20),
                AppMediumFont(
                    context, msg: widget.viewModel?.appConfigModel?.androidConfig?.loginWithPhone == false
                    ? "Please check your email we will send you a verification code."
                    : StringConstant.enterOtpText,
                    fontSize: 14 ,
                    textAlign: TextAlign.left),
                SizedBox(height: 30),
                Container(
                  width: SizeConfig.screenWidth,
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
                 SizedBox(height: 20),
                StreamBuilder(
                    stream: widget.viewModel?.appConfigModel?.androidConfig?.loginWithPhone == false
                        ? validation.checkEmailValidate
                        : validation.checkEmailAndPhoneValidate,
                    builder: (context, snapshot) {
                      return appButton(
                          context,
                          StringConstant.send,
                          SizeConfig.screenWidth,
                          50,
                          Theme.of(context).primaryColor,
                          Theme.of(context).hintColor,
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
                SizedBox(height: 10),
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
                    child: GlobalVariable.isLightTheme == true ?
                    Image.network("https://eacademyeducation.com:8011/logo/lite_logo.png", fit: BoxFit.fill, width: 100) :
                    Image.network("https://eacademyeducation.com:8011/logo/dark_logo.png", fit: BoxFit.fill, width: 100),
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          )) :
      Container(
        height: SizeConfig.screenHeight / 1.8,
        width: SizeConfig.screenWidth * 0.25,
        child: Column(
          children: [
            Stack(
              children: [
                Positioned(
                  child: Container(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        }, icon: Image.asset(AssetsConstants.icCross, color: Theme.of(context).canvasColor)),
                  ),
                )
              ],
            ),
            Container(
                margin:  EdgeInsets.only(left: 20, right: 20,top: 20,bottom: 10),
                alignment: Alignment.topLeft,
                child: AppBoldFont(context, msg: StringConstant.forgotPassword,
                    fontSize: ResponsiveWidget.isMediumScreen(context) ? 18 : 22,)),
            Container(
                margin:  EdgeInsets.only(left: 20, right: 20,bottom: 20),
                alignment: Alignment.topLeft,
                child: AppMediumFont(context, msg: widget.viewModel?.appConfigModel?.androidConfig?.loginWithPhone == false ? "Please check your email we will send you a verification code." : StringConstant.enterOtpText, fontSize: 16)),
            Container(
              margin:  EdgeInsets.only(left: 20, right: 20,bottom: 30),
              alignment: Alignment.center, // width: ResponsiveWidget.isMediumScreen(context) ? 500 : 400,
              child: widget.viewModel?.appConfigModel?.androidConfig?.loginWithPhone == false
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
            Container(
                              margin:  EdgeInsets.only(left: 20, right: 20,bottom: 30),
                              child: StreamBuilder(
                                  stream: widget.viewModel?.appConfigModel?.androidConfig?.loginWithPhone == false
                                      ? validation.checkEmailValidate
                                      : validation.checkEmailAndPhoneValidate,
                                  builder: (context, snapshot) {
                                    return appButton(
                                        context,
                                        StringConstant.send,
                                        SizeConfig.screenWidth,
                                        50,
                                        Theme.of(context).primaryColor,
                                        Theme.of(context).hintColor,
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
            SizedBox(height:20),
            GestureDetector(
              onTap: () async{
                const url = 'http://digitalseller.in/';
                if (await canLaunch(url)) {
                  await launch(url, forceWebView: false, enableJavaScript: true);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Container(
                // margin: EdgeInsets.only(left: 120, right: 120, bottom: 5),
                  width: SizeConfig.screenWidth * 0.08,
                  child: GlobalVariable.isLightTheme == true ?
                  Image.network("https://eacademyeducation.com:8011/logo/lite_logo.png", fit: BoxFit.fill, width: 50) :
                  Image.network("https://eacademyeducation.com:8011/logo/dark_logo.png", fit: BoxFit.fill, width: 50)),
            ),
            SizedBox(height:10),
          ],
        ),
      );
      // Container(
      //     decoration: BoxDecoration(
      //         // borderRadius: BorderRadius.circular(20),
      //         // border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.4)),
      //         color: Theme.of(context).cardColor),
      //     child: Column(
      //       // mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Stack(
      //             children: [
      //               // Container(
      //               //   decoration: const BoxDecoration(
      //               //       // borderRadius: BorderRadius.only(
      //               //       //     topLeft: Radius.circular(20),
      //               //       //     bottomLeft: Radius.circular(20))
      //               //   ),
      //               //   height: SizeConfig.screenHeight / 1.45,
      //               //   width: SizeConfig.screenWidth * 0.29,
      //               //   child: Image.asset(
      //               //     'images/LoginPageLogo.png',
      //               //     fit: BoxFit.fill,
      //               //   ),
      //               // ),
      //               Container(
      //                 alignment: Alignment.topLeft,
      //                 child: IconButton(
      //                   onPressed: (){
      //                   Navigator.pop(context);
      //                   showDialog(
      //                       context: context,
      //                       builder: (BuildContext context) {
      //                         return LoginUp();
      //                       });
      //                 }, icon: Image.asset(AssetsConstants.icBack, color: Theme.of(context).canvasColor)),
      //               )
      //             ],
      //           ),
      //           Container(
      //             height: SizeConfig.screenHeight * 0.8,
      //             // padding: EdgeInsets.only(right: 38),
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 // SizedBox(height: 45),
      //                 // Container(
      //                 //     // padding: EdgeInsets.only(left: 17),
      //                 //     alignment: Alignment.topLeft,
      //                 //     child: AppBoldFont(
      //                 //      textAlign: TextAlign.center,
      //                 //        context, msg: StringConstant.forgotPassword,
      //                 //        fontSize: ResponsiveWidget.isMediumScreen(context) ? 18 : 22)),
      //                 // SizedBox(height: SizeConfig.screenHeight * .01),
      //                 // Container(
      //                 //     // padding: EdgeInsets.only(left: 17),
      //                 //     alignment: Alignment.topLeft,
      //                 //     child: AppMediumFont(
      //                 //         context, msg: widget.viewModel?.appConfigModel?.androidConfig
      //                 //         ?.loginWithPhone == false ? "Please check your email we will send you a verification code."
      //                 //         : StringConstant.enterOtpText,
      //                 //         fontSize: 16,
      //                 //         textAlign: TextAlign.left),),
      //
      //                 SizedBox(height: 20),
      //                 Padding(
      //                   padding : EdgeInsets.only(left: 10,right: 15),
      //                   child: AppBoldFont(
      //                     textAlign: TextAlign.left,
      //                     context, msg: StringConstant.forgotPassword,
      //                     fontSize: ResponsiveWidget.isMediumScreen(context) ? 18 : 22,
      //                   ),
      //                 ),
      //                 SizedBox(height: 10),
      //                 Padding(
      //                   padding : EdgeInsets.only(left: 25,right: 15),
      //                   child: AppMediumFont(
      //                       context, msg: widget.viewModel?.appConfigModel?.androidConfig
      //                       ?.loginWithPhone == false
      //                       ? "Please check your email we will send you a verification code."
      //                       : StringConstant.enterOtpText,
      //                       fontSize: 16,
      //                       textAlign: TextAlign.left),
      //                 ),
      //                 const SizedBox(height: 35),
      //                 Container(
      //                   margin: EdgeInsets.only(right: 65, left: 65),
      //                   alignment: Alignment.center,
      //                   // width: ResponsiveWidget.isMediumScreen(context) ? 500 : 400,
      //                   child: widget.viewModel?.appConfigModel?.androidConfig?.loginWithPhone == false
      //                       ? StreamBuilder(
      //                       stream: validation.email,
      //                       builder: (context, snapshot) {
      //                         return AppTextField(
      //                           maxLine: 1,
      //                           controller: emailController,
      //                           labelText: StringConstant.email,
      //                           textCapitalization: TextCapitalization.words,
      //                           isShowCountryCode: true,
      //                           isShowPassword: false,
      //                           secureText: false,
      //                           maxLength: 30,
      //                           keyBoardType: TextInputType.emailAddress,
      //                           errorText: snapshot.hasError
      //                               ? snapshot.error.toString()
      //                               : null,
      //                           onChanged: (m) {
      //                             validation.sinkEmail.add(m);
      //                             setState(() {});
      //                           },
      //                           onSubmitted: (m) {},
      //                           isTick: null,
      //                         );
      //                       })
      //                       : Container(
      //                         child: StreamBuilder(
      //                         stream: validation.emailAndMobile,
      //                         builder: (context, snapshot) {
      //                           return AppTextField(
      //                               maxLine: null,
      //                               prefixText: '',
      //                               controller: phoneController,
      //                               labelText: "Email/Phone",
      //                               isShowCountryCode: true,
      //                               isShowPassword: false,
      //                               secureText: false,
      //                               isColor: isPhone,
      //                               isTick: false,
      //                               maxLength: 40,
      //                               errorText: snapshot.hasError
      //                                   ? snapshot.error.toString()
      //                                   : null,
      //                               onChanged: (m) {
      //                                 validation.sinkEmailAndPhone.add(m);
      //                                 isPhone = true;
      //                                 setState(() {});
      //                               },
      //                               keyBoardType: TextInputType.emailAddress,
      //                               onSubmitted: (m) {});
      //                         }),
      //                       ),
      //                 ),
      //                 const SizedBox(height: 35),
      //                 Container(
      //                   margin: const EdgeInsets.only(left: 10, right: 10),
      //                   alignment: Alignment.center,
      //                   child: StreamBuilder(
      //                       stream: widget.viewModel?.appConfigModel?.androidConfig?.loginWithPhone == false
      //                           ? validation.checkEmailValidate
      //                           : validation.checkEmailAndPhoneValidate,
      //                       builder: (context, snapshot) {
      //                         return appButton(
      //                             context,
      //                             StringConstant.send,
      //                             SizeConfig.screenWidth / 0.23,
      //                             50,
      //                             LIGHT_THEME_COLOR,
      //                             BUTTON_TEXT_COLOR,
      //                             16,
      //                             10,
      //                             snapshot.data != true ? false : true, onTap: () {
      //                           snapshot.data != true
      //                               ? ToastMessage.message(StringConstant.fillOut)
      //                               : sendButtonPressed(
      //                               authVM,
      //                               widget.viewModel?.appConfigModel?.androidConfig
      //                                   ?.loginWithPhone == false
      //                                   ? emailController.text
      //                                   : phoneController.text,
      //                               widget.viewModel!);
      //                         });
      //                       }),
      //                 ),
      //               ],
      //             ),
      //           )
      //         ]));
  }

  sendButtonPressed(AuthViewModel authVM, String phone,HomeViewModel viewModel) {
    authVM.forgotPassword(phone, viewModel.appConfigModel?.androidConfig?.loginWithPhone ?? false,widget.product,context,viewModel);
  }
}
