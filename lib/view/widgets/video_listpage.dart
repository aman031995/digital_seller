import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/model/data/data_sample.dart';
import 'package:tycho_streams/repository/subscription_provider.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/view/screens/ViewAllListPages.dart';
import 'package:tycho_streams/view/screens/subscription_page.dart';

class VideoListPage extends StatefulWidget {
  const VideoListPage({Key? key}) : super(key: key);

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  ScrollController scrollController = ScrollController();
  bool isTopTen = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final subscriptionVM = Provider.of<SubscriptionProvider>(context);
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          contentWidget(
            title: ' Trending',
            videoList: ListView(
              scrollDirection: Axis.horizontal,
              children: myList(subscriptionVM, false),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          contentWidget(
            title: ' Top 10',
            isTopTen: true,
            videoList: ListView(
              scrollDirection: Axis.horizontal,
              children: myList(subscriptionVM, true),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          contentWidget(
            title: ' Watching',
            videoList: ListView(
              scrollDirection: Axis.horizontal,
              children: myList(subscriptionVM, false),
            ),
          ),
        ],
      ),
    );
  }

  contentWidget({String? title, Widget? videoList, bool? isTopTen}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 15, top: 12, right: 15),
          alignment: Alignment.topLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewAllListPages(
                          moviesList: [],
                        ),
                      ));
                },
                child: Text(
                  'See All',
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.only(left: 15, top: 5),
            height: isTopTen == true
                ? SizeConfig.screenHeight! * 0.15
                : SizeConfig.screenHeight! * 0.25,
            child: videoList),
      ],
    );
  }

  myList(SubscriptionProvider subscriptionVM, bool isTopTen) {
    return marvelAction.entries.map((element) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SubscriptionPage(),
              ));
        },
        child: Container(
          width: isTopTen == true
              ? SizeConfig.screenHeight! * 0.22
              : SizeConfig.screenHeight! * 0.18,
          height: SizeConfig.screenHeight! * 0.25,
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(element.key, fit: BoxFit.fill))),
        ),
      );
    }).toList();
  }
}
