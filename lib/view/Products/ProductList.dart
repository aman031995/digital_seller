import 'package:TychoStream/main.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/MobileScreen/menu/app_menu.dart';
import 'package:TychoStream/view/Products/CategoryFilterWidget.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/footerDesktop.dart';
import 'package:TychoStream/view/WebScreen/getAppBar.dart';
import 'package:TychoStream/view/search/search_list.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/view/widgets/no_data_found_page.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppRouter.gr.dart';

@RoutePage()
class ProductListGallery extends StatefulWidget {

  @override
  State<ProductListGallery> createState() => _ProductListGalleryState();
}

class _ProductListGalleryState extends State<ProductListGallery> {
  CartViewModel cartViewModel = CartViewModel();
  ScrollController _scrollController = ScrollController();
  String? checkInternet;
  int pageNum = 1;
  HomeViewModel homeViewModel = HomeViewModel();
  ProfileViewModel profileViewModel = ProfileViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  TextEditingController? searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<String> sortDropDownList = ["Recommended", "What's New", "Popularity", "Better Discount", "Price: High to Low", "Price: Low to High", "Customers Rating"];


  void initState() {
    homeViewModel.getAppConfig(context);
    profileViewModel.getUserDetails(context);
    cartViewModel.getProductList(context, pageNum);
    cartViewModel.getCartCount(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    AppNetwork.checkInternet((isSuccess, result) {
      setState(() {
        checkInternet = result;
      });
    });

    return checkInternet == "Offline"
        ? NOInternetScreen()
        : ChangeNotifierProvider.value(
            value: cartViewModel,
            child: Consumer<CartViewModel>(builder: (context, viewmodel, _) {
              return GestureDetector(
                onTap: () {
                  if (isLogins == true) {
                    isLogins = false;
                    setState(() {});
                  }
                  if(isSearch==true){
                    isSearch=false;
                    setState(() {
                    });
                  }
                },
                child: Scaffold(
                  appBar:  ResponsiveWidget.isMediumScreen(context)
                      ? homePageTopBar(context,_scaffoldKey,cartViewModel.cartItemCount):getAppBar(context, homeViewModel, profileViewModel,
                      cartViewModel.cartItemCount, 1,searchController,() async {
                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    if (sharedPreferences.getString('token') == null) {
                      showDialog(
                          context: context,
                          barrierColor:
                           Theme.of(context).canvasColor.withOpacity(0.6),
                          builder: (BuildContext context) {
                            return LoginUp(
                              product: true,
                            );
                          });
                    } else {
                      if (isLogins == true) {
                        isLogins = false;
                        setState(() {});
                      }
                      if (isSearch == true) {
                        isSearch = false;
                        setState(() {});
                      }
                      context.router.push(FavouriteListPage());
                    }
                  }, () async {
                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    if (sharedPreferences.getString('token') == null) {
                      showDialog(
                          context: context,
                          barrierColor:
                              Theme.of(context).canvasColor.withOpacity(0.6),
                          builder: (BuildContext context) {
                            return LoginUp(
                              product: true,
                            );
                          });
                    } else {
                      if (isLogins == true) {
                        isLogins = false;
                        setState(() {});
                      }
                      if (isSearch == true) {
                        isSearch = false;
                        setState(() {});
                      }
                      context.router.push(CartDetail(
                          itemCount: '${cartViewModel.cartItemCount}'));
                    }
                  }),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: Scaffold(

                    extendBodyBehindAppBar: true,
                    key: _scaffoldKey,
                    backgroundColor: Theme.of(context)
                        .scaffoldBackgroundColor,
                    drawer:
                    ResponsiveWidget.isMediumScreen(context)
                        ? AppMenu()
                        : SizedBox(),
                    body: viewmodel.productListModel?.productList != null ?
                  (viewmodel.productListModel?.productList?.length ?? 0)  > 0
                      ?
                   Stack(
                      children: [
                                    SingleChildScrollView(
                                        child: Column(
                                        children: [
                                          ResponsiveWidget.isMediumScreen(context)
                                              ?  Container(
                                            margin: EdgeInsets.only(right: 12,left: 12,top: 12),

                                            height: SizeConfig.screenHeight/1.2,
                                            child: GridView.builder(
                                              shrinkWrap: true,
                                              controller: _scrollController,
                                              physics: BouncingScrollPhysics(),
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 0.68,
                                              ),
                                              itemCount: viewmodel
                                                  .productListModel
                                                  ?.productList
                                                  ?.length,
                                              itemBuilder: (context, index) {
                                                _scrollController.addListener(() {
                                                  if (_scrollController
                                                          .position.pixels ==
                                                      _scrollController.position
                                                          .maxScrollExtent) {
                                                    viewmodel.onPagination(
                                                        context,
                                                        viewmodel.lastPage,
                                                        viewmodel.nextPage,
                                                        viewmodel.isLoading,
                                                        'productList');
                                                  }
                                                });
                                                final productListData = viewmodel
                                                    .productListModel
                                                    ?.productList?[index];
                                                return productListItems(
                                                    context,
                                                    productListData,
                                                    index,
                                                    viewmodel);
                                              },
                                            ),
                                          ):
                                          Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: SizeConfig.screenWidth / 6.5,
                                              child: Column(
                                                children: [
                                                  CategoryFilterScreen(items: [],),
                                                 // SizedBox(height: 50),
                                                  Container(
                                                      color: Theme.of(context).cardColor,
                                                      margin: EdgeInsets.only( right: 10),
                                                      padding: EdgeInsets.only(top: 10),

                                                      alignment: Alignment.bottomCenter,
                                                      width: SizeConfig.screenWidth / 6.5,
                                                      child: GlobalVariable.isLightTheme == true ?
                                                      Image.network("https://eacademyeducation.com:8011/logo/lite_logo.png", fit: BoxFit.fill, width: SizeConfig.screenWidth * 0.08) :
                                                      Image.network("https://eacademyeducation.com:8011/logo/dark_logo.png", fit: BoxFit.fill, width: SizeConfig.screenWidth * 0.08)),
                                                  SizedBox(height: 10),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(top: 30,),
                                                    width: SizeConfig.screenWidth/2.03,
                                                    color: Theme.of(context).cardColor,
                                                    child: catrgoryTopSortWidget()),
                                                Container(
                                                  height: SizeConfig.screenHeight*1.5,
                                                  width: SizeConfig.screenWidth/2,
                                                  child: GridView.builder(
                                                    shrinkWrap: true,
                                                    controller: _scrollController,
                                                    physics:
                                                    BouncingScrollPhysics(),
                                                    padding:
                                                    EdgeInsets.only(top: 30),
                                                    gridDelegate:
                                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                                        mainAxisSpacing: 15,
                                                        mainAxisExtent: 470,
                                                        maxCrossAxisExtent:
                                                        350),
                                                    itemCount: viewmodel
                                                        .productListModel
                                                        ?.productList
                                                        ?.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      _scrollController
                                                          .addListener(() {
                                                        if (_scrollController
                                                            .position
                                                            .pixels ==
                                                            _scrollController
                                                                .position
                                                                .maxScrollExtent) {
                                                          viewmodel.onPagination(
                                                              context,
                                                              viewmodel.lastPage,
                                                              viewmodel.nextPage,
                                                              viewmodel.isLoading,
                                                              'productList');
                                                        }
                                                      });
                                                      final productListData =
                                                      cartViewModel
                                                          .productListModel
                                                          ?.productList?[
                                                      index];
                                                      return productListItems(
                                                          context,
                                                          productListData,
                                                          index,
                                                          viewmodel);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                          ResponsiveWidget.isMediumScreen(context)
                                              ?    SizedBox(height: 50): SizedBox(height: 100),
                                          ResponsiveWidget.isMediumScreen(context)
                                              ? footerMobile(context):footerDesktop()
                                        ],
                                      )),
                                    viewmodel.isLoading == true
                                        ? Container(
                                      margin: EdgeInsets.only(bottom:40),
                                        alignment:
                                        Alignment.bottomCenter,
                                        child:
                                        CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .primaryColor,
                                        ))
                                        : SizedBox(),
                        ResponsiveWidget
                            .isMediumScreen(context)
                            ?Container():  isLogins == true
                                        ? Positioned(
                                        top: 0,
                                        right: 180,
                                        child: profile(context, setState,
                                            profileViewModel))
                                        : Container(),
                        ResponsiveWidget
                            .isMediumScreen(context)
                            ? Container():  isSearch==true?
                        Positioned(
                            top: ResponsiveWidget.isMediumScreen(context) ? 0:0,
                            right: ResponsiveWidget.isMediumScreen(context) ? 0:SizeConfig.screenWidth*0.15,
                            child: searchList(context, homeViewModel, scrollController,homeViewModel, searchController!,cartViewModel.cartItemCount))
                            : Container()
                                  ],
                                )


                          : Center(
                              child: noDataFoundMessage(
                                  context, StringConstant.noItemInCart))
                      : Center(
                          child: ThreeArchedCircle(size: 45.0),
                        ),
                )),
              );
            }));
  }



  Widget catrgoryTopSortWidget(){
    return Container(
      height: SizeConfig.screenHeight * 0.05,
      child: Row(
        children: [
          SizedBox(width: 10),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: AppRegularFont(context, msg: "1240 Item found", color: Theme.of(context).canvasColor),
          ),
          Expanded(child: SizedBox(width: SizeConfig.screenWidth/ 8,)),
          Container(
              child: dropdown(sortDropDownList, context))
        ],
      ),
    );
  }

  Widget dropdown(List<String> txt,BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
          ),
          child: AppRegularFont(context, msg: "Sort By", color: Theme.of(context).canvasColor, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 15,),
        Container(
          height: SizeConfig.screenHeight * .04,color: Theme.of(context).cardColor.withOpacity(0.8),
          width: ResponsiveWidget.isMediumScreen(context)? 150:200,
          margin: EdgeInsets.only(left: 10,right: 10),
          child: DropdownButtonFormField2(
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).cardColor,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor.withOpacity(0.2)),
              ),
              contentPadding: EdgeInsets.only(bottom: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            //isExpanded: true,
            hint: Text(
              txt[0],
              style: TextStyle(fontSize:ResponsiveWidget.isMediumScreen(context)?12: 14, color: Theme.of(context).canvasColor.withOpacity(0.4),),
            ),
            isExpanded: true,
            items: txt
                .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(fontSize: ResponsiveWidget.isMediumScreen(context)?12:14, color:Theme.of(context).canvasColor),
              ),
            ))
                .toList(),
            onChanged: (String? value) {
            },
          ),
        ),
      ],
    );
  }
}

