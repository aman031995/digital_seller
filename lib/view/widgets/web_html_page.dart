import 'package:TychoStream/utilities/three_arched_circle.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:TychoStream/viewmodel/HomeViewModel.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';


@RoutePage()
class WebHtmlPage extends StatefulWidget {

  final String? html;
  final String? title;
  WebHtmlPage({
    @PathParam('title') this.title,
    @QueryParam() this.html,
    Key? key}) : super(key: key);

  @override
  State<WebHtmlPage> createState() => _WebHtmlPageState();
}

class _WebHtmlPageState extends State<WebHtmlPage> {
  String? connectivity;
HomeViewModel homeViewModel=HomeViewModel();
  @override
  void initState() {
    homeViewModel.openWebHtmlView(context, widget.html ?? "",
        title: widget.title );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return


      Scaffold(
        appBar: getAppBarWithBackBtn(
            onBackPressed: () => Navigator.pop(context, true),
            isBackBtn: false,
            title: widget.title,
            context: context),
        body:

            ChangeNotifierProvider.value(
    value: homeViewModel,
    child: Consumer<HomeViewModel>(builder: (context, viewmodel, _) {
      return connectivity == 'Offline'
            ? NOInternetScreen()
            : viewmodel.html==''? Center(child: ThreeArchedCircle(size: 45.0))    :


      SafeArea(child: SingleChildScrollView(
                    child: Html(data:viewmodel.html ?? '', style: {
                "body": Style(color: Theme.of(context).canvasColor)
              }))
        );}))
    );
  }
}
