import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/no_internet.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

@RoutePage()
class WebHtmlPage extends StatefulWidget {
  String? html;
  String? title;

  WebHtmlPage({Key? key, this.html, this.title}) : super(key: key);

  @override
  State<WebHtmlPage> createState() => _WebHtmlPageState();
}

class _WebHtmlPageState extends State<WebHtmlPage> {
  String? connectivity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBarWithBackBtn(
            onBackPressed: () => Navigator.pop(context, true),
            isBackBtn: false,
            title: widget.title,
            context: context),
        body: connectivity == 'Offline'
            ? NOInternetScreen()
            : SafeArea(child: SingleChildScrollView(
                    child: Html(data: widget.html ?? '', style: {
                "body": Style(color: Theme.of(context).canvasColor)
              }))
        )
    );
  }
}
