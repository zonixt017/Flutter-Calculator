import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const CalculatorApp(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.blueAccent,
        ),
      ),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _input = '';
  String _result = '';

  void _onButtonPressed(String text) {
    setState(() {
      if (text == 'AC') {
        _input = '';
        _result = '';
      } else if (text == '=') {
        _calculateResult();
      } else if (text == '+' || text == '-' || text == '*' || text == '/') {
        if (_input.isNotEmpty &&
            (_input.endsWith('+') ||
                _input.endsWith('-') ||
                _input.endsWith('*') ||
                _input.endsWith('/'))) {
          _input = _input.substring(0, _input.length - 1) + text;
        } else {
          _input += text;
        }
      } else {
        if (_result.isNotEmpty) {
          _input = '';
          _result = '';
        }
        _input += text;
      }
    });
  }

  void _calculateResult() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_input);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _result = result.toString();
        _input = '';
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  Widget _buildButton(String text, Color color, Color textColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor,
          ),
          child: Text(text, style: const TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _input.isEmpty ? _result : _input,
                style: const TextStyle(fontSize: 32.0, color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildButton('7', Colors.white, Colors.black),
                _buildButton('8', Colors.white, Colors.black),
                _buildButton('9', Colors.white, Colors.black),
                _buildButton('/', Colors.blue, Colors.white),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildButton('4', Colors.white, Colors.black),
                _buildButton('5', Colors.white, Colors.black),
                _buildButton('6', Colors.white, Colors.black),
                _buildButton('*', Colors.blue, Colors.white),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildButton('1', Colors.white, Colors.black),
                _buildButton('2', Colors.white, Colors.black),
                _buildButton('3', Colors.white, Colors.black),
                _buildButton('-', Colors.blue, Colors.white),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildButton('0', Colors.white, Colors.black),
                _buildButton('AC', Colors.red, Colors.white),
                _buildButton('=', Colors.green, Colors.white),
                _buildButton('+', Colors.blue, Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
