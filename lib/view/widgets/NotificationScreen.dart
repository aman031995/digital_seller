import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/notification_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../AppRouter.gr.dart';

@RoutePage()
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationViewModel notificationViewModel = NotificationViewModel();
  int pageNum = 1;
  ScrollController _scrollController = ScrollController();
  String? pageTitle;
  String? checkInternet;

  @override
  void initState() {
    notificationViewModel.getNotification(context, pageNum);
    super.initState();
  }

  onPagination(int lastPage, int nextPage, bool isLoading) {
    if (isLoading) return;
    isLoading = true;
    if (nextPage <= lastPage) {
      notificationViewModel.runIndicator(context);
      notificationViewModel.getNotification(context, nextPage);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider.value(
        value: notificationViewModel,
        child: Consumer<NotificationViewModel>(builder: (context, viewmodel, _) {
          _scrollController.addListener(() {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              onPagination(viewmodel.lastPage, viewmodel.nextPage, viewmodel.isLoading);
            }
          });
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: InkWell(
                onTap: (){
                  context.router.push(HomePageWeb());
                },
                child: Container(
                  width: 500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 1),
                      Expanded(
                        child: Container(
                            height: 15,
                            width: 15,
                            child: Image.asset(AssetsConstants.icBackArrow,
                                color:  Theme.of(context).hintColor, width: 15, height: 15)),
                      ),
                    ],
                  ),
                ),
              ),

              centerTitle: true,
              title: AppBoldFont(
                  context, msg: StringConstant.notifications,
                  color: Theme.of(context).hintColor,
                  fontSize: 20,
                  textAlign: TextAlign.start),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
            ),
              body: checkInternet == "Offline"
                  ? NOInternetScreen()
                  : viewmodel.notificationModel != null
                  ? Stack(children: [
                viewmodel.notificationModel!.notificationList!.isNotEmpty ?
                ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.only(bottom: 10),
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: viewmodel.notificationModel?.notificationList?.length,
                    addAutomaticKeepAlives: true,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                            onTap: (){
                              context.pushRoute(MyOrderPage());

                            }, title: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: AppMediumFont(context,
                                msg: viewmodel.notificationModel?.notificationList?[index].title),
                          ),
                            subtitle: AppRegularFont(context,
                                msg: viewmodel.notificationModel?.notificationList?[index].createdAt,
                                color: Theme.of(context).canvasColor.withOpacity(0.7),
                                fontSize: 13),
                          ));
                    }) :  Center(child: noNotification(context)),
                notificationViewModel.isLoading == true
                    ? Container(
                    margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.bottomCenter,
                    child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 2))
                    : SizedBox()
              ])
                  : Center(child: ThreeArchedCircle(size: 45.0)));
        }));
  }
}

Widget notification( NotificationViewModel viewmodel,BuildContext context,ScrollController _scrollController){
  return viewmodel.notificationModel != null
      ? Stack(children: [
    Container(
      color: Theme.of(context).cardColor,
      height: 400,
      width:500,
      child: viewmodel.notificationModel!.notificationList!.isNotEmpty ?
      ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          padding: EdgeInsets.only(bottom: 10),
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: viewmodel.notificationModel?.notificationList?.length,
          addAutomaticKeepAlives: true,
          itemBuilder: (context, index) {
            _scrollController.addListener(() {
              if (_scrollController.position.pixels ==
                  _scrollController.position.maxScrollExtent) {
                onPagination(viewmodel.lastPage, viewmodel.nextPage, viewmodel.isLoading,viewmodel,context);
              }
            });
            return Card(
              margin: EdgeInsets.only(bottom: 10),
                child: ListTile(
                  onTap: (){
                    context.pushRoute(MyOrderPage());
                    GlobalVariable.isLogins = false;
                    GlobalVariable.isnotification=false;
                    // handleNotificationClick(apiData: viewmodel.notificationModel?.notificationList?[index]);
                  }, title: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: AppMediumFont(context,
                      msg: viewmodel.notificationModel?.notificationList?[index].title),
                ),
                  subtitle: AppRegularFont(context,
                      msg: viewmodel.notificationModel?.notificationList?[index].createdAt,
                      color: Theme.of(context).canvasColor.withOpacity(0.7),
                      fontSize: 13),
                ));
          }) :  Center(child: noNotification(context)),
    ),
    viewmodel.isLoading == true
        ? Positioned(
       bottom: 10,right: SizeConfig.screenWidth*0.1,
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor))
        : SizedBox()
  ])
      : Center(child: ThreeArchedCircle(size: 45.0));
}
noNotification( BuildContext context) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AssetsConstants.ic_no_notification),
        SizedBox(height: 15),
        AppBoldFont(context,
            msg: StringConstant.noNotification,
            fontSize: 20,
            color: Theme.of(context).canvasColor),
      ]);
}
onPagination(int lastPage, int nextPage, bool isLoading,notificationViewModel,BuildContext context) {
  if (isLoading) return;
  isLoading = true;
  if (nextPage <= lastPage) {
    notificationViewModel.runIndicator(context);
    notificationViewModel.getNotification(context, nextPage);
  }
}