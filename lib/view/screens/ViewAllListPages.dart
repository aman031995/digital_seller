import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/repository/subscription_provider.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/view/screens/DetailPage.dart';
import 'package:tycho_streams/view/screens/subscription_page.dart';
import 'package:tycho_streams/view/widgets/AppNavigationBar.dart';
import 'package:tycho_streams/viewmodel/CategoryViewModel.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';

class ViewAllListPages extends StatefulWidget {
  int? trayId;
  List<VideoList>? moviesList;
  String? categoryWiseId, title;
  bool? isCategory;
  ViewAllListPages({Key? key,this.trayId, this.moviesList, this.categoryWiseId, this.title, this.isCategory}) : super(key: key);

  @override
  State<ViewAllListPages> createState() => _ViewAllListPagesState();
}

class _ViewAllListPagesState extends State<ViewAllListPages> {
  final CategoryViewModel categoryView = CategoryViewModel();
  final HomeViewModel homeView = HomeViewModel();
  ScrollController _scrollController = ScrollController();

  bool onNotification(ScrollNotification notification) {
    // if (notification is ScrollUpdateNotification) {
      if (_scrollController.hasClients) {
        if (_scrollController.position.maxScrollExtent > _scrollController.offset && _scrollController.position.maxScrollExtent - _scrollController.offset <= 150) {
            homeView.getPaginationVideoList(context, widget.trayId ?? 1, 2);
        }
      // }
    }
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    if(widget.isCategory == true){
      categoryView.getCategoryDetails(context, widget.categoryWiseId ?? "", 1);
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
            appBar: getAppBarWithBackBtn(title: widget.title ?? "", isBackBtn: true, context: context),
            body: SingleChildScrollView(
              child: contentWidget(
                  videoList: NotificationListener(
                    onNotification: onNotification,
                    child: GridView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        controller: _scrollController,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 3.0,
                            mainAxisSpacing: 1.0,
                            childAspectRatio: 1),
                        itemCount: widget.moviesList?.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                  builder: (context) =>
                                  new MovieDetailPage(
                                    platformMovieData: widget.moviesList?[index],
                                    // movieID: 'mZ5lbn9FWAQ',
                                    movieID: widget.moviesList?[index].videoUrl,
                                    // platformMovieData: widget.platformMovieData?.content,
                                  )));
                            },
                            child: Container(
                              height: SizeConfig.screenHeight * 0.5,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                          widget.moviesList![index].thumbnail ??
                                              "",
                                          fit: BoxFit.fill))),
                            ),
                          );
                        }),
                  )),
            ),
          );
        }));
  }

  contentWidget({Widget? videoList}) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.only(left: 10, top: 5, right: 10),
            height: SizeConfig.screenHeight * 0.85,
            child: videoList),
      ],
    );
  }
}
