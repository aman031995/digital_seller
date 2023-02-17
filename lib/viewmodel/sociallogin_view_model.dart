
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String? uid;
String? name;
String? userEmail;
String? imageUrl;
String? accesstoken;
class SocialLoginViewModel with ChangeNotifier {
  final _socialRepo = SocialLoginProvider();

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  Future<void> handleSignOut() => _googleSignIn.disconnect();
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
          name!);

    }

    return user;
  }


  Future<void> loginWithGoogle(BuildContext context) async {
    // try {
    //   await FirebaseMessaging.instance.getToken().then((value) {
    //     _googleSignIn.signIn().then((userData) async {
    //       userData?.authentication.then((googleKey) async {
    //         socialLoginPressed(
    //             context,
    //             uid!,
    //             accesstoken!,
    //             value ?? "",
    //             "google",
    //             userEmail!,
    //             name!);
    //       }).catchError((err) {
    //         ToastMessage.message(err.toString());
    //         print('inner error');
    //       });
    //     }).catchError((err) {
    //       ToastMessage.message(err.toString());
    //       print('error occurred');
    //     });
    //   });
    // } catch (error) {
    //   ToastMessage.message(error.toString());
    //   print(error);
    // }
  }

// for facebook login
  Future<void> loginWithFB(BuildContext context) async {

    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      var fbname = userData['name'];
      var fbmail = userData['email'];
      var fbImage=userData['picture']["data"]["url"];
      // userid(na: fbname,id: fbmail,pic: fbImage);
      print(fbmail);
      print(fbname);
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const MapHomeScreen()));
    } else {
      // print(result.status);
      // print(result.message);
    }

  }



  Future<void> loginWithApple(BuildContext context) async {
    // await FirebaseMessaging.instance.getToken().then((value) async {
    //   final credential = await SignInWithApple.getAppleIDCredential(scopes: [
    //     AppleIDAuthorizationScopes.email,
    //     AppleIDAuthorizationScopes.fullName
    //   ]);
    //   var lastName =
    //       credential.familyName != null ? (" " + credential.familyName!) : "";
    //   if (credential.email == null) {
    //     socialLoginPressed(context, credential.userIdentifier!,
    //         credential.identityToken!, value ?? "", "apple", '', '');
    //   } else {
    //     socialLoginPressed(
    //         context,
    //         credential.userIdentifier ?? "",
    //         credential.identityToken ?? "",
    //         value ?? "",
    //         "apple",
    //         credential.email!,
    //         credential.givenName ?? "" + lastName);
    //   }
    // });
  }


  updateSocialDetail(BuildContext context, SocialLoginViewModel socialVM,
      String? userEmail, String? phone, String? userId) async{
    _socialRepo.loginUpdate(userId!, userEmail!, phone!, context,
            (result, isSuccess) {
          AppIndicator.loadingIndicator();
          if (isSuccess) {
            AppIndicator.disposeIndicator();
            _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
            AppDataManager.getInstance.updateUserDetails(userInfoModel!);
            AppDataManager.setFirstTimeValue();
            Navigator.pushNamed(context,  '/');
           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BottomNavigation(index: 0)));
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
            userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
            if (userInfoModel!.firstTimeSocial == false) {
              AppDataManager.getInstance.updateUserDetails(userInfoModel);
              AppDataManager.setFirstTimeValue();
              Navigator.pushNamed(context,  '/');
              // GoRouter.of(context).pushReplacementNamed(RoutesName.bottomNavigation);
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (_) => BottomNavigation(index: 0)));
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
                        userId: userInfoModel!.userId.toString()));
              } else if (provider == "apple") {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => SocialLoginUpdate(
                      userEmail: userEmail,
                      userId: userInfoModel!.userId.toString(),
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
