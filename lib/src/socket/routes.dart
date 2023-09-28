import 'message.dart';

final socketRoutes = <String, MessageProcess>{
  'login': const LoginProcess(),
  'create_room': const CreateRoomProcess(),
  'join_room': const JoinRoomProcess(),
  'quit_room': const QuitRoomProcess(),
  'kick_room': const KickRoomProcess(),
  'dissolve_room': const DissolveRoomProcess(),
  'request_friend': const RequestFriendProcess(),
  'agree_friend': const AgreeFriendProcess(),
  'block_friend': const BlockFriendProcess(),
  'delete_friend': const DeleteFriendProcess(),
  'send_message': const SendMessageProcess(),
};

abstract class MessageProcess<T extends SocketMessage> {
  const MessageProcess();
  bool get needLogin => true;

  ResponseMessage call(WebSocketContext context, T message);
}

class LoginProcess extends MessageProcess<SocketMessage<LoginMessage>> {
  const LoginProcess();

  @override
  bool get needLogin => false;

  @override
  ResponseMessage call(
    WebSocketContext context,
    SocketMessage<LoginMessage> message,
  ) {
    // check token

    context.isLogin = true;
    return ResponseMessage.success();
  }
}

class CreateRoomProcess
    extends MessageProcess<SocketMessage<CreateRoomMessage>> {
  const CreateRoomProcess();

  @override
  ResponseMessage call(
    WebSocketContext context,
    SocketMessage<CreateRoomMessage> message,
  ) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class JoinRoomProcess extends MessageProcess<SocketMessage<JoinRoomMessage>> {
  const JoinRoomProcess();

  @override
  ResponseMessage call(
    WebSocketContext context,
    SocketMessage<JoinRoomMessage> message,
  ) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class QuitRoomProcess extends MessageProcess<SocketMessage<QuitRoomMessage>> {
  const QuitRoomProcess();

  @override
  ResponseMessage call(
    WebSocketContext context,
    SocketMessage<QuitRoomMessage> message,
  ) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class KickRoomProcess extends MessageProcess<SocketMessage<KickRoomMessage>> {
  const KickRoomProcess();

  @override
  ResponseMessage call(
    WebSocketContext context,
    SocketMessage<KickRoomMessage> message,
  ) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class DissolveRoomProcess
    extends MessageProcess<SocketMessage<DissolveRoomMessage>> {
  const DissolveRoomProcess();

  @override
  ResponseMessage call(
    WebSocketContext context,
    SocketMessage<DissolveRoomMessage> message,
  ) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class RequestFriendProcess
    extends MessageProcess<SocketMessage<RequestFriendMessage>> {
  const RequestFriendProcess();

  @override
  ResponseMessage call(
    WebSocketContext context,
    SocketMessage<RequestFriendMessage> message,
  ) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class AgreeFriendProcess
    extends MessageProcess<SocketMessage<AgreeFriendMessage>> {
  const AgreeFriendProcess();

  @override
  ResponseMessage call(
    WebSocketContext context,
    SocketMessage<AgreeFriendMessage> message,
  ) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class BlockFriendProcess
    extends MessageProcess<SocketMessage<BlockFriendMessage>> {
  const BlockFriendProcess();

  @override
  ResponseMessage call(
    WebSocketContext context,
    SocketMessage<BlockFriendMessage> message,
  ) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class DeleteFriendProcess
    extends MessageProcess<SocketMessage<DeleteFriendMessage>> {
  const DeleteFriendProcess();

  @override
  ResponseMessage call(
    WebSocketContext context,
    SocketMessage<DeleteFriendMessage> message,
  ) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class SendMessageProcess extends MessageProcess<SocketMessage<SendMessage>> {
  const SendMessageProcess();

  @override
  ResponseMessage call(
    WebSocketContext context,
    SocketMessage<SendMessage> message,
  ) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
