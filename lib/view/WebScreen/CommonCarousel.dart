import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/three_arched_circle.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:url_launcher/url_launcher.dart';
String url='https://www.instagram.com';
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
    return ChangeNotifierProvider<HomeViewModel>(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, homeViewModel, _) {
          return
            homeViewModel.bannerDataModal != null
                ? ResponsiveWidget.isMediumScreen(context)?carouselImageMobile() :
            carouselImageWeb()
                : Container(
              height: SizeConfig.screenHeight * 0.35,
              child: Center(
                  child: ThreeArchedCircle( size: 50.0)
              ),
            );
        }));
    ;
  }

//--WebCarousel---//
  Widget carouselImageWeb() {
    var imageSliders = generateImageTilesWeb(context);
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15,right: 15),
          height: SizeConfig.screenHeight/2.2,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5)
          ),
          child: CarouselSlider(
            items: imageSliders,
            disableGesture: true,
            options: CarouselOptions(
                autoPlayInterval: Duration(seconds: 2),
                scrollDirection: Axis.horizontal,
                scrollPhysics: PageScrollPhysics(),
                viewportFraction:  1,
                enlargeCenterPage: false,
                autoPlayCurve: Curves.linear,
                aspectRatio:16/9,
                autoPlay: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    current = index;
                  });
                }),
            carouselController: carouselController,
          ),
        ),
        Positioned(
          left: 30,top:  SizeConfig.screenHeight/4.2,
          child: InkWell(
              child: Image.asset(
                  'images/prev.png',
                  height: 40,
                  width: 30,
                  color:Colors.white54
              ),
              onTap: previous
          ),
        ),
        Positioned(
          top:  SizeConfig.screenHeight/4.2,right: 30,
          child: InkWell(
              child: Image.asset(
                  'images/next.png',
                  height: 40,
                  width: 30,
                  color: Colors.white54
              ),
              onTap:next
          ),
        )],
    );
  }
  List<Widget> generateImageTilesWeb(BuildContext context) {
    return homeViewModel.bannerDataModal!.bannerList!
        .map((element) =>  InkWell(
      focusNode: carouselFocus,
      onTap: () async {
        print(current);
        url = '${homeViewModel.bannerDataModal?.bannerList?[current].bannerUrl }';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }},
      child:
      Container(
        height: 600,width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(left: 0,right: 0,top: 0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
        child: Image.network(element.bannerFile?? " ",
            fit: BoxFit.fill
          //height: SizeConfig.screenHeight
        ),
      ),
    )
    )
        .toList();
  }

  //--MobileCarousel--//
  Widget carouselImageMobile() {
    var imageSliders = generateImageTileMobile(context);
    return CarouselSlider(
      items: imageSliders,
      options: CarouselOptions(
          scrollDirection: Axis.horizontal,
          scrollPhysics: PageScrollPhysics(),
          viewportFraction: 1,
          aspectRatio: 1.8,
          enlargeCenterPage: false,
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
  List<Widget> generateImageTileMobile(BuildContext context) {
    return homeViewModel.bannerDataModal!.bannerList!
        .map((element) => InkWell(
        focusNode: carouselFocus,
        onTap: () async {
          print(current);
          url = '${homeViewModel.bannerDataModal?.bannerList?[current].bannerUrl }';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }},
        child: Container(
          margin: EdgeInsets.only(left: 10,right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
                image: NetworkImage(element.bannerFile ?? ""),
                fit: BoxFit.fill
            ),
          ),
          // child: Image.network(element.bannerFile ?? "",
          //     fit: BoxFit.fill, height: SizeConfig.screenHeight)
        )))
        .toList();
  }



  void next() =>
      carouselController.nextPage(duration: Duration(milliseconds: 500));
  void previous() =>
      carouselController.previousPage(duration: Duration(milliseconds: 500));
}

