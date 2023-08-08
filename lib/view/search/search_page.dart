import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/view/search/search_list.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController? searchController = TextEditingController();
  HomeViewModel homeViewModel = HomeViewModel();
  ScrollController scrollController = ScrollController();
  int pageNum = 1;

  @override
  void dispose() {
    searchController?.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(55.0), // here the desired height
            child:searchTextField(),
            ),
        body: ChangeNotifierProvider.value(
            value: homeViewModel,
            child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
              return viewmodel.searchDataModel != null
                  ? searchListMobile(context, viewmodel, scrollController,
                      homeViewModel, searchController!)
                  : SizedBox();
            })));
  }

// widget of search list
  Widget searchListMobile(
      BuildContext context,
      HomeViewModel viewmodel,
      ScrollController _scrollController,
      HomeViewModel homeViewModel,
      TextEditingController searchController) {
    return  viewmodel.searchDataModel!.productList==null?
    Container(): Stack(children: [
      viewmodel.searchDataModel!.productList!.isNotEmpty
          ? ListView.builder(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            final item = viewmodel.searchDataModel?.productList?[index];
            _scrollController.addListener(() {
              if (_scrollController.position.pixels ==
                  _scrollController.position.maxScrollExtent) {
                onPagination(
                    context,
                    viewmodel.lastPage,
                    viewmodel.nextPage,
                    viewmodel.isLoading,
                    searchController.text ?? '',
                    viewmodel);
              }
            });
            return GestureDetector(
                onTap: () async {
                },
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).cardColor
                    ),

                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                              height: 180,
                              width: SizeConfig.screenWidth,
                              child: CachedNetworkImage(
                                  imageUrl: item?.productDetails?.productImages?[0]  ?? '', fit: BoxFit.fill,
                                  imageBuilder: (context, imageProvider) => Container(
                                    margin: EdgeInsets.only(bottom: 2),height: 180,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      image: DecorationImage(
                                          image: imageProvider, fit: BoxFit.fill),
                                    ),
                                  ),
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator(color: Colors.grey)))),

                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 6),
                            width: SizeConfig.screenWidth/1.2,
                            child: AppMediumFont(context, msg: item?.productName ?? '', maxLines: 1),
                          ),
                          SizedBox(height: 8)
                        ])));
          },
          itemCount: viewmodel.searchDataModel?.productList?.length)
          : Center(child: dataNotAvailable(viewmodel, context)),
      homeViewModel.isLoading == true
          ? Container(
          margin: EdgeInsets.only(bottom: 10),
          alignment: Alignment.bottomCenter,
          child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor))
          : SizedBox()
    ]);
  }
  // textfield for search
  searchTextField() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      Container(
          height: 50,
          width: 300,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: TRANSPARENT_COLOR, width: 2.0),
          ),
          child: AppTextField(
              controller: searchController,
              maxLine: searchController!.text.length > 2 ? 2 : 1,
              textCapitalization: TextCapitalization.words,
              secureText: false,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              maxLength: null,
              labelText: StringConstant.searchItems,
              keyBoardType: TextInputType.text,
              isSearch: true,
              autoFocus: true,
              onSubmitted: (v) {
                AppIndicator.loadingIndicator(context);
                homeViewModel.getSearchData(context, searchController?.text ?? '', pageNum);
              },
              verifySubmit: (){
                AppIndicator.loadingIndicator(context);
                homeViewModel.getSearchData(context, searchController?.text ?? '', pageNum);
              },
              isTick: null)),
    ]);
  }
}
