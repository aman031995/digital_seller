import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/AssetsConstants.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
@RoutePage()
class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController? nameController, messageController, emailController;
  final validation = ValidationBloc();
  ProfileViewModel profileViewModel = ProfileViewModel();
  String? name, email, pageTitle;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
    nameController = TextEditingController();
    emailController = TextEditingController();
    getUserInfo();
  }

  @override
  void dispose() {
    validation.closeStream();
    messageController?.dispose();
    nameController?.dispose();
    emailController?.dispose();
    super.dispose();
  }

  getUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    name = sharedPreferences.getString('name');
    email = sharedPreferences.getString('email');
    setState(() {});
    nameController?.text = name ?? '';
    emailController?.text = email ?? '';
    validateEditDetails();
    setState(() {});
  }

  validateEditDetails() {
    validation.sinkFirstName.add(name ?? '');
    validation.sinkEmail.add(email ?? '');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (ModalRoute.of(context)?.settings.arguments != null) {
      final Map<String, dynamic> data =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      pageTitle = data['title'];
    }
    return Scaffold(
      appBar: homePageTopBar(),
      body:ResponsiveWidget.isMediumScreen(context)
          ? Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.all(20),
              width: SizeConfig.screenWidth,
              alignment: Alignment.center,
              child: StreamBuilder(
                  stream: validation.firstName,
                  builder: (context, snapshot) {
                    return AppTextField(
                      maxLine: 1,
                      controller: nameController,
                      labelText: StringConstant.fullName,
                      textCapitalization: TextCapitalization.words,
                      isShowCountryCode: true,
                      isShowPassword: false,
                      secureText: false,
                      maxLength: 30,
                      isEnable: name != null ? false : true,
                      keyBoardType: TextInputType.name,
                      errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: (m) {
                        validation.sinkFirstName.add(m);
                        setState(() {});
                      },
                      onSubmitted: (m) {},
                      isTick: null,
                    );
                  }),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              width: SizeConfig.screenWidth,
              alignment: Alignment.center,
              child: StreamBuilder(
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
                      isEnable: email != null ? false : true,
                      keyBoardType: TextInputType.emailAddress,
                      errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: (m) {
                        validation.sinkEmail.add(m);
                        setState(() {});
                      },
                      onSubmitted: (m) {},
                      isTick: null,
                    );
                  }),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              width: SizeConfig.screenWidth,
              alignment: Alignment.center,
              child: StreamBuilder(
                  stream: validation.address,
                  builder: (context, snapshot) {
                    return AppTextField(
                      maxLine: 5,
                      controller: messageController,
                      labelText: StringConstant.message,
                      textCapitalization: TextCapitalization.words,
                      isShowCountryCode: true,
                      isShowPassword: false,
                      secureText: false,
                      maxLength: 300,
                      keyBoardType: TextInputType.multiline,
                      errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
                      onChanged: (m) {
                        validation.sinkAddress.add(m);
                        setState(() {});
                      },
                      onSubmitted: (m) {},
                      isTick: null,
                    );
                  }),
            ),
            SizedBox(height: 12),
            StreamBuilder(
                stream: validation.validateContactUs,
                builder: (context, snapshot) {
                  return appButton(
                      context,
                      StringConstant.send,
                      SizeConfig.screenWidth * 0.8,
                      60,
                      LIGHT_THEME_COLOR,
                      WHITE_COLOR,
                      20,
                      10,
                      snapshot.data != true ? false : true, onTap: () {
                    // snapshot.data != true ? null : " ";
                    snapshot.data != true
                        ? ToastMessage.message(StringConstant.fillOut)
                        : saveButtonPressed(
                            nameController?.text ?? '',
                            emailController?.text ?? '',
                            messageController?.text ?? '');
                  });
                }),
          ],
        ),
      ) :
      Center(
        child: Container(
          width: SizeConfig.screenWidth * 0.4,
          margin: EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            children: [
              SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.all(20),
                width: SizeConfig.screenWidth,
                alignment: Alignment.center,
                child: StreamBuilder(
                    stream: validation.firstName,
                    builder: (context, snapshot) {
                      return AppTextField(
                        maxLine: 1,
                        controller: nameController,
                        labelText: StringConstant.fullName,
                        textCapitalization: TextCapitalization.words,
                        isShowCountryCode: true,
                        isShowPassword: false,
                        secureText: false,
                        maxLength: 30,
                        isEnable: name != null ? false : true,
                        keyBoardType: TextInputType.name,
                        errorText:
                        snapshot.hasError ? snapshot.error.toString() : null,
                        onChanged: (m) {
                          validation.sinkFirstName.add(m);
                          setState(() {});
                        },
                        onSubmitted: (m) {},
                        isTick: null,
                      );
                    }),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                width: SizeConfig.screenWidth,
                alignment: Alignment.center,
                child: StreamBuilder(
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
                        isEnable: email != null ? false : true,
                        keyBoardType: TextInputType.emailAddress,
                        errorText:
                        snapshot.hasError ? snapshot.error.toString() : null,
                        onChanged: (m) {
                          validation.sinkEmail.add(m);
                          setState(() {});
                        },
                        onSubmitted: (m) {},
                        isTick: null,
                      );
                    }),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                width: SizeConfig.screenWidth,
                alignment: Alignment.center,
                child: StreamBuilder(
                    stream: validation.address,
                    builder: (context, snapshot) {
                      return AppTextField(
                        maxLine: 5,
                        controller: messageController,
                        labelText: StringConstant.message,
                        textCapitalization: TextCapitalization.words,
                        isShowCountryCode: true,
                        isShowPassword: false,
                        secureText: false,
                        maxLength: 300,
                        keyBoardType: TextInputType.multiline,
                        errorText:
                        snapshot.hasError ? snapshot.error.toString() : null,
                        onChanged: (m) {
                          validation.sinkAddress.add(m);
                          setState(() {});
                        },
                        onSubmitted: (m) {},
                        isTick: null,
                      );
                    }),
              ),
              SizedBox(height: 12),
              StreamBuilder(
                  stream: validation.validateContactUs,
                  builder: (context, snapshot) {
                    return appButton(
                        context,
                        StringConstant.send,
                        SizeConfig.screenWidth * 0.35,
                        60,
                        LIGHT_THEME_COLOR,
                        WHITE_COLOR,
                        20,
                        10,
                        snapshot.data != true ? false : true, onTap: () {
                      // snapshot.data != true ? null : " ";
                      snapshot.data != true
                          ? ToastMessage.message(StringConstant.fillOut)
                          : saveButtonPressed(
                          nameController?.text ?? '',
                          emailController?.text ?? '',
                          messageController?.text ?? '');
                    });
                  }),
            ],
          ),
        ),
      )
    );
  }

  homePageTopBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).cardColor,
      title: Row(children: <Widget>[
        GestureDetector(
            onTap: (){
              GoRouter.of(context).pushNamed(RoutesName.home);
            },
            child: Image.asset(AssetsConstants.icLogo,width: ResponsiveWidget.isMediumScreen(context) ? 35:45, height:ResponsiveWidget.isMediumScreen(context) ? 35: 45)),
        SizedBox(width: SizeConfig.screenWidth*0.04),
        AppBoldFont(context,msg:"Contact Us",fontSize:ResponsiveWidget.isMediumScreen(context) ? 16: 20, fontWeight: FontWeight.w700),
      ]),
      actions: [
        GestureDetector(
          onTap: () {
            setState(() {
              isLogins = true;
              if (isSearch == true) {
                isSearch = false;
                searchController?.clear();
                setState(() {});
              }
            });
          },
          child: Row(
            children: [
              appTextButton(context, names!, Alignment.center, Theme.of(context).canvasColor,ResponsiveWidget.isMediumScreen(context)
                  ?16: 18, true),
              Image.asset(
                AssetsConstants.icProfile,
                height:ResponsiveWidget.isMediumScreen(context)
                    ?20: 30,
                color: Theme.of(context).canvasColor,
              ),
            ],
          ),
        ),
        SizedBox(width: SizeConfig.screenWidth*0.04),
      ],
    );
  }
  saveButtonPressed(String name, String email, String message) {
    profileViewModel.contactUs(context, name, email, message);
  }
}
