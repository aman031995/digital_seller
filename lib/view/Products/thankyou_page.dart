import 'dart:async';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/route_service/routes_name.dart';
import 'package:TychoStream/view/widgets/AppNavigationBar.dart';
import 'package:TychoStream/view/widgets/common_methods.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../AppRouter.gr.dart';


@RoutePage()
class ThankYouPage extends StatefulWidget {
  const ThankYouPage({Key? key}) : super(key: key);

  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
  CartViewModel thankYouModel = CartViewModel();
  int activeStep = 3;

  @override
  void initState() {
    thankYouModel.thankYouPageImageTimer(context);
    // context.router.stack.clear();
    super.initState();
    // Timer.periodic(Duration(seconds: 5), (_) {
    //   context.router.popUntilRoot();
    // } );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: getAppBarWithBackBtn(
          title: '',
          context: context,
          isBackBtn: false,
          onBackPressed: () {
            // Navigator.pushNamedAndRemoveUntil(
            //     context, RoutesName.productPage, (route) => false);
          }),
      body: ChangeNotifierProvider.value(
          value: thankYouModel,
          child: Consumer<CartViewModel>(builder: (context, thankyoumodel, _) {
            return WillPopScope(
                onWillPop: _willPopCallback,
                child: Column(
                  children: <Widget>[
                    cartPageViewIndicator(context, 2, activeStep),
                    SizedBox(height:thankyoumodel.isThankyouPage == false
                        ? 0: SizeConfig.screenHeight * 0.2,),
                    thankyoumodel.isThankyouPage == false
                        ? Image.asset('images/ic_celebration.gif')
                        : SizedBox(),
                    SizedBox(height: 50),
                    thankyoumodel.isThankyouPage == false
                        ? SizedBox()
                        : _textLiquidFillAnimation()
                  ],
                ));
          })),
    );
  }

  Widget _textLiquidFillAnimation(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedTextKit(
          isRepeatingAnimation: false,
          // repeatForever: true,
          animatedTexts: [
            TypewriterAnimatedText( 'Thank You For Shopping \n Your order Has Been Placed.',cursor: "",
                curve: Curves.easeIn,speed: Duration(milliseconds: 40),textStyle: TextStyle(color: Theme.of(context).canvasColor,fontSize: 25),textAlign: TextAlign.center)
          ],
        ),
        SizedBox(height: 30),
        Center(
          child: TextButton(onPressed: () { context.pushRoute(ProductListGallery()); }, child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey,width: 3)
            ),
            child: Text("Continue Shopping",style: TextStyle(color: Theme.of(context).primaryColor),),
          ),

          )
          // Container(
          //
          //
          //     child: Text("Continue Shopping"))

          // TextLiquidFill(
          //   boxHeight: 200,boxWidth: SizeConfig.screenWidth,
          //   text: 'Continue Shopping',
          //   textAlign: TextAlign.center,
          //   boxBackgroundColor: Theme.of(context).cardColor,
          //   textStyle: TextStyle(
          //     fontSize: 80.0,
          //     color: Colors.yellow,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ),
      ],
    );
  }

  // MobileBackbutton method
  Future<bool> _willPopCallback() async {
    GoRouter.of(context).pushNamed(RoutesName.productList);
   // AppNavigator.pushNamedAndRemoveUntil(context, RoutesName.bottomNavigation,screenName: RouteBuilder.homePage);
    return Future.value(true);
  }
}
