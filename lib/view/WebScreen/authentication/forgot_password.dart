import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
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
        insetPadding: EdgeInsets.all(ResponsiveWidget.isSmallScreen(context) ?10:130),
        content: forgotPasswordSection(authVM));
  }

  Widget forgotPasswordSection(AuthViewModel authVM) {
    return Container(
      margin:  EdgeInsets.only(left:ResponsiveWidget.isMediumScreen(context)?15: 50, right:ResponsiveWidget.isMediumScreen(context)?15: 50,top:ResponsiveWidget.isMediumScreen(context)?10: 20),
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

              AppBoldFont(context, msg: StringConstant.forgotPassword, fontSize: ResponsiveWidget.isMediumScreen(context)?22: 30),
              SizedBox(height: ResponsiveWidget.isMediumScreen(context)?5:10),
              AppMediumFont(context, msg: widget.viewModel?.appConfigModel?.androidConfig?.loginWithPhone == false ? StringConstant.enterEmailOtpText: StringConstant.enterOtpText, fontSize: 16),
            SizedBox(height: ResponsiveWidget.isMediumScreen(context)?10:20),
              widget.viewModel?.appConfigModel?.androidConfig?.loginWithPhone == false
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
                                        labelText: StringConstant.emailAndPhone,
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
              SizedBox(height: ResponsiveWidget.isMediumScreen(context)?15:25),
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
                          ? ToastMessage.message(StringConstant.fillOut,context)
                          : sendButtonPressed(
                          authVM,
                          widget.viewModel?.appConfigModel?.androidConfig
                              ?.loginWithPhone == false
                              ? emailController.text
                              : phoneController.text,
                          widget.viewModel!);
                    });
                  }),
              SizedBox(height: ResponsiveWidget.isMediumScreen(context)?20:35),
              Center(
                child: Container(
                    child: GlobalVariable.isLightTheme == true ?
                    Image.network(StringConstant.digitalSellerLitelogo, fit: BoxFit.fill, width:ResponsiveWidget.isMediumScreen(context)?150:SizeConfig.screenWidth*0.12,height:ResponsiveWidget.isMediumScreen(context)?50: SizeConfig.screenWidth*0.03) :
                    Image.network(StringConstant.digitalSellerDarklogo, fit: BoxFit.fill, width:ResponsiveWidget.isMediumScreen(context)?150: SizeConfig.screenWidth*0.12,height:ResponsiveWidget.isMediumScreen(context)?50:SizeConfig.screenWidth*0.03)),
              ),
              SizedBox(height:35),
            ],
          ),
        ),
      );
  }

  sendButtonPressed(AuthViewModel authVM, String phone,HomeViewModel viewModel) {
    authVM.forgotPassword(phone, viewModel.appConfigModel?.androidConfig?.loginWithPhone ?? false,widget.product,context,viewModel);
  }
}
