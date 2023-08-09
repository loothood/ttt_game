import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../entity/figure.dart';
import '../entity/figure_type.dart';

abstract class ClientConstants {
  static const int gridColor = 0xfff7f1e3;
  static const Color backgoundColor = Color.fromARGB(255, 134, 198, 138);
  static const Map<int, MaterialColor> colorMap = {0: Colors.green, 1: Colors.red, 2: Colors.blue};
  static const Figure noneFigure = Figure(FigureType.none, 0, Constants.fakeCellId);
  static const double smallFigureDevider = 5;
  static const double mediumFigureDevider = 3;
  static const double largeFigureDevider = 2.1;
  static const Color textColor = Colors.white;
  static const double fontSize = 24.0;
}