import 'figure_type.dart';

class Move {
  Move(this.clientId, this.sourceCellId, this.targetCellId, this.figureType,
      {this.canPut});
  String clientId;
  int sourceCellId;
  int targetCellId;
  FigureType figureType;
  bool? canPut;

  factory Move.fromJson(Map<String, dynamic> json) => Move(
        json['clientId'],
        json['sourceCellId'],
        json['targetCellId'],
        FigureType.values.byName(json['figureType']),
        canPut: json.containsKey('canPut') ? json['canPut'] : null,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'clientId': clientId,
      'sourceCellId': sourceCellId,
      'targetCellId': targetCellId,
      'figureType': figureType.name,
    };
    if (canPut != null) {
      data['canPut'] = canPut;
    }
    return data;
  }
}