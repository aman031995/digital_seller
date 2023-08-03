import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';

import 'package:TychoStream/viewmodel/HomeViewModel.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  HomeViewModel homeViewModel = HomeViewModel();
  int pageNums = 1;
  ScrollController _scrollController = ScrollController();
  String? pageTitle;
  String? checkInternet;

  onPagination(int lastPage, int nextPage, bool isLoading) {
    if (isLoading) return;
    isLoading = true;
    if (nextPage <= lastPage) {
      homeViewModel.runIndicator(context);
      homeViewModel.getNotification(context, nextPage);
    }
  }

  @override
  void initState() {
    homeViewModel.getNotification(context, pageNums);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    AppNetwork.checkInternet((isSuccess, result) {
      setState(() {
        checkInternet = result;
      });
    });

    if (ModalRoute.of(context)?.settings.arguments != null) {
      final Map<String, dynamic> data =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      pageTitle = data['title'];
    }
    return ChangeNotifierProvider<HomeViewModel>(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
          _scrollController.addListener(() {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              onPagination(
                  viewmodel.lastPage, viewmodel.nextPage, viewmodel.isLoading);
            }
          });
          return GestureDetector(
            onTap: () {
              if (isSearch == true) {
                isSearch = false;
                setState(() {});
              }
              if (isLogins == true) {
                isLogins = false;
                setState(() {});
              }
            },
            child: Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                appBar:homePageTopBar(),
                body: checkInternet == "Offline"
                    ? Container()
                    : viewmodel.notificationModel != null
                        ? Stack(children: [
                            ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.only(bottom: 10),
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: viewmodel
                                    .notificationModel?.notificationList?.length,
                                addAutomaticKeepAlives: true,
                                itemBuilder: (context, index) {
                                  return Card(
                                      child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(bottom: 15),
                                      child: AppMediumFont(context,
                                          msg: viewmodel
                                              .notificationModel
                                              ?.notificationList?[index]
                                              .notification),
                                    ),
                                    subtitle: AppRegularFont(context,
                                        msg: viewmodel.notificationModel
                                            ?.notificationList?[index].createdAt,
                                        color: Theme.of(context)
                                            .canvasColor
                                            .withOpacity(0.7),
                                        fontSize: 13),
                                  ));
                                }),
                            homeViewModel.isLoading == true
                                ? Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    alignment: Alignment.bottomCenter,
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    ))
                                : SizedBox()
                          ])
                        : Center(child: Container(child: ThreeArchedCircle(size: 45.0)),
                          )),
          );
        }));
  }

  homePageTopBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).cardColor,
      title: Row(children: <Widget>[
        GestureDetector(
            onTap: (){
              GoRouter.of(context).pushNamed(RoutesName.home);
            },
            child: Image.asset(AssetsConstants.icLogo,width: ResponsiveWidget.isMediumScreen(context) ? 35:45, height:ResponsiveWidget.isMediumScreen(context) ? 35: 45)),
        SizedBox(width: SizeConfig.screenWidth*0.04),
        AppBoldFont(context,msg:"Notification",fontSize:ResponsiveWidget.isMediumScreen(context) ? 16: 20, fontWeight: FontWeight.w700),
      ]),
      actions: [
        GestureDetector(
          onTap: () {
            setState(() {
              isLogins = true;
              if (isSearch == true) {
                isSearch = false;

                setState(() {});
              }
            });
          },
          child: Row(
            children: [
              appTextButton(context, names!, Alignment.center, Theme.of(context).canvasColor,ResponsiveWidget.isMediumScreen(context)
                  ?16: 18, true),
              Image.asset(
                AssetsConstants.icProfile,
                height:ResponsiveWidget.isMediumScreen(context)
                    ?20: 30,
                color: Theme.of(context).canvasColor,
              ),
            ],
          ),
        ),
        SizedBox(width: SizeConfig.screenWidth*0.04),
      ],
    );
  }
}
