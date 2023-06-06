import 'package:TychoStream/view/MobileScreen/menu/menu_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/model/data/app_menu_model.dart';

import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';


class AppMenu extends StatefulWidget {


  AppMenu({Key? key}) : super(key: key);

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  HomeViewModel homeViewModel = HomeViewModel();

  @override
  void initState() {
    homeViewModel.getAppMenuData(context);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          return SizedBox(
              width: SizeConfig.screenWidth * 0.60,
              child: MenuList(
                  menuItem: viewmodel.appMenuModel));
        }));
  }



}
