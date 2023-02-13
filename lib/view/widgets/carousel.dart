import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/three_arched_circle.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';

class CommonCarousel extends StatefulWidget with ChangeNotifier {
  CommonCarousel({Key? key}) : super(key: key);

  @override
  State<CommonCarousel> createState() => _CommonCarouselState();
}

class _CommonCarouselState extends State<CommonCarousel> {
  final CarouselController carouselController = CarouselController();
  FocusNode carouselFocus = FocusNode();
  int current = 0;
  final HomeViewModel homeViewModel = HomeViewModel();

  @override
  void initState() {
    // TODO: implement initState
    homeViewModel.getBannerLists(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final homePageVM = Provider.of<HomeViewModel>(context);
    return ChangeNotifierProvider<HomeViewModel>(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, homeViewModel, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                homeViewModel.bannerDataModal != null
                    ? carouselImages()
                    : Container(
                        height: SizeConfig.screenHeight * 0.25,
                        child: Center(
                          child: ThreeArchedCircle(color: THEME_COLOR, size: 50.0)
                        ),
                      ),
              ],
            ),
          );
        }));
    ;
  }

  Widget carouselImages() {
    var imageSliders = generateImageTiles(context);
    return Container(
        height: SizeConfig.screenHeight * 0.20,
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(left: 15.0,right: 15.0, top: 10.0),
        child: Column(
          children: [
            CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                  scrollDirection: Axis.horizontal,
                  scrollPhysics: PageScrollPhysics(),
                  viewportFraction: 1,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  onPageChanged: (index, reason) {
                    setState(() {
                      current = index;
                    });
                  }),
              carouselController: carouselController,
            ),
            // Positioned(
            //   left: 160,
            //   bottom: 5,
            //   child: Center(
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: _buildIndicator(),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildIndicator(),
              ),
            )
          ],
        ));
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 12,
      width: 12,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: isActive == true ? THEME_COLOR : GREY_COLOR,
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
    if (homeViewModel.bannerDataModal!.bannerList!.length < 5) {
      return homeViewModel.bannerDataModal!.bannerList!.length;
    } else {
      return 6;
    }
  }

  List<Widget> generateImageTiles(BuildContext context) {
    return homeViewModel.bannerDataModal!.bannerList!
        .map((element) => InkWell(
            focusNode: carouselFocus,
            onTap: () {
              print(current);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage(element.bannerFile ?? ""),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
              // child: Image.network(element.bannerFile ?? "",
              //     fit: BoxFit.fill, height: SizeConfig.screenHeight)
            )))
        .toList();
  }
}
