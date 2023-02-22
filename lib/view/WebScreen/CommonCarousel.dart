import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
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
          return homeViewModel.bannerDataModal != null
              ? ResponsiveWidget.isMediumScreen(context)?carouselImage() :carouselImages()
              : Container(
            height: SizeConfig.screenHeight * 0.3,
            child: Center(
                child: ThreeArchedCircle(color: THEME_COLOR, size: 50.0)
            ),
          );
        }));
    ;
  }


  Widget carouselImages() {
    var imageSliders = generateImageTiles(context);
    return Stack(
      children: [
        Container(
          height:  700,width: 2500,
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
                    current = index;
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
        )],
    );
  }
  Widget carouselImage() {
    var imageSliders = generateImageTile(context);
    return CarouselSlider(
      items: imageSliders,
      options: CarouselOptions(
          scrollDirection: Axis.horizontal,
          scrollPhysics: PageScrollPhysics(),
          viewportFraction: 1,
          aspectRatio: 2,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          onPageChanged: (index, reason) {
            setState(() {
              current = index;
            });
          }),
      carouselController: carouselController,
    );
  }
  List<Widget> generateImageTile(BuildContext context) {
    return homeViewModel.bannerDataModal!.bannerList!
        .map((element) => InkWell(
        focusNode: carouselFocus,
        onTap: () {
          print(current);
        },
        child: Container(
          margin: EdgeInsets.only(left: 10,right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: NetworkImage(element.bannerFile ?? ""),
              // alignment: Alignment.topCenter,
              fit: BoxFit.fill
            ),
          ),
          // child: Image.network(element.bannerFile ?? "",
          //     fit: BoxFit.fill, height: SizeConfig.screenHeight)
        )))
        .toList();
  }
  List<Widget> generateImageTiles(BuildContext context) {
    return homeViewModel.bannerDataModal!.bannerList!
        .map((element) =>  Stack(
      children: [
        Container(
          height: 650,width: 2500,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          child: Image.network(element.bannerFile?? " ",
            fit: BoxFit.fill,
            //height: SizeConfig.screenHeight
          ),
        ),
      ],
    )
    )
        .toList();
  }


  void next() =>
      carouselController.nextPage(duration: Duration(milliseconds: 500));
  void previous() =>
      carouselController.previousPage(duration: Duration(milliseconds: 500));
}

