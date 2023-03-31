
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tycho_streams/main.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';

import 'package:tycho_streams/view/WebScreen/OnHover.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';

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
        height: ResponsiveWidget.isMediumScreen(context)?SizeConfig.screenHeight * 0.2:SizeConfig.screenHeight/5,
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
      GoRouter.of(context).pushNamed(RoutesName.DeatilPage, queryParams: {
        'movieID': '${widget.moviesList?.youtubeVideoId}',
        'VideoId': '${widget.moviesList?.videoId}',
        'Title': '${widget.moviesList?.videoTitle}',
        'Desc': '${widget.moviesList?.videoDescription}'
      });
    }
    else{
      showDialog(
          context: context,
          barrierColor: Colors.black87,
          builder: (BuildContext context) {
            return const LoginUp();
          });
    }
        },
        //9c5757df-6dea-44ad-9578-2df898ef7733
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(widget.image ?? '',
                    fit: BoxFit.cover))),
      ),
    );},
          hovered: Matrix4.identity()..translate(0, 0, 0));
  }
}
