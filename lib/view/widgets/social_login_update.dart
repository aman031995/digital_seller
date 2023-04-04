import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/model/data/UserInfoModel.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/viewmodel/sociallogin_view_model.dart';

class SocialLoginUpdate extends StatefulWidget {
  String? userEmail, userId, token;
  SocialLoginUpdate({Key? key, this.userEmail, this.userId, this.token}) : super(key: key);

  @override
  State<SocialLoginUpdate> createState() => _LoginUserUpdateState();
}

class _LoginUserUpdateState extends State<SocialLoginUpdate> {
  String? userId;
  bool isPhone = false, isValidate = false;
  final validation = ValidationBloc();
  UserInfoModel? userInfoModel;
  TextEditingController? popupEmailController = TextEditingController();
  TextEditingController? popupPhoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
   // getFCMToken();
    super.initState();
    userId = widget.userId!;
    popupEmailController!.text = widget.userEmail!;
    validateUpdateFields();
    setState(() {});
  }

  // void getFCMToken() {
  //   FirebaseMessaging.instance.getToken().then((value) {
  //     widget.token = value;
  //   });
  // }

  validateUpdateFields() {
    validation.sinkEmail.add(widget.userEmail!);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final socialVM = Provider.of<SocialLoginViewModel>(context);
    return Dialog(
      insetPadding: const EdgeInsets.all(30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      child: SingleChildScrollView(
        child: Container(
          color: LIGHT_THEME_BACKGROUND,
          height: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: AppMediumFont(
                    context,msg: 'Update',
                    fontSize: 20.0,
                    textAlign: TextAlign.center),
              ),
              const SizedBox(
                height: 18.0,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  StreamBuilder(
                      stream: validation.email,
                      builder: (context, snapshot) {
                        return AppTextField(
                          maxLine: 1,
                          controller: popupEmailController,
                          labelText: StringConstant.email,
                          isShowCountryCode: true,
                          isShowPassword: false,
                          secureText: false,
                          isEnable: widget.userEmail != '' ? false : true,
                          isTick: isValidate,
                          keyBoardType: TextInputType.emailAddress,
                          maxLength: 50,
                          errorText: snapshot.hasError
                              ? snapshot.error.toString()
                              : null,
                          onChanged: (m) {
                            validation.sinkEmail.add(m);
                            setState(() {});
                          },
                        );
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  StreamBuilder(
                      stream: validation.phoneNo,
                      builder: (context, snapshot) {
                        return AppTextField(
                          maxLine: 1,
                          controller: popupPhoneController,
                          labelText: StringConstant.mobileNumber,
                          isShowCountryCode: true,
                          isShowPassword: false,
                          secureText: false,
                          isTick: isValidate,
                          keyBoardType: TextInputType.phone,
                          maxLength: 10,
                          errorText: snapshot.hasError
                              ? snapshot.error.toString()
                              : null,
                          onChanged: (m) {
                            validation.sinkPhoneNo.add(m);
                            setState(() {});
                          },
                        );
                      }),
                  const SizedBox(height: 55),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      right: 12.0,
                    ),
                    child: StreamBuilder(
                        stream: validation.checkUserInfoValidate,
                        builder: (context, snapshot) {
                          return appButton(
                              context,
                              StringConstant.update,
                              SizeConfig.screenWidth * 0.85,
                              60,
                              THEME_COLOR,
                              Theme.of(context).canvasColor,17,
                              10,
                              snapshot.data != true ? false : true, onTap: () {
                            snapshot.data != true ? null : updateButtonPressed(context, socialVM, popupEmailController?.text, popupPhoneController?.text, userId);
                          });
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //---------Details verify to Register Home-----------
  updateButtonPressed(BuildContext context, SocialLoginViewModel socialVM, String? userEmail, String? phone, String? userId) async {
    socialVM.updateSocialDetail(context, socialVM, userEmail, phone, userId);
  }
}
