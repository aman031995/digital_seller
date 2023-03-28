import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/three_arched_circle.dart';
import 'package:tycho_streams/view/WebScreen/MovieListCommonWidget.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';

class VideoListPage extends StatefulWidget {
  bool? isDetail;

  VideoListPage({Key? key, this.isDetail}) : super(key: key);

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  ScrollController scrollController = ScrollController();
   HomeViewModel homeView = HomeViewModel();

  @override
  void initState() {
    homeView.getTrayData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider<HomeViewModel>(
        create: (BuildContext context) => homeView,
        child: Consumer<HomeViewModel>(builder: (context, homeViewModel, _) {
          return homeViewModel.homePageDataModel != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    homeViewModel.homePageDataModel?.videoList != null
                        ? Container(
                            height: (ResponsiveWidget.isMediumScreen(context)
                                ? 250.0 * trayHeight(homeViewModel)
                                : 350.0 * trayHeight(homeViewModel)),
                            width: SizeConfig.screenWidth,
                            margin: EdgeInsets.only(left: 25, right: 25),
                            child: ListView.builder(
                                itemCount:
                                    homeViewModel.trayDataModel?.length ??
                                        homeViewModel.homePageDataModel
                                            ?.videoList?.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return getTrayType(homeViewModel)
                                      ? Container(
                                          child: MovieListCommonWidget(
                                          trayId: homeViewModel
                                              .trayDataModel?[index].trayId,
                                          trayIdentifier: homeViewModel
                                              .trayDataModel?[index]
                                              .trayIdentifier,
                                          trayTitle: homeViewModel
                                              .trayDataModel?[index].trayTitle,
                                          isButtom: true,
                                          isSubtitle: homeViewModel
                                                  .trayDataModel![index]
                                                  .trayTitle!
                                                  .contains("Fan Favourite")
                                              ? true
                                              : false,
                                          platformMovieData: homeViewModel
                                              .trayDataModel?[index]
                                              .platformData(),
                                        ))
                                      : ThreeArchedCircle(
                                           size: 45.0);
                                }),
                          )
                        : SizedBox(
                            height: SizeConfig.screenHeight * 0.35,
                            child: const Center(
                                child: ThreeArchedCircle(
                                     size: 50.0)),
                          ),
                    const SizedBox(height: 70),
                    ResponsiveWidget.isMediumScreen(context)
                        ? footerMobile(context)
                        : const footerDesktop()
                  ],
                )
              : Center(
                  child: Container(),
                );
        }));
  }

  getTrayType(HomeViewModel homeViewModel) {
    if (widget.isDetail == true) {
      return homeViewModel.homePageDataModel?.videoList?.isNotEmpty;
    } else {
      return homeViewModel.trayDataModel?.isNotEmpty;
    }
  }

  int trayHeight(HomeViewModel homeViewModel) {
    int count = 0;
    homeViewModel.trayDataModel?.forEach((element) {
      if (element.platformData() != null) {
        if (element.platformData()!.content!.isNotEmpty) {
          count += 1;
        }
      }
    });
    return count;
  }
}
