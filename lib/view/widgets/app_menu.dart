import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/model/data/app_menu_model.dart';

import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';


class AppMenu extends StatefulWidget {
  HomeViewModel? homeViewModel;

  AppMenu({Key? key, this.homeViewModel}) : super(key: key);

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  HomeViewModel homeViewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    getMenu();
  }

  getMenu() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.get('oldMenuVersion') == sharedPreferences.get('newMenuVersion')){
      homeViewModel.getAppMenuData(context);
    } else {
      homeViewModel.getAppMenu(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          final menuItem = viewmodel.appMenuModel;
          return SizedBox(
            width: SizeConfig.screenWidth * 0.60,
            child: Drawer(
                backgroundColor: Theme.of(context).cardColor,
                child: viewmodel.appMenuModel != null
                    ? Container(
                  padding: EdgeInsets.only(top: 40),
                        color: Theme.of(context).cardColor,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: menuItem?.appMenu?.length,
                            itemBuilder: (context, index) {
                              final appMenuItem = menuItem?.appMenu?[index];
                              return InkWell(
                                  onTap: () {
                                    onItemSelection(context, appMenuItem);
                                  },
                                  child: Column(
                                      children: [
                                        SizedBox(height: 5),
                                        appMenuItem?.url?.contains('dropdown') == true ?
                                        ExpansionTile(
                                            title: Text(appMenuItem?.title ?? '', style: TextStyle(color: Theme.of(context).canvasColor)),
                                            iconColor: Theme.of(context).primaryColor,
                                            collapsedIconColor: Theme.of(context).canvasColor,
                                            children: [
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: appMenuItem?.childNodes?.length,
                                                  physics: BouncingScrollPhysics(),
                                                  itemBuilder: (BuildContext? context, int index1) {
                                                    return appMenuItem?.childNodes?[index1].url?.contains('dropdown') == true ?
                                                    ExpansionTile(
                                                        title: Text(appMenuItem?.childNodes?[index1].title ?? '', style: TextStyle(color: Theme.of(context!).canvasColor)),
                                                        iconColor: Theme.of(context).primaryColor,
                                                        collapsedIconColor: Theme.of(context).canvasColor,
                                                        children: [
                                                          ListView.builder(
                                                              shrinkWrap: true,
                                                              physics: BouncingScrollPhysics(),
                                                              itemCount: appMenuItem?.childNodes?[index1].childNodes?.length,
                                                              itemBuilder: (BuildContext? context, int index2) {
                                                                return ListTile(
                                                                  title: Text(appMenuItem?.childNodes?[index1].childNodes?[index2].title ?? '', style: TextStyle(color: Theme.of(context!).canvasColor)),
                                                                  onTap: () {
                                                                    onItemSelection(context, appMenuItem?.childNodes?[index1].childNodes?[index2]);
                                                                  },
                                                                );
                                                              })
                                                        ]) :
                                                    ListTile(
                                                        title: Text(appMenuItem?.childNodes?[index1].title ?? '', style: TextStyle(color: Theme.of(context!).canvasColor)),
                                                        onTap: () {
                                                          onItemSelection(context, appMenuItem?.childNodes?[index1]);
                                                        });
                                                  })
                                            ]) :
                                        ListTile(
                                            title: Text(appMenuItem?.title ?? '', style: TextStyle(color: Theme.of(context).canvasColor),),
                                            onTap: () {
                                              onItemSelection(context, appMenuItem);
                                            })
                                      ]
                                  ));
                            }))
                    : Center(
                        child: CircularProgressIndicator(color: Theme.of(context).primaryColor))),
          );
        }));
  }

  void onItemSelection(BuildContext context, Menu? appMenu) {
    if(appMenu != null){
      if (appMenu.title?.contains('Share') == true) {
        Share.share(appMenu.url ?? '');
      } else if (appMenu.url?.contains('push_notification') == true) {
        // getPath(appMenu.url ?? '', RoutesName.pushNotification).then((routePath) {
        //   if (routePath != null) {
        //     Navigator.pushNamed(context, routePath, arguments: {'title': appMenu.title});
        //   }
        // });
      } else if (appMenu.url?.contains('terms-and-conditions') == true) {

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => AppWebView(url: appMenu.url, pageName: appMenu.title)));
      } else if (appMenu.url?.contains('privacy-policy') == true) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => AppWebView(url: appMenu.url, pageName: appMenu.title)));
      } else if (appMenu.url?.contains('profile') == true) {
        // getPath(appMenu.url ?? '', RoutesName.profilePage).then((routePath) {
        //   if (routePath != null) {
        //     Navigator.pushNamed(context, routePath, arguments: {'title': appMenu.title, 'isBack' : true});
        //   }
        // });
      } else if (appMenu.url?.contains('bottom_navigation') == true){
        // getPath(appMenu.url ?? '', RoutesName.bottomNavigation).then((routePath) {
        //   if (routePath != null) {
        //     // Navigator.pushNamed(context, routePath);
        //     Navigator.of(context)
        //         .pushNamedAndRemoveUntil(routePath, (Route<dynamic> route) => false);
        //   }
        // });
      } else if (appMenu.url?.contains('update_user') == true){
       // getPath(appMenu.url ?? '', RoutesName.editProfile).then((routePath) {
       //    if (routePath != null) {
       //      Navigator.pushNamed(context, routePath, arguments: {'title' : appMenu.title});
       //    }
       //  });
      } else if (appMenu.url?.contains('faqs') == true){
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => AppWebView(url: appMenu.url, pageName: appMenu.title)));
      } else if (appMenu.url?.contains('notify_setting') == true){
        // getPath(appMenu.url ?? '', RoutesName.notifysetting).then((routePath) {
        //   if (routePath != null) {
        //     Navigator.pushNamed(context, routePath, arguments: {'title' : appMenu.title});
        //   }
        // });
      }
    }
  }

}

Future<String?> getPath(String url, String pathName) async {
  RegExp pattern = RegExp(r"\" + '${pathName}');
  Match match = pattern.firstMatch(url) as Match;
  String? path = match.group(0);
  return path;
}
