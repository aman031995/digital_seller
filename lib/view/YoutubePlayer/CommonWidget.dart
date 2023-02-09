import 'package:flutter/material.dart';

class ChangeValue with ChangeNotifier {

  bool? isCommentAdded, isGalleryImage = false;
  bool? isPlay;
  String? comment;
  String? movieImages;
  bool isMovieImage = false;
  bool isFallow = false;
  bool isAdmin = false;
  FadeInImage? fadeInImage;

  void chapterList() {
    notifyListeners();
  }

  void commentPageUpdate(isComment, comments) {
    isCommentAdded = isComment;
    comment = comments;
    notifyListeners();
  }

  void fallowStatusUpdate(isFallowing) {
    isFallow = isFallowing;
    notifyListeners();
  }

  void checkAdmin(isAdminStatus) {
    isAdmin = isAdminStatus;
    notifyListeners();
  }

  void chatPageRefresh(String movieImage, bool isMovie, FadeInImage movieImg) {
    movieImages = movieImage;
    isMovieImage = isMovie;
    fadeInImage = movieImg;
    notifyListeners();
  }

  void galleryDismiss(bool? isMovie) {
    isGalleryImage = isMovie;
    notifyListeners();
  }

  void updateVideoPlayerState(bool? isPause) {
    isPlay = isPause;
    notifyListeners();
  }
}
