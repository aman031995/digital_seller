
import 'package:TychoStream/model/data/homepage_data_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/view/WebScreen/LoginUp.dart';

import 'package:TychoStream/view/WebScreen/OnHover.dart';
import 'package:TychoStream/view/WebScreen/SignUp.dart';
import 'package:TychoStream/viewmodel/auth_view_model.dart';

class CardMovieHome extends StatefulWidget {
  int? trayId;
  final String? image, title;
  final Function(FadeInImage)? onTap;
  final movieID;
  VideoList? moviesList;
  int? index;

  CardMovieHome(
      {Key? key,
        this.trayId,
      this.image,
      this.title,
      this.onTap,
      this.movieID,
      this.index,
      this.moviesList})
      : super(key: key);

  @override
  _CardMovieHomeState createState() => _CardMovieHomeState();
}

class _CardMovieHomeState extends State<CardMovieHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return
      OnHover(
        builder: (isHovered) {
      bool _heigth = isHovered;
      return
      Container(
        height: ResponsiveWidget.isMediumScreen(context)?SizeConfig.screenHeight * 0.2:SizeConfig.screenHeight/6,
        width:ResponsiveWidget.isMediumScreen(context)?SizeConfig.screenWidth*0.6: SizeConfig.screenWidth/5.2,
      padding: EdgeInsets.only(left:_heigth?0: 5,right:_heigth?0: 5,top:_heigth?0: 5,bottom:_heigth?0:5),
      child: InkWell(
        onTap: () async{
          if (isSearch == true)  {
            isSearch = false;
            searchController?.clear();
            setState(() {});
          }
          if( isLogins == true){
            isLogins=false;
            setState(() {

            });
          }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.get('token') != null) {
      // GoRouter.of(context).pushNamed(RoutesName.DeatilPage, queryParameters: {
      //   'movieID': '${widget.moviesList?.youtubeVideoId}',
      //   'VideoId': '${widget.moviesList?.videoId}',
      //   'Title': '${widget.moviesList?.videoTitle}',
      //   'Desc': '${widget.moviesList?.videoDescription}'
      // });
    }
    //itemCount:state.queryParameters['itemCount'],
    //               productId: state.queryParameters['productId'],
    //               variantId: state.queryParameters['variantId'],
    //               productColor: state.queryParameters['productColor'],
    //               productColorId: state.queryParameters['productColorId'],
    else{
      showDialog(
          context: context,
          barrierColor: Colors.black87,
          builder: (BuildContext context) {
            return  LoginUp();
          });
    }
        },
        //9c5757df-6dea-44ad-9578-2df898ef7733
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2,color:Theme.of(context).cardColor),
            boxShadow: [
              BoxShadow(
                offset: const Offset(
                  1.0,
                  1.0,
                ),
                blurRadius: 1.0,
                spreadRadius: 1.0,
              ), //BoxShadow//BoxShadow
            ],
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(widget.image ?? '',
                fit: BoxFit.fill,
              )),
        ),
      ),
    );},
          hovered: Matrix4.identity()..translate(0, 0, 0));
  }
}
