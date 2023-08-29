import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'button_values.dart';

class calculatorscreen extends StatefulWidget {
  const calculatorscreen({super.key});

  @override
  State<calculatorscreen> createState() => _calculatorscreenState();
}

class _calculatorscreenState extends State<calculatorscreen> {
  String number1 = '';
  String operater = '';
  String number2 = '';
  @override
  Widget build(BuildContext context) {
    final Screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Calculator created by Akshith",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                      "$number1$operater$number2".isEmpty
                          ? "0"
                          : "$number1$operater$number2",
                      style: const TextStyle(
                          fontSize: 48, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end),
                ),
              ),
            ),

            //buttons
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                        width: value == Btn.n0
                            ? Screensize.width / 2
                            : Screensize.width / 4,
                        height: Screensize.width / 5,
                        child: buildButton(value)),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getbtncolor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: Colors.white24)),
        child: InkWell(
            onTap: () => onBtntap(value),
            child: Center(
                child: Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ))),
      ),
    );
  }

  void onBtntap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }
    if (value == Btn.per) {
      convertpersentage();
      return;
    }
    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendVlaue(value);
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operater.isNotEmpty) {
      operater = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void clearAll() {
    setState(() {
      number1 = '';
      operater = '';
      number2 = '';
    });
  }

  void convertpersentage() {
    if (number1.isNotEmpty && operater.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }
    if (operater.isNotEmpty) {
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operater = "";
      number2 = '';
    });
  }

  void calculate() {
    if (number1.isEmpty) return;
    if (operater.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch (operater) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }
    setState(() {
      number1 = result.toStringAsPrecision(10);

      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }

      operater = "";
      number2 = "";
    });
  }

  void appendVlaue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operater.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operater = value;
    } else if (number1.isEmpty || operater.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0";
      }
      number1 += value;
    } else if (number2.isEmpty || operater.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = "0";
      }
      number2 += value;
    }
    setState(() {
      // number1 += value;
      // operater += value;
      // number2 += value;
    });
  }

  Color getbtncolor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.subtract,
            Btn.add,
            Btn.divide,
            Btn.calculate,
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }
}
