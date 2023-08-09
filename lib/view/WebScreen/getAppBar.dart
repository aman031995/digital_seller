
import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/model/data/AppConfigModel.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/AppToast.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';
import 'package:TychoStream/view/WebScreen/OnHover.dart';
import 'package:TychoStream/view/effect/ShimmerEffect.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';
import 'package:TychoStream/viewmodel/profile_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../AppRouter.gr.dart';

PreferredSize getAppBar(BuildContext context, HomeViewModel viewmodel,ProfileViewModel profileViewModel, String? itemCount,TextEditingController? searchController,VoidCallback? onFavPressed,
    VoidCallback? onCartPressed){
  return  PreferredSize(
      preferredSize: Size.fromHeight(SizeConfig.screenHeight*0.085),
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
              Image.asset("images/CG-icon(2).webp",width: 60,height: 80,),
              SizedBox(width: SizeConfig.screenWidth * .01),
              Expanded(
                child: SizedBox(width: SizeConfig.screenWidth * .06)),
              viewmodel.appConfigModel!=null?
              Container(
                width: 300,height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: viewmodel.appConfigModel!.androidConfig!.bottomNavigation!.map((e) {
                    return GestureDetector(
                      onTap: (){
                        print(e.title);
                        getPages(e,context,profileViewModel);
                      },
                      child:OnHover(
        builder:
        (isHovered) { return AppBoldFont(context, msg: e.title ?? "",fontSize: isHovered==true?18:16,fontWeight:isHovered==true?FontWeight.w700: FontWeight.w500);},hovered: Matrix4
                          .identity()
                        ..translate(
                            0,
                            0,
                            0),
                    ));
                  }).toList() ,
                ),
              ):
              Center(
                child: Container(
                  width: 300,height: 50,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                            period: Duration(milliseconds: 1000),
                            baseColor: Colors.black38.withOpacity(0.4),
                            highlightColor:Colors.black38.withOpacity(0.1),
                            child: Container(
                              margin: EdgeInsets.all(8),
                              width: 80,height: 30,
                              color: Colors.grey,
                            )
                        );
                      }),
                ),
              ),
              Expanded(
                child: SizedBox(

                    width: SizeConfig.screenWidth * .04),

              ),
              Container(
                height: 40,
                width: SizeConfig.screenWidth / 4.2,
                alignment: Alignment.topCenter,
                child: AppTextField(
                    controller: searchController,
                    textCapitalization:
                    TextCapitalization.words,
                    secureText: false,
                    floatingLabelBehavior:
                    FloatingLabelBehavior.never,
                    maxLine: searchController!.text.length > 2 ? 2 : 1,
                    maxLength: null,
                    labelText: StringConstant.searchItems,
                    keyBoardType: TextInputType.text,
                    isSearch: true,
                    onSubmitted: (v) async{
                      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                      if (sharedPreferences.get('token') != null) {
                        AppIndicator.loadingIndicator(context);
                        viewmodel.getSearchData(context, searchController.text ?? '', 1);
                        isSearch = true;
                       }
                      else{

                      }
                    },
                    onChanged: (v) async{
                      if(v.isEmpty){
                        isSearch = false;
                      }
                      else{
                        AppIndicator.loadingIndicator(context);
                          viewmodel.getSearchData(context, searchController.text ?? '', 1);
                          isSearch = true;

                      }
                    },
                    isTick: null),
              ),
              SizedBox(
                  width: SizeConfig.screenWidth * .01),
              GestureDetector(
                  onTap: onFavPressed,
                  child: Icon(Icons.favorite_border, color: Theme.of(context).canvasColor, size: 30)),
              SizedBox(
                  width: SizeConfig.screenWidth * .01),
              Stack(
                children: [
                  GestureDetector(
                      onTap: onCartPressed,
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
              SizedBox(
                  width: SizeConfig.screenWidth * .01),
              names == "null"
                  ? OutlinedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder:
                            (BuildContext context) {
                          return  LoginUp(
                            product: false,
                          );
                        });
                  },
                  style: ButtonStyle(
                      overlayColor: MaterialStateColor
                          .resolveWith((states) =>
                      Theme
                          .of(context)
                          .primaryColor.withOpacity(0.4)),
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
                    isLogins =true;
                  }),
              names == "null"
                  ? Container()
                  : Image.asset(
                AssetsConstants.icProfile,
                height: 30,
                color: Theme.of(context).canvasColor,
              ),
              SizedBox(
                  width: SizeConfig.screenWidth * .04),
            ],
          ),
        ),
      )
  );
}
getPages(BottomNavigation navItem,BuildContext context,ProfileViewModel profileViewModel) {
  Uri url = Uri.parse(navItem.url ?? '');
  if(url.path == RoutesName.homepageweb){
    return context.router.push(HomePageWeb());
  }  else if (url.path == RoutesName.productPage){
    return context.router.push(ProductListGallery());
  }
  else if(url.path==RoutesName.profilePage){
    names == "null"?showDialog(
        context: context,
        barrierColor: Theme.of(context).canvasColor.withOpacity(0.6),
        builder:
            (BuildContext context) {
          return  LoginUp(
            product: true,
          );
        }):
    context.router.push(EditProfile());
  }
}

AppBar homePageTopBar(BuildContext context,GlobalKey<ScaffoldState> _scaffoldKey ) {
  return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme
          .of(context)
          .cardColor,
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
                onTap: () async{
                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  if (sharedPreferences.get('token') != null){
                    if (_scaffoldKey.currentState?.isDrawerOpen == false) {
                      _scaffoldKey.currentState?.openDrawer();
                    } else {
                      _scaffoldKey.currentState?.openEndDrawer();
                    }
                  }
                  else{
                   ToastMessage.message("please Login");
                  }
                },
                child: Icon(Icons.menu_outlined,color: Theme.of(context).canvasColor)),
            SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                if(isSearch==true){
                  isSearch=false;
                }
                if( isLogins == true){
                  isLogins=false;
                }
                context.pushRoute(ProductListGallery());
              },
              child: Container(height: 30,
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.6),width: 1),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: appTextButton(
                    context,
                    StringConstant.productList,
                    Alignment.center,
                    Theme
                        .of(context)
                        .canvasColor,
                    14,
                    true),
              ),
            ),
            SizedBox(width: 5),
            GestureDetector(
                onTap: () {
                  context.pushRoute(SearchPage());
                  // GoRouter.of(context).pushNamed(RoutesName.SearchPage);
                },
                child: Icon(Icons.search_sharp,size: 30,color: Theme.of(context).canvasColor,)
            ),
            SizedBox(
                width: SizeConfig.screenWidth * .01),
            names == "null"
                ?
            OutlinedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder:
                          (BuildContext context) {
                        return LoginUp();
                      });
                },
                style: ButtonStyle(

                    overlayColor: MaterialStateColor
                        .resolveWith((states) =>
                    Theme
                        .of(context)
                        .primaryColor.withOpacity(0.4)),
                    fixedSize:
                    MaterialStateProperty.all(
                        Size.fromHeight(30)),
                    side: MaterialStateProperty.all(BorderSide(
                        color: Theme
                            .of(context)
                            .canvasColor,

                        width: 1,
                        style: BorderStyle.solid),
                    )
                ),
                child: Row(
                  children: [
                    Image.asset(
                        AssetsConstants.icProfile,
                        width: 20,
                        height: 20, color: Theme
                        .of(context)
                        .canvasColor),
                    appTextButton(
                        context,
                        'SignIn',
                        Alignment.center,
                        Theme
                            .of(context)
                            .canvasColor,
                        14,
                        true),
                  ],
                ))
                :
            GestureDetector(
              onTap: () {

                  isLogins = true;
                  if (isSearch == true) {
                    isSearch = false;

                }
              },
              child: Image.asset(
                AssetsConstants.icProfile,
                height: 30,
                color: Theme
                    .of(context)
                    .canvasColor,
              ),
            ),
          ]));
}