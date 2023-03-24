import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tycho_streams/model/data/UserInfoModel.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/repository/sociallogin_provider.dart';
import 'package:tycho_streams/utilities/AppIndicator.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';


class SocialLoginViewModel with ChangeNotifier {
  final _socialRepo = SocialLoginProvider();
  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String? uid;
  String? name;
  String? userEmail;
  String? imageUrl;
  String? accesstoken;
  bool isGoogle = false;
  // for google Login
  Future<User?> signInWithGoogle(context) async {
    User? user;
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      try {
        final UserCredential userCredential =
        await _auth.signInWithPopup(authProvider);
        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    }
    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      userEmail = user.email;
      imageUrl = user.photoURL;
      accesstoken=user.refreshToken;
      socialLoginPressed(
          context,
          uid!,
          accesstoken!,
          "",
          "google",
          userEmail!,
          name!,
        imageUrl!,
      );
    }
    return user;
  }


// for facebook login
  Future<void> loginWithFB(BuildContext context) async {

    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();

    } else {

    }

  }

  updateSocialDetail(BuildContext context, SocialLoginViewModel socialVM,
      String? userEmail, String? phone, String? userId) async {
    AppIndicator.loadingIndicator(context);
    _socialRepo.loginUpdate(userId!, userEmail!, phone!, context,
            (result, isSuccess) {
          if (isSuccess) {
            _userInfoModel =
                ((result as SuccessState).value as ASResponseModal).dataModal;
            AppDataManager.getInstance.updateUserDetails(_userInfoModel!);
            AppDataManager.setFirstTimeValue();
            ToastMessage.message(
                ((result as SuccessState).value as ASResponseModal).message);
            GoRouter.of(context).pushNamed(RoutesName.home);
            notifyListeners();
            AppIndicator.disposeIndicator();
          }
        });
  }
  socialLoginPressed(
      context,
      String socialID,
      String accessToken,
      String deviceToken,
      String provider,
      String userEmail,
      String userName,
      String profilePic) async {
    AppIndicator.loadingIndicator(context);
    _socialRepo.loginWithSocialMedia(
        socialID,
        accessToken,
        provider,
        deviceToken,
        userEmail,
        userName,
        profilePic,
        context, (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        UserInfoModel? userInfoModel;
        userInfoModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        AppDataManager.getInstance.updateUserDetails(userInfoModel!);
        AppDataManager.setFirstTimeValue();
        GoRouter.of(context).pushNamed(RoutesName.home);
        reloadPage();
        notifyListeners();
      } else {
        var response = (result as SuccessState).value;
        // if (provider == "apple" && userEmail == '') {
        //   successDialog(context, StringConstant.appleAlertTitle,
        //       response["message"], false, onOkayTap: () {
        //     Navigator.pop(context, true);
        //   });
        // } else {
        ToastMessage.message(response['message']);
        notifyListeners();
        // }
      }
    });
  }
  // socialLoginPressed(
  //     context,
  //     String socialID,
  //     String accessToken,
  //     String deviceToken,
  //     String provider,
  //     String userEmail,
  //     String userName,
  //     ) async {
  //   AppIndicator.loadingIndicator(context);
  //   _socialRepo.loginWithSocialMedia(
  //       socialID,
  //       accessToken,
  //       provider,
  //       deviceToken,
  //       userEmail,
  //       userName,
  //       context, (result, isSuccess) {
  //     if (isSuccess) {
  //       AppIndicator.disposeIndicator();
  //       UserInfoModel? userInfoModel;
  //       userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
  //       AppDataManager.getInstance.updateUserDetails(userInfoModel!);
  //       AppDataManager.setFirstTimeValue();
  //       reloadPage();
  //       notifyListeners();
  //     } else {
  //       var response = (result as SuccessState).value;
  //       ToastMessage.message(response['message']);
  //       notifyListeners();
  //     }
  //   });
  // }
}

