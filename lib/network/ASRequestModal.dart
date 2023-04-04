import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

import 'NetworkConstants.dart';

enum RequestType { get, post, patch, delete, formpost, multipartPost, put }

class FileUploadTask {
  String filename = "";
  String? type;
  String? key;
  String filePath = "";
  String completeName = "";
  FileUploadTask(String fName, String fPath, {String? key, String? fType}) {
    this.filename = fName;
    this.type = fType;
    this.key = key;
    this.filePath = fPath;
  }

  FileUploadTask.fromPathString(String path) {
    this.filePath = path;
    this.filename = path.split("/").last.split(".").first;
    this.type = path.split("/").last.split(".").last;
  }

  FileUploadTask.fromFilePath(XFile path) {
    this.filePath = path.path;
    this.completeName = path.path.split("/").last;
    this.filename = path.path.split("/").last.split(".").first;
    this.type = path.path.split("/").last.split(".").last;
  }
}

class ASRequestModal {
  Map<String, dynamic>? inputParameters;
  Map<String, String>? urlParameters;
  RequestType? requestType;
  String? requestIdentifier;
  String? requestTag;
  String baseUrl = NetworkConstants.kAppBaseUrl;
  String? operationUrl;
  String? spinnerText;
  String? modalClass;
  Map<String, String>? requestHeader = {"Content-Type": "application/json"};
  bool? cacheData;
  bool? stubEnabled;
  bool? consumeError;
  bool? customErrorHandler;
  BuildContext? context;
  Map<String, dynamic>? fileUploadParams;

  ASRequestModal(String? rIdentifier, RequestType? rType,
      {BuildContext? context, Map<String, String>? headers}) {
    this.requestIdentifier = rIdentifier;
    this.requestType = rType!;
    this.context = context!;
    if (headers != null) {
      this.requestHeader = headers;
    }
  }

  addFileUploadRequest(List<XFile> paths, {required String key}) {
    List<FileUploadTask> uploadTasks = new List.empty(growable: true);
    paths.forEach((element) {
      uploadTasks.add(FileUploadTask.fromFilePath(element));
    });
    fileUploadParams = {key: uploadTasks};
  }

  addFileUploadRequestWithPathString(List<String> paths,
      {required String key}) {
    List<FileUploadTask> uploadTasks = new List.empty(growable: true);
    paths.forEach((element) {
      uploadTasks.add(FileUploadTask.fromPathString(element));
    });
    fileUploadParams = {key: uploadTasks};
  }

  ASRequestModal.withUrlAndInputParams(Map<String, dynamic> iParams,
      Map<String, String> urlParams, String rIdentifier, RequestType rType,
      {BuildContext? context,
      Map<String, String>? headers,
      Map<String, String>? fileUploadParams}) {
    this.requestIdentifier = rIdentifier;
    this.requestType = rType;
    this.inputParameters = iParams;
    this.urlParameters = urlParams;
    this.context = context;
    if (headers != null) {
      this.requestHeader = headers;
    }
  }

  ASRequestModal.withUrlParams(
      Map<String, String> urlParams, String rIdentifier, RequestType rType,
      {BuildContext? context, Map<String, String>? headers}) {
    this.requestIdentifier = rIdentifier;
    this.requestType = rType;
    this.urlParameters = urlParams;
    this.context = context;
    if (headers != null) {
      this.requestHeader = headers;
    }
  }

  ASRequestModal.withInputParams(
      Map<String, dynamic> iParams, String rIdentifier, RequestType rType,
      {BuildContext? context,
      String? modalClass,
      Map<String, String>? headers,
      Map<String, String>? fileUploadParams}) {
    this.requestIdentifier = rIdentifier;
    this.requestType = rType;
    this.inputParameters = iParams;
    this.context = context;
    this.modalClass = modalClass;
    if (headers != null) {
      this.requestHeader = headers;
    }
    //this.fileUploadParams = fileUploadParams;
  }

  dynamic jsonInputParameters() {
    return JsonEncoder().convert(inputParameters);
  }
}
