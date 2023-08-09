import '../entity/figure.dart';
import '../entity/figure_type.dart';

abstract class Constants {
  static const int player1Color = 1;
  static const int player2Color = 2;
  static const int fakeCellId = 404;
  static const int noColor = 0;
  
  static const Figure noneFigure = Figure(FigureType.none, noColor, fakeCellId);
  static const List<List<int>> winnigCombinations = <List<int>>[
    <int>[3, 4, 5],
    <int>[6, 7, 8],
    <int>[9, 10, 11],
    <int>[3, 7, 11],
    <int>[5, 7, 9],
    <int>[3, 6, 9],
    <int>[4, 7, 10],
    <int>[5, 8, 11],
  ];
  static const int winningCount = 3;
  static const int port = 8080;
  static const int maxAttempts = 5;
  static const String host = 'localhost';
  static const Duration reconnectDelay = Duration(seconds: 5);
  static const broadcastInterval = Duration(milliseconds: 100);
}