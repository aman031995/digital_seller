import 'package:flutter/material.dart';
import 'package:tycho_streams/Utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/view/widgets/carousel.dart';
import 'package:tycho_streams/view/widgets/video_listpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: homePageTopBar(),
        backgroundColor: WHITE_COLOR,
        body: SingleChildScrollView(
          child: SafeArea(
              child: Column(
            children: [ CommonCarousel(), VideoListPage()],
          )),
        ));
  }

   homePageTopBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: WHITE_COLOR,
      title: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
            child: Row(
              children: [
                Image.asset(AssetsConstants.icLogo, height: 50, width: 50),
                SizedBox(width: 3.0,),
                Container(
                  height: 50,
                  width: SizeConfig.screenWidth * 0.64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent, width: 2.0),
                  ),
                  child: new TextField(
                    maxLines: editingController!.text.length > 2 ? 2 : 1,
                    controller: editingController,
                    decoration: new InputDecoration(
                        hintText: StringConstant.search,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: GREY_COLOR)),
                    onChanged: (m) {},
                  ),
                ),
                SizedBox(width: 3.0,),
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: LIGHT_THEME_COLOR,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.asset(
                      AssetsConstants.icNotification,
                      height: 45,
                      width: 45,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
