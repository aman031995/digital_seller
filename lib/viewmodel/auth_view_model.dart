import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/model/data/UserInfoModel.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/AppDataManager.dart';
import 'package:TychoStream/network/CacheDataManager.dart';
import 'package:TychoStream/network/NetworkConstants.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/repository/auth_repository.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/view/WebScreen/reset_screen.dart';
import 'package:TychoStream/view/screens/verify_otp_screen.dart';
import '../view/WebScreen/HomePageWeb.dart';
import 'dart:html' as html;

void reloadPage() {
  html.window.location.reload();
}
class AuthViewModel with ChangeNotifier {
  final _authRepo = AuthRepository();

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;
  User() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    names=sharedPreferences.get('name').toString() ?? " ";
    image=sharedPreferences.get('profileImg').toString();
  }
  Future<void> login(
      String phone, String password, String deviceToken, BuildContext context) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.login(phone, password, deviceToken, context, (result, isSuccess) {
      if (isSuccess) {
        _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        AppDataManager.getInstance.updateUserDetails(userInfoModel!);
        print('Login api Successfully');
        AppIndicator.disposeIndicator();
        isLogin=true;
        Navigator.pop(context);
        User();
        GoRouter.of(context).pushNamed(RoutesName.home);
       notifyListeners();
      }
    });
  }
  logoutButtonPressed(BuildContext context) async {
    AppDataManager.deleteSavedDetails();
    CacheDataManager.clearCachedData();
    isLogins = false;
    isLogin=false;
    GoRouter.of(context).pushNamed(RoutesName.home);
     reloadPage();
  }

  Future<void> register(HomeViewModel viewModel,String name, String phone, String email,
      String password, BuildContext context) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.register(phone, email, context, (result, isSuccess) {
      if (isSuccess) {
        ToastMessage.message(
            ((result as SuccessState).value as ASResponseModal).message);
        AppIndicator.disposeIndicator();
        Navigator.pop(context);
        User();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return VerifyOtp(
                  mobileNo: phone,
                  name: name,
                  email: email,
                  password: password,
                  isForgotPassword: false,
                viewmodel: viewModel,
              );});
        notifyListeners();
      }
    });
  }

  Future<void> verifyOTP(BuildContext context, String phone, String otp,
      {bool? isForgotPW, String? name, String? email, String? password,
        String? deviceToken, String? mobileNumber,}) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.verifyOTP(phone, otp, deviceToken!, context, (result, isSuccess) {
      if (isSuccess) {
        ToastMessage.message(
            ((result as SuccessState).value as ASResponseModal).message);
        print('otp verified Successfully');
        if (isForgotPW == true) {
          AppIndicator.disposeIndicator();
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ResetPassword(phone: phone);});
        } else {
          registerUser(context, name, mobileNumber, password, email, deviceToken);
        }
        notifyListeners();
      }
    });
  }

  registerUser(BuildContext context, String? name, String? phone, String? password, String? email, String? deviceToken) {
    _authRepo.registerUser(name!, email!, phone!, password!, deviceToken!, context,
            (result, isSuccess) {
          if (isSuccess) {
            _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
            AppDataManager.getInstance.updateUserDetails(userInfoModel!);
            ToastMessage.message(
                ((result as SuccessState).value as ASResponseModal).message);
            isLogin=true;
            User();
            print('Register api Successfully');
            AppIndicator.disposeIndicator();
            GoRouter.of(context).pushNamed(RoutesName.home);
            Navigator.pop(context);
            notifyListeners();
          }
        });
  }

  Future<void> resendOtp(
      String name,
      String? email,
      String password,
      String? phone,
      bool isForgotPassword,
      HomeViewModel viewModel,
      BuildContext context,
      NetworkResponseHandler handler,
      {bool? editPage}) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.resendOTP('${viewModel.appConfigModel!.androidConfig!.loginWith=='email'?email:phone}', context, (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        _userInfoModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        if (_userInfoModel != null) {
          AppDataManager.getInstance.updateUserDetails(userInfoModel!);
        }
        ToastMessage.message(
            ((result as SuccessState).value as ASResponseModal).message);
        print('otp verified Successfully');
        if (editPage == true) {
        } else {
          // Navigator.pop(context);
          // showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return VerifyOtp(
          //           name: name,
          //           email: email,
          //           password: password,
          //           mobileNo: phone,
          //           isForgotPassword: isForgotPassword,
          //       viewmodel:viewModel);});
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => VerifyOtp(
          //             name: name,
          //             email: email,
          //             password: password,
          //             mobileNo: phone,
          //             isForgotPassword: isForgotPassword)));
        }
        notifyListeners();
      }
    });
  }

  Future<void> forgotPassword(String phone, BuildContext context, HomeViewModel viewModel) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.forgotPassword(phone, context, (result, isSuccess) {
      if (isSuccess) {
        print('forgot password api Successfully');
        ToastMessage.message(
            ((result as SuccessState).value as ASResponseModal).message);
        AppIndicator.disposeIndicator();
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return VerifyOtp(mobileNo: phone, isForgotPassword: true,viewmodel: viewModel);});
        notifyListeners();
      }
    });
  }

  Future<void> resetPassword(String email, String newPassword,
      String confirmPassword, BuildContext context) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.resetPassword(email, newPassword, confirmPassword, context,
            (result, isSuccess) {
          if (isSuccess) {
            print('forgot password api Successfully');
            ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);
            AppIndicator.disposeIndicator();
            Navigator.pop(context);
             //
             // Navigator.pushNamedAndRemoveUntil(context, RoutesName.home, (route) => false);
            GoRouter.of(context).pushNamed(RoutesName.home);
            notifyListeners();
          }
        });
  }
}
