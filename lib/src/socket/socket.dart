import 'dart:convert';

import 'package:shelf_web_socket/shelf_web_socket.dart' as web_socket;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../env.dart';
import 'message.dart';
import 'routes.dart';

final webSocketHandler = web_socket.webSocketHandler((WebSocketChannel webSocket) {
  webSocket.stream.listen((message) {
    final context = WebSocketContext();
    String outMessage;
    if (message.startWith('{')) {
      try {
        final data = jsonDecode(message);
        if (data is Map<String, dynamic> && data['action'] is String) {
          final msg = SocketMessage.fromJson(data);

          outMessage = socketRoutes[data['action']]!.call(context, msg).toString();
        } else {
          throw 'Message parse error.';
        }
      } catch (e) {
        webSocket.sink.addError(
          e is String ? e : 'process error${Env.instance.isDebug ? ':$e' : ''}',
        );
        return;
      }
    } else {
      outMessage = 'echo $message';
    }

    webSocket.sink.add(outMessage);
  });
});
