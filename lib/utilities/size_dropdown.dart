import 'package:TychoStream/model/data/product_list_model.dart';
import 'package:TychoStream/utilities/SizeConfig.dart';
import 'package:TychoStream/utilities/TextHelper.dart';
import 'package:flutter/material.dart';

class SizeDropDown extends StatefulWidget {
  String? hintText;
  List<SkuData> sizeList;
  final ValueChanged<dynamic>? onChanged;
  String? chosenValue;

  SizeDropDown(
      {Key? key,
        this.hintText,
        required this.sizeList,
        this.onChanged,
        this.chosenValue})
      : super(key: key);

  @override
  _SizeDropDownState createState() => _SizeDropDownState();
}

class _SizeDropDownState extends State<SizeDropDown> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: SizeConfig.screenWidth * 0.4,
        margin: EdgeInsets.only(left: 20,top: 10),
        decoration: BoxDecoration(
          color: const Color(0xfff2f0f0),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          child: DropdownButton<dynamic>(
            value: widget.chosenValue,
            elevation: 18,
            underline: const SizedBox(),
            isExpanded: true,
            alignment: Alignment.bottomLeft,
            borderRadius: BorderRadius.circular(10.0),
            dropdownColor: Colors.white,
            onChanged: widget.onChanged,
            // items: widget.sizeList.map((e){
            //
            //   if(e.name == w){
            //
            //   }
            //
            //   return DropdownMenuItem<String>(
            //       child: Container(height: 20,width: 30,
            //         child: AppBoldFont(context, msg:e.name, fontSize: 16, color: Colors.black),
            //   ));
            // }).toList(growable: true),
            items: widget.sizeList.map((e) => DropdownMenuItem<String>(
              value: e.name,
              child: Container(height: 20,width: 30,
                child: AppBoldFont(context, msg:e.name, fontSize: 16, color: Colors.black),
              ),
            ),
            ).toList(),
            hint: Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Text(widget.hintText ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            ),
          ),
        ),
      ),
    );
  }
}
