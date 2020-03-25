import 'package:flutter/material.dart';

class CustomThemeData {
  ThemeData lightTheme() {
    return ThemeData(
      cardTheme: CardTheme(
        color: Colors.grey[50],
        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
      ),
      scaffoldBackgroundColor: Colors.grey[100],
      sliderTheme: SliderThemeData(
        trackHeight: 3,
        activeTrackColor: Colors.cyan,
        inactiveTrackColor: Colors.grey[350],
        disabledActiveTrackColor: Colors.cyanAccent,
        disabledInactiveTrackColor: Colors.grey[200],
        activeTickMarkColor: Colors.deepPurple[400],
        inactiveTickMarkColor: Colors.deepPurple[200],
        disabledActiveTickMarkColor: Colors.grey,
        disabledInactiveTickMarkColor: Colors.grey,
        thumbColor: Colors.cyan,
        disabledThumbColor: Colors.grey,
        overlayColor: Color.fromRGBO(0, 188, 212, 0.2),
        valueIndicatorColor: Colors.cyanAccent,
        trackShape: RectangularSliderTrackShape(),
        tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 1.2),
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 15.0),
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        showValueIndicator: ShowValueIndicator.always,
        valueIndicatorTextStyle: TextStyle(color: Colors.deepPurple),
      ),
      inputDecorationTheme: InputDecorationTheme(
          errorStyle: TextStyle(fontWeight: FontWeight.w700),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                style: BorderStyle.solid, color: Colors.cyan[100], width: 0.5),
          ),
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide:
                BorderSide(style: BorderStyle.none, color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(style: BorderStyle.solid, color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
                style: BorderStyle.solid, color: Colors.cyan, width: 1.0),
          ),
          contentPadding: EdgeInsets.all(10.0)),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.cyan,
      ),
      primarySwatch: Colors.cyan,
    );
  }
}
