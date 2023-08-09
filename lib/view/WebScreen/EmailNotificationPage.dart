import 'package:TychoStream/bloc_validation/Bloc_Validation.dart';
import 'package:TychoStream/utilities/AppTextButton.dart';
import 'package:TychoStream/utilities/AppTextField.dart';
import 'package:TychoStream/utilities/Responsive.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:easy_stepper/easy_stepper.dart';



  TextEditingController? emailController = TextEditingController();
   final validation = ValidationBloc();


  Widget emailNotificationUpdatePage(BuildContext context) {
    return Container(
      height: ResponsiveWidget.isMediumScreen(context) ?220: SizeConfig.screenWidth * 0.2,
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.only(left: ResponsiveWidget.isMediumScreen(context) ?8:0,right: ResponsiveWidget.isMediumScreen(context) ?8:0),
      color: Theme.of(context).primaryColor.withOpacity(0.4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppMediumFont(context, msg: "SIGN UP AND SAVE UP TO 20%", fontSize:  ResponsiveWidget.isMediumScreen(context) ?20:32, fontWeight: FontWeight.w600, color: Theme.of(context).canvasColor),
          SizedBox(height:  ResponsiveWidget.isMediumScreen(context) ?10:30,),
          AppRegularFont(context, msg: 'Be updated on new arrivals, trends and offers. Sign up now! ', fontSize: ResponsiveWidget.isMediumScreen(context) ?16: 28, fontWeight: FontWeight.w500, color: Theme.of(context).canvasColor),
          SizedBox(height: ResponsiveWidget.isMediumScreen(context) ?10: 30,),
          ResponsiveWidget.isMediumScreen(context) ? getLatestUpdateRowTextFieldMobile(context):getLatestUpdateRowTextField(context),
        ],
      ),
    );
  }

  Widget getLatestUpdateRowTextField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        inputNormalTextField(emailController, TextInputType.emailAddress, 'Enter your email', null),
        SizedBox(width: 40,),
       ElevatedButton(onPressed: (){},
           style: ElevatedButton.styleFrom(
             primary: Theme.of(context).canvasColor,
           ),
           child:
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
          height: 50,
          width: SizeConfig.screenWidth * 0.1,
          child: AppRegularFont(context, msg: 'SUBSCRIBE', color: Theme.of(context).cardColor, fontSize: 20,),
        ))
      ],
    );
  }
Widget getLatestUpdateRowTextFieldMobile(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      inputNormalTextField(emailController, TextInputType.emailAddress, 'Enter your email', null),
      SizedBox(height: 5),
      ElevatedButton(onPressed: (){},
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).canvasColor,
          ),
          child:
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
            ),
            height: ResponsiveWidget.isMediumScreen(context) ?40:50,
             width:ResponsiveWidget.isMediumScreen(context) ?200:SizeConfig.screenWidth * 0.1,
            child: AppRegularFont(context, msg: 'SUBSCRIBE', color: Theme.of(context).cardColor, fontSize: 20,),
          ))
    ],
  );
}


Widget inputNormalTextField(var ctrl,var keyType, String msg, var sinkValue,) {
  return
    Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: StreamBuilder(
          builder: (context, snapshot) {
            return Container(
              height:ResponsiveWidget.isMediumScreen(context) ?40: 50,
              width:ResponsiveWidget.isMediumScreen(context) ?250: SizeConfig.screenWidth * 0.2,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(0)),
              ),
              child: TextField(
                  cursorColor:  Theme.of(context).canvasColor,
                  controller: ctrl,
                  obscureText: false,
                  keyboardType: keyType,
                  maxLength: 50,
                  style: TextStyle(color:Theme.of(context).canvasColor),
                  decoration: InputDecoration(
                    hintText: msg,
                    counterText: "",
                    hintStyle: TextStyle(color: Theme.of(context).canvasColor.withOpacity(0.4)),
                    // labelText: msg,
                    // labelStyle: TextStyle(color: Colors.grey),
                    // labelStyle: TextStyle(color: AppColors.buttonColor ),

                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3,color:Theme.of(context).canvasColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:  BorderSide(width: 3, color: Theme.of(context).canvasColor),
                    ),
                    errorText: snapshot.hasError
                        ? snapshot.error.toString()
                        : null,
                  ),
                  onChanged: (m) {
                    sinkValue.add(m);
                  },
                  onSubmitted: (value) {
                    sinkValue.add(value);
                  }),
            );
          }),
    );
}