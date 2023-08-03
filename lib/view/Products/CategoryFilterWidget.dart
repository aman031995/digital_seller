import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/services/global_variable.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:flutter/material.dart';

class CategoryFilterScreen extends StatefulWidget {
  final List<String> items;
  CategoryFilterScreen({Key? key, required this.items}) : super(key: key);

  @override
  State<CategoryFilterScreen> createState() => _CategoryFilterScreenState();
}

class _CategoryFilterScreenState extends State<CategoryFilterScreen> {
  bool value = false;
  bool downUpArrow = true;
  List<String> categoryList = ["Kurta", "Belt", "Cotton Shirts", "Trousers", "Party Wear", "T-Shirts", "Wallet", "Shoes"];
  List<String> categoryCountList = ["102", "45", "200", "100", "25", "156", "45", "312"];
  List<String> colorList = ["Red", "Blue", "Yellow", "Purple", "Green", "Pink"];
  List<String> priceFilterList = ["0 - 499", "500 - 999", "1000 - 1499", "1500 - 1999", "2000 - 2499", "2500 - 2999", "Above"];
  late List<bool> checkedList;

  @override
  void initState() {
    super.initState();
    checkedList = List.filled(categoryList.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: SizeConfig.screenWidth / 6.5,
        height: SizeConfig.screenHeight * 2,
        color: Theme.of(context).cardColor,
        margin: EdgeInsets.only(top: 30, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
          margin: EdgeInsets.all(15),
            color: Theme.of(context).cardColor,
            child: AppBoldFont(context, msg: "Filter", color: Theme.of(context).canvasColor, fontWeight: FontWeight.w600),
          ),

          Container(
            margin: EdgeInsets.only(right: 10),
            height: 1,
            color: Theme.of(context).canvasColor.withOpacity(0.2),
          ),
            SizedBox(height: 10,),
            categoryFilterHeadingWidget('Categories'),
            downUpArrow == true ? Container(height: 1,
              margin: EdgeInsets.only(left: 20, right: 20),
              color: Theme.of(context).canvasColor.withOpacity(0.2),) : SizedBox(),
            downUpArrow == true ? categoryFilterWidget() : SizedBox(),

            SizedBox(height: 15,),
            categoryFilterHeadingWidget('Color'),
            downUpArrow == true ? Container(height: 1,
              margin: EdgeInsets.only(left: 20, right: 20),
              color: Theme.of(context).canvasColor.withOpacity(0.2),) : SizedBox(),
            downUpArrow == true ? colorFilterWidget() : SizedBox(),

            SizedBox(height: 15,),
            categoryFilterHeadingWidget('Price'),
            downUpArrow == true ? Container(height: 1,
              margin: EdgeInsets.only(left: 20, right: 20),
              color: Theme.of(context).canvasColor.withOpacity(0.2),) : SizedBox(),
            downUpArrow == true ? priceFilterWidget() : SizedBox(),

            SizedBox(height: 15,),
            categoryFilterHeadingWidget('Brand'),
            downUpArrow == true ? Container(height: 1,
              margin: EdgeInsets.only(left: 20, right: 20),
              color: Theme.of(context).canvasColor.withOpacity(0.2),) : SizedBox(),
            downUpArrow == true ? colorFilterWidget() : SizedBox(),

            SizedBox(height: 15,),
            categoryFilterHeadingWidget('Others'),
            downUpArrow == true ? Container(height: 1,
              margin: EdgeInsets.only(left: 20, right: 20),
              color: Theme.of(context).canvasColor.withOpacity(0.2),) : SizedBox(),
            downUpArrow == true ? colorFilterWidget() : SizedBox(),

            SizedBox(height: 200,),

            Container(
              alignment: Alignment.bottomCenter,
              // margin: EdgeInsets.only(left: 120, right: 120, bottom: 5),
                width: SizeConfig.screenWidth / 6.5,
                child: GlobalVariable.isLightTheme == true ?
                Image.network("https://eacademyeducation.com:8011/logo/lite_logo.png", fit: BoxFit.fill, width: SizeConfig.screenWidth * 0.08) :
                Image.network("https://eacademyeducation.com:8011/logo/dark_logo.png", fit: BoxFit.fill, width: SizeConfig.screenWidth * 0.08)),
          ],
        ),
      ),
    );
  }


  Widget categoryFilterWidget(){
    return Container(
      height: 35 * categoryList.length as double,
      padding: EdgeInsets.only(top: 10),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10,),
      decoration: BoxDecoration(
       color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Checkbox(
                  checkColor: Theme.of(context).cardColor,
                  activeColor: Theme.of(context).primaryColor,
                  side: BorderSide(
                    color: Theme.of(context).canvasColor
                  ),
                  value: checkedList[index],
                  onChanged: (bool? value) {
                    setState(() {
                      checkedList[index] = value!;
                    });
                  },
                ),
                SizedBox(width: 8,),//Checkbox
                AppRegularFont(context, msg: categoryList[index], color: Theme.of(context).canvasColor),SizedBox(width: 5,),
                AppRegularFont(context, msg: "(${categoryCountList[index]})", color: Theme.of(context).canvasColor)
              ],
            );
          }),
    );
  }

  Widget colorFilterWidget(){
    return Container(
      height: 35 * colorList.length as double,
      padding: EdgeInsets.only(top: 10),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10,),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: colorList.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Checkbox(
                  checkColor: Theme.of(context).cardColor,
                  activeColor: Theme.of(context).primaryColor,
                  side: BorderSide(
                      color: Theme.of(context).canvasColor
                  ),
                  value: checkedList[index],
                  onChanged: (bool? value) {
                    setState(() {
                      checkedList[index] = value!;
                    });
                  },
                ),
                SizedBox(width: 8,),//Checkbox
                AppRegularFont(context, msg: colorList[index], color: Theme.of(context).canvasColor)
              ],
            );
          }),
    );
  }

  Widget priceFilterWidget(){
    return Container(
      height: 35 * priceFilterList.length as double,
      padding: EdgeInsets.only(top: 10),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10,),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: priceFilterList.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Checkbox(
                  hoverColor: Theme.of(context).scaffoldBackgroundColor,
                  checkColor: Theme.of(context).cardColor,
                  activeColor: Theme.of(context).primaryColor,
                  side: BorderSide(
                      color: Theme.of(context).canvasColor
                  ),
                  value: checkedList[index],
                  onChanged: (bool? value) {
                    setState(() {
                      checkedList[index] = value!;
                    });
                  },
                ),
                SizedBox(width: 8,),//Checkbox
                AppRegularFont(context, msg: priceFilterList[index], color: Theme.of(context).canvasColor)
              ],
            );
          }),
    );
  }


  Widget categoryFilterHeadingWidget(String msg){
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(left: 10, right: 10),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Container(
          child: AppMediumFont(context, msg: msg, fontSize: 16, fontWeight: FontWeight.w500),
        ),
         // GestureDetector(onTap: (){
         //   downUpArrow = !downUpArrow;
         // }, child: Container(
         //   color: Theme.of(context).scaffoldBackgroundColor,
         //  child: downUpArrow == true ? Image.asset(AssetsConstants.icUpArrow, height: 15, width: 20, color: Theme.of(context).canvasColor,) : Image.asset(AssetsConstants.icDownArrow, height: 15, width: 20, color: Theme.of(context).canvasColor,) ,
         // ),
         // ),
        ],
      ),
    );
  }
}
