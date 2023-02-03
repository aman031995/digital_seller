import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';

class CommonCarousel extends StatefulWidget with ChangeNotifier {
  CommonCarousel({Key? key}) : super(key: key);

  @override
  State<CommonCarousel> createState() => _CommonCarouselState();
}

class _CommonCarouselState extends State<CommonCarousel> {
  final CarouselController carouselController = CarouselController();
  FocusNode carouselFocus = FocusNode();
  FocusNode focus = FocusNode();
  TextEditingController? editingController = TextEditingController();
  int current = 0;

  final List<String> images = [
    'assets/images/carousel2.png',
    'assets/images/carousel2.png',
    'assets/images/carousel2.png',
    'assets/images/carousel2.png',
    'assets/images/carousel2.png',
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          homePageTopBar(),
          carouselImages(),
        ],
      ),
    );
  }

  Widget homePageTopBar() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 15, right: 10),
      child: Row(
        children: [
          Image.asset(AssetsConstants.icLogo, height: 50, width: 50),
          Container(
              height: 50,
              width: SizeConfig.screenWidth! * 0.65,
              margin: EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent, width: 2.0),
              ),
              child: new TextField(
                  maxLines: editingController!.text.length > 2 ? 2 : 1,
                  controller: editingController,
                  decoration: new InputDecoration(
                      hintText: StringConstant.search,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintStyle: TextStyle(color: GREY_COLOR)),
                  onChanged: (m) {},
                ),
              ),
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: BOX_COLOR,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Image.asset(
                AssetsConstants.icNotification,
                height: 45,
                width: 45,
              ))
        ],
      ),
    );
  }

  Widget carouselImages() {
    var imageSliders = generateImageTiles(context);
    return Column(
      children: [
        Container(
          height: 200,
          margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(
                scrollDirection: Axis.horizontal,
                scrollPhysics: PageScrollPhysics(),
                viewportFraction: 1,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 10),
                onPageChanged: (index, reason) {
                  setState(() {
                    current = index;
                  });
                }),
            carouselController: carouselController,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildIndicator(),
          ),
        ),
      ],
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 12,
      width: 12,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: isActive == true ? THEME_BUTTON : GREY_COLOR,
          borderRadius: BorderRadius.circular(5)),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < getCarouselIndicator(); i++) {
      if (current == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }
    return indicators;
  }

  getCarouselIndicator() {
    if (images.length <= 6) {
      return images.length;
    } else {
      return 6;
    }
  }

  List<Widget> generateImageTiles(BuildContext context) {
    return images
        .map((element) => InkWell(
            focusNode: carouselFocus,
            onTap: () {
              print(current);
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Image.asset(element,
                    fit: BoxFit.fill, height: SizeConfig.screenHeight))))
        .toList();
  }
}
