import 'package:tycho_streams/model/data/HomePageDataModel.dart';

class TrayDataModel {
  int? trayId;
  String? trayTitle;
  int? trayOrder;
  String? trayIdentifier;
  PlatformMovieData? platformMovieData;

  TrayDataModel({this.trayId, this.trayTitle, this.trayOrder, this.trayIdentifier});

  TrayDataModel.fromJson(Map<String, dynamic> json) {
    trayId = json['trayId'];
    trayTitle = json['trayTitle'];
    trayOrder = json['trayOrder'];
    trayIdentifier = json['trayIdentifier'];
  }

  updatePlatformData(PlatformMovieData platformMovieData) {
    this.platformMovieData = platformMovieData;
  }

  PlatformMovieData? platformData() {
    return this.platformMovieData;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trayId'] = this.trayId;
    data['trayTitle'] = this.trayTitle;
    data['trayOrder'] = this.trayOrder;
    data['trayIdentifier'] = this.trayIdentifier;
    return data;
  }
}