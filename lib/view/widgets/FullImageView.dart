import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/three_arched_circle.dart';

class FullImage extends StatefulWidget {
  String? imageUrl;
  FullImage({this.imageUrl});

  @override
  _FullImageState createState() => _FullImageState();
}

class _FullImageState extends State<FullImage> {
  var index = 0;

  PageController? pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          child: Stack(
            children: <Widget>[
              getImageView(),
              Positioned(
                top: 40.0,
                right: 20.0,
                child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              )
            ],
          ),
        ));
  }

  void onPageChanged(int indexss) {
    setState(() {
      index = indexss;
    });
  }

  Widget getImageView() {
    return Container(
        child: PhotoViewGallery.builder(
          scrollPhysics: BouncingScrollPhysics(),
          builder: (BuildContext context, int indexss) {
            String? photoUrl = widget.imageUrl;
            return PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider(photoUrl!),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          itemCount: 1,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 50.0,
              height: 50.0,
              child: ThreeArchedCircle(color: THEME_COLOR, size: 45.0)
            ),
          ),
          pageController: pageController,
          onPageChanged: onPageChanged,
          enableRotation: true,
          // reverse: true,
        ));
  }
}
