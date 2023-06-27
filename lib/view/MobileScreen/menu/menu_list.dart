import 'package:TychoStream/AppRouter.gr.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/view/widgets/AppDialog.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../../Utilities/AssetsConstants.dart';
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
    homeViewModel.getAppConfigData(context);
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
                    Column(children: buildMenuList(widget.menuItem?.appMenu, homeViewModel)),
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
                child: AppRegularFont(context, msg: menu.title, fontSize: 15)),
            leading: Image.network(menu.icon ?? '', height: 20, width: 20),
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
         context.router.push(FAQ());
         // homeViewModel.openWebHtmlView(context, 'faq', title: 'FAQ');
        } else if (appMenu.url?.contains('privacy_policy') == true) {
         context.router.push(Privacy());
          //homeViewModel.openWebHtmlView(context, url.path, title: appMenu.title);
        } else if (appMenu.url?.contains('terms_condition') == true){
         context.router.push(Terms());
         // homeViewModel.openWebHtmlView(context, url.path, title: appMenu.title);
        } else if (url.path.contains('about_us') == true) {
         context.router.push(FAQ());
         // homeViewModel.openWebHtmlView(context, 'about_us', title: appMenu.title);
        } else if (url.path == RoutesName.EditProfille){
         context.router.push(EditProfile());

         // AppNavigator.pushNamed(context, url.path, arguments: {'title': appMenu.title}, screenName: RouteBuilder.editProfile);
        } else if (url.path == RoutesName.ContactUs){
         context.router.push(FAQ());
         // AppNavigator.pushNamed(context, url.path, arguments: {'title': appMenu.title}, screenName: RouteBuilder.contactUs);
        }  else if (appMenu.title!.contains('Share') == true){
          Share.share(appMenu.url ?? '');
        } else {
          //AppNavigator.push(context, AppWebView(url: appMenu.url! ?? '', pageName: appMenu.title ?? '', isBack: true));
        }
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
