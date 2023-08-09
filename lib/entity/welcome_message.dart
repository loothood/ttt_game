import 'player_role.dart';

class WelcomeMessage {
  WelcomeMessage(this.clientId, this.canPlay, this.playerRole);
  final String clientId;
  final bool canPlay;
  final PlayerRole playerRole;

  factory WelcomeMessage.fromJson(Map<String, dynamic> json) {
    return WelcomeMessage(
      json['clientId'],
      json['canPlay'],
      PlayerRole.values.byName(json['playerRole']),
    );
  }

  Map<String, dynamic> toJson() => {
        'clientId': clientId,
        'canPlay': canPlay,
        'playerRole': playerRole.name,
      };
}