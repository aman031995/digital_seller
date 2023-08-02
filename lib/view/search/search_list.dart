import 'package:TychoStream/model/data/search_data_model.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../AppRouter.gr.dart';

// widget of search list
Widget searchList(
    BuildContext context,
    HomeViewModel viewmodel,
    ScrollController _scrollController,
    HomeViewModel homeViewModel,
    TextEditingController searchController) {
  return viewmodel.searchDataModel!=null?
    Positioned(
    right: ResponsiveWidget.isMediumScreen(context) ? 0:SizeConfig.screenWidth*0.06,
    child: Container(
      width: SizeConfig.screenWidth*0.25,height: SizeConfig.screenHeight/2.1,color: Colors.pinkAccent,
      child: Stack(children: [
        viewmodel.searchDataModel!.searchList!.isNotEmpty
            ? ListView.builder(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, index) {
                  final item = viewmodel.searchDataModel?.searchList?[index];
                  _scrollController.addListener(() {
                    if (_scrollController.position.pixels ==
                        _scrollController.position.maxScrollExtent) {
                      onPagination(
                          context,
                          viewmodel.lastPage,
                          viewmodel.nextPage,
                          viewmodel.isLoading,
                          searchController.text ?? '',
                          viewmodel);
                    }
                  });
                  return GestureDetector(
                      onTap: () async {


                        // GoRouter.of(context).pushNamed(RoutesName.DeatilPage,queryParameters: {
                        //   'movieID':"${ viewmodel.searchDataModel?.searchList?[index].youtubeVideoId}",
                        //   'VideoId':"${viewmodel.searchDataModel?.searchList?[index].videoId}",
                        //   'Title':"${viewmodel.searchDataModel?.searchList?[index].videoTitle}",
                        //   'Desc':"${viewmodel.searchDataModel?.searchList?[index].videoDescription}"
                        //   // 'movieID':"${homeViewModel.homePageDataModel?.videoList?[index].youtubeVideoId}",
                        //   // 'VideoId':'${homeViewModel.homePageDataModel?.videoList?[index].videoId}',
                        //   // 'Title':"${homeViewModel.homePageDataModel?.videoList?[index].videoTitle}",
                        //   // 'Desc':'${homeViewModel.homePageDataModel?.videoList?[index].videoDescription}'
                        // });
                        // AppNavigator.push(context, MovieDetailPage(
                        //   searchDataList: viewmodel.searchDataModel?.searchList?[index], movieID: viewmodel.searchDataModel?.searchList?[index].youtubeVideoId,
                        // ));
                      },
                      child: listContent(item, context));
                },
                itemCount: viewmodel.searchDataModel?.searchList?.length)
            : Center(child: dataNotAvailable(viewmodel, context)),
        homeViewModel.isLoading == true
            ? Container(
                margin: EdgeInsets.only(bottom: 10),
                alignment: Alignment.bottomCenter,
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor))
            : SizedBox()
      ]),
    ),
  ):
    Center(
        child: ThreeArchedCircle(
            size: 50.0))

  ;
}

// list item
listContent(SearchList? item, BuildContext context) {
  return Container(
      width: SizeConfig.screenWidth*0.08,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          color: Theme.of(context).cardColor,
          elevation: 10,
          child: Row(children: <Widget>[
            Expanded(
              flex: 30,
              child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 120,
                        maxHeight: 120,
                      ),
                      child: Image.network(item?.thumbnail ?? '', fit: BoxFit.fill))),
            ),
            Expanded(
                flex: 70,
                child: Container(
                  child: AppMediumFont(context,
                      msg: item?.videoTitle ?? '', maxLines: 3),
                ))
          ])));
}

// view of no available data
dataNotAvailable(HomeViewModel viewmodel, BuildContext context) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('images/ic_NotFoundLogo.png'),
        AppBoldFont(context,
            msg: viewmodel.message,
            fontSize: 22,
            color: Theme.of(context).canvasColor),
        SizedBox(height: 65)
      ]);
}

// pagination handle
onPagination(BuildContext context, int lastPage, int nextPage, bool isLoading,
    String searchData, HomeViewModel homeViewModel) {
  if (isLoading) return;
  isLoading = true;
  if (nextPage <= lastPage) {
    homeViewModel.runIndicator(context);
    homeViewModel.getSearchData(context, searchData, nextPage);
  }
}
