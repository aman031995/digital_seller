import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';

Widget searchView(BuildContext context, HomeViewModel viewmodel, bool isSearch,
    ScrollController _scrollController, HomeViewModel homeViewModel, TextEditingController searchController, setState) {
  return viewmodel.searchDataModel!.searchList != null && isSearch == true
      ? Padding(
      padding: EdgeInsets.only(left: 120, right: 15, top: 10),
          child: Stack(children: [
            if (isSearch)
              Container(
                  height: 350,
                  width: 450,
                  margin: EdgeInsets.only(left: SizeConfig.screenWidth/1.7),
                  decoration: BoxDecoration(
                    color: viewmodel.searchDataModel != null && isSearch == true
                        ? Theme.of(context).scaffoldBackgroundColor
                        : TRANSPARENT_COLOR,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: 2, color: Theme.of(context).primaryColor),
                  ),
                  child: viewmodel.searchDataModel!.searchList!.isNotEmpty
                      ? ListView.builder(
                          controller: _scrollController,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (_, index) {
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
                                  isSearch = false;
                                  GoRouter.of(context).pushNamed(
                                      RoutesName.DeatilPage,
                                      queryParams: {
                                        'movieID':
                                        '${viewmodel.searchDataModel?.searchList?[index].youtubeVideoId}',
                                        'VideoId':
                                        '${viewmodel.searchDataModel?.searchList?[index].videoId}',
                                        'Title':
                                        '${viewmodel.searchDataModel?.searchList?[index].videoTitle}',
                                        'Desc':
                                        '${viewmodel.searchDataModel?.searchList?[index].videoDescription}'
                                      });
                                  setState(() {

                                    searchController.clear();
                                  });
                                },
                                child: Card(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    title: AppMediumFont(context,
                                        msg: viewmodel.searchDataModel
                                            ?.searchList?[index].videoTitle),
                                    leading:
                                    ConstrainedBox(
                                    constraints: BoxConstraints(
                                    minWidth: 100,
                            minHeight: 200,
                            maxWidth: 324,
                            maxHeight: 464,
                            ),
                            child:

                            Image.network(viewmodel.searchDataModel?.searchList?[index].thumbnail ?? '',height: 200,width:120,fit: BoxFit.fill,),)
                                  ),
                                ));
                          },
                          itemCount:
                              viewmodel.searchDataModel?.searchList?.length)
                      : Center(
                          child: AppMediumFont(context,
                              msg: viewmodel.message,
                              color: Theme.of(context).canvasColor))),
            homeViewModel.isLoading == true
                ? Positioned(
                    bottom: 9,
                    left: SizeConfig.screenWidth/1.47,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )))
                : SizedBox()
          ]))
      : Container();
}

onPagination(BuildContext context, int lastPage, int nextPage, bool isLoading, String searchData, HomeViewModel homeViewModel) {
  if (isLoading) return;
  isLoading = true;
  if (nextPage <= lastPage) {
    homeViewModel.runIndicator(context);
    homeViewModel.getSearchData(context, searchData, nextPage);
  }
}
