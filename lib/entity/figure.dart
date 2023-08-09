import 'figure_type.dart';

class Figure {
  const Figure(this.figureType, this.color, this.cellId);

  final FigureType figureType;
  final int color;
  final int cellId;

  factory Figure.fromJson(Map<String, dynamic> json) {
    return Figure(
      FigureType.values.byName(json['figureType']),
      json['color'],
      json['cellId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'figureType': figureType.name,
        'color': color,
        'cellId': cellId,
      };
}