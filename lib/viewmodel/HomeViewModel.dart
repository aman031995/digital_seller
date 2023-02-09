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

  Future<void> getBannerLists(BuildContext context) async {
    // AppIndicator.loadingIndicator();
    _homePageRepo.getBannerData(context, (result, isSuccess) {
      if (isSuccess) {
        _bannerDataModal =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
      }
    });
  }

  Future<void> getPaginationVideoList(
      BuildContext context,int trayId,int pageNum)async {
    _homePageRepo.getHomePageData(trayId ??  1, pageNum, context,
            (result, isSuccess) {
          if (isSuccess) {
            _homePageDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
            ASResponseModal responseModal =
            (result as SuccessState).value as ASResponseModal;
            _homePageDataModel = responseModal.dataModal;
            TrayDataModel? element;
            PlatformMovieData platformMovieData = new PlatformMovieData(
                element?.trayIdentifier ?? '',
                element?.trayIdentifier ?? '',
                _homePageDataModel!.videoList!);
            element?.updatePlatformData(platformMovieData);
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
        _homePageDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        ASResponseModal responseModal =
            (result as SuccessState).value as ASResponseModal;
        _homePageDataModel = responseModal.dataModal;
        PlatformMovieData platformMovieData = new PlatformMovieData(
            element?.trayIdentifier ?? '',
            element?.trayIdentifier ?? '',
            _homePageDataModel!.videoList!);
        element?.updatePlatformData(platformMovieData);
        notifyListeners();
      }
    });
  }

  Future<void> getTrayData(BuildContext context, bool? isDetail) async {
    _homePageRepo.getTrayDataList(context, (result, isSuccess) {
      if (isSuccess) {
        _trayDataModel =
            ((result as SuccessState).value as ASResponseModal).dataModal;
        if (isDetail == true) {
          getHomePageData(context, _trayDataModel?[0]);
        } else {
          _trayDataModel!.forEach((element) {
            getHomePageData(context, element);
          });
        }
        notifyListeners();
      }
    });
  }
}
