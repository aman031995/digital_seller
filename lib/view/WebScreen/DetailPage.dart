import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/view/CustomPlayer/YoutubePlayer/YoutubeAppDemo.dart';


import 'package:tycho_streams/view/WebScreen/MovieDetailTitleSection.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';


class DetailPage extends StatefulWidget {
  String? movieID;
String? VideoId;
String? Title;
String? Desc;
  DetailPage({this.movieID,this.Desc,this.Title,this.VideoId});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? userID;

  @override
  void initState() {
    setState((){});
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    _tabController = TabController(length: 2, vsync: this);
  }
  bool _isRefreshing = false;
  final HomeViewModel homeView = HomeViewModel();
  @override
  void dispose() {
    super.dispose();
  }
  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Perform any refresh actions here, such as fetching new data

    setState(() {
      _isRefreshing = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,      body: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),

             Container(
                     width: SizeConfig.screenWidth/1.3,
                     height: ResponsiveWidget.isMediumScreen(context)?SizeConfig.screenWidth /2.47:SizeConfig.screenWidth /2.959,
                     child:
                     YoutubeAppDemo(videoID: widget.movieID,)
                 ),
                    //
                    MovieDetailTitleSection(
                        isWall: true, movieDetailModel: widget.VideoId,Title: widget.Title,Desc: widget.Desc,),
                  SizedBox(height: 20),
                  ResponsiveWidget.isMediumScreen(context)? footerMobile(context):footerDesktop()
                ],
              ),
            ),
          ));
  }


}
