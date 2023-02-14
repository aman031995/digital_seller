import 'package:flutter/material.dart';
import 'package:tycho_streams/model/data/BannerDataModel.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/model/data/TrayDataModel.dart';
import 'package:tycho_streams/network/ASResponseModal.dart';
import 'package:tycho_streams/network/result.dart';
import 'package:tycho_streams/repository/HomePageRepository.dart';

class HomeViewModel with ChangeNotifier {
  final _homePageRepo = HomePageRepository();

  BannerDataModel? _bannerDataModal;
  BannerDataModel? get bannerDataModal => _bannerDataModal;

  HomePageDataModel? _homePageDataModel;
  HomePageDataModel? get homePageDataModel => _homePageDataModel;

  List<TrayDataModel>? _trayDataModel;
  List<TrayDataModel>? get trayDataModel => _trayDataModel;

  BannerDataModel? bannerValueCheck;
  HomePageDataModel? homePageValueCheck;

  // getBanner(BuildContext context) async{
  //   final box = await Hive.openBox<String>('appBox');
  //   final JsonCache jsonCache = JsonCacheMem(JsonCacheHive(box));
  //
  //   if (await jsonCache.contains(StringConstant.kBannerList)) {
  //     CacheDataManager.getCachedData(key: StringConstant.kBannerList).then((jsonData) {
  //       _bannerDataModal = BannerDataModel.fromJson(jsonData!['data']);
  //       print('From Cached BannerList');
  //       notifyListeners();
  //     });
  //   } else {
  //     getBannerLists(context);
  //   }
  // }

  Future<void> getBannerLists(BuildContext context) async {
    // AppIndicator.loadingIndicator();
    _homePageRepo.getBannerData(context, (result, isSuccess) {
      if (isSuccess) {
        _bannerDataModal = ((result as SuccessState).value as ASResponseModal).dataModal;
        bannerValueCheck = _bannerDataModal;
        notifyListeners();
      }
    });
  }

  Future<void> getHomePageData(
      BuildContext context, TrayDataModel? element) async {
    // AppIndicator.loadingIndicator();
    _homePageRepo.getHomePageData(element?.trayId ?? 1, 1, context,
        (result, isSuccess) {
      if (isSuccess) {
        // _homePageDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        ASResponseModal responseModal = (result as SuccessState).value as ASResponseModal;
        _homePageDataModel = responseModal.dataModal;
        PlatformMovieData platformMovieData = new PlatformMovieData(
            element?.trayIdentifier ?? '',
            element?.trayIdentifier ?? '',
            _homePageDataModel!.videoList!);
        element?.updatePlatformData(platformMovieData);
        homePageValueCheck = _homePageDataModel;
        notifyListeners();
      }
    });
  }

  Future<void> getTrayData(BuildContext context) async {
    _homePageRepo.getTrayDataList(context, (result, isSuccess) {
      if (isSuccess) {
        _trayDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
          _trayDataModel?.forEach((element) {
            getHomePageData(context, element);
          });
        notifyListeners();
      }
    });
  }

  Future<void> getMoreLikeThis(BuildContext context, String videoId)async{
    _homePageRepo.getMoreLikeThisData(videoId ?? '', context,
            (result, isSuccess) {
          if (isSuccess) {
            _homePageDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
            notifyListeners();
          }
        });
  }
}
