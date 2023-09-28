import 'dart:convert';

import '../globals.dart';

class WebSocketContext {
  String token = '';
  bool isLogin = false;
}

class SocketMessage<T> {
  SocketMessage(this.action, this.timestamp, this.data);
  SocketMessage.fromJson(Map<String, dynamic> json)
      : this(
          json['action'],
          json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
          (parsers[json['action']] ?? (d) => d).call(json['data']) as T,
        );

  static final parsers = <String, Function(Json)>{
    'login': LoginMessage.fromJson,
    'crate_room': CreateRoomMessage.fromJson,
    'join_room': JoinRoomMessage.fromJson,
    'quit_room': QuitRoomMessage.fromJson,
    'kick_room': KickRoomMessage.fromJson,
    'dissolve_room': DissolveRoomMessage.fromJson,
    'request_friend': RequestFriendMessage.fromJson,
    'agree_friend': AgreeFriendMessage.fromJson,
    'block_friend': BlockFriendMessage.fromJson,
    'delete_friend': DeleteFriendMessage.fromJson,
    'send_message': SendMessage.fromJson,
  };

  static void registerParser(String action, Function(dynamic) parser) =>
      parsers[action] = parser;

  final String action;
  final int timestamp;
  final T? data;
}

class LoginMessage {
  LoginMessage({
    required this.token,
  });

  static LoginMessage fromJson(Json json) {
    return LoginMessage(
      token: json['token'],
    );
  }

  final String token;
}

abstract class RoomMessage {
  RoomMessage({
    required this.roomId,
    required this.userId,
  });

  final String roomId;
  final int userId;
}

abstract class ChatMessage {
  ChatMessage({
    required this.roomId,
    required this.userId,
  });

  final String roomId;
  final int userId;
}

abstract class FriendMessage {
  FriendMessage({
    required this.toId,
    required this.userId,
  });

  final String toId;
  final int userId;
}

class CreateRoomMessage extends RoomMessage {
  CreateRoomMessage({required super.roomId, required super.userId});
  static CreateRoomMessage fromJson(Json json) {
    return CreateRoomMessage(
      roomId: json['room_id'],
      userId: json['user_id'],
    );
  }
}

class JoinRoomMessage extends RoomMessage {
  JoinRoomMessage({required super.roomId, required super.userId});
  static JoinRoomMessage fromJson(Json json) {
    return JoinRoomMessage(
      roomId: json['room_id'],
      userId: json['user_id'],
    );
  }
}

class QuitRoomMessage extends RoomMessage {
  QuitRoomMessage({required super.roomId, required super.userId});
  static QuitRoomMessage fromJson(Json json) {
    return QuitRoomMessage(
      roomId: json['room_id'],
      userId: json['user_id'],
    );
  }
}

class KickRoomMessage extends RoomMessage {
  KickRoomMessage({required super.roomId, required super.userId});
  static KickRoomMessage fromJson(Json json) {
    return KickRoomMessage(
      roomId: json['room_id'],
      userId: json['user_id'],
    );
  }
}

class DissolveRoomMessage extends RoomMessage {
  DissolveRoomMessage({required super.roomId, required super.userId});
  static DissolveRoomMessage fromJson(Json json) {
    return DissolveRoomMessage(
      roomId: json['room_id'],
      userId: json['user_id'],
    );
  }
}

class RequestFriendMessage extends FriendMessage {
  RequestFriendMessage({required super.toId, required super.userId});
  static RequestFriendMessage fromJson(Json json) {
    return RequestFriendMessage(
      toId: json['to_id'],
      userId: json['user_id'],
    );
  }
}

class AgreeFriendMessage extends FriendMessage {
  AgreeFriendMessage({required super.toId, required super.userId});
  static AgreeFriendMessage fromJson(Json json) {
    return AgreeFriendMessage(
      toId: json['to_id'],
      userId: json['user_id'],
    );
  }
}

class BlockFriendMessage extends FriendMessage {
  BlockFriendMessage({required super.toId, required super.userId});
  static BlockFriendMessage fromJson(Json json) {
    return BlockFriendMessage(
      toId: json['to_id'],
      userId: json['user_id'],
    );
  }
}

class DeleteFriendMessage extends FriendMessage {
  DeleteFriendMessage({required super.toId, required super.userId});
  static DeleteFriendMessage fromJson(Json json) {
    return DeleteFriendMessage(
      toId: json['to_id'],
      userId: json['user_id'],
    );
  }
}

class SendMessage extends ChatMessage {
  SendMessage({required super.roomId, required super.userId});
  static SendMessage fromJson(Json json) {
    return SendMessage(
      roomId: json['room_id'],
      userId: json['user_id'],
    );
  }
}

class ResponseMessage<T> {
  ResponseMessage({this.code = 1, this.message = '', this.data});

  ResponseMessage.error({this.code = -1, required this.message, this.data});

  ResponseMessage.success({this.code = 0, this.message = '', this.data});

  final int code;
  final String message;
  T? data;

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'data': data,
      };

  @override
  String toString() => jsonEncode(toJson());
}
