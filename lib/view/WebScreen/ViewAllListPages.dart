

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/network/AppDataManager.dart';
import 'package:tycho_streams/network/CacheDataManager.dart';
import 'package:tycho_streams/repository/subscription_provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/three_arched_circle.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/WebScreen/OnHover.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
import 'package:tycho_streams/view/screens/DetailPage.dart';
import 'package:tycho_streams/view/screens/NoDataFoundPage.dart';
import 'package:tycho_streams/view/screens/subscription_page.dart';
import 'package:tycho_streams/view/widgets/AppNavigationBar.dart';
import 'package:tycho_streams/viewmodel/CategoryViewModel.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/sociallogin_view_model.dart';

class SeeAllListPages extends StatefulWidget {
  int? trayId;
  List<VideoList>? moviesList;
  String? categoryWiseId, title;
  bool? isCategory;

  SeeAllListPages(
      {Key? key,
      this.trayId,
      this.moviesList,
      this.categoryWiseId,
      this.title,
      this.isCategory})
      : super(key: key);

  @override
  State<SeeAllListPages> createState() => _SeeAllListPagesState();
}

class _SeeAllListPagesState extends State<SeeAllListPages> {
  final CategoryViewModel categoryView = CategoryViewModel();
  final HomeViewModel homeView = HomeViewModel();
  ScrollController _scrollController = ScrollController();
  TextEditingController? editingController = TextEditingController();

  bool onNotification(ScrollNotification notification) {
    // if (notification is ScrollUpdateNotification) {
    if (_scrollController.hasClients) {
      if (_scrollController.position.maxScrollExtent >
              _scrollController.offset &&
          _scrollController.position.maxScrollExtent -
                  _scrollController.offset <=
              150) {}
      // }
    }
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.isCategory == true) {
      categoryView.getCategoryDetails(context, widget.categoryWiseId ?? "", 1);
    } else {
      categoryView.getMovieList(context, widget.moviesList);
    }
    super.initState();
  }
  final List<String> genderItems = ['My Acount', 'Logout'];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //final subscriptionVM = Provider.of<SubscriptionProvider>(context);
    return ChangeNotifierProvider<CategoryViewModel>(
        create: (BuildContext context) => categoryView,
        child: Consumer<CategoryViewModel>(builder: (context, categoryView, _) {
          return Scaffold(
            appBar:  ResponsiveWidget.isMediumScreen(context)?homePageTopBar():  PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: Container(
                height:70,color: Colors.white,
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 40),
                    Image.asset(AssetsConstants.icLogo, height: 40),
                    Expanded(
                        child:
                        SizedBox(width: SizeConfig.screenWidth * .12)),
                    AppBoldFont(
                        msg: 'Home', color: BLACK_COLOR, fontSize: 20),
                    SizedBox(width: SizeConfig.screenWidth * .02),
                    AppBoldFont(
                        msg: 'Upcoming', color: BLACK_COLOR, fontSize: 20),
                    SizedBox(width: SizeConfig.screenWidth * .02),
                    AppBoldFont(
                        msg: 'Contact US',
                        color: BLACK_COLOR,
                        fontSize: 20),
                    Expanded(
                        child:
                        SizedBox(width: SizeConfig.screenWidth * .12)),
                    Image.asset(AssetsConstants.icSearch, height: 40),
                    SizedBox(width: SizeConfig.screenWidth * .08),

                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(


              child:   ResponsiveWidget.isMediumScreen(context)?contentsWidget( videoList: NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollEndNotification) {
                  print(_scrollController.position.pixels);
                }
                return false;
              },
              child: categoryView != null
                  ? categoryView.getPreviousPageList.length > 0
                  ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: 250,
                          child: GridView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          controller: _scrollController,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 5,
                              mainAxisSpacing:  15,
                              childAspectRatio: 1.8),
                          itemCount: categoryView.getPreviousPageList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .push(MaterialPageRoute(
                                    builder: (context) =>
                                    new MovieDetailPage(
                                      platformMovieData: categoryView
                                          .getPreviousPageList[index],
                                      movieID: categoryView
                                          .getPreviousPageList[index]
                                          .youtubeVideoId,
                                    )));
                              },
                              child: OnHover(
                                  builder: (isHovered) {
                                    bool _heigth = isHovered;
                                    return Container(
                                      child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          child: Image.network(
                                            categoryView
                                                .getPreviousPageList[
                                            index]
                                                .thumbnail ??
                                                "",
                                            fit: BoxFit.fill)),
                                    );
                                  },
                                  hovered: Matrix4.identity()
                                    ..translate(0, 0, 0)),
                            );
                          }),
                        ),
                        SizedBox(height: 40),
                        footerMobile(context)
                      ],
                    ),
                  )
                  : Container()
                  : Container(
                height: SizeConfig.screenHeight * 0.8,
                child: Center(
                  child:
                  ThreeArchedCircle(color: THEME_COLOR, size: 45.0),
                ),
              ),
            )) :
            contentWidget(
                 videoList: NotificationListener(
              onNotification: (notification) {
                if (notification is ScrollEndNotification) {
                  print(_scrollController.position.pixels);
                }
                return false;
              },
              child: categoryView != null
                  ? categoryView.getPreviousPageList.length > 0
                      ? GridView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          controller: _scrollController,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      ResponsiveWidget.isMediumScreen(context)
                                          ? 1
                                          : 4,
                                  crossAxisSpacing: ResponsiveWidget.isMediumScreen(context)?5:9.0,
                                  mainAxisSpacing:  ResponsiveWidget.isMediumScreen(context)?15:5.0,
                                  childAspectRatio: ResponsiveWidget.isMediumScreen(context)
                                      ? 1.8:1.5),
                          itemCount: categoryView.getPreviousPageList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            new MovieDetailPage(
                                              platformMovieData: categoryView
                                                  .getPreviousPageList[index],
                                              movieID: categoryView
                                                  .getPreviousPageList[index]
                                                  .youtubeVideoId,
                                            )));
                              },
                              child: OnHover(
                                  builder: (isHovered) {
                                    bool _heigth = isHovered;
                                    return Container(
                                      margin: EdgeInsets.only(left: 25,right: 25),
                                      padding: EdgeInsets.only(
                                          left:ResponsiveWidget.isMediumScreen(context)?0: _heigth ? 20 :10,
                                          right: ResponsiveWidget.isMediumScreen(context)? 0:_heigth ? 20 :10,
                                          top: ResponsiveWidget.isMediumScreen(context)? 0:_heigth ? 20 :10,
                                          bottom: ResponsiveWidget.isMediumScreen(context)?0: _heigth ? 20 :10),
                                      height: ResponsiveWidget.isMediumScreen(
                                              context)
                                          ? 1000
                                          : SizeConfig.screenHeight * 0.5,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                              categoryView
                                                      .getPreviousPageList[
                                                          index]
                                                      .thumbnail ??
                                                  "",
                                              fit: BoxFit.fill,width: 50,height: 50,)),
                                    );
                                  },
                                  hovered: Matrix4.identity()
                                    ..translate(0, 0, 0)),
                            );
                          })
                      : Container()
                  : Container(
                      height: SizeConfig.screenHeight * 0.8,
                      child: Center(
                        child:
                            ThreeArchedCircle(color: THEME_COLOR, size: 45.0),
                      ),
                    ),
            ))),
          );
        }));
  }

  homePageTopBar() {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: WHITE_COLOR,
        title: Stack(children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Row(children: [
                GestureDetector(
                    onTap: () {},
                    child: Image.asset(AssetsConstants.icLogo,
                        height: 50, width: 50)),
                Expanded(child: SizedBox(width: SizeConfig.screenWidth * 0.09)),
                Container(
                    height: 50,
                    width: SizeConfig.screenWidth * 0.64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: TRANSPARENT_COLOR, width: 2.0),
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
                    )),
                Expanded(child: SizedBox(width: SizeConfig.screenWidth * 0.13)),
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: LIGHT_THEME_COLOR,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.asset(
                      AssetsConstants.icNotification,
                      height: 45,
                      width: 45,
                    ))
              ]))
        ]));
  }

  contentWidget({Widget? videoList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 40, top: 30),
          child: AppBoldFont(msg: widget.title ?? "",fontSize: 22),
        ),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.only(left: 20, top: 15, right: 20),
            height: SizeConfig.screenHeight,
            child: videoList),
        SizedBox(height: 40),
    footerDesktop()
      ],
    );
  }
  contentsWidget({Widget? videoList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 40, top: 30,bottom: 20),
          child: AppBoldFont(msg: widget.title ?? "",fontSize: 18),
        ),
        Center(
          child: Container(
            width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: videoList),
        ),

      ],
    );
  }
  logoutButtonPressed() async {
    AppDataManager.deleteSavedDetails();
    CacheDataManager.clearCachedData();
    await Future.delayed(const Duration(milliseconds:100)).then((value) =>Navigator.pushNamedAndRemoveUntil(context, '/HomePage', (route) => false));

  }
}
