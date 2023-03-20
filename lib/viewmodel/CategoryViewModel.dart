
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_cache/json_cache.dart';
import 'package:tycho_streams/model/data/CategoryDataModel.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/CacheDataManager.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/repository/HomePageRepository.dart';
import 'package:tycho_streams/utilities/AppIndicator.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';

class CategoryViewModel with ChangeNotifier{
  final _categoryPageRepo = HomePageRepository();

  CategoryDataModel? _categoryDataModel;
  CategoryDataModel? get categoryDataModel => _categoryDataModel;

  HomePageDataModel? _homePageDataModel;
  HomePageDataModel? get homePageDataModel => _homePageDataModel;

  List<VideoList> getPreviousPageList = [];


  // getCategoryList(BuildContext context, int pageNum) async {
  //   final box = await Hive.openBox<String>('appBox');
  //   final JsonCache jsonCache = JsonCacheMem(JsonCacheHive(box));
  //   if (await jsonCache.contains(StringConstant.kCategoryList)) {
  //     CacheDataManager.getCachedData(key: StringConstant.kCategoryList).then((jsonData) {
  //       _categoryDataModel = CategoryDataModel.fromJson(jsonData!['data']);
  //       print('From Cached CategoryDetails');
  //       notifyListeners();
  //     });
  //   } else {
  //     getCategoryListData(context, pageNum);
  //   }
  // }

  Future<void> getCategoryListData(BuildContext context, int pageNum) async {
    // AppIndicator.loadingIndicator();
    _categoryPageRepo.getCategoryList(pageNum, context, (result, isSuccess) {
      if (isSuccess) {
        _categoryDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
      }
    });
  }

  Future<void> getMovieList(BuildContext context, List<VideoList>? moviesList)async {
    getPreviousPageList = moviesList!;
    notifyListeners();
  }

  Future<void> getCategoryDetails(BuildContext context, String categoryId, int pageNum) async {
    AppIndicator.loadingIndicator(context);
    _categoryPageRepo.getCategoryWiseDetails(categoryId, pageNum, context, (result, isSuccess) {
      if (isSuccess) {
        _homePageDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        getPreviousPageList = _homePageDataModel!.videoList!;
        notifyListeners();
      }
    });
  }
}