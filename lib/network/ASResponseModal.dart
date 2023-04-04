import 'result.dart';

abstract class DataParsing {
  parsedObjectFromJSON(Map<String, dynamic> json);
}

class ASResponseModal {
  bool? status;
  int? code;
  String? message;
  String? responseIdentifier;
  dynamic dataModal;

  ASResponseModal(Map<String, dynamic> json) {
    this.status = json['status'];
    this.code = json['code'];
    this.message = json['message'];
  }

  ASResponseModal.fromResult(Result result, {String? identifier}) {
    Map<String, dynamic> map = (result as SuccessState).value as Map<String, dynamic>;
    this.status = map['status'];
    this.code = map['code'];
    this.message = map['message'];
    this.responseIdentifier = identifier;
  }
}
