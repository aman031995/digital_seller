
import 'package:flutter/material.dart';
import 'package:tycho_streams/model/data/CategoryDataModel.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/repository/HomePageRepository.dart';
import 'package:tycho_streams/utilities/AppIndicator.dart';

class CategoryViewModel with ChangeNotifier{
  final _categoryPageRepo = HomePageRepository();

  CategoryDataModel? _categoryDataModel;
  CategoryDataModel? get categoryDataModel => _categoryDataModel;

  HomePageDataModel? _homePageDataModel;
  HomePageDataModel? get homePageDataModel => _homePageDataModel;


  Future<void> getCategoryListData(BuildContext context, int pageNum) async {
    // AppIndicator.loadingIndicator();
    _categoryPageRepo.getCategoryList(pageNum, context, (result, isSuccess) {
      if (isSuccess) {
        _categoryDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
      }
    });
  }

  Future<void> getCategoryDetails(BuildContext context, String categoryId, int pageNum) async {
    AppIndicator.loadingIndicator();
    _categoryPageRepo.getCategoryWiseDetails(categoryId, pageNum, context, (result, isSuccess) {
      if (isSuccess) {
        _homePageDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
      }
    });
  }
}