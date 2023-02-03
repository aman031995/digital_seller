import 'package:flutter/material.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/AssetsConstants.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/view/widgets/AppNavigationBar.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> categoryListName = [
    StringConstant.romance,
    StringConstant.drama,
    StringConstant.family,
    StringConstant.kids,
    StringConstant.talkshow,
    StringConstant.adventure,
    StringConstant.sports,
    StringConstant.travel,
  ];

  List<String> categoryIcon = [
    AssetsConstants.icRomance,
    AssetsConstants.icDrama,
    AssetsConstants.icFamily,
    AssetsConstants.icKids,
    AssetsConstants.icTalkShow,
    AssetsConstants.icAdventure,
    AssetsConstants.icSports,
    AssetsConstants.icTravel,
  ];

  List categoryColor = [
    RED_GRADIENT,
    DRAMA_GRADIENT,
    FAMILY_GRADIENT,
    KIDS_GRADIENT,
    TALK_SHOW_GRADIENT,
    ADVENTURE_GRADIENT,
    SPORTS_GRADIENT,
    TRAVEL_GRADIENT,
  ];

  List categoryColorLight = [
    RED_GRADIENT.withOpacity(0.5),
    DRAMA_GRADIENT.withOpacity(0.5),
    FAMILY_GRADIENT.withOpacity(0.5),
    KIDS_GRADIENT.withOpacity(0.5),
    TALK_SHOW_GRADIENT.withOpacity(0.5),
    ADVENTURE_GRADIENT.withOpacity(0.5),
    SPORTS_GRADIENT.withOpacity(0.5),
    TRAVEL_GRADIENT.withOpacity(0.5),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: getAppBarWithBackBtn(StringConstant.category),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: GridView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              controller: ScrollController(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.5),
              itemCount: categoryListName.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: SizeConfig.screenHeight! * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          categoryColor[index],
                          categoryColorLight[index],
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          categoryListName[index],
                          style: TextStyle(
                              color: WHITE_COLOR,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        ClipRRect(
                            child: Image.asset(categoryIcon[index],
                                fit: BoxFit.cover)),
                      ],
                    ),
                  ),
                );
              }),
        )
      ),
    );
  }

}
