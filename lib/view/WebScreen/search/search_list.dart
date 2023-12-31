import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../AppRouter.gr.dart';

// widget of search list
Widget searchList(
    BuildContext context,
    HomeViewModel viewmodel,
    ScrollController _scrollController,
    TextEditingController searchController,String count) {
  return viewmodel.searchDataModel!=null? viewmodel.searchDataModel!.productList == null ? Container():
    Stack(
      children: [
        SingleChildScrollView(
          child: Container(
           color: Theme.of(context).cardColor,
            height: 400,
            width: 500,
            child: viewmodel.searchDataModel!.productList!.isNotEmpty
                ? ListView.builder(
              shrinkWrap: true,
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (_, index) {
                      final item = viewmodel.searchDataModel?.productList?[index];
                      _scrollController.addListener(() {
                        if (_scrollController.position.pixels ==
                            _scrollController.position.maxScrollExtent) {
                          onPagination(
                              context,
                              viewmodel.lastPage,
                              viewmodel.nextPage,
                              viewmodel.isLoading,
                              searchController.text,
                              viewmodel);
                        }
                      });
                      return InkWell(
                          onTap: () async {
                            if (GlobalVariable.isLogins == true) {
                              GlobalVariable.isLogins = false;
                            }
                            if (GlobalVariable.isSearch == true) {
                              GlobalVariable.isSearch = false;
                            }
                            context.router.push(
                            ProductDetailPage(
                              productName:'${item?.productName}',
                              productdata: [
                              '${item?.productId}',
                                '${count}',
                                '${item?.productDetails?.defaultVariationSku?.size?.name}',
                                '${item?.productDetails?.defaultVariationSku?.color?.name}',
                                '${item?.productDetails?.defaultVariationSku?.style?.name}',
                                '${item?.productDetails?.defaultVariationSku?.unitCount?.name}',
                                '${item?.productDetails?.defaultVariationSku?.materialType?.name}',
                              ],
                            ));},

                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5)),
margin: EdgeInsets.only(bottom: 6),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(width: 10),
                                    CachedNetworkImage(
                                        imageUrl: item?.productDetails?.productImages?[0]  ?? '', fit: BoxFit.fill,
                                        imageBuilder: (context, imageProvider) => Container(
                                          margin: EdgeInsets.only(bottom: 2),height: 100,width: 120,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            image: DecorationImage(
                                                image: imageProvider, fit: BoxFit.fill),
                                          ),
                                        ),
                                       // placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Colors.grey))
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(child: AppMediumFont(context, msg: getNameTitle(item) ?? '', maxLines: 1)),
                                      //  AppRegularFont(context, msg: item?.productDetails?.productDiscountPrice),
                                        Row(
                                            children: [
                                              AppBoldFont(context,
                                                  msg: "₹" +
                                                      "${item?.productDetails?.productDiscountPrice}",
                                                  color: Theme.of(context).canvasColor,
                                                  fontSize:  ResponsiveWidget.isSmallScreen(context) ?14:16.0),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              AppMediumFont(context,
                                                  color: Theme.of(context).canvasColor,
                                                  msg: "₹" + "${item?.productDetails?.productPrice} ",
                                                  textDecoration: TextDecoration.lineThrough,
                                                  fontSize:
                                                  ResponsiveWidget.isMediumScreen(context) ? 12.0 : 14),
                                              AppMediumFont(context,
                                                  msg: "${item?.productDetails?.productDiscountPercent}" +
                                                      r"% OFF",
                                                  color: GREEN,
                                                  fontSize: 12),
                                            ]),
                                      ],
                                    )
                                  ])));
                    },
                    itemCount: viewmodel.searchDataModel?.productList?.length)
                : Center(child: dataNotAvailable(viewmodel, context)),
          ),
        ),
        viewmodel.isLoading == true
            ? Container(
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.bottomCenter,
            child: CircularProgressIndicator(color: Theme.of(context).primaryColor,strokeWidth: 2)) : SizedBox()
      ],
    )
  : Center(child: ThreeArchedCircle(size: 45.0));
}


// view of no available data
dataNotAvailable(HomeViewModel viewmodel, BuildContext context) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AssetsConstants.ic_noProductFound),
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
