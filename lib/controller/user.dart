import 'dart:async';

import 'package:api_for_dart/src/core/controller.dart';
import 'package:api_for_dart/src/core/result.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'user.g.dart';

class UserController extends Controller {
  UserController() : super();

  @override
  bool get needLogin => true;

  @Route.get('/index')
  FutureOr<Response> _index(Request request) {
    return response(Result(data: 'index'));
  }

  @Route.get('/profile')
  FutureOr<Response> _profile(Request request) {
    return response(Result(data: 'profile'));
  }

  @Route.all('/<ignored|.*>')
  Response _notFound(Request request) => Response.notFound('user action error');

  @override
  Router get router => _$UserControllerRouter(this);
}
