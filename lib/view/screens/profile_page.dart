import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/model/data/TermsPrivacyModel.dart';
import 'package:tycho_streams/model/data/UserInfoModel.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/repository/get_image_files_provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/view/widgets/image_source.dart';
import 'package:tycho_streams/view/widgets/profile_bottom_view.dart';
import 'package:tycho_streams/viewmodel/profile_view_model.dart';
import 'login_screen.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileViewModel profileViewModel = ProfileViewModel();

  @override
  void initState() {
    if (names.length == 4) {
      profileViewModel.getTermsPrivacy(context);
    }
    profileViewModel.getProfileDetails(context);
    super.initState();
  }

  //-------Profile Screen---------
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final profileVM = Provider.of<ProfileViewModel>(context);
    return ChangeNotifierProvider<ProfileViewModel>(
        create: (BuildContext context) => profileViewModel,
        child: Consumer<ProfileViewModel>(builder: (context, viewmodel, _) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: SizeConfig.screenWidth,
                      margin: EdgeInsets.only(
                          top: 25, left: 20, right: 20, bottom: 20),
                      decoration: BoxDecoration(
                          color: WHITE_COLOR,
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black12.withOpacity(0.1),
                              spreadRadius: 1.0,
                              blurRadius: 1.0,
                              offset: Offset(0, 1),
                            )
                          ],
                          borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Stack(
                          children: [
                            Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: WHITE_COLOR,
                                  radius: 57,
                                  child: CircleAvatar(
                                    backgroundColor: YELLOW_COLOR,
                                    backgroundImage: NetworkImage(
                                        viewmodel.userInfoModel?.profilePic ??
                                            ''),
                                    radius: 55.0,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(top: 20),
                                  child: AppBoldFont(
                                      msg: (viewmodel.userInfoModel?.name ?? ''),
                                      color: BLACK_COLOR,
                                      fontSize: 19),
                                ),
                              ],
                            )),
                            Positioned(
                              left: (SizeConfig.screenWidth! * 0.44),
                              bottom: 60,
                              child: IconButton(
                                alignment: Alignment.bottomCenter,
                                onPressed: () {
                                  // _askVideoPermission(profileVM);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          PhotoAndVideoPopUp(
                                            onCameraSelection: () {
                                              GetImageFile.pickImage(
                                                  ImageSource.camera, context,
                                                  (result, isSuccess) {
                                                if (isSuccess) {
                                                  profileVM.imageUpload(context, result);
                                                }
                                              });
                                            },
                                            onGallerySelection: () {
                                              GetImageFile.pickImage(
                                                  ImageSource.gallery, context,
                                                  (result, isSuccess) {
                                                if (isSuccess) {
                                                  profileVM.imageUpload(
                                                      context, result);
                                                }
                                              });
                                            },
                                          ));
                                },
                                icon: Image.asset(
                                  AssetsConstants.icAddImage,
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 25, left: 20, right: 20, bottom: 20),
                      decoration: BoxDecoration(
                          color: WHITE_COLOR,
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black12.withOpacity(0.1),
                              spreadRadius: 1.0,
                              blurRadius: 1.0,
                              offset: Offset(0, 1),
                            )
                          ],
                          borderRadius: BorderRadius.circular(12)),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: names.length,
                          itemExtent: 48,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                onItemSelection(context, index);
                              },
                              child: Container(
                                  margin: EdgeInsets.only(left: 15, right: 5),
                                  color: WHITE_COLOR,
                                  height: 55,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Expanded(
                                      //     flex: 5,
                                      //     child: Container(
                                      //         child: Image.asset(
                                      //             _namesIcon[index],
                                      //             width: 23,
                                      //             height: 23))),
                                      SizedBox(width: 15),
                                      Expanded(
                                          flex: 90,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: AppRegularFont(
                                                msg: names[index],
                                                fontSize: 16,
                                                color: BLACK_COLOR,
                                                textAlign: TextAlign.center),
                                          )),
                                      Expanded(
                                          flex: 10,
                                          child: Container(
                                              child: Icon(Icons.arrow_right))),
                                      // AppRegularFont(
                                      //     msg: _names[index],
                                      //     fontSize: 16,
                                      //     color: BLACK_COLOR,
                                      //     textAlign: TextAlign.center),
                                      // Icon(Icons.arrow_right),
                                    ],
                                  )),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
    // : Center(child: CircularProgressIndicator());
  }

  //--------Profile Screen Item Selection---------
  void onItemSelection(BuildContext context, int index) {
    if (index == 0) {
    } else if (index == 1) {
    } else if (index == 2) {
    } else if (index == 3) {
      print('terms');
    } else if (index == 4) {
      print('policy');
    } else if (index == 5) {
      logoutButtonPressed(context);
      setState(() {
      });
    }
  }

  BoxDecoration homeBoxDecoration() {
    return BoxDecoration(
      color: WHITE_COLOR,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      boxShadow: [
        new BoxShadow(
          color: Colors.black12.withOpacity(0.1),
          spreadRadius: 1.5,
          blurRadius: 1.5,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  // login button function
  logoutButtonPressed(BuildContext context) async {
    AppDataManager.deleteSavedDetails();
    await Future.delayed(const Duration(seconds: 1)).then((value) =>
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false));
  }
}
