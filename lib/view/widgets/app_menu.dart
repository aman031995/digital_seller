import 'package:flutter/material.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/network/CacheDataManager.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/WebScreen/HomePageWeb.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';

class AppMenu extends StatefulWidget {
  HomeViewModel? homeViewModel;

  AppMenu({Key? key, this.homeViewModel}) : super(key: key);

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Drawer(
      width: 250,
      backgroundColor: LIGHT_THEME_BACKGROUND,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
           SizedBox(height: 50),
              Center(
                child: Container(
                    height: 80,
                    width: 80,
                    child: Image.asset('images/app_logo.png',fit: BoxFit.fill,)),
              ),
              SizedBox(height: 20),
              InkWell(

                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Home',
                  style: TextStyle(color:  Colors.black, fontSize: 22),
                ),
              ),
              Divider(
                color: Colors.blueGrey.shade400,
                thickness: 2,
              ),

              name=="a"?  InkWell(

                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      barrierDismissible:false,
                      barrierColor: Colors.black87,
                      builder: (BuildContext context) {
                        return LoginUp();
                      }
                  );
                },
                child: Text(
                   'Login',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ):InkWell(
                onTap: (){
                  logoutButtonPressed();
                },
                child: Text("LogOut",style: TextStyle(color: Colors.black, fontSize: 22)),
              ),
              Divider(
                color: Colors.blueGrey.shade400,
                thickness: 2,
              ),
              // InkWell(
              //
              //   onTap: () {
              //     Navigator.pop(context);
              //           showDialog(
              //               context: context,
              //               barrierDismissible:false,
              //               barrierColor: Colors.black87,
              //               builder: (BuildContext context) {
              //                 return SignUp();
              //               }
              //     );
              //   },
              //   child: Text(
              //     name=="a"?name  : 'SignUp',
              //     style: TextStyle(color: Colors.black, fontSize: 22),
              //   ),
              // ),
              // Divider(
              //   color: Colors.blueGrey.shade400,
              //   thickness: 2,
              // ),
              InkWell(

                onTap: () {

                },
                child: Text(
                  'Contact Us',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),


              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Copyright © 2023 | TychoStream',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  logoutButtonPressed() async {
    AppDataManager.deleteSavedDetails();
    CacheDataManager.clearCachedData();
    await Future.delayed(const Duration(milliseconds:100)).then((value) =>Navigator.pushNamedAndRemoveUntil(context, '/HomePage', (route) => false));

  }
}
