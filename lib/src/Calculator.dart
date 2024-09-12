import 'dart:ui';

import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

enum Op { ADD, SUB, DIV, MULT, PERCENT, NONE }

class _CalculatorState extends State<Calculator> {
  String frontBuffer = "0";
  String backBuffer = "";
  Op op = Op.NONE;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(32),
    child: Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flex(
            direction: Axis.vertical,
            verticalDirection: VerticalDirection.up,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                frontBuffer,
                style: TextStyle(fontSize: 32),
                textWidthBasis: TextWidthBasis.parent,
              ),
              Text(
                backBuffer,
                style: TextStyle(fontSize: 16),
              ),
            ]),
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            makeButton(
              Text("C"),
              () {
                setState(() {
                  frontBuffer = "0";
                  backBuffer = "";
                  op = Op.NONE;
                });
              },
            ),
            makeButton(
              Text("-/+"),
              () {
                negateFrontBuffer();
              },
            ),
            makeButton(
              Text("%"),
              () {
                op = Op.PERCENT;
                swapBuffers();
              },
            ),
            makeButton(
              Text("÷"),
              () {
                op = Op.DIV;
                swapBuffers();
              },
            ),
          ],
        ),
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            makeNumberButton("7"),
            makeNumberButton("8"),
            makeNumberButton("9"),
            makeButton(
              Text("×"),
              () {
                op = Op.MULT;
                swapBuffers();
              },
            ),
          ],
        ),
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            makeNumberButton("4"),
            makeNumberButton("5"),
            makeNumberButton("6"),
            makeButton(
              Text("-"),
              () {
                op = Op.SUB;
                swapBuffers();
              },
            ),
          ],
        ),
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            makeNumberButton("1"),
            makeNumberButton("2"),
            makeNumberButton("3"),
            makeButton(
              Text("+"),
              () {
                op = Op.ADD;
                swapBuffers();
              },
            ),
          ],
        ),
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            makeButton(
              Icon(Icons.backspace),
              () => setState(() {
                frontBuffer = "";
              }),
            ),
            makeNumberButton("0"),
            makeNumberButton("."),
            makeButton(
              Text("="),
              () {
                doCalc();
              },
            ),
          ],
        ),
      ],
    ),);
  }

  TextButton makeNumberButton(String number) {
    return TextButton(
      style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size.square(64))),
      onPressed: () => updateFrontBuffer(number),
      child: Text(number),
    );
  }

  TextButton makeButton(Widget body, VoidCallback onPressed) {
    return TextButton(
      style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size.square(64))),
      onPressed: onPressed,
      child: body,
    );
  }

  TextButton makeButtonWithPadding(
      Widget body, EdgeInsets padding, VoidCallback onPressed) {
    return TextButton(
      style: ButtonStyle(fixedSize: WidgetStatePropertyAll(Size.square(64))),
      onPressed: onPressed,
      child: Padding(
        padding: padding,
        child: body,
      ),
    );
  }

  void updateFrontBuffer(number) {
    setState(() {
      frontBuffer += number;
      frontBuffer = "${double.parse(frontBuffer.isEmpty ? "0" : frontBuffer)}";
    });
  }
  
  void negateFrontBuffer(){
    setState(() {
      frontBuffer = "${double.parse(frontBuffer.isEmpty ? "0" : frontBuffer) * -1}";
    },);
  }

  void swapBuffers() {
    setState(() {
      var temp = backBuffer;
      backBuffer = frontBuffer;
      frontBuffer = temp;
    });
  }

  void doCalc() {
    var val = double.parse(frontBuffer);
    var old = double.parse(backBuffer);
    backBuffer = frontBuffer;

    double result = 0;
    switch (op) {
      case Op.ADD:
        result = old + val;
        break;
      case Op.SUB:
        result = old - val;
        break;
      case Op.DIV:
        result = old / val;
        break;
      case Op.MULT:
        result = old * val;
        break;
      case Op.PERCENT:
        result = ((old / 100) * val);
        break;
      case Op.NONE:
        break;
    }

    setState(() {
      frontBuffer = "$result";
    });
  }
}
