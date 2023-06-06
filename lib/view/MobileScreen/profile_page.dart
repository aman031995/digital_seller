import 'package:TychoStream/network/AppDataManager.dart';
import 'package:TychoStream/network/CacheDataManager.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Utilities/AssetsConstants.dart';
import '../widgets/profile_bottom_view.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileViewModel profileViewModel = ProfileViewModel();
  final HomeViewModel homeViewModel = HomeViewModel();
  String? checkInternet;
  String logFilePath = '';

  @override
  void initState() {
    profileViewModel.getUserDetails(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //-------Profile Screen---------
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return ChangeNotifierProvider.value(
        value: profileViewModel,
        child: Consumer<ProfileViewModel>(builder: (context, viewmodel, _) {
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: getAppBarWithBackBtn(
                context: context,
                title: StringConstant.profile,
                isBackBtn: false,
                onBackPressed: () {
                  Navigator.pop(context, true);
                }),
            body: checkInternet == "Offline"
                ? NOInternetScreen()
                : viewmodel.userInfoModel != null
                    ? SingleChildScrollView(
                        child: Column(children: [
                          _profileImageView(viewmodel),
                        _profileTopView(viewmodel),
                        Divider(height: 1, color: Theme.of(context).canvasColor.withOpacity(0.5)),
                        _profileBottomView(viewmodel),
                        SizedBox(height: 10)
                      ]))
                    : Center(child: ThreeArchedCircle(size: 45.0)),
          );
        }));
  }

  _profileImageView(ProfileViewModel viewmodel) {
    return Container(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              // AppNavigator.push(
              //     context,
              //     FullImage(
              //         imageUrl:
              //         '${viewmodel.userInfoModel?.profilePic ?? widget.viewmodel?.userInfoModel?.profilePic ?? profileImg}'));
            },
            child: CircleAvatar(
              backgroundColor: WHITE_COLOR,
              radius: 57,
              child: CachedNetworkImage(
                imageUrl:
                '${viewmodel.userInfoModel?.profilePic ??
                ""}',
                imageBuilder: (context, imageProvider) => Container(
                  width: 110.0,
                  height: 110.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
              ),
            ),
          ),
          Positioned(
            left: 75,
            top: 60,
            child: IconButton(
              alignment: Alignment.bottomCenter,
              onPressed: () => viewmodel.uploadProfileImage(context),

              // CommonMethods.uploadImageVideo(context, viewmodel),
              icon: Image.asset(
                AssetsConstants.icAddImage,
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
  //--------Profile Screen Item Selection---------
  void onItemSelection(
      BuildContext context, int index, ProfileViewModel viewmodel) {
    // if (index == 0) {
    //   AppNavigator.push(context, EditProfile(viewmodel: viewmodel),
    //       screenName: RouteBuilder.editProfile);
    // } else if (index == 1) {
    //   AppNavigator.push(context, MyOrderPage(),
    //       screenName: RouteBuilder.myOrderPage);
    // } else if (index == 2) {
    //   AppDialog.deleteDialogue(context,
    //       onTap: () => viewmodel.deleteProfile(context));
    // } else if (index == 3) {
    //   homeViewModel.openWebHtmlView(context, 'terms_condition',
    //       title: 'Terms And Condition');
    //   CommonMethods.setScreenName(RouteBuilder.termsCondition);
    // } else if (index == 4) {
    //   homeViewModel.openWebHtmlView(context, 'privacy_policy',
    //       title: 'Privacy Policy');
    //   CommonMethods.setScreenName(RouteBuilder.privacyPolicy);
    // } else if (index == 5) {
    //   logoutButtonPressed(context);
    //   setState(() {});
    // }
  }

  // top view
  _profileTopView(ProfileViewModel viewmodel) {
    return Container(
        height: 200,
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Stack(children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      // AppNavigator.push(
                      //     context,
                      //     FullImage(
                      //         imageUrl:
                      //             viewmodel.userInfoModel?.profilePic ?? ''));
                    },
                    child: CircleAvatar(
                      backgroundColor: WHITE_COLOR,
                      radius: 57,
                      child: CachedNetworkImage(
                        imageUrl: viewmodel.userInfoModel?.profilePic ?? '',
                        imageBuilder: (context, imageProvider) => Container(
                          width: 110.0,
                          height: 110.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
                                color: Theme.of(context).primaryColor),
                      ),
                    )),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 20),
                  child: AppBoldFont(context,
                      msg: (viewmodel.userInfoModel?.name ?? ''), fontSize: 19),
                )
              ]),
          // Positioned(
          //     left: (SizeConfig.screenWidth * 0.5),
          //     bottom: 60,
          //     child: IconButton(
          //         alignment: Alignment.bottomCenter,
          //         onPressed: () =>
          //             //CommonMethods.uploadImageVideo(context, viewmodel),
          //         icon: Image.asset(
          //           AssetsConstants.icAddImage,
          //           height: 30,
          //           width: 30,
          //         ))


        ]));
  }

  //bottom view
  _profileBottomView(ProfileViewModel viewmodel) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
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
                    onItemSelection(context, index, viewmodel);
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 15, right: 5),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      height: 55,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 5,
                                child: Container(
                                    child: Image.asset(namesIcon[index],
                                        width: 25,
                                        height: 25,
                                        color: Theme.of(context).canvasColor))),
                            SizedBox(width: 15),
                            Expanded(
                                flex: 90,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: AppMediumFont(context,
                                      msg: names[index],
                                      fontSize: 16,
                                      textAlign: TextAlign.center),
                                )),
                            Expanded(
                                flex: 10,
                                child: Container(
                                    child: Image.asset(
                                        AssetsConstants.icNextArrow,
                                        height: 12,
                                        width: 12,
                                        color: Theme.of(context).canvasColor))),
                          ])));
            }));
  }

  // // ad view
  // _bannerAdView() {
  //   return ChangeNotifierProvider.value(
  //       value: adsViewModel,
  //       child: Consumer<AdsViewModel>(builder: (context, viewmodel, _) {
  //         return viewmodel.isBannerAdReady
  //             ? Align(
  //                 alignment: Alignment.bottomCenter,
  //                 child: Container(
  //                   width: viewmodel.bannerAd!.size.width.toDouble(),
  //                   height: viewmodel.bannerAd!.size.height.toDouble(),
  //                   child: AdWidget(ad: viewmodel.bannerAd!),
  //                 ))
  //             : SizedBox();
  //       }));
  // }

  // login button function
  logoutButtonPressed(BuildContext context) async {
    AppDataManager.deleteSavedDetails();
    CacheDataManager.clearCachedData(key: StringConstant.kPrivacyTerms);
    CacheDataManager.clearCachedData(key: StringConstant.kUserDetails);
    CacheDataManager.clearCachedData(key: StringConstant.kBannerList);
    CacheDataManager.clearCachedData(key: StringConstant.kCategoryList);
    CacheDataManager.clearCachedData(key: StringConstant.kAppMenu);
    // await Future.delayed(const Duration(seconds: 1)).then((value) =>
    //     AppNavigator.pushNamedAndRemoveUntil(context, RoutesName.login,
    //         screenName: RouteBuilder.loginPage));
  }
}
