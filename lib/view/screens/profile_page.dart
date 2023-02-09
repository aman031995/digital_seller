import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/model/data/TermsPrivacyModel.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/repository/get_image_files_provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/widgets/AppDialog.dart';
import 'package:tycho_streams/view/widgets/AppNavigationBar.dart';
import 'package:tycho_streams/view/widgets/FullImageView.dart';
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
    getUserDetail();
    super.initState();
  }

  getUserDetail() {
    profileViewModel.getProfileDetails(context);
  }

  //-------Profile Screen---------
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider<ProfileViewModel>(
        create: (BuildContext context) => profileViewModel,
        child: Consumer<ProfileViewModel>(builder: (context, viewmodel, _) {
          return Scaffold(
            appBar: getAppBarWithBackBtn(context: context, title: StringConstant.profile, isBackBtn: false),
              body: SafeArea(
                  child: SingleChildScrollView(
                      child: Column(children: [
            Container(
                height: 200,
                width: SizeConfig.screenWidth,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Stack(children: [
                  Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => FullImage(
                                        imageUrl: viewmodel.userInfoModel
                                                ?.profilePic ??
                                            '')));
                          },
                          child: CircleAvatar(
                              backgroundColor: WHITE_COLOR,
                              radius: 57,
                              child: CircleAvatar(
                                backgroundColor: LIGHT_THEME_BACKGROUND,
                                backgroundImage: NetworkImage(
                                    viewmodel.userInfoModel?.profilePic ??
                                        ''),
                                radius: 55.0,
                              )),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 20),
                          child: AppBoldFont(
                              msg: (viewmodel.userInfoModel?.name ?? ''),
                              color: BLACK_COLOR,
                              fontSize: 19),
                        )
                      ])),
                  Positioned(
                      left: (SizeConfig.screenWidth * 0.5),
                      bottom: 60,
                      child: IconButton(
                          alignment: Alignment.bottomCenter,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    PhotoAndVideoPopUp(
                                        onCameraSelection: () {
                                      GetImageFile.pickImage(
                                          ImageSource.camera, context,
                                          (result, isSuccess) {
                                        if (isSuccess) {
                                          viewmodel.imageUpload(
                                              context, result);
                                        }
                                      });
                                    }, onGallerySelection: () {
                                      GetImageFile.pickImage(
                                          ImageSource.gallery, context,
                                          (result, isSuccess) {
                                        if (isSuccess) {
                                          viewmodel.imageUpload(
                                              context, result);
                                        }
                                      });
                                    }));
                          },
                          icon: Image.asset(
                            AssetsConstants.icAddImage,
                            height: 30,
                            width: 30,
                          )))
                ])),
            Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Divider(
                  color: TOAST_COLOR,
                )),
            Container(
                color: WHITE_COLOR,
                margin: EdgeInsets.only(left: 10, right: 30),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: names.length,
                    itemExtent: 48,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            onItemSelection(context, index, viewmodel,
                                viewmodel.termsPrivacyModel);
                          },
                          child: Container(
                              margin: EdgeInsets.only(left: 15, right: 5),
                              color: WHITE_COLOR,
                              height: 55,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        flex: 5,
                                        child: Container(
                                            child: index == 4 || index == 3
                                                ? Image.network(
                                                    namesIcon[index],
                                                    width: 23,
                                                    height: 23)
                                                : Image.asset(namesIcon[index],
                                                    width: 23, height: 23))),
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
                                            child: Image.asset(
                                                AssetsConstants.icNextArrow,
                                                height: 12,
                                                width: 12))),
                                  ])));
                    })),
            SizedBox(height: 10),
          ]))));
        }));
    // : Center(child: CircularProgressIndicator());
  }

  //--------Profile Screen Item Selection---------
  void onItemSelection(BuildContext context, int index,
      ProfileViewModel viewmodel, List<TermsPrivacyModel>? termsPrivacyModel) {
    if (index == 0) {
      GoRouter.of(context).pushNamed(RoutesName.editProfile, extra: viewmodel);
    } else if (index == 1) {
    } else if (index == 2) {
      AppDialog.deleteDialogue(context,
          onTap: () => viewmodel.deleteProfile(context));
    } else if (index == 3) {
      GoRouter.of(context).pushNamed(RoutesName.privacyTerms, params: {
        'title': '${termsPrivacyModel?[1].pageTitle}',
        'description': '${termsPrivacyModel?[1].pageDescription}'
      });
    } else if (index == 4) {
      GoRouter.of(context).pushNamed(RoutesName.privacyTerms, params: {
        'title': '${termsPrivacyModel?[0].pageTitle}',
        'description': '${termsPrivacyModel?[0].pageDescription}'
      });
    } else if (index == 5) {
      logoutButtonPressed(context);
      setState(() {});
    }
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
