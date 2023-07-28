import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:TychoStream/utilities/Responsive.dart';

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
  bool? isEditPage;
  int? maxLine;
  String? errorText;
  TextCapitalization? textCapitalization;
  FloatingLabelBehavior? floatingLabelBehavior;
  FocusNode? focusNode;
  bool? isSearch;
  bool? autoFocus = false;
  bool? isRead;
  AppTextField(
      {Key? key,
        this.isShowCountryCode,
        required this.controller,
        this.verifySubmit, this.isRead,
        this.labelText,
        this.isVerifyNumber,
        this.secureText,
        this.prefixText,
        this.onSubmitted,
        this.isError,
        this.isEditPage,
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
        this.floatingLabelBehavior, this.focusNode,
        this.isSearch,
        this.autoFocus})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<AppTextField> {
  final _focusNode = FocusNode();
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
        child: FocusScope(
            node: FocusScopeNode(),
            child: TextField(
                readOnly: widget.isRead ?? false,
                autofocus: widget.autoFocus ?? false,
                maxLines: widget.maxLine,
                onChanged: widget.onChanged,
                enabled: widget.isEnable,
                focusNode: _focusNode,
                textCapitalization: widget.textCapitalization == null
                    ? widget.textCapitalization = TextCapitalization.none
                    : widget.textCapitalization!,
                cursorColor: Theme.of(context).primaryColor,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(widget.maxLength),
                ],
                controller: widget.controller,
                style: TextStyle(
                    color: widget.isEnable == false
                        ? Theme.of(context).primaryColor.withOpacity(0.6)
                        : Theme.of(context).canvasColor,
                    fontSize: 18),
                onSubmitted: widget.onSubmitted,
                decoration: new InputDecoration(
                  errorText: widget.errorText,
                  floatingLabelBehavior: widget.floatingLabelBehavior,
                  errorStyle: CustomTextStyle.textFormFieldInterMedium
                      .copyWith(color: RED_COLOR, fontSize: 12),
                  errorMaxLines: 3,
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: RED_COLOR, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: RED_COLOR, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                        color: Theme.of(context).canvasColor.withOpacity(0.4),
                        width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor.withOpacity(0.4),
                        width: 2),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                        color: Theme.of(context).canvasColor.withOpacity(0.2),
                        width: 2),
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
                      height: 25,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _secureText = !_secureText;
                      });
                    },
                  )
                      : widget.isVerifyNumber == true
                      ? TextButton(
                      onPressed: widget.verifySubmit,
                      child: Text('Verify'))
                      : widget.isEditPage == true
                      ? Container(
                    margin: EdgeInsets.all(13.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    height: 10,
                    width: 10,
                    child: Icon(Icons.check, color: Colors.black),
                  )
                      : widget.isSearch == true
                      ? IconButton(
                      onPressed: widget.verifySubmit,
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            color: Theme.of(context).canvasColor.withOpacity(0.5),
                            width: 1,
                            margin: EdgeInsets.only(right: 2),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 18),
                              child: Icon(Icons.search_outlined,
                                  color: Theme.of(context).canvasColor,
                                  size: 25),
                            ),
                          ),
                        ],
                      ))
                      : null,
                  labelText: widget.labelText,
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                  labelStyle: CustomTextStyle.textFormFieldInterMedium.copyWith(
                      color: widget.isColor == true
                          ? Theme.of(context).canvasColor.withOpacity(0.4)
                          : Theme.of(context).canvasColor.withOpacity(0.4),
                      fontSize: 17),
                  prefixText: widget.prefixText,
                  suffixStyle: CustomTextStyle.textFormFieldInterMedium
                      .copyWith(
                      color: Theme.of(context).canvasColor, fontSize: 17),
                  prefixStyle: TextStyle(
                      color: Theme.of(context).canvasColor, fontSize: 20),
                ),
                keyboardType: widget.keyBoardType,
                obscureText: widget.isShowPassword == true
                    ? _secureText
                    : widget.secureText!)),
      ),
    );
  }
}
