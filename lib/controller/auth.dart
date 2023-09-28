import 'dart:async';

import 'package:api_for_dart/src/core/controller.dart';
import 'package:api_for_dart/src/core/result.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'auth.g.dart';

class AuthController extends Controller {
  AuthController() : super();

  @Route.post('/index')
  FutureOr<Response> _index(Request request) {
    return response(Result(data: 'index'));
  }

  @Route.post('/login')
  FutureOr<Response> _login(Request request) {
    return response(Result(data: 'login'));
  }
  //
  // @Route.all('/<ignored|.*>')
  // Response _notFound(Request request) => Response.notFound('auth action error');

  @override
  Router get router => _$AuthControllerRouter(this);
}
