import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:tycho_streams/utilities/AppToast.dart';
import 'package:tycho_streams/utilities/AppIndicator.dart';
import 'ASRequestConstructor.dart';
import 'ASRequestModal.dart';
import 'ASResponseModal.dart';
import 'NetworkConstants.dart';
import 'result.dart';

class AppNetwork {
  Future<Result?> getNetworkResponse(ASRequestModal requestModal,BuildContext context,
      NetworkResponseHandler responseHandler) async {
    bool isConnected = await isConnectedToInternet();
    if (isConnected) {
      ASRequestConstructor requestConstructor = ASRequestConstructor();
      requestConstructor.processRequestFor(requestModal, (result, isSuccess) {
        var response = ASResponseModal.fromResult(result,
            identifier: requestModal.requestTag);
        if (isSuccess == false || response.status == false) {
          AppIndicator.disposeIndicator();
          handleErrorResponse(response.message!);
        } else {
          AppIndicator.disposeIndicator();
          handleSuccessResponse(result, requestModal, responseHandler);
        }
      });
    } else {
      AppIndicator.disposeIndicator();
      handleErrorResponse("internet is not available");
    }
  }

  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool isConnected = false;
    if (connectivityResult == ConnectivityResult.mobile) {
      isConnected = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isConnected = true;
    }
    return isConnected;
  }

  handleErrorResponse(String message) {
    ToastMessage.message(message);
  }

  handleSuccessResponse(Result result, ASRequestModal forRequest,
      NetworkResponseHandler networkResponseHandler) {
    networkResponseHandler(result, true);
  }

  static Future<void> checkInternet(
      InternetResponseHandler internetResponseHandler) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      internetResponseHandler(true, "Offline");
    } else if (connectivityResult == ConnectivityResult.mobile) {
      internetResponseHandler(true, "Mobile");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      internetResponseHandler(true, "wifi");
    }
  }
}
