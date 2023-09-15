import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
    SizeConfig().init(context);

    return AlertDialog(
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: GestureDetector(
          child: Stack(
            children: <Widget>[
              getImageView(),
              Positioned(
                top: 10.0,
                right: 20.0,
                child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: WHITE_COLOR,
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
      width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: PhotoViewGallery.builder(
          scrollPhysics: BouncingScrollPhysics(),
          builder: (BuildContext context, int indexss) {
            String? photoUrl = widget.imageUrl;
            return PhotoViewGalleryPageOptions(

              imageProvider: CachedNetworkImageProvider(photoUrl!),
              minScale: PhotoViewComputedScale.contained ,
              maxScale: PhotoViewComputedScale.covered ,
            );
          },
          itemCount: 1,
          loadingBuilder: (context, event) => Center(
            child: ThreeArchedCircle( size: 45.0),
          ),
          pageController: pageController,
          onPageChanged: onPageChanged,
          enableRotation: true,
          // reverse: true,
        ));
  }
}
