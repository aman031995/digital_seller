import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:tycho_streams/model/data/TermsPrivacyModel.dart';
import 'package:tycho_streams/model/data/UserInfoModel.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/repository/profile_repository.dart';
import 'package:tycho_streams/utilities/AppIndicator.dart';
import 'package:tycho_streams/view/widgets/profile_bottom_view.dart';

class ProfileViewModel with ChangeNotifier {
  final _profileRepo = ProfileRepository();

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  List<TermsPrivacyModel>? _termsPrivacyModel;
  List<TermsPrivacyModel>? get termsPrivacyModel => _termsPrivacyModel;

  Future getTermsPrivacy(BuildContext context) async {
    AppIndicator.loadingIndicator();
    _profileRepo.getTermsPrivacy(context,(result, isSuccess) {
      if (isSuccess) {
        _termsPrivacyModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        print('Terms Privacy api Successfully');
        addItemOnList(_termsPrivacyModel);
        notifyListeners();
        AppIndicator.disposeIndicator();
      }
    });
  }

  void addItemOnList(List<TermsPrivacyModel>? termsPrivacyModel) {
      for(var i = 0; i < termsPrivacyModel!.length; i++) {
        names.insert(3, termsPrivacyModel[i].pageTitle!);
        namesIcon.insert(3, termsPrivacyModel[i].pageIcon!);
    }
  }

  Future<void> imageUpload(BuildContext context, result) async {
    AppIndicator.loadingIndicator();
    var imageToUpload = File(result.path);
    _profileRepo.uploadImage([imageToUpload.path], context, (result, isSuccess) {
      _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
      notifyListeners();
    });
  }

  Future<void> getProfileDetails(BuildContext context) async {
    AppIndicator.loadingIndicator();
    _profileRepo.getUserProfileDetails(context, (result, isSuccess) {
      if(isSuccess){
        _userInfoModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
      }
    });
  }

  Future<void> updateProfile() async{
    AppIndicator.loadingIndicator();
    // _profileRepo.editProfile(name, phone, userProfilePic, address, context, (result, isSuccess) {
    //   if(isSuccess){
    //
    //   }
    // });
  }

// saveButtonPressed() async {
//   AppIndicator.loadingIndicator();
//   AppNetworkManager.editProfile(
//       fullNameController!.text,
//       lastNameController!.text,
//       mediaFile,
//       emailController!.text,
//       context, (result, isSuccess) {
//     if (isSuccess) {
//       AppIndicator.disposeIndicator();
//       UserInfoModel? userInfoModel;
//       userInfoModel =
//           ((result as SuccessState).value as ASResponseModal).dataModal;
//       AppDataManager.getInstance.updateUserDetails(userInfoModel!);
//       ToastMessage.message(
//           ((result as SuccessState).value as ASResponseModal).message);
//       Navigator.pop(context, true);
//     }
//   });
// }
}