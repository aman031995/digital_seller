import 'package:TychoStream/model/data/category_data_model.dart';
import 'package:TychoStream/model/data/homepage_data_model.dart';
import 'package:flutter/material.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/repository/HomePageRepository.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';

class CategoryViewModel with ChangeNotifier{
  final _categoryPageRepo = HomePageRepository();

  CategoryDataModel? _categoryDataModel;
  CategoryDataModel? get categoryDataModel => _categoryDataModel;

  HomePageDataModel? _homePageDataModel;
  HomePageDataModel? get homePageDataModel => _homePageDataModel;

  HomePageDataModel? _newHomePageDataModel;
  HomePageDataModel? get newHomePageDataModel => _newHomePageDataModel;

  List<VideoList>? getPreviousPageList;
  int lastPage = 2, nextPage = 1 ;
  bool isLoading = false;

//method for get Category List data
  Future<void> getCategoryListData(BuildContext context, int pageNum) async {
    _categoryPageRepo.getCategoryList(pageNum, context, (result, isSuccess) {
      if (isSuccess) {
        _categoryDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
      }
    });
  }

  //method for get category details
  Future<void> getCategoryDetails(BuildContext context, String categoryId, int pageNum) async {
    AppIndicator.loadingIndicator(context);
    _categoryPageRepo.getCategoryWiseDetails(categoryId, pageNum, context, (result, isSuccess) {
      if (isSuccess) {
        _newHomePageDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        if (_newHomePageDataModel?.pagination?.current == 1) {
          lastPage = _newHomePageDataModel?.pagination?.lastPage ?? 1;
          nextPage = _newHomePageDataModel?.pagination?.next ?? 1;
          getPreviousPageList = _newHomePageDataModel?.videoList;
        } else {
          lastPage = _newHomePageDataModel?.pagination?.lastPage ?? 1;
          nextPage = _newHomePageDataModel?.pagination?.next ?? 1;
          getPreviousPageList?.addAll(_newHomePageDataModel!.videoList!);
        }
        notifyListeners();
      }
    });
  }

  Future<void> runIndicator(BuildContext context)async {
    isLoading = true;
    notifyListeners();
  }

  Future<void> stopIndicator(BuildContext context)async {
    isLoading = false;
    notifyListeners();
  }
}