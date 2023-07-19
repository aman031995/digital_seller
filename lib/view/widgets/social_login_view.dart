import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/sociallogin_view_model.dart';
class SocialLoginView extends StatefulWidget {
  SocialLoginViewModel? socialLoginViewModel;
  HomeViewModel? homeViewModel;

  SocialLoginView({Key? key, this.socialLoginViewModel, this.homeViewModel}) : super(key: key);

  @override
  State<SocialLoginView> createState() => _SocialLoginViewState();
}

class _SocialLoginViewState extends State<SocialLoginView> {
  HomeViewModel homeViewModel = HomeViewModel();

  @override
  void initState() {
    homeViewModel.getAppConfigData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final socialLogin =
        widget.homeViewModel?.appConfigModel?.androidConfig?.socialLogin;
    return ChangeNotifierProvider<HomeViewModel>(
      create: (BuildContext context) => homeViewModel,
      child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            socialLogin?.google != null
                ? socialNetworkButton(AssetsConstants.icGoogle, () {
              widget.socialLoginViewModel?.isGoogle = true;
              widget.socialLoginViewModel?.signInWithGoogle(context);
              Navigator.pop(context);   },context)
                : Container(),
            SizedBox(width: 10),
            socialLogin?.facebook != null
                ? socialNetworkButton(AssetsConstants.icFacebook, () {
              widget.socialLoginViewModel?.loginWithFB(context);
              widget.socialLoginViewModel?.isGoogle = false;
            },context)
                : Container(),


          ],
        );
      }),
    );
  }
}
