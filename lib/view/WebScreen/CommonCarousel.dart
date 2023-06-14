import 'package:TychoStream/AppRouter.gr.dart';
import 'package:TychoStream/model/data/BannerDataModel.dart';
import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:url_launcher/url_launcher.dart';

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
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 15),
            height: SizeConfig.screenHeight/3,
            width: SizeConfig.screenWidth/1.5,
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
        ),
        Positioned(
          left: SizeConfig.screenWidth*0.17,top:  SizeConfig.screenHeight/6,
          child: InkWell(
              child: Image.asset(
                  'images/prev.png',
                  height: 40,
                  width: 30,
                  color: Colors.black45
              ),
              onTap: previous
          ),
        ),
        Positioned(
          top:  SizeConfig.screenHeight/6,right:SizeConfig.screenWidth*0.17,
          child: InkWell(
              child: Image.asset(
                  'images/next.png',
                  height: 40,
                  width: 30,
                  color: Colors.black45
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
        // print(current);
        // url = '${homeViewModel.bannerDataModal?.bannerList?[current].bannerUrl }';
        // if (await canLaunch(url)) {
        //   await launch(url);
        // } else {
        //   throw 'Could not launch $url';
        // }
        redirectPage(homeViewModel.bannerDataModal?.bannerList?[current]);

        },
      child:
      Container(
        height: SizeConfig.screenHeight/3,width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(left: 0,right: 0,top: 0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
        child: Image.network(element.bannerUrl?? " ",
            fit: BoxFit.fill
          //height: SizeConfig.screenHeight
        ),
      ),
    )
    )
        .toList();
  }
  // image click redirection handling
  void redirectPage(BannerList? element) {
    if (element != null) {

      if(element.bannerType == 'Product'){
        if(element.productId != ""){
          context.router.push(Banner_product(
            productId: element.productId,
            productdata: '${element.catId}'
          ));
         // AppNavigator.push(context, ProductDetailPage(bannerData: element));
        } else {
          context.router.push(ProductListGallery(
          ));
         // AppNavigator.push(context, ProductListGallery(bannerListData: element));
        }
      } else if (element.bannerType == 'Video') {
        // AppNavigator.push(context, MovieDetailPage(
        //     isHomeBanner: true,
        //     movieID: element.videoUrl,
        //     bannerList:
        //     homeViewModel.bannerDataModal?.bannerList?[current]
        // ));
      } else {
        launch(element.bannerUrl! , forceSafariVC: false);
      }

    }
  }
  //--MobileCarousel--//
  Widget carouselImageMobile() {
    var imageSliders = generateImageTileMobile(context);
    return Container(
      height: SizeConfig.screenHeight/3,
      width: SizeConfig.screenWidth,
      child: CarouselSlider(
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
      ),
    );
  }
  List<Widget> generateImageTileMobile(BuildContext context) {
    return homeViewModel.bannerDataModal!.bannerList!
        .map((element) => InkWell(
        focusNode: carouselFocus,
        onTap: () async {
          redirectPage(homeViewModel.bannerDataModal?.bannerList?[current]);},
        child: Container(
          height: SizeConfig.screenHeight/3,width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1.0),
            image: DecorationImage(
                image: NetworkImage(element.bannerUrl?? ""),
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

