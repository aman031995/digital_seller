import 'package:flutter/material.dart';


import 'package:provider/provider.dart';
import 'package:tycho_streams/main.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AppTextButton.dart';
import 'package:tycho_streams/utilities/AppTextField.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/Responsive.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/CustomPlayer/YoutubePlayer/YoutubeAppDemo.dart';
import 'package:tycho_streams/view/WebScreen/DesktopAppBar.dart';
import 'package:tycho_streams/view/WebScreen/EditProfile.dart';
import 'package:tycho_streams/view/WebScreen/HomePageWeb.dart';
import 'package:tycho_streams/view/WebScreen/LoginUp.dart';


import 'package:tycho_streams/view/WebScreen/MovieDetailTitleSection.dart';
import 'package:tycho_streams/view/WebScreen/SignUp.dart';
import 'package:tycho_streams/view/WebScreen/footerDesktop.dart';
import 'package:tycho_streams/view/widgets/search_view.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';
import 'package:tycho_streams/viewmodel/auth_view_model.dart';

import '../widgets/app_menu.dart';


class DetailPage extends StatefulWidget {
  String? movieID;
String? VideoId;
String? Title;
String? Desc;
  DetailPage({this.movieID,this.Desc,this.Title,this.VideoId});

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
     url = 'https://www.youtube.com/embed/${widget.movieID}';
    });
    homeViewModel.getAppConfigData(context);
    searchController?.addListener(() {
      homeViewModel.getSearchData(
          context, '${searchController?.text}', pageNum);
    });
    super.initState();
  }
  void dispose() {
    _scrollController.dispose();
    searchController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authVM = Provider.of<AuthViewModel>(context);
    return ChangeNotifierProvider(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
      return
        Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body:  SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                         width: SizeConfig.screenWidth/1.3,
                         height: ResponsiveWidget.isMediumScreen(context)?SizeConfig.screenWidth /2.47:SizeConfig.screenWidth /2.959,
                         child: YoutubeAppDemo(videoID: widget.movieID)
                     ),
                        MovieDetailTitleSection(
                            isWall: true, movieDetailModel: widget.VideoId,Title: widget.Title,Desc: widget.Desc,),
                      SizedBox(height: 80),
                      ResponsiveWidget.isMediumScreen(context)? footerMobile(context):footerDesktop(),

                    ],
                  ),
                ),
              ],
            ),
          )
        );
        }
        )
    );
  }


}
