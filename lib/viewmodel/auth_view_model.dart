import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
import 'package:TychoStream/view/WebScreen/reset_screen.dart';
import 'package:TychoStream/view/screens/verify_otp_screen.dart';
import 'dart:html' as html;
import '../AppRouter.gr.dart';

void reloadPage() {
  html.window.location.reload();
}

class AuthViewModel with ChangeNotifier {
  final _authRepo = AuthRepository();

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  User() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    names=sharedPreferences.get('name').toString();
  }

  Future<void> login(
      String phone,
      String password,
      String deviceId,
      String firebaseId,
      String loginType,
      bool? product,
      HomeViewModel viewmodel,
      bool checkPhoneEmailValid,
      BuildContext context) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.login(phone, password, deviceId, firebaseId, loginType, context,
            (result, isSuccess) {
          if (isSuccess) {
            _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
            if (_userInfoModel?.isEmailVerified == false && _userInfoModel?.isPhoneVerified == false) {
              AppIndicator.disposeIndicator();
              Navigator.pop(context);
              isLogin=true;
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return VerifyOtp(
                      mobileNo: phone,
                      name: '',
                      email: phone,
                      password: password,product:product,
                      isForgotPassword: false,
                      loginPage: true,
                      isNotVerified: true,
                      viewmodel: viewmodel,
                    );});}
            else if (checkPhoneEmailValid == true && loginType == 'phone') {
              AppIndicator.disposeIndicator();
              Navigator.pop(context);
              isLogin=true;
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return VerifyOtp(
                      mobileNo: phone,
                      name: '',
                      email: phone,
                      password: password,
                      isForgotPassword: false,
                      loginPage: false,product:product,
                      isNotVerified: true,
                      viewmodel: viewmodel,
                    );});
            }
            else if ((_userInfoModel?.isEmailVerified == false && _userInfoModel?.isPhoneVerified == true) && loginType == 'phone') {
              AppIndicator.disposeIndicator();
              Navigator.pop(context);
              isLogin=true;
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return VerifyOtp(
                      mobileNo: phone,
                      name: '',
                      email: phone,
                      password: password,
                      isForgotPassword: false,
                      loginPage: true,product:product,
                      isNotVerified: true,
                      viewmodel: viewmodel,
                    );
                  });}
            else if (_userInfoModel?.isEmailVerified == false && checkPhoneEmailValid == false) {
              AppIndicator.disposeIndicator();
              Navigator.pop(context);
              isLogin=true;
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return VerifyOtp(
                      mobileNo: phone,product:product,
                      name: '',
                      email: phone,
                      password: password,
                      isForgotPassword: false,
                      loginPage: true,
                      isNotVerified: true,
                      viewmodel: viewmodel,
                    );
                  });
            }
            else {
              AppDataManager.getInstance.updateUserDetails(userInfoModel!);
              print('Login api Successfully');
              AppIndicator.disposeIndicator();
              User();
              reloadPage();
              ResponsiveWidget.isMediumScreen(context) ? null :
              product==true? Navigator.pop(context):context.router.push(HomePageWeb());
            }
            notifyListeners();
          }
        });
  }

  logoutButtonPressed(BuildContext context) async {
    AppDataManager.deleteSavedDetails();
    CacheDataManager.clearCachedData();
    isLogins = false;
    isLogin=false;
     reloadPage();
  }

// method for user register from api
  Future<void> register(
      HomeViewModel viewModel,
      String name,
      String phone,
      String email,
      String password,
      String loginType,
      BuildContext context) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.register(phone, email, loginType, context, (result, isSuccess) {
      if (isSuccess) {
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);
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
                loginPage: false,
                isNotVerified: false,
                isForgotPassword: false,
                viewmodel: viewModel,
              );});
        notifyListeners();
      }
    });
  }

  Future<void> verifyOTP(BuildContext context, String phone, String otp,
      {bool? isForgotPW,bool?product,
        String? name,
        String? email,
        String? password,
        String? deviceId,
        String? firebaseId,
        String? mobileNumber,
        String? loginType,
        bool? isNotVerified,
        NetworkResponseHandler? handler,
        bool? verifyNumber}) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.verifyOTP(phone, otp, deviceId ?? '', firebaseId ?? '', context,
            (result, isSuccess) {
          if (isSuccess) {
            handler!(Result.success(result), isSuccess);
            AppIndicator.disposeIndicator();
            ToastMessage.message(
                ((result as SuccessState).value as ASResponseModal).message);
            print('otp verified Successfully');
            reloadPage();
            _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
            if (isForgotPW == true) {
              AppIndicator.disposeIndicator();
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ResetPassword(
                      product: product,
                      phone: phone,loginType: loginType,);});
            } else if (verifyNumber == true) {
              otpValue = '';
              Navigator.of(context, rootNavigator: true).pop();
            } else if (_userInfoModel?.isEmailVerified == true || _userInfoModel?.isPhoneVerified == true) {
              print('Login api Successfully');
              AppDataManager.getInstance.updateUserDetails(_userInfoModel!);
              AppIndicator.disposeIndicator();
              reloadPage();
              product==true?  Navigator.pop(context):context.router.push(HomePageWeb());
            } else {
              registerUser(context, name, mobileNumber, password, email, deviceId, firebaseId);
            }
          }

          notifyListeners();
        });
  }

  registerUser(BuildContext context, String? name, String? phone,
      String? password, String? email, String? deviceId, String? deviceToken) {
    AppIndicator.loadingIndicator(context);
    _authRepo.registerUser(
        name!, email!, phone!, password!, deviceId!, deviceToken!, context,
            (result, isSuccess) {
          if (isSuccess) {
            AppIndicator.disposeIndicator();
            _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
            AppDataManager.getInstance.updateUserDetails(userInfoModel!);
            ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);
            AppIndicator.disposeIndicator();
            Navigator.pop(context);
            reloadPage();
            notifyListeners();
          }
        });
  }

  Future<void> resendOtp(
      String? phone, BuildContext context, NetworkResponseHandler handler,
      {String? verifyDetailType}) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.resendOTP(phone ?? '',verifyDetailType ?? '',context, (result, isSuccess) {
      if (isSuccess) {
        AppIndicator.disposeIndicator();
        _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        if (_userInfoModel != null) {
          AppDataManager.getInstance.updateUserDetails(userInfoModel!);
        }
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);
        notifyListeners();
      }
    });
  }

  Future<void> forgotPassword(String phone,bool loginType,bool? product, BuildContext context, HomeViewModel viewModel) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.forgotPassword(phone, loginType == true ? 'phone' : 'email',context, (result, isSuccess) {
      if (isSuccess) {
        print('forgot password api Successfully');
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);
        AppIndicator.disposeIndicator();
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return VerifyOtp(
                  product: product,
                  mobileNo: phone, isForgotPassword: true,viewmodel: viewModel,loginPage: true,email: phone);});
        notifyListeners();
      }
    });
  }

  Future<void> resetPassword(String email, String newPassword,
      String confirmPassword,String loginType, BuildContext context) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.resetPassword(email, newPassword, confirmPassword,loginType, context,
            (result, isSuccess) {
          if (isSuccess) {
            print('forgot password api Successfully');
            ToastMessage.message(((result as SuccessState).value as ASResponseModal).message);
            AppIndicator.disposeIndicator();
            Navigator.pop(context);
            notifyListeners();
            reloadPage();
          }
        });
  }
}
