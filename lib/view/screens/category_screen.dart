import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/utilities/AppColor.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/StringConstants.dart';
import 'package:tycho_streams/utilities/three_arched_circle.dart';
import 'package:tycho_streams/view/WebScreen/ViewAllListPages.dart';
import 'package:tycho_streams/view/widgets/AppNavigationBar.dart';
import 'package:tycho_streams/view/widgets/profile_bottom_view.dart';
import 'package:tycho_streams/viewmodel/CategoryViewModel.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryViewModel categoryView = CategoryViewModel();

  @override
  void initState() {
    // TODO: implement initState
    categoryView.getCategoryListData(context, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider<CategoryViewModel>(
        create: (BuildContext context) => categoryView,
        child: Consumer<CategoryViewModel>(builder: (context, categoryView, _) {
          return Scaffold(
            appBar: getAppBarWithBackBtn(
                title: StringConstant.category, context: context),
            body: categoryView.categoryDataModel != null
                ? SingleChildScrollView(
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
                        itemCount: categoryView
                            .categoryDataModel!.categoryList!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SeeAllListPages(
                                      moviesList: [],
                                      title: categoryView
                                              .categoryDataModel!
                                              .categoryList![index]
                                              .categoryName ??
                                          "",
                                      categoryWiseId: categoryView
                                              .categoryDataModel!
                                              .categoryList![index]
                                              .categoryId ??
                                          "",
                                      isCategory: true,
                                    ),
                                  ));
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              height: SizeConfig.screenHeight * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color(int.parse(categoryView
                                        .categoryDataModel!
                                        .categoryList![index]
                                        .categoryColor!)),
                                    categoryColorLight[index],
                                  ],
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    categoryView
                                            .categoryDataModel!
                                            .categoryList![index]
                                            .categoryName ??
                                        "",
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
                  ))
                : Container(
                    height: SizeConfig.screenHeight * 0.8,
                    child: Center(
                      child: ThreeArchedCircle(color: THEME_COLOR, size: 45.0),
                    ),
                  ),
          );
        }));
  }
}
