import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/repository/subscription_provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final subscriptionVM = Provider.of<SubscriptionProvider>(context);
    return ChangeNotifierProvider<CategoryViewModel>(
        create: (BuildContext context) => categoryView,
        child: Consumer<CategoryViewModel>(builder: (context, categoryView, _) {
          return Scaffold(
            appBar:  PreferredSize(preferredSize: Size.fromHeight(60),
                child: Container(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 40),
                      Image.asset(AssetsConstants.icLogo,height: 40),
                      Expanded(child: SizedBox(width: SizeConfig.screenWidth*.12)),
                      AppBoldFont(msg: 'Home', color: BLACK_COLOR, fontSize: 20),
                      SizedBox(width: SizeConfig.screenWidth*.02),
                      AppBoldFont(msg: 'Upcoming', color: BLACK_COLOR, fontSize: 20),
                      SizedBox(width: SizeConfig.screenWidth*.02),
                      AppBoldFont(msg: 'Contact US', color: BLACK_COLOR, fontSize: 20),
                      Expanded(child: SizedBox(width: SizeConfig.screenWidth*.12)),
                      Image.asset(AssetsConstants.icSearch,height: 40),SizedBox(width: SizeConfig.screenWidth*.02),
                      GestureDetector(
                          onTap: (){
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierColor: Colors.black87,
                                builder: (BuildContext context) {
                                  return SignUp();
                                });
                          },
                          child: Image.asset(AssetsConstants.icSignup,height: 40)),


                      SizedBox(width: SizeConfig.screenWidth*.01),
                      GestureDetector(
                          onTap: (){

                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierColor: Colors.black87,
                                builder: (BuildContext context) {
                                  return LoginUp();
                                });
                          },
                          child: Image.asset(AssetsConstants.icLogin,height: 40)),SizedBox(width: SizeConfig.screenWidth*.02),
                    ],
                  ),
                )
            ),
            body: SingleChildScrollView(
              child:

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
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 9.0,
                                    mainAxisSpacing: 5.0,
                                    childAspectRatio: 1.5),
                            itemCount: categoryView.getPreviousPageList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              new MovieDetailPage(
                                                platformMovieData:
                                                categoryView.getPreviousPageList[index],
                                                movieID: categoryView.getPreviousPageList[index]
                                                    .youtubeVideoId,
                                              )));
                                },
                                child:
                          OnHover(
                      builder: (isHovered) {
                                   bool _heigth = isHovered;
                                   return Container(
                                  padding: EdgeInsets.only(left:_heigth?0: 10,right:_heigth?0: 10,top: _heigth?0:10,bottom:_heigth?0: 10),
                                  height: SizeConfig.screenHeight * 0.5,
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                              categoryView
                                                      .getPreviousPageList[
                                                          index]
                                                      .thumbnail ??
                                                  "",
                                              fit: BoxFit.fill))),
                                );}, hovered: Matrix4.identity()..translate(0, 0, 0)),
                              );
                            })
                        : noDataFoundMessage(context)
                    : Container(
                        height: SizeConfig.screenHeight * 0.8,
                        child: Center(
                          child:
                              ThreeArchedCircle(color: THEME_COLOR, size: 45.0),
                        ),
                      ),
              )),
            ),
          );
        }));
  }

  contentWidget({Widget? videoList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20,top: 30),
          child: AppBoldFont(msg: widget.title??""),
        ),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.only(left: 20, top: 5, right: 20),
            height: SizeConfig.screenHeight,
            child: videoList),
        SizedBox(height: 40),
        footerDesktop()
      ],
    );
  }
}
