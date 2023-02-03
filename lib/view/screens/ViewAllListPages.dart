import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/model/data/data_sample.dart';
import 'package:tycho_streams/repository/subscription_provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/view/screens/subscription_page.dart';
import 'package:tycho_streams/view/widgets/AppNavigationBar.dart';

class ViewAllListPages extends StatefulWidget {
  List<String>? moviesList;
  ViewAllListPages({Key? key, this.moviesList}) : super(key: key);

  @override
  State<ViewAllListPages> createState() => _ViewAllListPagesState();
}

class _ViewAllListPagesState extends State<ViewAllListPages> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final subscriptionVM = Provider.of<SubscriptionProvider>(context);
    return Scaffold(
      appBar: getAppBarWithBackBtn(StringConstant.trending),
      body: SingleChildScrollView(
        child: contentWidget(
            title: ' Trending',
            videoList: GridView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                controller: ScrollController(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 3.0,
                    mainAxisSpacing: 1.0,
                    childAspectRatio: 0.65),
                itemCount: 50,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubscriptionPage(),
                          ));
                    },
                    child: Container(
                      height: SizeConfig.screenHeight! * 0.5,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                  "https://static-koimoi.akamaized.net/wp-content/new-galleries/2022/04/bholaa-001.jpg",
                                  fit: BoxFit.fill))),
                    ),
                  );
                })),
      ),
    );
  }

  contentWidget({String? title, Widget? videoList}) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.only(left: 10, top: 5,right: 10),
            height: SizeConfig.screenHeight! * 0.85,
            child: videoList),
      ],
    );
  }

  // myList(SubscriptionProvider subscriptionVM, bool isTopTen) {
  //   return marvelAction.entries.map((element) {}).toList();
  // }
}
