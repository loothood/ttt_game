import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'client/my_game.dart';

void main() {
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: '
        '${record.loggerName}: '
        '${record.message}');
  });

  runApp(
    GameWidget(
      game: MyGame(),
    ),
  );
}