import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/main.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/TextHelper.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';

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
              width: 450,
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
            left: SizeConfig.screenWidth*0.46,
            child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                )))
            : SizedBox()
      ])) :Padding(
      padding: EdgeInsets.only(left: 0, right: 0),
          child: Stack(children: [
            if (isSearch)
              Container(
                  height: 350,
                  width: 450,
                  margin: EdgeInsets.only(left: SizeConfig.screenWidth/1.5),
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
        padding: EdgeInsets.only(left: 20),
        height: 90,
        width: 150,
        child: Column(
          children: [
            SizedBox(height: 5),
            appTextButton(
                context,
                "My Account",
                Alignment.centerLeft,
                Theme.of(context).canvasColor,
                18,
                false, onPressed: () {
              isProfile = true;
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
                "LogOut",
                Alignment.centerLeft,
                Theme.of(context).canvasColor,
                18,
                false, onPressed: () {
              setState(() {
                authVM
                    .logoutButtonPressed(context);
                isLogins = false;
                if (isSearch == true) {
                  isSearch = false;
                  searchController?.clear();
                  setState(() {});
                }
              });
            }),
          ],
        ),
        color: Theme.of(context).cardColor,
        // height: 20,width: 20,
      ));
}

Widget Header(BuildContext context,setState){
  return  Container(
        height: 55,
        color: Theme
            .of(context)
            .cardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 40),
            Image.asset(AssetsConstants.icLogo,
                height: 40),
            Expanded(
                child: SizedBox(
                    width:
                    SizeConfig.screenWidth * .12)),
            AppButton(context, 'Home', onPressed: () {
              names == "null"
                  ? showDialog(
                  context: context,
                  barrierColor: Colors.black87,
                  builder: (BuildContext context) {
                    return const SignUp();
                  })
                  : GoRouter.of(context)
                  .pushNamed(RoutesName.home);
            }),
            SizedBox(
                width: SizeConfig.screenWidth * .02),
            AppButton(context, 'Contact US',
                onPressed: () {
                  names == "null"
                      ? showDialog(
                      context: context,
                      barrierColor: Colors.black87,
                      builder: (BuildContext context) {
                        return const SignUp();
                      })
                      : GoRouter.of(context).pushNamed(
                    RoutesName.Contact,
                  );
                }),
            Expanded(
                child: SizedBox(
                    width:
                    SizeConfig.screenWidth * .12)),
            names == "null"
                ? Image.asset(AssetsConstants.icSearch,
                height: 30)
                : Container(
              height: 45,
              width: SizeConfig.screenWidth / 4.2,
              alignment: Alignment.center,
              child: AppTextField(
                  controller: searchController,
                  maxLine: searchController!
                      .text.length >
                      2
                      ? 2
                      : 1,
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
                  },
                  isTick: null),
            ),
            SizedBox(
                width: SizeConfig.screenWidth * .02),
            names == "null"
                ? OutlinedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierColor: Colors.black87,
                      builder:
                          (BuildContext context) {
                        return const SignUp();
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
                      Size.fromHeight(30)),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                              5.0))),
                ),
                child: appTextButton(
                    context,
                    'SignUp',
                    Alignment.center,
                    Theme
                        .of(context)
                        .canvasColor,
                    18,
                    true))
                : appTextButton(
                context,
                names!,
                Alignment.center,
                Theme
                    .of(context)
                    .canvasColor,
                18,
                true,
                onPressed: () {}),
            names == "null"
                ? SizedBox(
                width: SizeConfig.screenWidth * .01)
                : const SizedBox(),
            names == "null"
                ? OutlinedButton(
                onPressed: () {
                  showDialog(
                      context: context,
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
                      Size.fromHeight(30)),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                              5.0))),
                ),
                child: appTextButton(
                    context,
                    'Login',
                    Alignment.center,
                    Theme
                        .of(context)
                        .canvasColor,
                    18,
                    true))
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
              },
              child: Image.asset(
                'images/LoginUser.png',
                height: 30,
                color:
                Theme
                    .of(context)
                    .accentColor,
              ),
            ),
            SizedBox(
                width: SizeConfig.screenWidth * .02),
          ],
        ),
      );
}