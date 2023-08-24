import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/model/data/AppConfigModel.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/OnHover.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../AppRouter.gr.dart';

PreferredSize getAppBar(
    BuildContext context,
    HomeViewModel viewmodel,
    ProfileViewModel profileViewModel,
    String? itemCount,
    int pageNum,
    TextEditingController? searchController,
    VoidCallback? onFavPressed,
    VoidCallback? onCartPressed) {
  return PreferredSize(
      preferredSize: Size.fromHeight(75),
      child: Card(
        elevation: 0.8,
        margin: EdgeInsets.zero,
        child: Container(
          color: Theme.of(context).cardColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: SizeConfig.screenWidth * .01),
              Image.asset(
                AssetsConstants.webLogo,
                width: 60,
                height: 80,
              ),
              SizedBox(width: SizeConfig.screenWidth * .01),
              Expanded(child: SizedBox(width: SizeConfig.screenWidth * .04)),
              viewmodel.appConfigModel != null
                  ? Container(
                      width: 300,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: viewmodel
                            .appConfigModel!.androidConfig!.bottomNavigation!
                            .map((e) {
                          return InkWell(
                              onTap: () {
                                print(e.title);
                                getPages(e, context, profileViewModel);

                              },
                              child: OnHover(
                                builder: (isHovered) {
                                  return AppBoldFont(context,
                                      msg: e.title ?? "",
                                      fontSize: isHovered == true ? 18 : 16,
                                      fontWeight: isHovered == true
                                          ? FontWeight.w700
                                          : FontWeight.w500);
                                },
                                hovered: Matrix4.identity()..translate(0, 0, 0),
                              ));
                        }).toList(),
                      ),
                    )
                  : Center(
                      child: Container(
                        width: 300,
                        height: 50,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                  period: Duration(milliseconds: 1000),
                                  baseColor: Colors.black38.withOpacity(0.4),
                                  highlightColor:
                                      Colors.black38.withOpacity(0.1),
                                  child: Container(
                                    margin: EdgeInsets.all(8),
                                    width: 80,
                                    height: 30,
                                    color: Colors.grey,
                                  ));
                            }),
                      ),
                    ),
              Expanded(
                child: SizedBox(width: SizeConfig.screenWidth * .04),
              ),
              Container(
                height: 40,
                width: SizeConfig.screenWidth / 4.2,
                alignment: Alignment.topCenter,
                child: AppTextField(
                    controller: searchController,
                    textCapitalization: TextCapitalization.words,
                    secureText: false,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    maxLine: searchController!.text.length > 2 ? 2 : 1,
                    maxLength: null,
                    labelText: StringConstant.searchItems,
                    keyBoardType: TextInputType.text,
                    isSearch: true,
                    onSubmitted: (v) async {
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      if (sharedPreferences.get('token') != null) {
                        AppIndicator.loadingIndicator(context);
                        viewmodel.getSearchData(
                            context, searchController.text, pageNum);
                        isSearch = true;
                      } else {}
                    },
                    onChanged: (v) async {
                      if (v.isEmpty) {
                        isSearch = false;
                      } else {
                        AppIndicator.loadingIndicator(context);
                        viewmodel.getSearchData(
                            context, searchController.text, pageNum);
                        isSearch = true;
                      }
                    },
                    isTick: null),
              ),
              SizedBox(width: SizeConfig.screenWidth * .01),
              InkWell(
                  onTap: onFavPressed,
                  child: Icon(Icons.favorite_border,
                      color: Theme.of(context).canvasColor, size: 30)),
              SizedBox(width: SizeConfig.screenWidth * .01),
              Stack(
                children: [
                  InkWell(
                      onTap:
                      onCartPressed,
                      child: Icon(Icons.shopping_cart,
                          color: Theme.of(context).canvasColor, size: 30)),
                  itemCount != '0'
                      ? Positioned(
                          right: 1,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: Text(
                              itemCount ?? '',
                              style: TextStyle(color: WHITE_COLOR),
                            ),
                          ))
                      : SizedBox()
                ],
              ),
              SizedBox(width: SizeConfig.screenWidth * .01),
              names == "null"
                  ? OutlinedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return LoginUp(
                                product: true,
                              );
                            });
                      },
                      style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.4)),
                          fixedSize:
                              MaterialStateProperty.all(Size.fromHeight(35)),
                          side: MaterialStateProperty.all(
                            BorderSide(
                                color: Theme.of(context).canvasColor,
                                width: 1.5,
                                style: BorderStyle.solid),
                          )),
                      child: Row(
                        children: [
                          Image.asset(AssetsConstants.icProfile,
                              width: 20,
                              height: 20,
                              color: Theme.of(context).canvasColor),
                          appTextButton(context, StringConstant.SignIn, Alignment.center,
                              Theme.of(context).canvasColor, 16, true),
                        ],
                      ))
                  : appTextButton(context, names!, Alignment.center,
                      Theme.of(context).canvasColor, 18, true, onPressed: () {
                      isLogins = !isLogins;
                      isSearch = false;

                  }),
              names == "null"
                  ? Container()
                  : GestureDetector(
                onTap: (){
                  isLogins = !isLogins;
                  isSearch = false;
                },
                    child: Image.asset(
                        AssetsConstants.icProfile,
                        height: 30,
                        color: Theme.of(context).canvasColor,
                      ),
                  ),
              Expanded(
                child: SizedBox(width: SizeConfig.screenWidth * .05),
              ),
            ],
          ),
        ),
      ));
}

getPages(BottomNavigation navItem, BuildContext context,
    ProfileViewModel profileViewModel) {
  Uri url = Uri.parse(navItem.url ?? '');
  if (url.path == RoutesName.homepageweb) {
    isSearch = false;

    return context.router.push(HomePageWeb());
  } else if (url.path == RoutesName.productPage) {
    isSearch = false;
    return context.router.push(ProductListGallery());
  } else if (url.path == RoutesName.profilePage) {
    isSearch = false;

    names == "null"
        ? showDialog(
            context: context,
            barrierColor: Theme.of(context).canvasColor.withOpacity(0.6),
            builder: (BuildContext context) {
              return LoginUp(
                product: true,
              );
            })
        : context.router.push(EditProfile());
  }
}

PreferredSize homePageTopBar(BuildContext context,
    GlobalKey<ScaffoldState> _scaffoldKey, String itemCount, HomeViewModel viewmodel,
    ProfileViewModel profileViewModel) {
  return PreferredSize(
      preferredSize: Size.fromHeight(90),
      child: Card(
        elevation: 0.8,
        margin: EdgeInsets.zero,
        child: Container(
          color: Theme.of(context).cardColor,

          child: Column(
            children: [
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                SizedBox(width: 5),

                GestureDetector(

                    onTap: () async {

                        if (_scaffoldKey.currentState?.isDrawerOpen == false) {
                          _scaffoldKey.currentState?.openDrawer();
                        } else {
                          _scaffoldKey.currentState?.openEndDrawer();
                        }

                    },
                    child: Icon(Icons.menu_outlined,
                        color: Theme.of(context).canvasColor,size: 30,)),
                SizedBox(width: 5),
                // OutlinedButton(
                //     onPressed: () {
                //       if (isSearch == true) {
                //         isSearch = false;
                //       }
                //       if (isLogins == true) {
                //         isLogins = false;
                //       }
                //       context.pushRoute(ProductListGallery());
                //     },
                //     style: ButtonStyle(
                //         overlayColor: MaterialStateColor.resolveWith(
                //                 (states) => Theme.of(context)
                //                 .primaryColor
                //                 .withOpacity(0.4)),
                //         fixedSize:
                //         MaterialStateProperty.all(Size.fromHeight(20)),
                //         side: MaterialStateProperty.all(
                //           BorderSide(
                //               color: Theme.of(context).canvasColor,
                //               width: 1,
                //               style: BorderStyle.solid),
                //         )),
                //     child: appTextButton(context, StringConstant.category,
                //         Alignment.center, Theme.of(context).canvasColor, 12, true)),
                InkWell(
                    onTap: () {
                      context.pushRoute(SearchPage());
                      // GoRouter.of(context).pushNamed(RoutesName.SearchPage);
                    },
                    child:Container(
                        height: 40,
                        padding: EdgeInsets.only(left: 5),
                        width: SizeConfig.screenWidth * 0.55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Theme.of(context).canvasColor.withOpacity(0.5), width: 1.0),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 12),
                                  child: AppRegularFont(context, msg: StringConstant.searchItems,color: Theme.of(context).canvasColor.withOpacity(0.4))),
                              Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: Image.asset(AssetsConstants.icSearch,width: 20, height: 20,color: Theme.of(context).canvasColor.withOpacity(0.4)))
                            ])),
                    // Icon(
                    //   Icons.search_sharp,
                    //   size: 30,
                    //   color: Theme.of(context).canvasColor,
                    // )
                ),
                SizedBox(width: 5),
                InkWell(
                    onTap: () async {
                      SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                      if (sharedPreferences.get('token') == null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return LoginUp(
                                product: true,
                              );
                            });
                      } else {
                        context.router.push(FavouriteListPage());
                      }
                    },
                    child: Icon(Icons.favorite_border,
                        color: Theme.of(context).canvasColor, size: 30)),
                SizedBox(width: 5),
                Stack(
                  children: [
                    InkWell(
                        onTap: () async {
                          SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
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
                            context.router.push(CartDetail(itemCount: '${itemCount}'));
                          }
                        },
                        child: Icon(Icons.shopping_cart,
                            color: Theme.of(context).canvasColor, size: 30)),
                    itemCount != '0'
                        ? Positioned(
                        right: -1,
                        top: -2,
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Text(
                            itemCount ?? '',
                            style: TextStyle(color: WHITE_COLOR, fontSize: 10),
                          ),
                        ))
                        : SizedBox()
                  ],
                ),
                SizedBox(width: 5),

              ]),
              SizedBox(width: 5),
              viewmodel.appConfigModel != null
                  ? Container(
                padding: EdgeInsets.only(top: 10),
                width: SizeConfig.screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: viewmodel
                      .appConfigModel!.androidConfig!.bottomNavigation!
                      .map((e) {
                    return InkWell(
                        onTap: () {
                          print(e.title);
                          getPages(e, context, profileViewModel);

                        },
                        child: OnHover(
                          builder: (isHovered) {
                            return AppBoldFont(context,
                                msg: e.title ?? "",
                                fontSize: isHovered == true ? 18 : 16,
                                fontWeight: isHovered == true
                                    ? FontWeight.w700
                                    : FontWeight.w500);
                          },
                          hovered: Matrix4.identity()..translate(0, 0, 0),
                        ));
                  }).toList(),
                ),
              )
                  : Center(
                child: Container(
                  height: 30,
                  width: SizeConfig.screenWidth,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                            period: Duration(milliseconds: 1000),
                            baseColor: Colors.black38.withOpacity(0.4),
                            highlightColor:
                            Colors.black38.withOpacity(0.1),
                            child: Container(
                              margin: EdgeInsets.all(8),
                              width: 80,
                              height: 30,
                              color: Colors.grey,
                            ));
                      }),
                ),
              )
            ],
          ),
        ),
      ));
}
