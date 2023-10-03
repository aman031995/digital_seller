import 'package:TychoStream/AppRouter.gr.dart';
import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/model/data/AppConfigModel.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../model/data/app_menu_model.dart';
import '../../widgets/AppDialog.dart';

class MenuList extends StatefulWidget {
  final AppMenuModel? menuItem;


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
    return ChangeNotifierProvider.value(
        value: homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
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
                            AssetsConstants.webLogo,
                            width: 70,
                            height: 70,
                          ),
                          viewmodel.appConfigModel != null
                              ? Container(
                            width: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: viewmodel
                                  .appConfigModel!.androidConfig!.bottomNavigation!
                                  .map((e) {
                                return ListTile(
                                    title: Transform(
                                        transform: Matrix4.translationValues(-20, 0.0, 0.0),
                                        child: AppRegularFont(context, msg: e.title, fontSize: 15,color: Theme.of(context).canvasColor)),
                                    leading: Image.network(e.icon ?? '', height: 20, width: 20,color: Theme.of(context).canvasColor.withOpacity(0.6)),
                                    onTap: (){getPages(e, context);});
                              }).toList(),
                            ),
                          )
                              : Center(
                            child: Container(
                              width: 300,
                              height: 50,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    return Shimmer.fromColors(
                                        period: Duration(milliseconds: 1000),
                                        baseColor: Colors.black38.withOpacity(0.4),
                                        highlightColor:
                                        Colors.black38.withOpacity(0.1),
                                        child: Container(
                                          margin: EdgeInsets.all(8),
                                          width: 80,
                                          height: 30,
                                          color: Colors.grey,
                                        ));
                                  }),
                            ),
                          ),
                          Column(children: buildMenuList(widget.menuItem?.appMenu, homeViewModel)),

                          ListTile(
                              title: Transform(
                                  transform: Matrix4.translationValues(-20, 0.0, 0.0),
                                  child: AppRegularFont(context, msg:StringConstant.myOrder, fontSize: 15,color: Theme.of(context).canvasColor)),
                              leading: Image.asset(AssetsConstants.ic_myOrder, height: 20, width: 20,color: Theme.of(context).canvasColor.withOpacity(0.8)),
                              onTap: () {
                                GlobalVariable.names == "null"?
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return LoginUp();
                                    }):context.pushRoute(MyOrderPage());
                                if (GlobalVariable.isSearch == true) {
                                  GlobalVariable.isSearch = false;
                                }
                              }),
                          ChangeNotifierProvider.value(
                              value: homeViewModel,
                              child: Consumer<HomeViewModel>(builder: (context, viewmodel, _){
                                final followUs = viewmodel.appConfigModel?.androidConfig?.socialMedia;
                                return followUs != null ?
                                ListTile(
                                    onTap: () => AppDialog.followSocialDialog(context, StringConstant.followus, followUs),
                                    title: Transform(
                                        transform: Matrix4.translationValues(-20, 0.0, 0.0),
                                        child: AppRegularFont(context, msg: StringConstant.followus, fontSize: 15)),
                                    leading: Icon(Icons.library_add_check,color: Theme.of(context).canvasColor.withOpacity(0.4))
                                ) : SizedBox();
                              }))
                        ])),
              ])
                  : Center(child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 2)));
        }));
  }

  getPages(BottomNavigation navItem, BuildContext context) {
    Uri url = Uri.parse(navItem.url ?? '');
    if (url.path == RoutesName.homepageweb) {
      closeAppbarProperty();


      return context.router.push(HomePageWeb());
    } else if (url.path == RoutesName.productPage) {
      closeAppbarProperty();

      return context.router.push(ProductListGallery());
    } else if (url.path == RoutesName.profilePage) {                      closeAppbarProperty();


    GlobalVariable.names == "null"
        ? showDialog(
        context: context,
        barrierColor: Theme.of(context).canvasColor.withOpacity(0.6),
        builder: (BuildContext context) {
          return LoginUp(
            product: true,
          );
        })
        : context.router.push(EditProfile());
    }
  }
  // method that returns menu
  buildMenuList(List<Menu>? appMenu, HomeViewModel homeViewModel) {
    return appMenu?.map((menu) {
      if (menu.childNodes!.isEmpty) {
        return menu.title=="Home"?Container() :ListTile(
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
            leading: Image.network(menu.icon ?? '', height: 20, width: 20,color: Theme.of(context).canvasColor.withOpacity(0.6)),
            children: buildMenuList(menu.childNodes, homeViewModel));
      }
    }).toList();
  }

  // method of menu selection handling
  void onItemSelection(BuildContext context, Menu? appMenu, HomeViewModel homeViewModel) {
    if (appMenu != null) {
      CommonMethods.breakUrls(appMenu.url ?? '').then((url) async {
        if(url.path.contains('faq') == true){
          context.router.push(WebHtmlPage(
              title:
              'FAQ',
              html:
              'faq'));

        }
        else if (appMenu.url?.contains('return_policy') == true) {
          context.router.push(WebHtmlPage(
              title:
              'ReturnPolicy',
              html:
              'return_policy'));

        }
        else if (appMenu.url?.contains('privacy_policy') == true) {
          context.router.push(WebHtmlPage(title:'PrivacyPolicy',html: 'privacy_policy' ));


        }
        else if (appMenu.url?.contains('terms_condition') == true){
          context.router.push(WebHtmlPage(title:'TermsAndCondition',html: 'terms_condition' ));


        }
        else if (url.path.contains('about_us') == true) {
          context.router.push(WebHtmlPage(title:'AboutUs',html: 'about_us'));


        } else if (url.path == RoutesName.EditProfille){
          context.router.push(EditProfile());

        }
        else if (url.path.contains('contact_us') == true){
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
            context.router.push(ContactUs());
          }
        }
        else if (appMenu.title!.contains('Share') == true){
          Share.share(appMenu.url ?? '');
        }
        else if (appMenu.title!.contains('Home') == true){
          context.router.push(HomePageRestaurant());

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