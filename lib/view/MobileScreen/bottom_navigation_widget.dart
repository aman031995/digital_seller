import 'package:TychoStream/model/data/AppConfigModel.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/TextStyling.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/view/MobileScreen/home_page.dart';
import 'package:TychoStream/view/MobileScreen/product_list_category.dart';
import 'package:TychoStream/view/MobileScreen/profile_page.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class BottomNavigationWidget extends StatefulWidget {

  BottomNavigationWidget({Key? key}) : super(key: key);

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedIndex = 0;
HomeViewModel homeViewModel=HomeViewModel();
  @override
  void initState() {
    homeViewModel.getAppConfigData(context);
    super.initState();
  }
List<String> bottomNav=["jgh","gjgj"];
  @override
  Widget build(BuildContext context) {
    return
      homeViewModel.appConfigModel!=null?
      Scaffold(
          body:Container(
            color: Colors.yellow,
          height: 500,width: 500,
            child: getPages(homeViewModel.appConfigModel!.androidConfig!.bottomNavigation![_selectedIndex]),
          ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).cardColor,
            unselectedItemColor: Theme.of(context).canvasColor,
            items: homeViewModel.appConfigModel!.androidConfig!.bottomNavigation!.map((e) => BottomNavigationBarItem(
                icon: Image.network(e.icon  ?? '', width: 20, height: 20),
                label: e.title, activeIcon: Image.network(e.icon ?? '', width: 23, height: 23))).toList(),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedLabelStyle: CustomTextStyle.textFormFieldInterMedium.copyWith(color: BLACK_COLOR, fontSize: 15),
            type: BottomNavigationBarType.fixed,
            fixedColor: Theme.of(context).primaryColor,
          )):
      Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));


  }

  // method for handling bottom nav clicks
  getPages(BottomNavigation navItem) {
    Uri url = Uri.parse(navItem.url ?? '');
    if(url.path == RoutesName.home){
      return Container(
        height: 500,width: 500,color: Colors.pink,
      );
    } else if (url.path == RoutesName.profilePage){
      return ProfilePage();
    } else if (url.path == RoutesName.productPage){
      return ProductListMobileGallery();
    }
  }

  //OnItemTapped Method
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}


