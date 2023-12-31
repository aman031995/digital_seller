import 'package:TychoStream/model/data/order_data_model.dart';
import 'package:TychoStream/model/data/order_detail_model.dart';
import 'package:TychoStream/network/ASResponseModal.dart';
import 'package:TychoStream/network/result.dart';
import 'package:TychoStream/repository/OrderDetailRepository.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:flutter/cupertino.dart';

class OrderViewModel extends ChangeNotifier {
  final _orderRepo = OrderDetailRepository();
  OrderDataModel? _orderDataModel;
  OrderDataModel? get orderData => _orderDataModel;
  OrderDetailModel? _orderDetailModel;
  OrderDetailModel? get orderDetailModel => _orderDetailModel;
  OrderDataModel? _orderNewDataModel;
  OrderDataModel? get orderNewDataModel => _orderNewDataModel;
  bool isLoading = false;
  int lastPage = 1, nextPage = 1;

  //method for GetOrderList Method
  Future<void> getOrderList(BuildContext context,int pageNum) async {
    _orderRepo.getOrderList(context,pageNum, (result, isSuccess) {
      if (isSuccess) {
        dataPagination(result);
        isLoading = false;
        notifyListeners();
      }
    });
  }

  //method for getOrderDetails
  Future<void> getOrderDetails(BuildContext context, String orderItemId) async{
    _orderRepo.getOrderListDetail(orderItemId, context, (result, isSuccess) {
      if(isSuccess){
        _orderDetailModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
      }
    });
  }

  // method for cancel order method
  Future<void> cancelOrder(BuildContext context, String orderId, String itemId) async{
    AppIndicator.loadingIndicator(context);
    _orderRepo.cancelOrder(context,orderId, itemId, (result, isSuccess) {
      if(isSuccess){
        ToastMessage.message(((result as SuccessState).value as ASResponseModal).message,context);
        AppIndicator.disposeIndicator();
        getOrderDetails(context, itemId);
        notifyListeners();
      }
    });
  }

  dataPagination(Result result){
    _orderNewDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
    if(_orderNewDataModel?.pagination?.current == 1){
      lastPage = _orderNewDataModel?.pagination?.lastPage ?? 1;
      nextPage = _orderNewDataModel?.pagination?.next ?? 1;
      _orderDataModel = _orderNewDataModel;
    } else {
      lastPage = _orderNewDataModel?.pagination?.lastPage ?? 1;
      nextPage = _orderNewDataModel?.pagination?.next ?? 1;
      _orderDataModel?.orderList?.addAll(_orderNewDataModel!.orderList!);
    }
  }

  Future<void> runIndicator(BuildContext context) async {
    isLoading = true;
    notifyListeners();
  }

  onPagination(BuildContext context, int lastPage, int nextPage, bool isLoading) {
    if (isLoading) return;
    isLoading = true;
    if (nextPage <= lastPage) {
      runIndicator(context);
      getOrderList(context,nextPage);
    }
  }

  //method for GetOrderDetail Method
  Future<void> getOrderDetail(BuildContext context, String orderId) async {
    _orderRepo.getOrderListDetail(orderId, context, (result, isSuccess) {
      if (isSuccess) {
        _orderDataModel = ((result as SuccessState).value as ASResponseModal).dataModal;
        notifyListeners();
      }
    });
   }
}