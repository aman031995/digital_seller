import 'dart:async';

import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/view/WebScreen/authentication/LoginUp.dart';
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
import 'package:TychoStream/view/WebScreen/authentication/reset_screen.dart';
import 'package:TychoStream/view/WebScreen/authentication/verify_otp_screen.dart';
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
    GlobalVariable.names=sharedPreferences.get('name').toString();
  }

  // method for login
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
            ToastMessage.message(((result as SuccessState).value as ASResponseModal).message,context);
            if (_userInfoModel?.isEmailVerified == false && _userInfoModel?.isPhoneVerified == false) {
              AppIndicator.disposeIndicator();
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return VerifyOtp(
                      mobileNo: phone,
                      name: '',
                      email: phone,
                      password: password,
                      product:product,
                      isForgotPassword: false,
                      loginPage: true,
                      isNotVerified: true,
                      viewmodel: viewmodel,
                    );});}
            else if (checkPhoneEmailValid == true && loginType == 'phone') {
              AppIndicator.disposeIndicator();
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return VerifyOtp(
                      mobileNo: phone,
                      name: '',
                      email: phone,
                      password: password,
                      isForgotPassword: false,
                      loginPage: false,
                      product:product,
                      isNotVerified: true,
                      viewmodel: viewmodel,
                    );});
            }
            else if ((_userInfoModel?.isEmailVerified == false && _userInfoModel?.isPhoneVerified == true) && loginType == 'phone') {
              AppIndicator.disposeIndicator();
              Navigator.pop(context);
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
              User();
              AppIndicator.disposeIndicator();
              product==true? Navigator.pop(context):context.router.push(HomePageWeb());
              if(product==true)
                reloadPage();
            }
            notifyListeners();
          }
        });
  }

  logoutButtonPressed(BuildContext context) async {
    ToastMessage.message("logout user successfully",context);
    AppDataManager.deleteSavedDetails();
    CacheDataManager.clearCachedData();
    GlobalVariable.isLogins = false;
    context.router.push(HomePageWeb());
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
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message,context);
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

  // method for  verify otp
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
            ToastMessage.message(((result as SuccessState).value as ASResponseModal).message,context);
            AppIndicator.disposeIndicator();
            print('otp verified Successfully');
            _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
            if (isForgotPW == true) {
              AppIndicator.disposeIndicator();
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ResetPassword(
                      product: product,
                      phone: phone,
                      loginType: loginType,);});
            } else if (verifyNumber == true) {
              otpValue = '';
              Navigator.of(context, rootNavigator: true).pop();
            } else if (_userInfoModel?.isEmailVerified == true || _userInfoModel?.isPhoneVerified == true) {
              print('Login api Successfully');
              ToastMessage.message('Login User Successfully',context);
              AppIndicator.disposeIndicator();
              AppDataManager.getInstance.updateUserDetails(_userInfoModel!);
              product==true?  Navigator.pop(context):context.router.push(HomePageWeb());
              if(product==true)
                reloadPage();
              notifyListeners();


            } else {
              registerUser(context, name, mobileNumber, password, email, deviceId, firebaseId);
            }
          }

          notifyListeners();
        });
  }

  // method for registerUser
  registerUser(BuildContext context, String? name, String? phone,
      String? password, String? email, String? deviceId, String? deviceToken) {
    AppIndicator.loadingIndicator(context);
    _authRepo.registerUser(
        name!, email!, phone!, password!, deviceId!, deviceToken!, context,
            (result, isSuccess) {
          if (isSuccess) {
            ToastMessage.message(((result as SuccessState).value as ASResponseModal).message,context);
            _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
            AppDataManager.getInstance.updateUserDetails(userInfoModel!);
            AppIndicator.disposeIndicator();
            Navigator.pop(context);
            Timer(Duration(milliseconds: 50), () {
              reloadPage();
            });
            notifyListeners();

          }
        });
  }

  // Method for resend Otp
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
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message,context);
        notifyListeners();
      }
    });
  }

  //Method for forgot Password
  Future<void> forgotPassword(String phone,bool loginType,bool? product, BuildContext context, HomeViewModel viewModel) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.forgotPassword(phone, loginType == true ? 'phone' : 'email',context, (result, isSuccess) {
      if (isSuccess) {
        print('forgot password api Successfully');
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message,context);
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

  // Method for reset Password
  Future<void> resetPassword(String email, String newPassword,
      String confirmPassword,String loginType, BuildContext context) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.resetPassword(email, newPassword, confirmPassword,loginType, context,
            (result, isSuccess) {
          if (isSuccess) {
            print('forgot password api Successfully');
            ToastMessage.message(((result as SuccessState).value as ASResponseModal).message,context);
            AppIndicator.disposeIndicator();
            Navigator.pop(context);
            showDialog(
                context: context,
                barrierColor: Theme.of(context).canvasColor.withOpacity(0.6),
                builder: (BuildContext context) {
                  return LoginUp(
                    product: true,
                  );
                });
            notifyListeners();

          }
        });
  }

  // Method for subscribeEmail
  Future<void> subscribedEmail(String email, BuildContext context) async {
    AppIndicator.loadingIndicator(context);
    _authRepo.subscribedEmail(email,context, (result, isSuccess) {
      if (isSuccess) {
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message,context);
        AppIndicator.disposeIndicator();
        notifyListeners();
      }
    });
  }
}
