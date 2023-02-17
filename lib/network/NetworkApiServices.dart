import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/utilities/AppIndicator.dart';
import 'package:tycho_streams/utilities/LogsMessage.dart';
import 'package:tycho_streams/view/screens/login_screen.dart';

import 'ASRequestModal.dart';
import 'NetworkConstants.dart';
import 'result.dart';

class NetworkApiServices  {

  static processGETRequest(requestModal, networkResponseHandler) async {
    try {
      final response = await http.get(Uri.parse(requestModal.operationUrl!),
          headers: requestModal.requestHeader);
      if(response.statusCode == 401){
        logoutButtonPressed(requestModal.context);
      } else {
        if (response.statusCode == 200) {
          dynamic responseJson = json.decode(response.body.toString());
          LogsMessage.logMessage(message: response.request, level: Level.info);
          LogsMessage.logMessage(message: responseJson, level: Level.info);
          networkResponseHandler(Result.success(responseJson), true);
        } else {
          //error
          AppIndicator.disposeIndicator();
          dynamic responseJson = json.decode(response.body.toString());
          LogsMessage.logMessage(message: response.request, level: Level.error);
          LogsMessage.logMessage(message: responseJson, level: Level.error);
          return Result.error("Book list not available");
        }
      }
    } catch (error) {
      AppIndicator.disposeIndicator();
      LogsMessage.logMessage(message: error, level: Level.error);
      return Result.error("Book list not available");
    }
    // throw UnimplementedError("Fail");
  }

 static processPostRequest(requestModal, networkResponseHandler) async {
    switch (requestModal.requestType) {
      case RequestType.multipartPost:
        {
          performMultipartPostOperation(requestModal, networkResponseHandler);
        }
        break;
      case RequestType.formpost:
        {
          performFormPostOperation(requestModal, networkResponseHandler);
        }
        break;
      case RequestType.post:
        {
          performPostOperation(requestModal, networkResponseHandler);
        }
    }
    // TODO: implement processPostRequest
    // throw UnimplementedError("Fail");
  }

  static performFormPostOperation(ASRequestModal requestModal,
      NetworkResponseHandler networkResponseHandler) async {
    try {
      var headers = {"accept": "application/x-www-form-urlencoded"};
      final response = await http.post(Uri.parse(requestModal.operationUrl!),
          headers: headers, body: requestModal.inputParameters);
      if (response.statusCode == 200) {
        dynamic responseJson = json.decode(response.body.toString());
        LogsMessage.logMessage(message: responseJson, level: Level.info);
        networkResponseHandler(Result.success(responseJson), true);
      } else {
        //error
        AppIndicator.disposeIndicator();
        dynamic responseJson = json.decode(response.body.toString());
        LogsMessage.logMessage(message: responseJson, level: Level.error);
        networkResponseHandler(Result.error("Book list not available"), false);
      }
    } catch (error) {
      AppIndicator.disposeIndicator();
      LogsMessage.logMessage(message: error, level: Level.error);
      return Result.error("Book list not available");
    }
  }

  static performPostOperation(ASRequestModal requestModal,
      NetworkResponseHandler networkResponseHandler) async {
    try {
      final response = await http.post(Uri.parse(requestModal.operationUrl!),
          body: requestModal.jsonInputParameters(),
          headers: requestModal.requestHeader);
      if(response.statusCode == 401){
        logoutButtonPressed(requestModal.context!);
      } else {
        if (response.statusCode == 200) {
          dynamic responseJson = json.decode(response.body.toString());
          LogsMessage.logMessage(message: responseJson, level: Level.info);
          networkResponseHandler(Result.success(responseJson), true);
        } else {
          //error
          AppIndicator.disposeIndicator();
          dynamic responseJson = json.decode(response.toString());
          LogsMessage.logMessage(message: responseJson, level: Level.error);
          return Result.error("Book list not available");
        }
      }
    } catch (error) {
      AppIndicator.disposeIndicator();
      //networkResponseHandler(Result.success(responseString), true);
      LogsMessage.logMessage(message: error, level: Level.error);
      return Result.error("Book list not available");
    }
  }

  static performMultipartPostOperation(ASRequestModal requestModal,
      NetworkResponseHandler networkResponseHandler,) async {
    try {
      var request =
      http.MultipartRequest('POST', Uri.parse(requestModal.operationUrl!));
      request.headers.addAll(requestModal.requestHeader!);
      var requestParams = requestModal.inputParameters;
      var fileDetails = requestModal.fileUploadParams;
      if (fileDetails != null) {
        var fileUploadTasks =
        fileDetails[fileDetails.keys.first] as List<FileUploadTask>;
        if (fileUploadTasks != null) {
          for (int index = 0; index < fileUploadTasks.length; index++) {
            request.files.add(await http.MultipartFile.fromPath(
                fileDetails.keys.first, fileUploadTasks[index].filePath,
                filename: fileUploadTasks[index].filePath));
          }
        }
        requestParams?.forEach((key, value) {
          request.fields[key] = value as String;
        });
        var response = await request.send();
        // logRequestAndStreamedResponse(response);
        if (response.statusCode == 200) {
          final respStr = await response.stream.bytesToString();
          dynamic responseJson = json.decode(respStr);
          LogsMessage.logMessage(message: responseJson, level: Level.info);
          networkResponseHandler(Result.success(responseJson), true);
        } else {
          AppIndicator.disposeIndicator();
          dynamic responseJson = json.decode(response.toString());
          LogsMessage.logMessage(message: responseJson, level: Level.error);
          networkResponseHandler(responseJson, false);
        }
      }
    } catch (error) {
      AppIndicator.disposeIndicator();
      LogsMessage.logMessage(message: error, level: Level.error);
      networkResponseHandler(Result.error(error), false);
    }
  }

 static processPutRequest(requestModal, networkResponseHandler) async {
    try {
      final response = await http.put(Uri.parse(requestModal.operationUrl!),
          body: requestModal.jsonInputParameters(),
          headers: requestModal.requestHeader);
      if (response.statusCode == 200) {
        dynamic responseJson = json.decode(response.body.toString());
        LogsMessage.logMessage(message: responseJson, level: Level.info);
        networkResponseHandler(Result.success(responseJson), true);
      } else {
        //error
        AppIndicator.disposeIndicator();
        dynamic responseJson = json.decode(response.body.toString());
        LogsMessage.logMessage(message: responseJson, level: Level.error);
        return Result.error("Book list not available");
      }
    } catch (error) {
      AppIndicator.disposeIndicator();
      LogsMessage.logMessage(message: error, level: Level.error);
      return Result.error("Book list not available");
    }
    // throw UnimplementedError("Fail");
  }

  static processDeleteRequest(ASRequestModal requestModal,
      NetworkResponseHandler networkResponseHandler) async {
    try {
      final response = await http.delete(Uri.parse(requestModal.operationUrl!),
          headers: requestModal.requestHeader, body: requestModal.inputParameters);
      // logRequestAndResponse(response);
      if (response.statusCode == 200) {
        dynamic responseJson = json.decode(response.body.toString());
        LogsMessage.logMessage(message: responseJson, level: Level.info);
        networkResponseHandler(Result.success(responseJson), true);
        //return Result<UserDetails>.success(Library.fromRawJson(response.body));
      } else {
        //error
        AppIndicator.disposeIndicator();
        dynamic responseJson = json.decode(response.body.toString());
        LogsMessage.logMessage(message: responseJson, level: Level.error);
        //return Result.error("Book list not available");
        networkResponseHandler(Result.error("error"), false);
      }
    } catch (error) {
      AppIndicator.disposeIndicator();
      LogsMessage.logMessage(message: error, level: Level.error);
      return networkResponseHandler(Result.error(error), false);
      //return Result.error("Book list not available");
    }
  }

  static void logoutButtonPressed(BuildContext context) async {
    AppDataManager.deleteSavedDetails();
    Navigator.pushNamed(context, '/');
  }
}