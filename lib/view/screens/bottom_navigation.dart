import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/TextStyling.dart';
import 'package:tycho_streams/view/screens/home_page.dart';
import 'package:tycho_streams/view/screens/profile_page.dart';
import 'package:tycho_streams/view/screens/category_screen.dart';

class BottomNavigation extends StatefulWidget {
  int? index = 0;

  BottomNavigation({Key? key, this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BottomNavigationState();
  }
}

class _BottomNavigationState extends State<BottomNavigation> {
  int? _currentPageIndex = 0;
  List<Widget> _pages = [];
  String? profileType;

  Widget _getCurrentPage() => _pages[_currentPageIndex!];
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _pages.add(HomePage());
    _pages.add(CategoryScreen());
    _pages.add(ProfilePage());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _getCurrentPage(),
        floatingActionButton: keyboardIsOpened
            ? null
            : Padding(
          padding: EdgeInsets.only(top: 20),
          child: SizedBox(
            height: 60,
            width: 60,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: WHITE_COLOR,
          unselectedItemColor: GREY_COLOR,
          currentIndex: _currentPageIndex!,
          onTap: (index) {
            setState(() {
              _currentPageIndex = index;
            });
            if (_currentPageIndex == 1) {
              isSelected = true;
            } else {
              isSelected = false;
            }
          },
          items: [
            BottomNavigationBarItem(
              backgroundColor: WHITE_COLOR,
              icon: Image.asset(AssetsConstants.icHome,
                  width: 20, height: 20),
              label: 'Home',
              activeIcon: Image.asset(AssetsConstants.icSelectHome,
                  width: 23, height: 23),
            ),
            BottomNavigationBarItem(
              backgroundColor: WHITE_COLOR,
              icon: Image.asset(AssetsConstants.icCategory,
                width: 20, height: 20),
              label: 'Category',
              activeIcon: Image.asset(AssetsConstants.icSelectCategory,
                  width: 23, height: 23),
            ),
            BottomNavigationBarItem(
              backgroundColor: WHITE_COLOR,
              icon: Image.asset(AssetsConstants.icProfile,
                width: 20, height: 20),
              label: 'Profile',
              activeIcon: Image.asset(AssetsConstants.icSelectProfile,
                  width: 23, height: 23),
            )
          ],
          selectedLabelStyle: _currentPageIndex == 0 ||
              _currentPageIndex == 1 ||
              _currentPageIndex == 2
              ? CustomTextStyle.textFormFieldInterMedium
              .copyWith(color: BUTTON_ONCLICK_COLOR, fontSize: 15)
              : CustomTextStyle.textFormFieldInterMedium
              .copyWith(color: BLACK_COLOR, fontSize: 15),
          type: BottomNavigationBarType.fixed,
          fixedColor: THEME_COLOR,
        ),
      ),
    );
  }
}