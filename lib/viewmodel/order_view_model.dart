

import 'package:TychoStream/model/data/order_data_model.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/repository/OrderDetailRepository.dart';
import 'package:flutter/cupertino.dart';

class OrderViewModel extends ChangeNotifier {
  final _orderRepo = OrderDetailRepository();

  OrderDataModel? _orderDataModel;
  OrderDataModel? get orderData => _orderDataModel;

  //GetOrderList Method
  Future<void> getOrderList(BuildContext context) async {
    _orderRepo.getOrderList(context, (result, isSuccess) {
      if (isSuccess) {
        _orderDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        // AppIndicator.disposeIndicator();
         notifyListeners();
      }
    });
  }
  //GetOrderDetail Method
  Future<void> getOrderDetail(BuildContext context, value, int orderId) async {
    // _orderRepo.getOrderListDetail(orderId, context, (result, isSuccess) {
    //   if (isSuccess) {
    //     _orderDataModel =
    //         ((result as SuccessState).value as ASResponseModal).dataModal;
    //     AppIndicator.disposeIndicator();
    //     notifyListeners();
    //   }
    // });
  }
}