import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/main.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/WebScreen/EditProfile.dart';
import 'package:tycho_streams/view/WebScreen/HomePageWeb.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
import 'package:tycho_streams/view/widgets/app_menu.dart';
import 'package:tycho_streams/view/widgets/search_view.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  HomeViewModel homeViewModel = HomeViewModel();
  ScrollController _scrollController = ScrollController();
  bool isSearch = false;
  int pageNum = 1;
  @override
  void initState() {
    searchController?.addListener(() {
      homeViewModel.getSearchData(
          context, '${searchController?.text}', pageNum);
    });
    super.initState();
  }
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    return ChangeNotifierProvider(
        create: (BuildContext context) => homeViewModel,
    child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
    return
    GestureDetector(
      onTap: (){
        if (isSearch == true)  {
          isSearch = false;
          searchController?.clear();
          setState(() {});
        }
        if( isLogins == true){
          isLogins=false;
          setState(() {

          });
        }
      },
      child: Scaffold(
      drawer: AppMenu(homeViewModel: viewmodel),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar:  PreferredSize(preferredSize: Size.fromHeight( 60),
            child: Container(
              height: 55,
              color: Theme.of(context).cardColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 40),
                  Image.asset(AssetsConstants.icLogo, height: 40),
                  Expanded(child: SizedBox(width: SizeConfig.screenWidth * .12)),
                  AppButton(context, 'Home', onPressed: () {
                    GoRouter.of(context)
                        .pushNamed(RoutesName.home);
                  }),
                  SizedBox(width: SizeConfig.screenWidth * .02),
                  AppButton(context, 'Contact US',
                      onPressed: () {
                        GoRouter.of(context).pushNamed(
                          RoutesName.Contact,
                        );
                      }),
                  Expanded(
                      child: SizedBox(
                          width: SizeConfig.screenWidth * .12)),
                  Container(
                      height: 45,
                      width: SizeConfig.screenWidth / 4.2,
                      alignment: Alignment.center,
                      child: AppTextField(
                          controller: searchController,
                          maxLine: searchController!.text.length > 2 ? 2 : 1,
                          textCapitalization:
                          TextCapitalization.words,
                          secureText: false,
                          floatingLabelBehavior:
                          FloatingLabelBehavior.never,
                          maxLength: 30,
                          labelText:
                          'Search videos, shorts, products',
                          keyBoardType: TextInputType.text,
                          onChanged: (m) {
                            isSearch = true;
                            if( isLogins == true){
                              isLogins=false;
                              setState(() {

                              });
                            }
                          },
                          isTick: null)),
                  SizedBox(width: SizeConfig.screenWidth * .02),
                  names == "null"
                      ? OutlinedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierColor: Colors.black87,
                            builder:
                                (BuildContext context) {
                              return const SignUp();
                            });
                      },
                      style: ButtonStyle(
                        overlayColor:
                        MaterialStateColor.resolveWith(
                                (states) =>
                            Theme.of(context)
                                .primaryColor),
                        fixedSize:
                        MaterialStateProperty.all(
                            Size.fromHeight(30)),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    5.0))),
                      ),
                      child: appTextButton(
                          context,
                          'SignUp',
                          Alignment.center,
                          Theme.of(context).canvasColor,
                          18,
                          true))
                      : appTextButton(
                      context,
                      names!,
                      Alignment.center,
                      Theme.of(context).canvasColor,
                      18,
                      true,
                      onPressed: () {
                        if (isSearch == true)  {
                          isSearch = false;
                       searchController?.clear();
                          setState(() {});
                        }

                      }),
                  names == "null"
                      ? SizedBox(
                      width: SizeConfig.screenWidth * .01)
                      : const SizedBox(),
                  names == "null"
                      ? OutlinedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierColor: Colors.black87,
                            builder:
                                (BuildContext context) {
                              return const LoginUp();
                            });
                      },
                      style: ButtonStyle(
                        overlayColor:
                        MaterialStateColor.resolveWith(
                                (states) =>
                            Theme.of(context)
                                .primaryColor),
                        fixedSize:
                        MaterialStateProperty.all(
                            Size.fromHeight(30)),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    5.0))),
                      ),
                      child: appTextButton(
                          context,
                          'Login',
                          Alignment.center,
                          Theme.of(context).canvasColor,
                          18,
                          true))
                      : GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogins = true;
                        if (isSearch == true)  {
                          isSearch = false;
                          searchController?.clear();
                          setState(() {});
                        }
                      });
                    },
                    child: Image.asset(
                      'images/LoginUser.png',
                      height: 30,
                      color:
                      Theme.of(context).accentColor,
                    ),
                  ),
                  SizedBox(width: SizeConfig.screenWidth * .02),
                ],
              ),
            )),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding:  EdgeInsets.only(left: 350,right: 350),
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Text('About', style: TextStyle(fontWeight: FontWeight.w600, fontSize: ResponsiveWidget.isMediumScreen(context)?16:22, color:  Theme.of(context).canvasColor),),
                        SizedBox(height: 20),
                        Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularized in the 1960s with the release of Letterset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', style: TextStyle(fontWeight: FontWeight.w400, fontSize: ResponsiveWidget.isMediumScreen(context)?14:18, color:  Theme.of(context).canvasColor)),
                        SizedBox(height: 20),
                        Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularized in the 1960s with the release of Letterset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', style: TextStyle(fontWeight: FontWeight.w400, fontSize: ResponsiveWidget.isMediumScreen(context)?14:18, color:  Theme.of(context).canvasColor)),
                        SizedBox(height: 20),
                        Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularized in the 1960s with the release of Letterset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', style: TextStyle(fontWeight: FontWeight.w400, fontSize: ResponsiveWidget.isMediumScreen(context)?14:18, color:  Theme.of(context).canvasColor)),
                        SizedBox(height: 20),
                        contactUswidget('images/ContactUs1.png', 'A-102, Sec-62, Noida UP 201301'),
                        SizedBox(height: 10),
                        contactUswidget('images/ContactUs.png', 'www.alifbaata.com'),
                        SizedBox(height: 350),

                      ],
                    ),
                  ),
                  ResponsiveWidget.isMediumScreen(context)?   footerMobile(context): footerDesktop()
                ],
              ),
            ),
            isLogins == true
                ?profile(context,setState)
                : Container(),
            if (viewmodel.searchDataModel != null)
              searchView(context, viewmodel, isSearch, _scrollController, homeViewModel, searchController!, setState)
          ],
        ),
      ),
    );
  }));}
  Widget contactUswidget(var img, String txt){
    return Row(
      children: [
        Image.asset(img, width: 20,height: 34,color:Theme.of(context).canvasColor),
        SizedBox(width: 10),
        Text(txt, style: TextStyle(fontWeight: FontWeight.w400, fontSize:ResponsiveWidget.isMediumScreen(context)? 16:22, color: Theme.of(context).canvasColor)),
      ],
    );
  }
}
