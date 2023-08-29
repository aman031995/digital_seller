import 'package:TychoStream/main.dart';
import 'package:TychoStream/model/data/category_product_model.dart';
import 'package:TychoStream/network/AppNetwork.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
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
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppRouter.gr.dart';

@RoutePage()
class CategorySubcategoryProduct extends StatefulWidget {
  final String? CategoryName;

  CategorySubcategoryProduct({
    @PathParam('CategoryName') this.CategoryName,
    Key? key,
  }) : super(key: key);

  @override
  State<CategorySubcategoryProduct> createState() => _CategorySubcategoryProductState();
}

class _CategorySubcategoryProductState extends State<CategorySubcategoryProduct> {
  CartViewModel cartViewModel = CartViewModel();
  String? checkInternet;
  int pageNum = 1;
  HomeViewModel homeViewModel = HomeViewModel();
  ProfileViewModel profileViewModel = ProfileViewModel();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  TextEditingController? searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<String> sortDropDownList = [
    "Recommended",
    "What's New",
    "Popularity",
    "Better Discount",
    "Price: High to Low",
    "Price: Low to High",
    "Customers Rating"
  ];

  void initState() {
    homeViewModel.getAppConfigData(context);
    getProduct();
    cartViewModel.getCartCount(context);
    super.initState();
  }

  getProduct() {
    cartViewModel.getCategorySubcategoryProductList(
        context, widget.CategoryName ?? "");
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
              return  GestureDetector(
                      onTap: () {
                        if (isLogins == true) {
                          isLogins = false;
                          setState(() {});
                        }
                        if (isSearch == true) {
                          isSearch = false;
                          setState(() {});
                        }
                      },
                      child: Scaffold(
                          appBar: ResponsiveWidget.isMediumScreen(context)
                              ? homePageTopBar(
                                  context,
                                  _scaffoldKey,
                                  cartViewModel.cartItemCount,
                                  homeViewModel,
                                  profileViewModel,
                                )
                              : getAppBar(
                                  context,
                                  homeViewModel,
                                  profileViewModel,
                                  cartViewModel.cartItemCount,
                                  1,
                                  searchController, () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  if (sharedPreferences.getString('token') ==
                                      null) {
                                    showDialog(
                                        context: context,
                                        barrierColor: Theme.of(context)
                                            .canvasColor
                                            .withOpacity(0.6),
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
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  if (sharedPreferences.getString('token') ==
                                      null) {
                                    showDialog(
                                        context: context,
                                        barrierColor: Theme.of(context)
                                            .canvasColor
                                            .withOpacity(0.6),
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
                                        itemCount:
                                            '${cartViewModel.cartItemCount}'));
                                  }
                                }),
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          body: Scaffold(
                              extendBodyBehindAppBar: true,
                              key: _scaffoldKey,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              drawer: ResponsiveWidget.isMediumScreen(context)
                                  ? AppMenu()
                                  : SizedBox(),
                              body:viewmodel.CategoryProduct!=null
                                  ?  Stack(
                                children: [
                                  SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      SizedBox(height: 20),
                                      Container(
                                          height: ResponsiveWidget.isMediumScreen(
                                              context) ? 140 : SizeConfig.screenWidth * 0.16,
                                          width: ResponsiveWidget.isMediumScreen(
                                              context) ?SizeConfig
                                              .screenWidth/1.08:SizeConfig
                                              .screenWidth/1.38,
                                          margin: EdgeInsets.zero,
                                          padding: EdgeInsets.zero,
                                          child: ListView.builder(
                                              physics: BouncingScrollPhysics(),
                                              reverse: false,
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              scrollDirection:
                                              Axis.horizontal,
                                              itemCount: viewmodel.CategoryProduct?.subCategoryList?.length,
                                              itemBuilder:
                                                  (context,
                                                  position) {
                                                return InkWell(
                                                  onTap: () {
                                                    if (isLogins == true) {
                                                      isLogins = false;

                                                    }
                                                    if (isSearch == true) {
                                                      isSearch = false;

                                                    }
                                                    context.router.push(SubcategoryProductList(
                                                      SubcategoryProductName:  viewmodel.CategoryProduct?.subCategoryList?[position].catId
                                                    ));
                                                  },
                                                  child:
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: ResponsiveWidget.isMediumScreen(
                                                            context)
                                                            ? 8
                                                            : 18),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        CircleAvatar(
                                                          radius: ResponsiveWidget.isMediumScreen(context) ? 50 : SizeConfig.screenWidth * 0.068,
                                                          child: CachedNetworkImage(
                                                              imageUrl: viewmodel.CategoryProduct?.subCategoryList?[position].imageUrl ?? "",
                                                              fit: BoxFit.fill,
                                                              imageBuilder: (context, imageProvider) => Container(
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  image: DecorationImage(
                                                                    image: imageProvider,
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                ),
                                                              ),
                                                              placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Colors.grey))),
                                                        ),

                                                        AppBoldFont(
                                                            maxLines:
                                                            1,
                                                            context,
                                                            msg: viewmodel
                                                                .CategoryProduct?.subCategoryList?[position].title ??
                                                                "",
                                                            fontSize: ResponsiveWidget.isMediumScreen(context)
                                                                ? 14
                                                                : 18,
                                                            color:
                                                            Theme.of(context).canvasColor),

                                                      ],
                                                    ),
                                                  ),
                                                );
                                              })),
                                      ResponsiveWidget.isMediumScreen(context)
                                          ? Container(
                                            margin: EdgeInsets.only(
                                                right: 12,
                                                left: 12,
                                                top: 12),
                                            width: SizeConfig.screenWidth,
                                            child: GridView.builder(
                                                shrinkWrap: true,
                                                //controller: _scrollController,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 0.6,
                                                ),
                                                itemCount: viewmodel
                                                    .CategoryProduct!
                                                    .productList
                                                    ?.length,
                                                itemBuilder:
                                                    (context, index) {
                                                  final productListData =
                                                      viewmodel
                                                          .CategoryProduct!
                                                          .productList?[index];
                                                  return productListItems(
                                                      context,
                                                      productListData,
                                                      index,
                                                      viewmodel);
                                                }),
                                          )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CategoryFilterScreen(
                                                  items: [],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 30,
                                                                right: 20),
                                                        width: SizeConfig
                                                                .screenWidth /
                                                            1.75,
                                                        child:
                                                            catrgoryTopSortWidget()),
                                                    SizedBox(height: 15),

                                                    Container(
                                                        width: SizeConfig
                                                                .screenWidth /
                                                            1.75,
                                                        child: GridView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 30,
                                                                  right: 5),
                                                          gridDelegate:
                                                              SliverGridDelegateWithMaxCrossAxisExtent(
                                                                  mainAxisSpacing:
                                                                      15,
                                                                  mainAxisExtent:
                                                                      470,
                                                                  maxCrossAxisExtent:
                                                                      350),
                                                          itemCount: viewmodel
                                                              .CategoryProduct!
                                                              .productList
                                                              ?.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final productListData =
                                                                viewmodel
                                                                    .CategoryProduct!
                                                                    .productList?[index];
                                                            return productListItems(
                                                                context,
                                                                productListData,
                                                                index,
                                                                viewmodel);
                                                          },
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                      ResponsiveWidget.isMediumScreen(context)
                                          ? SizedBox(height: 50)
                                          : SizedBox(height: 100),
                                      ResponsiveWidget.isMediumScreen(context)
                                          ? footerMobile(context)
                                          : footerDesktop()
                                    ],
                                  )),
                                  ResponsiveWidget.isMediumScreen(context)
                                      ? Container()
                                      : isLogins == true
                                          ? Positioned(
                                              top: 0,
                                              right: 180,
                                              child: profile(context, setState,
                                                  profileViewModel))
                                          : Container(),
                                  ResponsiveWidget.isMediumScreen(context)
                                      ? Container()
                                      : isSearch == true
                                          ? Positioned(
                                              top: ResponsiveWidget
                                                      .isMediumScreen(context)
                                                  ? 0
                                                  : 0,
                                              right: ResponsiveWidget
                                                      .isMediumScreen(context)
                                                  ? 0
                                                  : SizeConfig.screenWidth *
                                                      0.20,
                                              child: searchList(
                                                  context,
                                                  homeViewModel,
                                                  scrollController,
                                                  homeViewModel,
                                                  searchController!,
                                                  cartViewModel.cartItemCount))
                                          : Container()
                                ],
                              ) :Center(
                                child: ThreeArchedCircle(size: 45.0),
                              ))),
                    );

            }));
  }

  Widget catrgoryTopSortWidget() {
    return Container(
      height: 50,
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: AppRegularFont(context,
                msg: "1240 Item found", color: Theme.of(context).canvasColor),
          ),
          Expanded(
              child: SizedBox(
            width: SizeConfig.screenWidth / 8,
          )),
          Container(child: dropdown(sortDropDownList, context))
        ],
      ),
    );
  }

  Widget dropdown(List<String> txt, BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: AppRegularFont(context,
              msg: "Sort By",
              color: Theme.of(context).canvasColor,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          width: 15,
        ),
        Container(
          height: SizeConfig.screenHeight * .04,
          color: Theme.of(context).cardColor.withOpacity(0.8),
          width: ResponsiveWidget.isMediumScreen(context) ? 150 : 200,
          margin: EdgeInsets.only(left: 10, right: 10),
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
                borderSide: BorderSide(
                    width: 1,
                    color: Theme.of(context).primaryColor.withOpacity(0.2)),
              ),
              contentPadding: EdgeInsets.only(bottom: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            //isExpanded: true,
            hint: Text(
              txt[0],
              style: TextStyle(
                fontSize: ResponsiveWidget.isMediumScreen(context) ? 12 : 14,
                color: Theme.of(context).canvasColor.withOpacity(0.4),
              ),
            ),
            isExpanded: true,
            items: txt
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                            fontSize: ResponsiveWidget.isMediumScreen(context)
                                ? 12
                                : 14,
                            color: Theme.of(context).canvasColor),
                      ),
                    ))
                .toList(),
            onChanged: (String? value) {},
          ),
        ),
      ],
    );
  }
}
