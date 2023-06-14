import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:TychoStream/main.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/view/CustomPlayer/YoutubePlayer/YoutubeAppDemo.dart';
import 'package:TychoStream/view/WebScreen/MovieDetailTitleSection.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';


@RoutePage()
class DetailPage extends StatefulWidget {
  String? movieID;
String? VideoId;
String? Title;
String? Desc;
  final List<String>? VideoDetails;
  DetailPage({
    @QueryParam() this.VideoDetails,
    this.movieID,this.Desc,this.Title,this.VideoId});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<DetailPage> {
  String url='';
  HomeViewModel homeViewModel = HomeViewModel();
  ScrollController _scrollController = ScrollController();
  ScrollController scrollController = ScrollController();
  bool isSearch = false;
  int pageNum = 1;
  @override

  void initState() {
    setState((){
    });
    searchController?.addListener(() {
      homeViewModel.getSearchData(
          context, '${searchController?.text}', pageNum);
    });
    super.initState();
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body:  SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                 width: ResponsiveWidget.isMediumScreen(context)?  SizeConfig.screenWidth: SizeConfig.screenWidth/1.3,
                 height: ResponsiveWidget.isMediumScreen(context)?SizeConfig.screenWidth /2:SizeConfig.screenWidth /2.959,
                 child: YoutubeAppDemo(videoID: widget.VideoDetails?[0])
              ),
                MovieDetailTitleSection(
                    isWall: true, movieDetailModel:  widget.VideoDetails?[1],Title:  widget.VideoDetails?[2],Desc: widget.VideoDetails?[3]),
              SizedBox(height: 80),
            //  ResponsiveWidget.isMediumScreen(context)? footerMobile(context):footerDesktop(),

            ],
          ),
        ),
      )
    );
  }}
