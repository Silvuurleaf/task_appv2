import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {


  final Function(bool) callbackFunction;
  const ToggleButton({Key? key, required this.callbackFunction}) : super(key: key);

  @override
  ToggleButtonState createState() => ToggleButtonState();
}

class ToggleButtonState extends State<ToggleButton> {

  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) => Container(
    color: Colors.white,
    child: LayoutBuilder(
      builder: (context, constraints) => ToggleButtons(
        constraints: BoxConstraints.expand(width: (constraints.maxWidth - 20) / 2),
        borderColor: Colors.black,
        selectedBorderColor: Colors.black,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        fillColor: const Color(0xFFAA77FF),
        selectedColor: Colors.black,
        isSelected: isSelected,
        children: const [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('Personal',)
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('Remote',)
          ),
        ],
        onPressed: (int newIndex){
          setState(() {
            for(int idx = 0; idx < isSelected.length; idx++ ){
              if(idx == newIndex){
                isSelected[idx] = true;
              }
              else{
                isSelected[idx] = false;
              }
            }
            //check the first toggle button value
            bool isRemote = isSelected[1];
            print("Sending this value $isRemote to callback function");
            widget.callbackFunction(isSelected[1]);
          });
        },
      ),
    ),
  );
}