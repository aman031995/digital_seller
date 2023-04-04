import 'package:flutter/material.dart';

class PhotoAndVideoPopUp extends StatefulWidget {
  Function? onGallerySelection;
  Function? onCameraSelection;
  String? text;

  PhotoAndVideoPopUp({this.onGallerySelection, this.onCameraSelection, this.text});

  @override
  _PhotoAndVideoPopUpState createState() => _PhotoAndVideoPopUpState();
}

class _PhotoAndVideoPopUpState extends State<PhotoAndVideoPopUp> {
  double? _height, _width;
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: Text("Make a Good Choice"),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            GestureDetector(
              child: Text("Gallery"),
              onTap: () {
                widget.onGallerySelection!();
                Navigator.of(context).pop();
              },
            ),
            Padding(padding: EdgeInsets.all(8.0)),
            GestureDetector(
              child: Text("Camera"),
              onTap: () {
                widget..onCameraSelection!();
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
