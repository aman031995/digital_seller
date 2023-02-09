import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tycho_streams/model/data/HomePageDataModel.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/view/screens/DetailPage.dart';

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
    return Container(
      width: SizeConfig.screenHeight * 0.25,
      height: SizeConfig.screenHeight * 0.25,
      child: InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(
              builder: (context) =>
              new MovieDetailPage(
                platformMovieData: widget.moviesList,
                // movieID: 'mZ5lbn9FWAQ',
                movieID: widget.moviesList?.videoUrl,
              )));
        },
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(widget.image ?? '',
                    fit: BoxFit.fill))),
      ),
    );
  }
}
