import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/route_service/routes_name.dart';
import 'package:tycho_streams/view/WebScreen/OnHover.dart';
import 'package:tycho_streams/viewmodel/HomeViewModel.dart';

class TrendingVideos extends StatefulWidget {
  String? Videos;
  bool? isDetail;
 TrendingVideos({Key? key,this.Videos,this.isDetail}) : super(key: key);

  @override
  State<TrendingVideos> createState() => _TrendingVideosState();
}

class _TrendingVideosState extends State<TrendingVideos> {
  late AutoScrollController controller;
  final HomeViewModel homeView = HomeViewModel();
  List<String> title=['The Sunset','Mountains hills','Beautiful Beache','Green valley','Black Heads','The Sunset','Mountains hills','Beautiful Beache','Green valley','Black Heads','Mountains hills','Beautiful Beache'];
  List<String> images=["images/Trending1.png","images/Trending2.png","images/Trending3.png","images/Trending4.png","images/Trending5.png","images/Trending1.png",
    "images/Trending1.png","images/Trending2.png","images/Trending3.png","images/Trending4.png","images/Trending5.png","images/Trending1.png",
  ];
  int counter = 5;
  void initState() {
    homeView.getTrayData(context);
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
        create: (BuildContext context) => homeView,
        child: Consumer<HomeViewModel>(builder: (context, homeViewModel, _) {
          return
      Container(
      padding: EdgeInsets.only(right: 100,left: 100),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text("${widget.Videos}",style: TextStyle(
                  fontSize: 30,color: Color.fromRGBO(33, 37, 41, 1)
              )),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/ViewAll');
                },
                child: Text("view All",style: TextStyle(
                    fontSize: 24,color: Color.fromRGBO(33, 37, 41, 1)
                )),
              ),

            ],
          ),
          Stack(
            children: [
              Container(
                height:  330,
                child: ListView.builder(
                  padding: EdgeInsets.only(
                      left:  0),
                  scrollDirection: Axis.horizontal,
                  itemCount: homeViewModel.trayDataModel?.length ?? homeViewModel.homePageDataModel?.videoList?.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemExtent: 300,
                  controller: controller,
                  itemBuilder: (context, index) {

                    return AutoScrollTag(
                        key: ValueKey(index),
                        index: index,
                        controller: controller,
                        child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/Recommended');
                            } ,
                            child: OnHover(
                              builder: (isHovered) {
                                bool _heigth = isHovered;
                                return Container(
                                  padding: EdgeInsets.only(top: _heigth?0:10,bottom:_heigth?0: 10),
                                  decoration: BoxDecoration(
                                      borderRadius:BorderRadius.circular(5.0),
                                  ),

                                  child: Stack(
                                    children: <Widget>[
                                      CachedNetworkImage(
                                          height: _heigth?330:300,
                                          imageUrl: images[index],
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) =>
                                              placeHoldar(context),
                                          imageBuilder: (context,
                                              imageProvider) =>
                                              Container(
                                                decoration:
                                                BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      5.0),
                                                  image: DecorationImage(
                                                      image:
                                                      imageProvider,
                                                      fit: BoxFit.fill),
                                                ),
                                              )),
                                      Positioned(
                                        bottom:_heigth?20: 30,right:_heigth?30: 35,left: _heigth?20:30,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(AssetsConstants.icplay,height: 22),
                                            Text(title[index],style: TextStyle(fontSize: 22,color: Colors.white)),
                                            SizedBox(width: 22),
                                            Image.asset(AssetsConstants.icadd,height: 20),

                                          ],
                                        ),
                                      ),


                                    ],
                                  ),
                                );
                              },
                              hovered: Matrix4.identity()..translate(0, 0, 0),
                            )));
                  },
                ),
              ),
              Positioned(
                top: 150,right: 10,
                child: Container(
                    color: Colors.transparent,
                    child: InkWell(
                        child: Image.asset(
                          'images/next.png',
                          height:
                          30,
                          width:
                       45,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        onTap: () {
                          _nextCounter();
                        })),
              ),
              Positioned(
                top: 150,left: 12,
                child: Container(
                    color: Colors.transparent,
                    child: InkWell(
                        child: Image.asset(
                          'images/prev.png',
                          height:
                          30,
                          width:
                          45,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        onTap: () {
                          _prev();
                        })),
              ),
            ],
          )
        ],
      ),
    );}));



  }
  getTrayType(HomeViewModel homeViewModel){
    if(widget.isDetail == true){
      return homeViewModel.homePageDataModel?.videoList?.isNotEmpty;
    }else{
      return homeViewModel.trayDataModel?.isNotEmpty;
    }
  }
  Future _nextCounter() async {
    setState(() => counter = (counter + 1));
    await controller.scrollToIndex(counter,
        preferPosition: AutoScrollPosition.end);
    controller.highlight(counter);
  }

  Future _prev() async {
    setState(() {
      counter = 0;
    });
    await controller.scrollToIndex(counter,
        preferPosition: AutoScrollPosition.begin);
    controller.highlight(counter);
  }
}
Widget placeHoldar(BuildContext context) {
  return Center(
    child: Container(
      width:  200,
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/Indict.gif'),
          )),
    ),
  );
}