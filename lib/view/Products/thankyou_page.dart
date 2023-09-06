import 'package:TychoStream/Utilities/AssetsConstants.dart';
import 'package:TychoStream/utilities/AppColor.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/StringConstants.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:TychoStream/viewmodel/cart_view_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    thankYouModel.thankYouPageImageTimer(context);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ChangeNotifierProvider.value(
          value: thankYouModel,
          child: Consumer<CartViewModel>(builder: (context, thankyoumodel, _) {
            return Center(
              child: Container(
                height:ResponsiveWidget.isMediumScreen(context) ?SizeConfig.screenWidth/1.3 :SizeConfig.screenWidth/3.8,
                width: ResponsiveWidget.isMediumScreen(context) ?SizeConfig.screenWidth/1.1 :SizeConfig.screenWidth/3,
                color: Theme.of(context).cardColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                     Center(child: Image.asset(AssetsConstants.ic_shoppingSuccess,height:ResponsiveWidget.isMediumScreen(context) ?SizeConfig.screenWidth/3 :SizeConfig.screenWidth/8,width:ResponsiveWidget.isMediumScreen(context) ?SizeConfig.screenWidth/2 :  SizeConfig.screenWidth/6,fit: BoxFit.fill,)),
                    SizedBox(height: 20),
                     Center(child: _textLiquidFillAnimation()),
                    SizedBox(height: 20),

                  ],
                ),
              ),
            );
          })),
    );
  }

  Widget _textLiquidFillAnimation(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        AppBoldFont(context, msg: StringConstant.ThankYOU,color: GREEN,fontSize: ResponsiveWidget.isMediumScreen(context) ?20: 40),
        SizedBox(height: 10),
        AppBoldFont(context, msg: StringConstant.orderPlacedSuccess,color:Theme.of(context).canvasColor,fontSize: ResponsiveWidget.isMediumScreen(context) ?15: 22),
        SizedBox(height:  SizeConfig.screenWidth*0.02),
        Container(
            height:ResponsiveWidget.isMediumScreen(context)
                ?40: 50,
            decoration:BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(4)
            ) ,
            width:  ResponsiveWidget.isMediumScreen(context)
                ?150:SizeConfig.screenWidth/7.6,
            child: InkWell(
              onTap: () {
                context.pushRoute(HomePageWeb());
              },
              child: Center(
                  child: AppMediumFont(context,
                      msg: StringConstant.continueShopping,
                      fontSize: 16.0,fontWeight: FontWeight.w500,
                      color:Theme.of(context).hintColor)),
            )),
      ],
    );
  }

}
