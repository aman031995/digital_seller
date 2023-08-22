import 'package:TychoStream/AppRouter.gr.dart';
import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/view/Profile/order_details.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../../../model/data/app_menu_model.dart';

class MenuList extends StatefulWidget {
  AppMenuModel? menuItem;


  MenuList({Key? key, required this.menuItem}) : super(key: key);

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  HomeViewModel homeViewModel = HomeViewModel();


  @override
  void initState() {
    homeViewModel.getAppConfig(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).cardColor,
        child: widget.menuItem != null
            ? Column(children: [
          Expanded(
              flex: 90,
              child: ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: [
                    SizedBox(height: 10),
                    Image.asset(
                      "images/CG-icon(2).webp",
                      width: 70,
                      height: 70,

                    ),
                    Column(children: buildMenuList(widget.menuItem?.appMenu, homeViewModel)),
                    names == "null"
                        ? GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return LoginUp();
                              });
                        },
                        child: Row(
                          children: [
                            SizedBox(width: 15),
                            Image.asset(AssetsConstants.icProfile,
                                width: 20,
                                height: 20,
                                color:  Theme.of(context).canvasColor),
                            SizedBox(width: 10),
                            AppRegularFont(context, msg: "SignIn", fontSize: 15,color: Theme.of(context).canvasColor),
                          ],
                        ))
                        : GestureDetector(
                      onTap: () {
                        if (isSearch == true) {
                          isSearch = false;
                        }
                        context.router.push(EditProfile());
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          Image.asset(AssetsConstants.icProfile,
                              width: 20,
                              height: 20,
                              color:  Theme.of(context).canvasColor),
                          SizedBox(width: 10),
                          AppRegularFont(context, msg:  StringConstant.profile,fontSize: 15,color: Theme.of(context).canvasColor)
                        ],
                      ),
                    ),
                  SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        names == "null"?
                        showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return LoginUp();
                                }):context.pushRoute(MyOrderPage());
                        if (isSearch == true) {
                          isSearch = false;

                        }
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          Image.asset(AssetsConstants.ic_myOrder,
                              width: 20,
                              height: 20,
                              color:  Theme.of(context).canvasColor.withOpacity(0.6)),
                          SizedBox(width: 10),
                          AppRegularFont(context, msg: StringConstant.myOrder,fontSize: 15,color: Theme.of(context).canvasColor)
                        ],
                      ),
                    ),
                    ChangeNotifierProvider.value(
                        value: homeViewModel,
                      child: Consumer<HomeViewModel>(builder: (context, viewmodel, _){
                        final followUs = viewmodel.appConfigModel?.androidConfig?.socialMedia;
                        return followUs != null ?
                        ListTile(
                           // onTap: () => AppDialog.followSocialDialog(context, 'Follow Us', followUs),
                            title: Transform(
                                transform: Matrix4.translationValues(-20, 0.0, 0.0),
                                child: AppRegularFont(context, msg: 'Follow Us', fontSize: 15)),
                            leading: Icon(Icons.library_add_check)
                        ) : SizedBox();
                      }))
                  ])),
         ])
            : Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)));
  }

  // method that returns menu
  buildMenuList(List<Menu>? appMenu, HomeViewModel homeViewModel) {
    return appMenu?.map((menu) {
      if (menu.childNodes!.isEmpty) {
        return ListTile(
            title: Transform(
                transform: Matrix4.translationValues(-20, 0.0, 0.0),
                child: AppRegularFont(context, msg: menu.title, fontSize: 15,color: Theme.of(context).canvasColor)),
            leading: Image.network(menu.icon ?? '', height: 20, width: 20,color: Theme.of(context).canvasColor.withOpacity(0.6)),
        onTap: () => onItemSelection(context, menu, homeViewModel));
      } else {
        return ExpansionTile(
            iconColor: Theme.of(context).primaryColor,
            collapsedIconColor: Theme.of(context).canvasColor,
            title: Transform(
                transform: Matrix4.translationValues(-20, 0.0, 0.0),
                child: AppRegularFont(context, msg: menu.title, fontSize: 15)),
            leading: Image.network(menu.icon ?? '', height: 20, width: 20),
            children: buildMenuList(menu.childNodes, homeViewModel));
      }
    }).toList();
  }

  // method of menu selection handling
  void onItemSelection(BuildContext context, Menu? appMenu, HomeViewModel homeViewModel) {
    if (appMenu != null) {
      CommonMethods.breakUrls(appMenu.url ?? '').then((url) {
       if(url.path.contains('faq') == true){

        } else if (appMenu.url?.contains('privacy_policy') == true) {
         context.router.push(WebHtmlPage(title:'PrivacyPolicy',html: 'privacy_policy' ));


       } else if (appMenu.url?.contains('terms_condition') == true){
         context.router.push(WebHtmlPage(title:'TermsAndCondition',html: 'terms_condition' ));


       } else if (url.path.contains('about_us') == true) {
         context.router.push(WebHtmlPage(title:'AboutUs',html: 'about_us'));


       } else if (url.path == RoutesName.EditProfille){
         context.router.push(EditProfile());

        } else if (url.path == RoutesName.ContactUs){
        }
       else if (appMenu.title!.contains('Share') == true){
          Share.share(appMenu.url ?? '');
         }
       else if (appMenu.title!.contains('Home') == true){
         context.router.push(HomePageWeb());

       }


       else {}
      });
    }
  }

  // app version widget
  versionWidget( BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 5),
        alignment: Alignment.bottomCenter,
        child: AppBoldFont(context,
            msg: 'version: ' + '' + '',
            fontSize: 14,
            color: Theme.of(context).primaryColor));
  }
}
