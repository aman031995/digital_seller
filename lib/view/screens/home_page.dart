import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/view/widgets/carousel.dart';
import 'package:tycho_streams/view/widgets/video_listpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE_COLOR,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              CommonCarousel(),
              VideoListPage()
            ],
          )
        ),
      )
    );
  }
}
