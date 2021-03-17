import 'dart:typed_data';

import 'package:drawonme/brush_size_dialog.dart';
import 'package:drawonme/draw_point.dart';
import 'package:drawonme/sketch_canvas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';



class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<DrawPoint> _drawPoints =[];
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  double _brushSize = 5;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }
void _showColorPicker() {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: changeColor,
          showLabel: true,
          pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('Done'),
          onPressed: () {
            setState(() => currentColor = pickerColor);
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
void _showBrushSizeDialog() async {
    double selectedSize = await showDialog(context: context,
        builder: (_) => BrushSizeDialog(
      initialSize: _brushSize,
        ),
    );
    if(selectedSize != null) {
      _brushSize = selectedSize;
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(

            onPanStart: (event) {
              setState(() {
                _drawPoints.add(DrawPoint(
                  position: event.localPosition,
                  paint: Paint()
                    ..color = currentColor
                    ..strokeWidth = _brushSize
                    ..strokeCap = StrokeCap.round,
                )
                );
              });
            },
            onPanUpdate: (event) {
              setState(() {
              _drawPoints.add(DrawPoint(
                position: event.localPosition,
                paint: Paint()
                  ..color = currentColor
                  ..strokeWidth = _brushSize
                  ..strokeCap = StrokeCap.round,
              )
              );
              });
            },
            onPanEnd: (event) {
              _drawPoints.add(null);
            },

              child: Container(
                child: CustomPaint (
                  painter: SketchCanvas(
                    drawPoints: _drawPoints,
                  ),
                    child: Container(),
                    ),
                ),
            ),

          Positioned(
            bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                 margin: EdgeInsets.all(15.0),
                  padding: EdgeInsets.symmetric(
                   horizontal: 15.0,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(50.0),
            ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  GestureDetector(
                  onTap: () {
                    _showColorPicker();
                  },
                    child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: currentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                FlatButton(
                  child: Text("Brush Size"),
                  onPressed: () {
                    _showBrushSizeDialog();
                  },
                ),

                FlatButton(
                  child: Text("Clear"),
                  onPressed: () {
                    _drawPoints.clear();
                  },
                ),
              ],
            ),
          ))
    ],
    ),
    );
  }
}