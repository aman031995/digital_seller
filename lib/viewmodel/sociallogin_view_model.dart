import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tycho_streams/model/data/UserInfoModel.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/repository/sociallogin_provider.dart';
import 'package:tycho_streams/utilities/AppIndicator.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/view/screens/bottom_navigation.dart';
import 'package:tycho_streams/view/widgets/social_login_update.dart';

bool isGoogle = false;
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
);

class SocialLoginViewModel with ChangeNotifier {
  final _socialRepo = SocialLoginProvider();

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  Future<void> handleSignOut() => _googleSignIn.disconnect();
  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      await FirebaseMessaging.instance.getToken().then((value) {
        _googleSignIn.signIn().then((userData) async {
          userData?.authentication.then((googleKey) async {
            socialLoginPressed(
                context,
                userData.id,
                googleKey.accessToken!,
                value ?? "",
                "google",
                _googleSignIn.currentUser!.email,
                _googleSignIn.currentUser!.displayName!);
          }).catchError((err) {
            ToastMessage.message(err.toString());
            print('inner error');
          });
        }).catchError((err) {
          ToastMessage.message(err.toString());
          print('error occurred');
        });
      });
    } catch (error) {
      ToastMessage.message(error.toString());
      print(error);
    }
  }

// for facebook login
  Future<void> loginWithFB(BuildContext context) async {
    AccessToken? _accessToken;
    await FirebaseMessaging.instance.getToken().then((value) {
      FacebookAuth.instance.logOut();
      FacebookAuth.instance.login().then((result) async {
        if (result.status == LoginStatus.success) {
          _accessToken = result.accessToken;
          final userData = await FacebookAuth.instance.getUserData();
          socialLoginPressed(
            context,
            _accessToken!.userId,
            _accessToken!.token,
            value ?? "",
            "facebook",
            userData['email'] ?? '',
            userData['name'],
          );
        } else {
          ToastMessage.message(result.message);
          print(result.status);
          print(result.message);
        }
      });
    });
  }

  Future<void> loginWithApple(BuildContext context) async {
    await FirebaseMessaging.instance.getToken().then((value) async {
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName
      ]);
      var lastName =
          credential.familyName != null ? (" " + credential.familyName!) : "";
      if (credential.email == null) {
        socialLoginPressed(context, credential.userIdentifier!,
            credential.identityToken!, value ?? "", "apple", '', '');
      } else {
        socialLoginPressed(
            context,
            credential.userIdentifier ?? "",
            credential.identityToken ?? "",
            value ?? "",
            "apple",
            credential.email!,
            credential.givenName ?? "" + lastName);
      }
    });
  }

  updateSocialDetail(BuildContext context, SocialLoginViewModel socialVM,
      String? userEmail, String? phone, String? userId) async {
    AppIndicator.loadingIndicator();
    _socialRepo.loginUpdate(userId!, userEmail!, phone!, context,
        (result, isSuccess) {
      if (isSuccess) {
        _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        AppDataManager.getInstance.updateUserDetails(userInfoModel!);
        AppDataManager.setFirstTimeValue();
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => BottomNavigation(index: 0)),
            (route) => false);
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
      String userName) async {
    AppIndicator.loadingIndicator();
    _socialRepo.loginWithSocialMedia(socialID, accessToken, provider,
        deviceToken, userEmail, userName, context, (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        UserInfoModel? userInfoModel;
        userInfoModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        if (userInfoModel!.firstTimeSocial == false) {
          AppDataManager.getInstance.updateUserDetails(userInfoModel);
          AppDataManager.setFirstTimeValue();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => BottomNavigation(index: 0)), (route) => false);
          notifyListeners();
        } else {
          if (provider == "google") {
            showDialog(
                context: context,
                builder: (BuildContext context) => SocialLoginUpdate(
                    userEmail: userInfoModel?.email,
                    userId: userInfoModel?.userId.toString()));
          } else if (provider == "facebook") {
            showDialog(
                context: context,
                builder: (BuildContext context) => SocialLoginUpdate(
                    userEmail: userInfoModel?.email,
                    userId: userInfoModel?.userId.toString()));
          } else if (provider == "apple") {
            showDialog(
                context: context,
                builder: (BuildContext context) => SocialLoginUpdate(
                      userEmail: userEmail,
                      userId: userInfoModel?.userId.toString(),
                    ));
          }
        }
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
}
