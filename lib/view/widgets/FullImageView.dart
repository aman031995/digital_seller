import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';

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
        backgroundColor:  Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          height: 500,
          child: Stack(
            children: <Widget>[
              Image.network(
                'https://example.com/image.jpg',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              // getImageView(),
              Positioned(
                top: 40.0,
                right: 20.0,
                child: IconButton(
                    icon: Icon(
                      Icons.close,
                      
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
      height: 500,
        width: 500,
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
              child: ThreeArchedCircle( size: 45.0)
            ),
          ),
          pageController: pageController,
          onPageChanged: onPageChanged,
          enableRotation: true,
          // reverse: true,
        ));
  }
}
