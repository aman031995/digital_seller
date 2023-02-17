import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/bloc_validation/Bloc_Validation.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/widgets/AppNavigationBar.dart';
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
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content:  forgotPasswordSection(authVM));
  }

  Widget forgotPasswordSection(AuthViewModel authVM) {
    return Container(
        height: 350,
        width: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                child: AppBoldFont(
                    msg: StringConstant.forgotPassword,
                    fontSize: 28,
                    color: TEXT_COLOR)),
            SizedBox(height: 20),
            Container(
                width: 400,
                margin: const EdgeInsets.only(
                  top: 6,
                  left: 20,
                ),
                child: AppMediumFont(
                    msg: StringConstant.enterOtpText,
                    fontSize: 16,
                    color: GREY_COLOR,
                    textAlign: TextAlign.start)),
            const SizedBox(height: 35),
            Container(
              width: 400,
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
              width: 400,
              alignment: Alignment.center,
              child: StreamBuilder(
                  stream: validation.checkPhoneValidate,
                  builder: (context, snapshot) {
                    return appButton(
                        context,
                        StringConstant.send,
                        SizeConfig.screenWidth * 0.90,
                        60,
                        LIGHT_THEME_COLOR,
                        BUTTON_TEXT_COLOR,
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
        ));
  }

  sendButtonPressed(AuthViewModel authVM, String phone) {
    authVM.forgotPassword(phone, context);
  }
}
