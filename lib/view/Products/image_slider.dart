import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  List<String>? images;
  final int activeIndex;

  ImageSlider({required this.images, required this.activeIndex});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.images
              ?.map((img) => Container(
            child: Image.network(img),
          ))
              .toList(),
          options: CarouselOptions(
            height: 180,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            initialPage: widget.activeIndex,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images!.map((url) {
            int index = widget.images!.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Theme.of(context).primaryColor
                    :Theme.of(context).primaryColor.withOpacity(0.5),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
