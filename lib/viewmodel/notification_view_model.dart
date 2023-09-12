import 'package:TychoStream/model/data/cart_detail_model.dart';
import 'package:TychoStream/model/data/notification_model.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/repository/notifcation_repo.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:flutter/material.dart';


class NotificationViewModel with ChangeNotifier{
  final _notificationRepo = NotificationRepository();

  NotificationModel? _notificationModel;
  NotificationModel? get notificationModel => _notificationModel;

  NotificationModel? _newNotificationModel;
  NotificationModel? get newNotificationModel => _newNotificationModel;

  ItemCountModel? _itemCountModel;
  ItemCountModel? get itemCountModel => _itemCountModel;

  HomeViewModel homeViewModel = HomeViewModel();

  int lastPage = 1, nextPage = 1;
  bool isLoading = false;
  String notificationItem = '0';
  String logFilePath = '';

  // notification method
  void getNotification(BuildContext context, int pageNum){
    _notificationRepo.getNotification(pageNum,context, (result, isSuccess) {
      if(isSuccess){
        _newNotificationModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        if (_newNotificationModel?.pagination?.current == 1) {
          lastPage = _newNotificationModel?.pagination?.lastPage ?? 1;
          nextPage = _newNotificationModel?.pagination?.next ?? 1;
          _notificationModel = _newNotificationModel;
        } else {
          lastPage = _newNotificationModel?.pagination?.lastPage ?? 1;
          nextPage = _newNotificationModel?.pagination?.next ?? 1;
          _notificationModel?.notificationList?.addAll(_newNotificationModel!.notificationList!);
        }
        isLoading = false;
        AppIndicator.disposeIndicator();
        _notificationRepo.readNotification(context, (result, isSuccess) { });
        notifyListeners();
      }
    });
  }

  // get notification count method
  Future<void> getNotificationCountText(BuildContext context) async {
    _notificationRepo.getNotificationCount(context, (result, isSuccess) {
      if (isSuccess) {
        _itemCountModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        notificationItem = _itemCountModel?.count.toString() ?? '';
        notifyListeners();
      }
    });
  }

  Future<void> updateNotificationCount(BuildContext context, String count) async {
    notificationItem = count;
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


}
