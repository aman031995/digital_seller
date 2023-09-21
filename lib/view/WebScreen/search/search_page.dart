import 'package:TychoStream/AppRouter.gr.dart';
import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/WebScreen/search/search_list.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController? searchController = TextEditingController();
  HomeViewModel homeViewModel = HomeViewModel();
  ScrollController scrollController = ScrollController();
  CartViewModel cartViewModel = CartViewModel();
  int pageNum = 1;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(55.0), // here the desired height
            child:searchTextField(),
            ),
        body: ChangeNotifierProvider.value(
            value: homeViewModel,
            child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
              return viewmodel.searchDataModel != null
                  ? searchListMobile(context, viewmodel, scrollController,
                      searchController!)
                  : Container(
                width: SizeConfig.screenWidth,
                color: Theme.of(context).cardColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AssetsConstants.ic_noSearch,width: 250,height: 200,fit: BoxFit.fill),
                    AppBoldFont(context, msg: StringConstant.noSearchProductFound,color: Theme.of(context).canvasColor,fontSize: 18,textAlign: TextAlign.center)
                  ],
                ),
              );
            })));
  }

// widget of search list
  Widget searchListMobile(
      BuildContext context,
      HomeViewModel viewmodel,
      ScrollController _scrollController,
      TextEditingController searchController) {
    return  viewmodel.searchDataModel!.productList==null?
    Container(
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Image.asset(AssetsConstants.ic_noSearch,width: 80,height: 150,)

        ],
      ),
    ): Stack(children: [
      viewmodel.searchDataModel!.productList!.isNotEmpty
          ? GridView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          padding: EdgeInsets.all(15),
          physics:BouncingScrollPhysics(),
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveWidget.isSmallScreen(context) ?2:3,
            childAspectRatio:ResponsiveWidget.isMediumScreen(context)
                ?ResponsiveWidget.isSmallScreen(context) ?0.6: 0.80:1.04,
            mainAxisSpacing: 5,crossAxisSpacing: 5),
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
            return GestureDetector(
                onTap: () async {
                  context.router.push(ProductDetailPage(
                    productName: '${item?.productName?.replaceAll(' ', '')}',
                    productdata: [
                      '${item?.productId}',
                      '${cartViewModel.cartItemCount}',
                      '${item?.productDetails?.defaultVariationSku?.size?.name}',
                      '${item?.productDetails?.defaultVariationSku?.color?.name}',
                      '${item?.productDetails?.defaultVariationSku?.style?.name}',
                      '${item?.productDetails?.defaultVariationSku?.unitCount?.name}',
                      '${item?.productDetails?.defaultVariationSku?.materialType?.name}',
                    ],
                  ));
                },
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                      color: Theme.of(context).cardColor
                    ),

                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                              height: ResponsiveWidget.isMediumScreen(context)
                                  ?ResponsiveWidget.isSmallScreen(context)
                        ?180:SizeConfig.screenHeight/4:SizeConfig.screenHeight/3.2,
                              width:  ResponsiveWidget.isMediumScreen(context)
                                  ?SizeConfig.screenWidth/1.5:SizeConfig.screenWidth/1.3,
                              child: CachedNetworkImage(
                                  imageUrl: item?.productDetails?.productImages?[0]  ?? '', fit: BoxFit.contain,
                                  imageBuilder: (context, imageProvider) => Container(
                                    margin: EdgeInsets.only(bottom: 2),height: ResponsiveWidget.isMediumScreen(context)
                                      ?ResponsiveWidget.isSmallScreen(context)
                                      ?180:SizeConfig.screenHeight/4:SizeConfig.screenHeight/3.2,
                                    width: ResponsiveWidget.isMediumScreen(context)
                                        ?SizeConfig.screenWidth/1.5:SizeConfig.screenWidth/1.3,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      image: DecorationImage(
                                          image: imageProvider, fit: BoxFit.fill),
                                    ),
                                  ),
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 2)))),

                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(left: 4),
                            width: SizeConfig.screenWidth/1.2,
                            child: AppMediumFont(context, msg: item?.productName ?? '', maxLines: 1),
                          ),
                          AppMediumFont(context, msg:" ₹"+ '${item?.productDetails?.productDiscountPrice}'),
                          SizedBox(height: 8)
                        ])));
          },
          itemCount: viewmodel.searchDataModel?.productList?.length)
          : Center(child: dataNotAvailable(viewmodel, context)),
      homeViewModel.isLoading == true
          ? Container(
          margin: EdgeInsets.only(bottom: 10),
          alignment: Alignment.bottomCenter,
          child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,strokeWidth: 2))
          : SizedBox()
    ]);
  }
  // textfield for search
  searchTextField() {
    return Container(
      color:Theme.of(context).primaryColor.withOpacity(0.9),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
               GestureDetector(
                   onTap: (){
                     context.router.push(HomePageWeb());
                   },
                   child: Image.asset(AssetsConstants.icBackArrow,color: Theme.of(context).hintColor)),
            SizedBox(width: 20),
            Container(
            height: 50,
            width:ResponsiveWidget.isSmallScreen(context) ?300:SizeConfig.screenWidth /1.2,
            margin: EdgeInsets.only(top: 5,bottom: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: TRANSPARENT_COLOR, width: 2.0),
            ),
            child: TextField(
    textAlign: TextAlign.start,
    controller: searchController,
    autofocus: true,
    style: TextStyle(color: Theme.of(context).hintColor),
    decoration: InputDecoration(
    contentPadding: EdgeInsets.only(top: 2,left: 12),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
    borderSide: BorderSide(
    color: Theme.of(context).hintColor.withOpacity(0.4),
    width: 2),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
    borderSide: BorderSide(
    color: Theme.of(context).hintColor.withOpacity(0.4),
    width: 2),
    ),
    hintText: StringConstant.searchItems,
    suffixIcon: Icon(Icons.search),
    suffixIconColor: Theme.of(context).hintColor
    ),
    onChanged: (v) {
    // AppIndicator.loadingIndicator(context);
    if(v.isEmpty){
            isSearch = false;
          }
          else{
            AppIndicator.loadingIndicator(context);
            homeViewModel.getSearchData(context, searchController?.text ?? '', pageNum);

          }
    },
    onSubmitted: (v){
      AppIndicator.loadingIndicator(context);
            homeViewModel.getSearchData(context, searchController?.text ?? '', pageNum);
            isSearch = true;
         //   homeViewModel.getSearchData(context, searchController?.text ?? '', pageNum);
    },
    ),
    )
            //
            // AppTextField(
            //     controller: searchController,
            //     maxLine: searchController!.text.length > 2 ? 2 : 1,
            //     textCapitalization: TextCapitalization.words,
            //     secureText: false,
            //     floatingLabelBehavior: FloatingLabelBehavior.never,
            //     maxLength: null,
            //     labelText: StringConstant.searchItems,
            //     keyBoardType: TextInputType.text,
            //     isSearch: true,
            //     autoFocus: true,
            //     onSubmitted: (v) {
            //       AppIndicator.loadingIndicator(context);
            //       homeViewModel.getSearchData(context, searchController?.text ?? '', pageNum);
            //       isSearch = true;
            //    //   homeViewModel.getSearchData(context, searchController?.text ?? '', pageNum);
            //     },
            //     verifySubmit: (){
            //       AppIndicator.loadingIndicator(context);
            //       homeViewModel.getSearchData(context, searchController?.text ?? '', pageNum);
            //     },
            //     onChanged: (v) async{
            //       if(v.isEmpty){
            //         isSearch = false;
            //       }
            //       else{
            //         AppIndicator.loadingIndicator(context);
            //         homeViewModel.getSearchData(context, searchController?.text ?? '', pageNum);
            //
            //       }
            //     },
            //     isTick: null)),
      ]),
    );
  }
}
