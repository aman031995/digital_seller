import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:flutter/material.dart';


class ColorDropDown extends StatefulWidget {
  String? hintText;
  List<ColorDetails> colorList = [];
  final ValueChanged<dynamic?>? onChanged;
  String? chosenValue;


  ColorDropDown(
      {Key? key,
        this.hintText,
        required this.colorList,
        this.onChanged,
        this.chosenValue})
      : super(key: key);

  @override
  _ColorDropDownState createState() => _ColorDropDownState();
}

class _ColorDropDownState extends State<ColorDropDown> {
  String getColorCode ='';
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        width: SizeConfig.screenWidth * 0.4,
        margin: EdgeInsets.only(left: 20, top: 10),
        decoration: BoxDecoration(
          color: const Color(0xfff2f0f0),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: DropdownButton<dynamic>(
          value: widget.chosenValue,
          elevation: 18,
          underline: const SizedBox(),
          isExpanded: true,
          alignment: Alignment.bottomLeft,
          borderRadius: BorderRadius.circular(10.0),
          dropdownColor: Colors.white,
          onChanged: widget.onChanged,
          items: widget.colorList
              .map(
                (dynamic e) => DropdownMenuItem<String>(
                value: e.colorName,
                child: Container(
                    decoration: BoxDecoration(
                        color: Color(int.parse("0xff${getColorfromHashcode(e.colorCode)}")),
                        border: Border.all(color: Colors.black, width: 1)),
                    height: 20,
                    width: 30)),
          )
              .toList(),
          hint: Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Text(widget.hintText ?? '',
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ),
        ),
      ),
    );
  }
  getColorfromHashcode(String colorCode){
    if(colorCode.contains('#')){
      getColorCode = colorCode.replaceAll('#', '');
      return getColorCode;
    }
    else
      return colorCode;
  }
}
