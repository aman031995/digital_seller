import 'package:TychoStream/network/NetworkApiServices.dart';

import 'ASRequestModal.dart';
import 'NetworkConstants.dart';
import 'result.dart';

class ASRequestConstructor {
  // ASRequestConstructor._privateConstructor();
  // static final ASRequestConstructor _instance = ASRequestConstructor._privateConstructor();
  //
  // factory AppDataManager() {
  //   return _instance;
  // }

  String fetchUrl(ASRequestModal requestModal) {
    String finalUrl = requestModal.baseUrl + requestModal.requestIdentifier!;
    if (requestModal.urlParameters != null) {
      requestModal.urlParameters!.forEach((key, value) {
        finalUrl = finalUrl.replaceAll(key, value);
      });
    }
    return finalUrl;
  }

  Future<Result>? _processPUTRequest(
      ASRequestModal requestModal, NetworkResponseHandler responseHandler) {
    NetworkApiServices.processPutRequest(requestModal, responseHandler);
  }

  Future<Result>? _processDELETERequest(
      ASRequestModal requestModal, NetworkResponseHandler responseHandler) {
    NetworkApiServices.processDeleteRequest(requestModal, responseHandler);
  }

  Future<Result>? _processPOSTRequest(
      ASRequestModal requestModal, NetworkResponseHandler responseHandler) {
    NetworkApiServices.processPostRequest(requestModal, responseHandler);
  }

  Future<Result>? _processFORMPOSTRequest(
      ASRequestModal requestModal, NetworkResponseHandler responseHandler) {
    NetworkApiServices.performFormPostOperation(requestModal, responseHandler);
  }

  Future<Result>? _processGETRequest(
      ASRequestModal requestModal, NetworkResponseHandler responseHandler) {
    NetworkApiServices.processGETRequest(requestModal, responseHandler);
  }

  Future<Result>? _processPATCHRequest(
      ASRequestModal requestModal, NetworkResponseHandler responseHandler) {
    // TBD
  }

  Future<Result?> processRequestFor(ASRequestModal requestModal,
      NetworkResponseHandler responseHandler) async {
    String requestUrl = fetchUrl(requestModal);
    requestModal.operationUrl = requestUrl;

    switch (requestModal.requestType) {
      case RequestType.get:
        {
          _processGETRequest(requestModal, responseHandler);
        }
        break;

      case RequestType.post:
        {
          _processPOSTRequest(requestModal, responseHandler);
        }
        break;

      case RequestType.formpost:
        {
          _processFORMPOSTRequest(requestModal, responseHandler);
        }
        break;

      case RequestType.multipartPost:
        {
          _processPOSTRequest(requestModal, responseHandler);
        }
        break;

      case RequestType.put:
        {
          _processPUTRequest(requestModal, responseHandler);
        }
        break;

      case RequestType.delete:
        {
          _processDELETERequest(requestModal, responseHandler);
        }
        break;

      case RequestType.patch:
        {
          _processPATCHRequest(requestModal, responseHandler);
        }
        break;
    }
  }
}
