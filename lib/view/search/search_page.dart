import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/AppIndicator.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/view/search/search_list.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../AppRouter.gr.dart';

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
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(55.0), // here the desired height
            child: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Theme.of(context).cardColor,
              title: searchTextField(),
              leadingWidth: 20,
            )),
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
    return Stack(children: [
      viewmodel.searchDataModel!.searchList!.isNotEmpty
          ? ListView.builder(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            final item = viewmodel.searchDataModel?.searchList?[index];
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
                  context.router.push(
                      DetailPage(
                          VideoDetails:["${ viewmodel.searchDataModel?.searchList?[index].youtubeVideoId}","${viewmodel.searchDataModel?.searchList?[index].videoId}","${viewmodel.searchDataModel?.searchList?[index].videoTitle}","${viewmodel.searchDataModel?.searchList?[index].videoDescription}"]
                      )

                  );
                },
                child: listContent(item, context));
          },
          itemCount: viewmodel.searchDataModel?.searchList?.length)
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
    return Row(children: [
      Expanded(
        child: Container(
            height: 50,
            width: SizeConfig.screenWidth,
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
      ),
    ]);
  }
}
