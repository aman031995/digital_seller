import 'package:TychoStream/model/data/search_data_model.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../AppRouter.gr.dart';

// widget of search list
Widget searchList(
    BuildContext context,
    HomeViewModel viewmodel,
    ScrollController _scrollController,
    HomeViewModel homeViewModel,
    TextEditingController searchController,String count) {
  return viewmodel.searchDataModel!=null?
    Container(
      width: SizeConfig.screenWidth*0.25,height: SizeConfig.screenHeight/2.1,
      child: Stack(children: [
        viewmodel.searchDataModel!.productList!.isNotEmpty
            ? ListView.builder(
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
                          searchController.text ?? '',
                          viewmodel);
                    }
                  });
                  return GestureDetector(
                      onTap: () async {
                        context.router.push(
                        ProductDetailPage(
                          productId: '${item?.productId}',
                          productdata: [
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
                              color: Theme.of(context).cardColor
                          ),

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
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Colors.grey))),
                                SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: SizeConfig.screenWidth*0.15,
                                        child: AppMediumFont(context, msg: item?.productName ?? '', maxLines: 1)),
                                    AppRegularFont(context, msg: item?.productDetails?.productDiscountPrice)
                                  ],
                                )

                              ])));
                },
                itemCount: viewmodel.searchDataModel?.productList?.length)
            : Center(child: dataNotAvailable(viewmodel, context)),
        homeViewModel.isLoading == true
            ? Container(
                margin: EdgeInsets.only(bottom: 10),
                alignment: Alignment.bottomCenter,
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor))
            : SizedBox()
      ]),
    ):
    Center(
        child: ThreeArchedCircle(
            size: 50.0))

  ;
}

// list item
// listContent( productList item, BuildContext context) {
//   return Container(
//       width: SizeConfig.screenWidth*0.08,
//       child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(0.0),
//           ),
//           color: Theme.of(context).cardColor,
//           elevation: 10,
//           child: Row(children: <Widget>[
//             Expanded(
//               flex: 30,
//               child: Padding(
//                   padding: const EdgeInsets.all(2.0),
//                   child: ConstrainedBox(
//                       constraints: BoxConstraints(
//                         maxWidth: 120,
//                         maxHeight: 120,
//                       ),
//                       child: Image.network(item?.thumbnail ?? '', fit: BoxFit.fill))),
//             ),
//             Expanded(
//                 flex: 70,
//                 child: Container(
//                   child: AppMediumFont(context,
//                       msg: item?.videoTitle ?? '', maxLines: 3),
//                 ))
//           ])));
// }

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
