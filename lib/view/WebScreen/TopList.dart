import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/view/WebScreen/OnHover.dart';
import 'package:tycho_streams/view/WebScreen/TrendingVideos.dart';
class TopList extends StatefulWidget {
  const TopList({Key? key}) : super(key: key);

  @override
  State<TopList> createState() => _TopListState();
}

class _TopListState extends State<TopList> {
  late AutoScrollController controller;
  List<String> title=["Earth & Space",'The Perfect Girl','Real hunter','Blenders','Two Guy’s',"Earth & Space",'The Perfect Girl','Real hunter','Blenders','Two Guy’s',"Earth & Space",'The Perfect Girl'];
  List<String> images=["images/TopList1.png","images/TopList2.png","images/TopList3.png","images/TopList4.png","images/TopList1.png","images/TopList1.png",
    "images/TopList2.png","images/TopList3.png","images/TopList4.png","images/TopList2.png","images/TopList1.png","images/TopList2.png",
  ];
  int counter = 5;
  void initState() {
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
    return Container(
      padding: EdgeInsets.only(right: 100,left: 100),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text("TopList",style: TextStyle(
                  fontSize: 30,color: Color.fromRGBO(33, 37, 41, 1)
              )),
              Text("view All",style: TextStyle(
                  fontSize: 24,color: Color.fromRGBO(33, 37, 41, 1)
              )),

            ],
          ),
          Stack(
            children: [
              Container(
                height:  280,
                child: ListView.builder(
                  padding: EdgeInsets.only(
                      left:  0),
                  scrollDirection: Axis.horizontal,
                  itemCount:12,
                  itemExtent: 380,
                  controller: controller,
                  itemBuilder: (context, index) {

                    return AutoScrollTag(
                        key: ValueKey(index),
                        index: index,
                        controller: controller,
                        child: InkWell(
                            onTap: () {
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
                                          height: _heigth?280:250,
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
                                        bottom:_heigth?25: 35,right:_heigth?30: 35,left: _heigth?20:30,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(AssetsConstants.icplay,height: 22),
                                            Text(title[index],style: TextStyle(fontSize: 22,color: Colors.white)),
                                            SizedBox(width: 30),
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
                top: 120,right: 10,
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
                top: 120,left: 12,
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
    );
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