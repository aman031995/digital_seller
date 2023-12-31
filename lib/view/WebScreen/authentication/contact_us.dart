import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/menu/app_menu.dart';
import 'package:TychoStream/view/WebScreen/search/search_list.dart';
import 'package:TychoStream/view/widgets/NotificationScreen.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/footerDesktop.dart';
import 'package:TychoStream/view/widgets/getAppBar.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/notification_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import '../../../AppRouter.gr.dart';


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
  HomeViewModel homeViewModel = HomeViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  ScrollController scrollController = ScrollController();
  CartViewModel cartViewModel = CartViewModel();
  TextEditingController? searchController = TextEditingController();
  String? name, email, pageTitle;
  String?  checkInternet;
  NotificationViewModel notificationViewModel = NotificationViewModel();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    profileViewModel.getProfileDetail(context);
    homeViewModel.getAppConfig(context);
    messageController = TextEditingController();
    nameController = TextEditingController();
    emailController = TextEditingController();
    notificationViewModel.getNotificationCountText(context);
    cartViewModel.getCartCount(context);

    getUserInfo();
    super.initState();
  }


  getUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    name = sharedPreferences.getString('name');
    email = sharedPreferences.getString('email');
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
    AppNetwork.checkInternet((isSuccess, result) {
      setState(() {
        checkInternet = result;
      });
    });
    return checkInternet == "Offline"
        ? NOInternetScreen()
        : ChangeNotifierProvider.value(
        value: profileViewModel,
        child: Consumer<ProfileViewModel>(builder: (context, profilemodel, _) {
      return ChangeNotifierProvider.value(
        value: homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          return ChangeNotifierProvider.value(
              value: notificationViewModel,
              child: Consumer<NotificationViewModel>(
                  builder: (context, model, _) { return GestureDetector(
            onTap: () {
              if (GlobalVariable.isLogins == true) {
                GlobalVariable.isLogins = false;
              }
              if(GlobalVariable.isSearch==true){
                GlobalVariable.isSearch=false;

              }
              if(GlobalVariable.isnotification==true){
                GlobalVariable. isnotification=false;

              }
            },
            child: Scaffold(
                appBar: ResponsiveWidget.isMediumScreen(context)
                    ? homePageTopBar(
                        context,
                        _scaffoldKey,
                        cartViewModel.cartItemCount,
                  viewmodel,
                  profilemodel,notificationViewModel
                      )
                    : getAppBar(
                        context,model,
                    viewmodel,
                    profilemodel,
                        cartViewModel.cartItemCount,
                        1,
                        searchController, () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        if (sharedPreferences.get('token') != null) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return LoginUp(
                                  product: true,
                                );
                              });
                        } else {
                          if (GlobalVariable.isLogins == true) {
                            GlobalVariable.isLogins = false;

                          }
                          if (GlobalVariable.isSearch == true) {
                            GlobalVariable.isSearch = false;
                          }
                          if(GlobalVariable.isnotification==true){
                            GlobalVariable.isnotification=false;

                          }
                          context.router.push(FavouriteListPage());
                        }
                      }, () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        if (sharedPreferences.getString('token') == null) {
                          showDialog(
                              context: context,
                              barrierColor:
                                  Theme.of(context).canvasColor.withOpacity(0.6),
                              builder: (BuildContext context) {
                                return LoginUp(
                                  product: true,
                                );
                              });
                        } else {
                          if (GlobalVariable.isLogins == true) {
                            GlobalVariable.isLogins = false;
                            setState(() {});
                          }
                          if (GlobalVariable.isSearch == true) {
                            GlobalVariable.isSearch = false;
                            setState(() {});
                          }
                          if(GlobalVariable.isnotification==true){
                            GlobalVariable.isnotification=false;
                            setState(() {

                            });
                          }
                          context.router.push(CartDetail(
                              itemCount: '${cartViewModel.cartItemCount}'));
                        }
                      }),
                body: Scaffold(
                    extendBodyBehindAppBar: true,
                    key: _scaffoldKey,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    drawer: ResponsiveWidget.isMediumScreen(context)
                        ? AppMenu()
                        : SizedBox(),
                    body: Stack(
                            children: [
                              ResponsiveWidget.isMediumScreen(context)
                                  ? SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    width: SizeConfig.screenWidth,
                                    alignment: Alignment.center,
                                    child:AppBoldFont(context, msg: "Helpdesk",fontSize: 18)),
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
                                                textCapitalization:
                                                TextCapitalization.words,
                                                isShowCountryCode: true,
                                                isShowPassword: false,
                                                secureText: false,
                                                maxLength: 30,
                                                isEnable: name != null ? false : true,
                                                keyBoardType: TextInputType.name,
                                                errorText: snapshot.hasError
                                                    ? snapshot.error.toString()
                                                    : null,
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
                                                textCapitalization:
                                                TextCapitalization.words,
                                                isShowCountryCode: true,
                                                isShowPassword: false,
                                                secureText: false,
                                                maxLength: 30,
                                                isEnable:
                                                email != null ? false : true,
                                                keyBoardType:
                                                TextInputType.emailAddress,
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
                                                textCapitalization:
                                                TextCapitalization.words,
                                                isShowCountryCode: true,
                                                isShowPassword: false,
                                                secureText: false,
                                                maxLength: 300,
                                                keyBoardType: TextInputType.multiline,
                                                errorText: snapshot.hasError
                                                    ? snapshot.error.toString()
                                                    : null,
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
                                                50,
                                                Theme.of(context).primaryColor,
                                                Theme.of(context).hintColor,
                                                20,
                                                10,
                                                snapshot.data != true ? false : true,
                                                onTap: () {
                                                  // snapshot.data != true ? null : " ";
                                                  snapshot.data != true
                                                      ? ToastMessage.message(
                                                      StringConstant.fillOut, context)
                                                      : saveButtonPressed(
                                                      nameController?.text ?? '',
                                                      emailController?.text ?? '',
                                                      messageController?.text ?? '');
                                                });
                                          }),
                                      SizedBox(height: ResponsiveWidget.isSmallScreen(context)? 100:SizeConfig.screenHeight/4.5),
                                      footerMobile(context,homeViewModel)
                                    ],
                                  ),
                                ),
                              )
                                  : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Center(
                                      child: Container(
                                        width: SizeConfig.screenWidth * 0.4,
                                        margin: EdgeInsets.only(
                                            top: 50, left: 20, right: 20),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 12),
                                            Container(
                                                margin: const EdgeInsets.all(20),
                                                width: SizeConfig.screenWidth,
                                                alignment: Alignment.center,
                                                child:AppBoldFont(context, msg: "Helpdesk",fontSize: 22)),
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
                                                      labelText:
                                                          StringConstant.fullName,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                      isShowCountryCode: true,
                                                      isShowPassword: false,
                                                      secureText: false,
                                                      maxLength: 30,
                                                      isEnable: name != null
                                                          ? false
                                                          : true,
                                                      keyBoardType:
                                                          TextInputType.name,
                                                      errorText: snapshot.hasError
                                                          ? snapshot.error
                                                              .toString()
                                                          : null,
                                                      onChanged: (m) {
                                                        validation.sinkFirstName
                                                            .add(m);
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
                                                      labelText:
                                                          StringConstant.email,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                      isShowCountryCode: true,
                                                      isShowPassword: false,
                                                      secureText: false,
                                                      maxLength: 30,
                                                      isEnable: email != null
                                                          ? false
                                                          : true,
                                                      keyBoardType: TextInputType
                                                          .emailAddress,
                                                      errorText: snapshot.hasError
                                                          ? snapshot.error
                                                              .toString()
                                                          : null,
                                                      onChanged: (m) {
                                                        validation.sinkEmail
                                                            .add(m);
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
                                                      controller:
                                                          messageController,
                                                      labelText:
                                                          StringConstant.message,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                      isShowCountryCode: true,
                                                      isShowPassword: false,
                                                      secureText: false,
                                                      maxLength: 300,
                                                      keyBoardType:
                                                          TextInputType.multiline,
                                                      errorText: snapshot.hasError
                                                          ? snapshot.error
                                                              .toString()
                                                          : null,
                                                      onChanged: (m) {
                                                        validation.sinkAddress
                                                            .add(m);
                                                        setState(() {});
                                                      },
                                                      onSubmitted: (m) {},
                                                      isTick: null,
                                                    );
                                                  }),
                                            ),
                                            SizedBox(height: 12),
                                            StreamBuilder(
                                                stream:
                                                    validation.validateContactUs,
                                                builder: (context, snapshot) {
                                                  return appButton(
                                                      context,
                                                      StringConstant.send,
                                                      SizeConfig.screenWidth *
                                                          0.35,
                                                      50,
                                                      Theme.of(context).primaryColor,
                                                      Theme.of(context).hintColor,
                                                      20,
                                                      10,
                                                      snapshot.data != true
                                                          ? false
                                                          : true, onTap: () {
                                                    snapshot.data != true
                                                        ? ToastMessage.message(
                                                            StringConstant
                                                                .fillOut,
                                                            context)
                                                        : saveButtonPressed(
                                                            nameController
                                                                    ?.text ??
                                                                '',
                                                            emailController
                                                                    ?.text ??
                                                                '',
                                                            messageController
                                                                    ?.text ??
                                                                '');
                                                  });
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height:170),
                                    footerDesktop()
                                  ],
                                ),
                              ),
                              ResponsiveWidget.isMediumScreen(context)
                                  ? Container()
                                  : GlobalVariable.isLogins == true
                                      ? Positioned(
                                          top: 0,
                                          right: 180,
                                          child: profile(context, setState,
                                              profilemodel))
                                      : Container(),
                              ResponsiveWidget.isMediumScreen(context)
                                  ? Container()
                                  : GlobalVariable.isSearch == true
                                      ? Positioned(
                                          top: 1,
                                          right: SizeConfig.screenWidth * 0.20,
                                          child: searchList(
                                              context,
                                              viewmodel,
                                              scrollController,
                                              searchController!,
                                              cartViewModel.cartItemCount))
                                      : Container(),
                              ResponsiveWidget.isMediumScreen(context)
                                  ? Container()
                                  : GlobalVariable.isnotification == true
                                  ?    Positioned(
                                  top:  0,
                                  right:  SizeConfig
                                      .screenWidth *
                                      0.20,
                                  child: notification(notificationViewModel,context,_scrollController)):Container()

                            ],
                          ))),
          );
        }));})); }));
  }

  saveButtonPressed(String name, String email, String message) {
    profileViewModel.contactUs(context, name, email, message);
  }
}
