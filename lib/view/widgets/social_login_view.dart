import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/viewmodel/sociallogin_view_model.dart';

class SocialLoginView extends StatefulWidget {
  SocialLoginViewModel? socialLoginViewModel;
  SocialLoginView({Key? key, this.socialLoginViewModel}) : super(key: key);

  @override
  State<SocialLoginView> createState() => _SocialLoginViewState();
}

class _SocialLoginViewState extends State<SocialLoginView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        socialNetworkButton(AssetsConstants.icGoogle, () {
          isGoogle = true;
          widget.socialLoginViewModel?.loginWithGoogle(context);
        }),
        SizedBox(width: 10),
        socialNetworkButton(AssetsConstants.icFacebook, () {
          widget.socialLoginViewModel?.loginWithFB(context);
          isGoogle = false;
        }),
        SizedBox(width: 10),
        Platform.isIOS ? socialNetworkButton(AssetsConstants.icApple, () {
          // loginWithFB(context, fcmToken!);
          // isGoogle = false;
        }) : SizedBox(),
      ],
    );
  }
}
