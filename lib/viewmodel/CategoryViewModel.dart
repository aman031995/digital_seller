
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
  final _homePageRepo = HomePageRepository();

  CategoryDataModel? _categoryDataModel;
  CategoryDataModel? get categoryDataModel => _categoryDataModel;

  HomePageDataModel? _homePageDataModel;
  HomePageDataModel? get homePageDataModel => _homePageDataModel;

  HomePageDataModel? _newHomePageDataModel;
  HomePageDataModel? get newHomePageDataModel => _newHomePageDataModel;
  List<VideoList>? getPreviousPageList;
  int lastPage = 2, nextPage = 1 ,homeNextPage = 2;
  bool isLoading = false;


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

  Future<void> runIndicator(BuildContext context)async {
    isLoading = true;
    notifyListeners();
  }
  Future<void> stopIndicator(BuildContext context)async {
    isLoading = false;
    notifyListeners();
  }

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
        // lastPage = _homePageDataModel?.pagination?.lastPage ?? 1;
        // nextPage = _homePageDataModel?.pagination?.next ?? 1;
        // getPreviousPageList = _homePageDataModel!.videoList!;
        notifyListeners();
      }
    });
  }

  Future<void> getAllPaginatedData(
      BuildContext context, int trayId,int pageNum) async {
    _homePageRepo.getHomePageData(trayId, pageNum, context,
            (result, isSuccess) {
          if (isSuccess) {
            _newHomePageDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
            lastPage = _newHomePageDataModel?.pagination?.lastPage ?? 1;
            homeNextPage = _newHomePageDataModel?.pagination?.next ?? 1;
            getPreviousPageList?.addAll(_newHomePageDataModel!.videoList!);
            isLoading = false;
            notifyListeners();
          }
        });
  }
        seealll(BuildContext context,int trayId,int pagenum){
    _homePageRepo.getHomePageData(trayId, pagenum, context,
            (result, isSuccess) {
          if (isSuccess) {
            ASResponseModal responseModal = (result as SuccessState).value as ASResponseModal;
           // _homePageDataModel = responseModal.dataModal;
            _newHomePageDataModel = responseModal.dataModal;
            if (_newHomePageDataModel?.pagination?.current == 1) {
              lastPage = _newHomePageDataModel?.pagination?.lastPage ?? 1;
              nextPage = _newHomePageDataModel?.pagination?.next ?? 1;
              getPreviousPageList = _newHomePageDataModel?.videoList;
            } else {
              lastPage = _newHomePageDataModel?.pagination?.lastPage ?? 1;
              nextPage = _newHomePageDataModel?.pagination?.next ?? 1;
              getPreviousPageList?.addAll(_newHomePageDataModel!.videoList!);
            }
            isLoading = false;
            notifyListeners();
          }
        });
  }

}