import 'package:TychoStream/utilities/AppColor.dart';
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
            height: 250,width: SizeConfig.screenWidth,
            child: CachedNetworkImage(
                imageUrl: '${widget.images![0]}',fit: BoxFit.cover,
                placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Colors.grey)))

        ) : CarouselSlider(
          items: widget.images
              ?.map((img) => Container(
            child: Image.network(img),
          )).toList(),
          options: CarouselOptions(
            height: 250,
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
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: widget.images!.map((url) {
        //  index = widget.images!.indexOf(url);
        // return Container(
        //   width: 8.0,
        //   height: 8.0,
        //   margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
        //   decoration:
        //   widget.images?.length==1?  BoxDecoration():
        //   BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: _current == index
        //         ? Theme.of(context).primaryColor
        //         :Theme.of(context).primaryColor.withOpacity(0.5),
        //   ),
        // );
        //   }).toList(),
        // ),

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
