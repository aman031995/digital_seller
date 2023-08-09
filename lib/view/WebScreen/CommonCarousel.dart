import 'package:TychoStream/AppRouter.gr.dart';
import 'package:TychoStream/model/data/BannerDataModel.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
              height: SizeConfig.screenHeight/1.4,
                  child: Center(
                      child: ThreeArchedCircle( size: 50.0)
                  ));

        }));
  }

//--WebCarousel---//
  Widget carouselImageWeb() {
    var imageSliders = generateImageTilesWeb(context);
    return Stack(
      children: [
        Container(
          height: SizeConfig.screenHeight/1.4,
          width: SizeConfig.screenWidth,
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
      ],
    );
  }
  List<Widget> generateImageTilesWeb(BuildContext context) {
    return homeViewModel.bannerDataModal!.bannerList!
        .map((element) =>  InkWell(
      focusNode: carouselFocus,
      onTap: () async {
        redirectPage(homeViewModel.bannerDataModal?.bannerList?[current]);

        },
      child:
      CachedNetworkImage(
          imageUrl:element.bannerUrl ?? "",
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                  image: imageProvider, fit: BoxFit.fill),
            ),
          ),
          placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Colors.grey))),
    )
    )
        .toList();
  }
  // image click redirection handling
  void redirectPage(BannerList? element) {
    if (element != null) {

      if(element.bannerType == 'Product'){
        if(element.productId != ""){
          context.router.push(ProductDetailPage(
            productId: element.productId,
              productdata: ['${element.catId}']
          ));

        } else {
          context.router.push(ProductListGallery(
          ));

        }
      } else if (element.bannerType == 'Video') {

      } else {
        launch(element.bannerUrl! , forceSafariVC: false);
      }

    }
  }

  //--MobileCarousel--//
  Widget carouselImageMobile() {
    var imageSliders = generateImageTileMobile(context);
    return Container(
      margin: EdgeInsets.only(left: 20.0,right: 20,top: 8),
      width: SizeConfig.screenWidth,
      child: CarouselSlider(
        items: imageSliders,
        options: CarouselOptions(
            height: SizeConfig.screenHeight*0.45,
            scrollDirection: Axis.horizontal,
            scrollPhysics: PageScrollPhysics(),
            viewportFraction: 1,
            enableInfiniteScroll: true,
            enlargeCenterPage: false,
            autoPlay: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),

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
        child:  Container(
          child: CachedNetworkImage(
              imageUrl:element.bannerUrl ?? "",
              fit: BoxFit.fill,
              placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                      color:
                      Theme.of(context).canvasColor.withOpacity(0.5)))),
        )))
        .toList();
  }



  void next() =>
      carouselController.nextPage(duration: Duration(milliseconds: 500));
  void previous() =>
      carouselController.previousPage(duration: Duration(milliseconds: 500));
}

