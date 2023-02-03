import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ASRequestModal.dart';
import 'NetworkConstants.dart';
import 'result.dart';

class NetworkApiServices  {

  static processGETRequest(requestModal, networkResponseHandler) async {
    try {
      final response = await http.get(Uri.parse(requestModal.operationUrl!),
          headers: requestModal.requestHeader);
      if (response.statusCode == 200) {
        dynamic responseJson = json.decode(response.body.toString());
        networkResponseHandler(Result.success(responseJson), true);
      } else {
        //error
        dynamic responseJson = json.decode(response.body.toString());
        return Result.error("Book list not available");
      }
    } catch (error) {
      return Result.error("Book list not available");
    }
    throw UnimplementedError("Fail");
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
    throw UnimplementedError("Fail");
  }

  static performFormPostOperation(ASRequestModal requestModal,
      NetworkResponseHandler networkResponseHandler) async {
    try {
      var headers = {"accept": "application/x-www-form-urlencoded"};
      final response = await http.post(Uri.parse(requestModal.operationUrl!),
          headers: headers, body: requestModal.inputParameters);
      if (response.statusCode == 200) {
        dynamic responseJson = json.decode(response.body.toString());
        networkResponseHandler(Result.success(responseJson), true);
      } else {
        //error
        dynamic responseJson = json.decode(response.body.toString());
        networkResponseHandler(Result.error("Book list not available"), false);
      }
    } catch (error) {
      return Result.error("Book list not available");
    }
  }

  static performPostOperation(ASRequestModal requestModal,
      NetworkResponseHandler networkResponseHandler) async {
    try {
      final response = await http.post(Uri.parse(requestModal.operationUrl!),
          body: requestModal.jsonInputParameters(),
          headers: requestModal.requestHeader);
      if (response.statusCode == 200) {
        dynamic responseJson = json.decode(response.body.toString());
        networkResponseHandler(Result.success(responseJson), true);
      } else {
        //error
        dynamic responseJson = json.decode(response.toString());
        return Result.error("Book list not available");
      }
    } catch (error) {
      //networkResponseHandler(Result.success(responseString), true);
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
          networkResponseHandler(Result.success(responseJson), true);
        } else {
          networkResponseHandler(Result.error("error"), false);
        }
      }
    } catch (error) {
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
        networkResponseHandler(Result.success(responseJson), true);
      } else {
        //error
        dynamic responseJson = json.decode(response.body.toString());
        return Result.error("Book list not available");
      }
    } catch (error) {
      return Result.error("Book list not available");
    }
    throw UnimplementedError("Fail");
  }

  static processDeleteRequest(requestModal, networkResponseHandler) async {
    try {
      final response = await http.delete(Uri.parse(requestModal.operationUrl!),
          headers: requestModal.requestHeader);
      if (response.statusCode == 200) {
        dynamic responseJson = json.decode(response.body.toString());
        networkResponseHandler(Result.success(responseJson), true);
        //return Result<UserDetails>.success(Library.fromRawJson(response.body));
      } else {
        //error
        dynamic responseJson = json.decode(response.body.toString());
        return Result.error("Book list not available");
      }
    } catch (error) {
      return Result.error("Book list not available");
    }
    throw UnimplementedError("Fail");
  }
}