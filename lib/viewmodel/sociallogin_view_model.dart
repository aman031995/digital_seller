import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:TychoStream/model/data/UserInfoModel.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppDataManager.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/repository/sociallogin_provider.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';

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
        reloadPage();
        Navigator.pop(context);
        notifyListeners();
      }
      else {
        var response = (result as SuccessState).value;
        ToastMessage.message(response['message']);
        notifyListeners();
      }
    });
  }
}

