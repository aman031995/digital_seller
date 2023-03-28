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
import 'package:tycho_streams/viewmodel/auth_view_model.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String errorPhoneNumber = "";
  final validation = ValidationBloc();
  bool isPhone = false, isPhoneType = false, isValidate = false;
  int? type;

  TextEditingController? phoneController = TextEditingController();

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
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content:  forgotPasswordSection(authVM));
  }

  Widget forgotPasswordSection(AuthViewModel authVM) {
    return Container(
        height:ResponsiveWidget.isMediumScreen(context)
            ? 300 : 350,
        width: ResponsiveWidget.isMediumScreen(context)
            ? 600 :500,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.8),
          border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.6)),
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
                  fontSize: ResponsiveWidget.isMediumScreen(context)
                      ? 18 :22,
                  color: TEXT_COLOR),
              SizedBox(height: 20),
              Padding(
                padding:EdgeInsets.only(left: 25,right: 15),
                child: AppMediumFont(
                    context,msg: StringConstant.enterOtpText,
                    fontSize: ResponsiveWidget.isMediumScreen(context)
                        ? 14 :16,
                    color: GREY_COLOR,
                    textAlign: TextAlign.left),
              ),
              const SizedBox(height: 35),
              Container(
                width: ResponsiveWidget.isMediumScreen(context)
                    ?500:400,
                child: StreamBuilder(
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
                          isColor: isPhone,
                          isTick: false,
                          maxLength: 10,
                          errorText: snapshot.hasError
                              ? snapshot.error.toString()
                              : null,
                          onChanged: (m) {
                            validation.sinkPhoneNo.add(m);
                            isPhone = true;
                            setState(() {});
                          },
                          keyBoardType: TextInputType.phone,
                          onSubmitted: (m) {});
                    }),
              ),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                child: StreamBuilder(
                    stream: validation.checkPhoneValidate,
                    builder: (context, snapshot) {
                      return appButton(
                          context,
                          StringConstant.send,
                          ResponsiveWidget.isMediumScreen(context)
                              ? SizeConfig.screenWidth*0.67 : SizeConfig.screenWidth/8,
                          ResponsiveWidget.isMediumScreen(context)
                              ? 50 : 60,
                          LIGHT_THEME_COLOR,Theme.of(context).canvasColor,
                          16,
                          10,
                          snapshot.data != true ? false : true, onTap: () {
                        snapshot.data != true
                            ? ToastMessage.message(StringConstant.fillOut)
                            : sendButtonPressed(authVM, phoneController!.text);
                      });
                    }),
              ),
            ],
          ),
        ));
  }

  sendButtonPressed(AuthViewModel authVM, String phone) {
    authVM.forgotPassword(phone, context);
  }
}
