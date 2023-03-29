import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tycho_streams/utilities/Responsive.dart';

import 'AppColor.dart';
import 'AssetsConstants.dart';
import 'TextStyling.dart';

bool _secureText = true;
String? countryDialCode;
String? countryCodeValue;

class AppTextField extends StatefulWidget {
  TextEditingController? controller;
  bool? isShowPassword = false;
  bool? isVerifyNumber = false;
  String? labelText;
  bool? isSearch=true;
  bool? secureText;
  bool? isShowCountryCode;
  String? prefixText;
  ValueChanged<String>? onSubmitted;
  bool? isError;
  TextInputType? keyBoardType;
  int? maxLength;
  double? height;
  double? width;
  bool? isEnable;
  bool? isColor;
  ValueChanged<String>? onChanged;
  void Function()? verifySubmit;
  bool? isTick;
  int? maxLine;
  String? errorText;
  TextCapitalization? textCapitalization;
  FloatingLabelBehavior? floatingLabelBehavior;

  AppTextField(
      {Key? key,
        this.isShowCountryCode,
        required this.controller,
        this.verifySubmit,
        this.labelText,
        this.isVerifyNumber,
        this.secureText,
        this.prefixText,
        this.onSubmitted,
        this.isError,
        this.isSearch,
        this.keyBoardType,
        this.maxLength,
        this.isShowPassword,
        this.height,
        this.width,
        this.isEnable,
        this.isColor,
        this.onChanged,
        this.maxLine,
        required this.isTick,
        this.errorText,
        this.textCapitalization,
        this.floatingLabelBehavior})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      height: widget.height,
      child: Theme(
        data: new ThemeData(
          primaryColor: Theme.of(context).primaryColor,
          disabledColor: Theme.of(context).primaryColor,
          primaryColorDark: Theme.of(context).primaryColor,
        ),
        child:  FocusScope(
          node: FocusScopeNode(),
          child: TextField(
              maxLines: widget.maxLine,
              onChanged: widget.onChanged,
              enabled: widget.isEnable,
              textCapitalization: widget.textCapitalization == null
                  ? widget.textCapitalization = TextCapitalization.none
                  : widget.textCapitalization!,
              cursorColor: Theme.of(context).primaryColor,
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.maxLength),
              ],
              controller: widget.controller,
              style: TextStyle(
                  color: widget.isEnable == false ?Theme.of(context).primaryColor.withOpacity(0.6) : Theme.of(context).canvasColor,
                  fontSize: ResponsiveWidget.isMediumScreen(context)?16:18),
              onSubmitted: widget.onSubmitted,
              decoration:widget.isSearch==false?

              InputDecoration(
                  errorText: widget.errorText,
                  floatingLabelBehavior: widget.floatingLabelBehavior,
                  errorStyle: CustomTextStyle.textFormFieldInterMedium
                      .copyWith(color: RED_COLOR, fontSize: 12),
                  errorMaxLines: 3,
                  isDense: true,
                  labelText: widget.labelText,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                  labelStyle: CustomTextStyle.textFormFieldInterMedium.copyWith(
                      color: widget.isColor == true ? Theme.of(context).canvasColor.withOpacity(0.4) : Theme.of(context).canvasColor.withOpacity(0.4), fontSize: 17),
                  prefixText: widget.prefixText,
                  suffixStyle: CustomTextStyle.textFormFieldInterMedium.copyWith(color: TEXT_COLOR, fontSize: 17),
                  prefixStyle: TextStyle(color: TEXT_COLOR, fontSize: 20),
                border: InputBorder.none
              ):

              InputDecoration(
                errorText: widget.errorText,
                floatingLabelBehavior: widget.floatingLabelBehavior,
                errorStyle: CustomTextStyle.textFormFieldInterMedium
                    .copyWith(color: RED_COLOR, fontSize: 12),
                errorMaxLines: 3,
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: RED_COLOR, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: RED_COLOR, width: 2),
                ),
                enabledBorder:

                OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Theme.of(context).canvasColor.withOpacity(0.4), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: TEXTFIELD_BORDER_COLOR, width: 2),
                ),
                isDense: true,
                //  <- you can it to 0.0 for no space
                suffixIcon: widget.isShowPassword == true
                    ? IconButton(
                  icon: Image.asset(
                      _secureText == true
                          ? AssetsConstants.icEyeFill
                          : AssetsConstants.ic_passwordHide,
                      width: 25,
                      height: 25, color: Theme.of(context).primaryColor,),
                  onPressed: () {
                    setState(() {
                      _secureText = !_secureText;
                    });
                  },
                )
                    : widget.isVerifyNumber == true
                    ? TextButton(
                    onPressed: widget.verifySubmit, child: Text('Verify'))
                    : null,
                labelText: widget.labelText,
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                labelStyle: CustomTextStyle.textFormFieldInterMedium.copyWith(
                    color: widget.isColor == true ? Theme.of(context).canvasColor.withOpacity(0.4) : Theme.of(context).canvasColor.withOpacity(0.4), fontSize: 17),
                prefixText: widget.prefixText,
                suffixStyle: CustomTextStyle.textFormFieldInterMedium.copyWith(color: TEXT_COLOR, fontSize: 17),
                prefixStyle: TextStyle(color: TEXT_COLOR, fontSize: 20),
              ),
              keyboardType: widget.keyBoardType,
              obscureText: widget.isShowPassword == true
                  ? _secureText
                  : widget.secureText!),
        ),
      ),
    );
  }
}
