import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/SignUp.dart';
import 'package:TychoStream/view/screens/notification_screen.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';

Widget searchView(BuildContext context, HomeViewModel viewmodel, bool isSearch,
    ScrollController _scrollController, HomeViewModel homeViewModel, TextEditingController searchController, setState) {
  return viewmodel.searchDataModel!.searchList != null && isSearch == true
      ?
  ResponsiveWidget.isMediumScreen(context)
      ? Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Stack(children: [
        if (isSearch)
          Container(
            height: 250,
              decoration: BoxDecoration(
                color: viewmodel.searchDataModel != null && isSearch == true
                    ? Theme.of(context).scaffoldBackgroundColor
                    : TRANSPARENT_COLOR,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    width: 1, color: Theme.of(context).primaryColor),
              ),
              child: viewmodel.searchDataModel!.searchList!.isNotEmpty
                  ? ListView.builder(
                itemExtent: 100,
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
                          child: Row(
                            children: [
                              Image.network(viewmodel.searchDataModel?.searchList?[index].thumbnail ?? '',fit: BoxFit.fill,),
                        SizedBox(width: 6),
                          Expanded(child: AppMediumFont(context, msg: viewmodel.searchDataModel?.searchList?[index].videoTitle)),
                            ],
                          ),
                        ));
                  },
                  itemCount: viewmodel.searchDataModel?.searchList?.length)
                  : Center(
                  child: AppMediumFont(context,
                      msg: viewmodel.message,
                      color: Theme.of(context).canvasColor))),
        homeViewModel.isLoading == true
            ? Positioned(
            bottom: 9,
            left: SizeConfig.screenWidth*0.46,
            child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                )))
            : SizedBox()
      ])) :Padding(
      padding: EdgeInsets.only(left:SizeConfig.screenWidth*0.33, right: 0),
          child: Stack(
              children: [

            if (isSearch)
              Container(
                  height: 350,
                  width: 430,
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
                    itemExtent: 120,
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
                                      child: Row(
                                        children: [
                                          Image.network(viewmodel.searchDataModel?.searchList?[index].thumbnail ?? '',fit: BoxFit.fill,),
                                          SizedBox(width: 10),
                                          Expanded(child: AppMediumFont(context, msg: viewmodel.searchDataModel?.searchList?[index].videoTitle)),
                                        ],
                                      ),
                                ));
                          },
                          itemCount:
                              viewmodel.searchDataModel?.searchList?.length)
                      : Center(
                          child: AppMediumFont(context,
                              msg: viewmodel.message,
                              ))),
            homeViewModel.isLoading == true
                ? Positioned(
                    bottom: 9,
                    right: 150,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )))
                : SizedBox()
          ])) :Container();
}

onPagination(BuildContext context, int lastPage, int nextPage, bool isLoading, String searchData, HomeViewModel homeViewModel) {
  if (isLoading) return;
  isLoading = true;
  if (nextPage <= lastPage) {
    homeViewModel.runIndicator(context);
    homeViewModel.getSearchData(context, searchData, nextPage);
  }
}
Widget profile(BuildContext context,setState){
  final authVM = Provider.of<AuthViewModel>(context);
  return Positioned(
      right: 20,
      child: Container(
        width: 150,
        color: Theme.of(context).cardColor,
        child: Column(
          children: [
            SizedBox(height: 5),
            appTextButton(
                context,
                "  My Account",
                Alignment.centerLeft,
                Theme.of(context).canvasColor,
                18,
                false, onPressed: () {
              isProfile = true;
              if(isNotification==true){
                isNotification=false;
                setState(() {

                });
              }
              if (isProfile == true) {
                GoRouter.of(context).pushNamed(
                  RoutesName.EditProfille,
                );
              }
              if (isSearch == true) {
                isSearch = false;
                searchController?.clear();
                setState(() {});
              }
              setState(() {
                isLogins = false;
              });
            }),
            SizedBox(height: 5),
            Container(
              height: 1,
              color: Colors.black,
            ),
            SizedBox(height: 5),
            appTextButton(
                context,
                "  LogOut",
                Alignment.centerLeft,
                Theme.of(context).canvasColor,
                18,
                false, onPressed: () {
              setState(() {
                authVM.logoutButtonPressed(context);
                isLogins = false;
                if (isSearch == true) {
                  isSearch = false;
                  searchController?.clear();
                  setState(() {});
                }
              });
            }),
            SizedBox(height: 5),
          ],
        ),
        // height: 20,width: 20,
      ));
}

Widget Header(BuildContext context,setState,HomeViewModel viewmodel){
  return  Container(
    height: 50,
    color: Theme.of(context).cardColor,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
              width: SizeConfig.screenWidth * .18),
        ),
        Container(
          height: 40,
          width: SizeConfig.screenWidth / 4.9,
          alignment: Alignment.topCenter,
          child: AppTextField(
              controller: searchController,
             //  maxLine: searchController!.text.length > 2 ? 2 : 1,
              textCapitalization:
              TextCapitalization.words,
              secureText: false,
              floatingLabelBehavior:
              FloatingLabelBehavior.never,
              maxLength: 30,
              labelText:
              'Search videos, shorts, products',
              keyBoardType:
              TextInputType.text,
              onChanged: (m) {
                isSearch = true;
                if (isLogins == true) {
                  isLogins = false;
                  setState(() {});
                }
                if(isNotification==true){
                  isNotification=false;
                  setState(() {
                  });
                }
              },
              isTick: null),
        ),
        SizedBox(
            width: SizeConfig.screenWidth * .19),
        GestureDetector(
          onDoubleTap: (){
            setState((){
              isNotification=false;
            });
          },
            onTap: () {
              isSearch = false;
              names == "null"
                  ? showDialog(
                  context: context,
                  barrierColor: Colors.black87,
                  builder: (BuildContext context) {
                    return const LoginUp();
                  })
                  :setState((){ isNotification=true;});
              if (isSearch == true) {
                isSearch = false;
                setState(() {});
              }
              if (isLogins == true) {
                isLogins = false;
                setState(() {});
              }
            },
            child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Image.asset(
                   AssetsConstants.icNotification,
                  height: 50,
                  width: 50,
                ))),
        SizedBox(
            width: SizeConfig.screenWidth * .01),
        names == "null"
            ? OutlinedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  barrierColor: Colors.black87,
                  builder:
                      (BuildContext context) {
                    return const LoginUp();
                  });
            },
            style: ButtonStyle(

                overlayColor: MaterialStateColor
                    .resolveWith((states) =>
                Theme
                    .of(context)
                    .primaryColor),
                fixedSize:
                MaterialStateProperty.all(
                    Size.fromHeight(35)),
                side: MaterialStateProperty.all(BorderSide(
                    color: Theme.of(context).canvasColor,

                    width: 1.5,
                    style: BorderStyle.solid),
                )
            ),
            child: Row(
              children: [
                Image.asset(
                    AssetsConstants.icProfile,
                    width: 20,
                    height: 20, color: Theme.of(context).canvasColor),
                appTextButton(
                    context,
                    'SignIn',
                    Alignment.center,
                    Theme
                        .of(context)
                        .canvasColor,
                    16,
                    true),
              ],
            ))
            :
        appTextButton(
            context,
            names!,
            Alignment.center,
            Theme
                .of(context)
                .canvasColor,
            18,
            true,
            onPressed: () {
              setState(() {
                isLogins = true;
                if (isSearch == true) {
                  isSearch = false;
                  searchController?.clear();
                  setState(() {});
                }
              });
              if(isNotification==true){
                isNotification=false;
                setState(() {

                });
              }
            }),
        names == "null"
            ? Container()
            : GestureDetector(
          onTap: () {
            setState(() {
              isLogins = true;
              if (isSearch == true) {
                isSearch = false;
                searchController?.clear();
                setState(() {});
              }
            });
            if(isNotification==true){
              isNotification=false;
              setState(() {

              });
            }
          },
          child:  Image.asset(
            AssetsConstants.icProfile,
            height: 30,
            color: Theme.of(context).canvasColor,
          ),
        ),

        SizedBox(
            width: SizeConfig.screenWidth * .02),
      ],
    ),
  );
}