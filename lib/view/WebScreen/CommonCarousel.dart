import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';


class CommonCarousel extends StatefulWidget {
  @override
  _CommonCarouselState createState() => _CommonCarouselState();
}

class _CommonCarouselState extends State<CommonCarousel> {


  final CarouselController carouselController = CarouselController();
  int _current = 0;
  final List<String> images = [
    'images/carousel.png',
    'images/carousel.png',
    'images/carousel.png',
    'images/carousel.png',
    'images/carousel.png',

  ];

  List<Widget> generateImageTiles() {
    return images
        .map((element) => Stack(
          children: [
            Container(
              height: 650,width: 2500,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
              child: Image.asset(element,
                  fit: BoxFit.cover,
                 // alignment: Alignment.topCenter,
                  //height: SizeConfig.screenHeight
                ),
            ),
          ],
        )
            )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var imageSliders = generateImageTiles();
    return  Stack(
          children: [
            Container(
              height:730, width: 2500,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(5)
             ),
             padding: const EdgeInsets.only(top: 15),
             child: CarouselSlider(
               items: imageSliders,
               disableGesture: true,
               options: CarouselOptions(
                   scrollDirection: Axis.horizontal,
                   scrollPhysics: PageScrollPhysics(),
                   viewportFraction:  0.99,
                   enlargeCenterPage: true,
                   autoPlayCurve: Curves.linear,
                   aspectRatio:16/9,
                   autoPlay: true,
                   onPageChanged: (index, reason) {
                     setState(() {
                       _current = index;
                     });
                   }),
               carouselController: carouselController,
             ),
            ),
            Positioned(
              left: 30,top: 350,
              child: Container(
                  child: InkWell(
                      child: Image.asset(
                        'images/prev.png',
                        height: 25,
                        width: 35,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      onTap: previous
                  )
              ),
            ),
            Positioned(
              top: 350,right: 30,
              child: Container(
                color: Colors.transparent,
                child:  InkWell(
                    child: Image.asset(
                      'images/next.png',
                      height: 25,
                      width: 35,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    onTap:next
                )
              ),
            )
      ],
    );
  }

  void next() =>
      carouselController.nextPage(duration: Duration(milliseconds: 200));

  void previous() =>
      carouselController.previousPage(duration: Duration(milliseconds: 200));
}
