import 'dart:async';

import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../entity/message.dart';
import 'my_game.dart';

class SocketManager {
  SocketManager(this.myGame, this.port);

  static final Logger _log = Logger('Client');
  final MyGame myGame;
  final int port;
  late WebSocketChannel? socket;
  bool connected = false;

  Future<void> connectWithReconnect(
      Uri wsUrl, int maxAttempts, Duration reconnectDelay) async {
    var attempts = 0;
    bool isConnected = false;
    StreamSubscription? subscription;

    while (!isConnected && attempts < maxAttempts) {
      try {
        socket = WebSocketChannel.connect(wsUrl);
        isConnected = true;
        _log.info('Connected to Server');

        subscription?.cancel();
        subscription = socket?.stream.listen((data) {
          handleMessage(data);
        }, onError: (error) {
          _log.shout('Connection closed with error: $error');
          connectWithReconnect(wsUrl, maxAttempts, reconnectDelay);
        }, onDone: () {
          _log.warning('Connection closed.');
        });
      } on Exception {
        attempts++;
        _log.warning(
            "Cannot connect to the server. Attempt $attempts if $maxAttempts...");
        await Future.delayed(reconnectDelay);
      }
    }

    if (!isConnected) {
      _log.shout(
          'Failed to connect to the server. The maximum number of attempts has been exhausted.');
      subscription?.cancel();
      return;
    }
  }

  void handleMessage(data) {
    final message = Message.fromJsonString(data);
    if (message.type == MessageType.gameStatus) {
      myGame.clientBoard.board = message.gameStatus!.board;
      myGame.winner = message.gameStatus!.winnerId;
      if (myGame.winner != null) {
        myGame.canPlay = false;
      }
    } else if (message.type == MessageType.welcome) {
      myGame.clientId = message.welcomeMessage!.clientId;
      myGame.canPlay = message.welcomeMessage!.canPlay;
      myGame.playerRole = message.welcomeMessage!.playerRole;
      _log.info('My client id is: ${message.welcomeMessage!.clientId}');
    } else if (message.type == MessageType.move) {
      myGame.canPut = message.move!.canPut!;
    }
  }

  void send(Message message) {
    socket?.sink.add(message.toJsonString());
  }
}