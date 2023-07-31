import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  List<String>? images;


  ImageSlider({required this.images});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.images?.length==1? Container(
            height:ResponsiveWidget.isMediumScreen(context)
                ? 189: 400,
            width: SizeConfig.screenWidth,
            child: CachedNetworkImage(
                imageUrl: '${widget.images![0]}',fit: BoxFit.fill,
                placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Colors.grey)))

        ) : CarouselSlider(
          items: widget.images
              ?.map((img) => Container(
            width: SizeConfig.screenWidth,
            child: Image.network(img,fit: BoxFit.fill,),
          )).toList(),
          options: CarouselOptions(
            height:ResponsiveWidget.isMediumScreen(context)
                ?189: 400,
            aspectRatio: 16/8,
            viewportFraction: 2,
            initialPage:  0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: false,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              _current = index;
            },
          ),
        ),
        Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildIndicator(),
            )
        )
      ],
    );
  }

  // carousel indicators
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 8,
      width: 8,
      margin: EdgeInsets.only(right: 5,top: 2),
      decoration: BoxDecoration(
          color: isActive == true ? Theme.of(context).primaryColor : GREY_COLOR,
          borderRadius: BorderRadius.circular(5)),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < getCarouselIndicator(); i++) {
      if (_current == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }
    return indicators;
  }

  getCarouselIndicator() {
    if (widget.images!.length >1) {
      return widget.images?.length;
    } else {
      return 0;
    }
  }
}
