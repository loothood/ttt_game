import 'dart:convert';

import 'package:base2e15/base2e15.dart';

import 'game_status.dart';
import 'move.dart';
import 'welcome_message.dart';

enum MessageType {
  welcome,
  gameStatus,
  move,
}

class Message {
  final MessageType type;
  final WelcomeMessage? welcomeMessage;
  final Move? move;
  final GameStatus? gameStatus;

  Message(this.type, {this.welcomeMessage, this.move, this.gameStatus});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      MessageType.values.firstWhere((e) => e.toString() == json['type']),
      gameStatus: json.containsKey('gameStatus') ? GameStatus.fromJson(json['gameStatus']) : null,
      welcomeMessage:
          json.containsKey('welcomeMessage') ? WelcomeMessage.fromJson(json['welcomeMessage']) : null,
      move: 
          json.containsKey('move') ? Move.fromJson(json['move']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'type': type.toString()};
    if (gameStatus != null) {
      data['gameStatus'] = gameStatus!.toJson();
    }
    if (welcomeMessage != null) {
      data['welcomeMessage'] = welcomeMessage!.toJson();
    }
    if (move != null) {
      data['move'] = move!.toJson();
    }
    return data;
  }

  String toJsonString() {
    final jsonString = jsonEncode(toJson());
    final base2e15String = Base2e15.encode(jsonString.codeUnits);
    return base2e15String;
  }

  factory Message.fromJsonString(String jsonString) {
    final base2e15Bytes = Base2e15.decode(jsonString);
    final base2e15String = String.fromCharCodes(base2e15Bytes);
    final jsonData = jsonDecode(base2e15String);
    return Message.fromJson(jsonData);
  }
}