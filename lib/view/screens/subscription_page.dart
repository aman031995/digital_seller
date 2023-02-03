import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:tycho_streams/repository/subscription_provider.dart';
import 'package:tycho_streams/utilities/SizeConfig.dart';
import 'package:tycho_streams/utilities/AppIndicator.dart';
import 'package:process_run/shell.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  late SubscriptionProvider provider = SubscriptionProvider();
  ScrollController? _controller;
  var shell = Shell();

  @override
  void initState() {
    final purchaseProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    purchaseProvider.initInApp(context);
    super.initState();
  }

  @override
  void dispose() {
    provider.subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SubscriptionProvider purchaseProvider = context.watch<SubscriptionProvider>();
    provider = purchaseProvider;
    purchaseProvider.products.forEach((element) {
      element.price;
      SubscriptionProvider.kProductIds.add(element.id);
    });

    List<Widget> stack = [];
    if (purchaseProvider.queryProductError == null) {
      stack.add(_buildProductList(purchaseProvider));
    } else {
      stack.add(Center(
        child: Text(purchaseProvider.queryProductError!),
      ));
    }

    if (purchaseProvider.purchasePending) {
      stack.add(Stack(
        children: const [
          Opacity(
            opacity: 0.3,
            child: ModalBarrier(dismissible: false, color: Colors.pink),
          ),
          Center(child: CircularProgressIndicator()),
        ],
      ));
    }
    return Scaffold(
      backgroundColor: const Color(0xff0D141D),
      body: SafeArea(
        child: Stack(
          children: stack,
        ),
      ),
    );
  }

  _buildProductList(SubscriptionProvider purchaseProvider) {
    if (purchaseProvider.loading) {
      return Center(
          child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: 200),
              child: CircularProgressIndicator(
                  backgroundColor: Colors.amber,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue))),
          SizedBox(height: 20),
          Text('Fetching Plan')
        ],
      ));
    }

    if (!purchaseProvider.isAvailable) {
      return Card();
    }

    List<Widget> productList = [];

    productList.addAll(purchaseProvider.products.map(
      (ProductDetails productDetails) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 5),
              alignment: Alignment.topLeft,
              child: const Text(
                'Our available plans',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              elevation: 10,
              child: Container(
                padding: EdgeInsets.only(top: 16),
                margin: EdgeInsets.only(left: 10, right: 10),
                height: 190,
                width: SizeConfig.screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: const Text(
                          'Please Subscribe us for more\n entertainment',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black)),
                    ),
                    const Divider(
                      height: 15,
                      thickness: 1,
                      indent: 45,
                      endIndent: 45,
                      color: Colors.blue,
                    ),
                    Text(
                      productDetails.price,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: SizeConfig.screenWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          shadowColor: Colors.greenAccent,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: Size(200, 40), //////// HERE
                        ),
                        onPressed: () {
                          // shell = shell.cd('C:\Users\tycho\tycho_streams');
                          shell.run('echo hello');
                          // AppIndicator.loadingIndicator();
                          // PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails, applicationUserName: null);
                          // purchaseProvider.inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
                        },
                        child: Text('Get this plan'),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ));

    if (purchaseProvider.notFoundIds.isNotEmpty) {
      productList.add(Container(
        child: Text('[${purchaseProvider.notFoundIds.join(", ")}] not found',
            style: TextStyle(color: ThemeData.light().errorColor)),
      ));
    }

    return Container(
        padding: EdgeInsets.all(17),
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: ListView(controller: _controller, children: productList));
  }
}
