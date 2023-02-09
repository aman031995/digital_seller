import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tycho_streams/model/data/UserInfoModel.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/network/NetworkConstants.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/repository/auth_repository.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/screens/bottom_navigation.dart';
import 'package:tycho_streams/view/screens/verify_otp_screen.dart';
import 'package:tycho_streams/utilities/AppIndicator.dart';

class AuthViewModel with ChangeNotifier {
  final _authRepo = AuthRepository();

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  Future<void> login(
      String phone, String password, BuildContext context) async {
    AppIndicator.loadingIndicator();
    _authRepo.login(phone, password, context, (result, isSuccess) {
      if (isSuccess) {
        _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        AppDataManager.getInstance.updateUserDetails(userInfoModel!);
        print('Login api Successfully');
        AppIndicator.disposeIndicator();
        GoRouter.of(context).pushReplacementNamed(RoutesName.bottomNavigation);
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (_) => BottomNavigation(index: 0)));
        notifyListeners();
      }
    });
  }

  Future<void> register(String name, String phone,
      String email, String password, BuildContext context) async {
    AppIndicator.loadingIndicator();
    _authRepo.register(phone, email, context, (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        // GoRouter.of(context).pushNamed(RoutesName.verifyOtp, params: {
        //   'phone': phone,
        //   'name': name,
        //   'email': email,
        //   'password': password,
        // });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyOtp(
                    mobileNo: phone,
                    name: name,
                    email: email,
                    password: password)));
        notifyListeners();
      }
    });
  }

  Future<void> verifyOTP(BuildContext context, String phone, String otp,
      {bool? isForgotPW, String? name, String? email, String? password}) async {
    AppIndicator.loadingIndicator();
    _authRepo.verifyOTP(phone, otp, context, (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        AppDataManager.getInstance.updateUserDetails(userInfoModel!);
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);
        print('otp verified Successfully');
        if (isForgotPW == true) {
          GoRouter.of(context).pushNamed(RoutesName.reset_password, params: {'phone' : phone});
        } else {
          registerUser(context, name, phone, password, email);
        }
        notifyListeners();
      }
    });
  }

  registerUser(BuildContext context, String? name, String? phone,
      String? password, String? email) {
    _authRepo.registerUser(name!, email!, phone!, password!, context,
        (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        AppDataManager.getInstance.updateUserDetails(userInfoModel!);
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);
        print('Register api Successfully');
        AppIndicator.disposeIndicator();
        GoRouter.of(context).pushReplacementNamed(RoutesName.bottomNavigation);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BottomNavigation(index: 0)));
        notifyListeners();
      }
    });
  }

  Future<void> resendOtp(String phone, BuildContext context, NetworkResponseHandler handler) async {
    AppIndicator.loadingIndicator();
    _authRepo.resendOTP(phone, context, (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        if(_userInfoModel != null){
          AppDataManager.getInstance.updateUserDetails(userInfoModel!);
        }
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);
        print('otp verified Successfully');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => VerifyOtp(mobileNo: phone, isForgotPassword: true)));
        notifyListeners();
      }
    });
  }

  Future<void> forgotPassword(String phone, BuildContext context) async {
    AppIndicator.loadingIndicator();
    _authRepo.forgotPassword(phone, context, (result, isSuccess) {
      if (isSuccess) {
        print('forgot password api Successfully');
        AppIndicator.disposeIndicator();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VerifyOtp(mobileNo: phone, isForgotPassword: true)));
        notifyListeners();
      }
    });
  }

  Future<void> resetPassword(String email, String newPassword, String confirmPassword, BuildContext context) async {
    AppIndicator.loadingIndicator();
    _authRepo.resetPassword(email, newPassword, confirmPassword, context, (result, isSuccess) {
      if (isSuccess) {
        print('forgot password api Successfully');
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);
        AppIndicator.disposeIndicator();
        GoRouter.of(context).pushReplacementNamed(RoutesName.login);
        notifyListeners();
      }
    });
  }
}
